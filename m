Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4341D9A4B
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgESOpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:45:31 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49590 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726880AbgESOpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:45:31 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from chrism@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 May 2020 17:45:26 +0300
Received: from dev-r630-04.mtbc.labs.mlnx (dev-r630-04.mtbc.labs.mlnx [10.75.205.14])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04JEjOsK015252;
        Tue, 19 May 2020 17:45:25 +0300
From:   Chris Mi <chrism@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     yotam.gi@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        chrism@mellanox.com
Subject: [PATCH net-next] net: psample: Add tunnel support
Date:   Tue, 19 May 2020 22:45:20 +0800
Message-Id: <20200519144520.9275-1-chrism@mellanox.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, psample can only send the packet bits after decapsulation.
The tunnel information is lost. Add the tunnel support.

If the sampled packet has no tunnel info, the behavior is the same as
before. If it has, add a nested metadata field named PSAMPLE_ATTR_TUNNEL
and include the tunnel subfields if applicable.

Increase the metadata length for sampled packet with the tunnel info.
If new subfields of tunnel info should be included, update the metadata
length accordingly.

Signed-off-by: Chris Mi <chrism@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/psample.h |  22 +++++
 net/psample/psample.c        | 157 +++++++++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+)

diff --git a/include/uapi/linux/psample.h b/include/uapi/linux/psample.h
index ce1116cff53d..aea26ab1431c 100644
--- a/include/uapi/linux/psample.h
+++ b/include/uapi/linux/psample.h
@@ -11,6 +11,7 @@ enum {
 	PSAMPLE_ATTR_GROUP_SEQ,
 	PSAMPLE_ATTR_SAMPLE_RATE,
 	PSAMPLE_ATTR_DATA,
+	PSAMPLE_ATTR_TUNNEL,
 
 	/* commands attributes */
 	PSAMPLE_ATTR_GROUP_REFCOUNT,
@@ -25,6 +26,27 @@ enum psample_command {
 	PSAMPLE_CMD_DEL_GROUP,
 };
 
+enum psample_tunnel_key_attr {
+	PSAMPLE_TUNNEL_KEY_ATTR_ID,                 /* be64 Tunnel ID */
+	PSAMPLE_TUNNEL_KEY_ATTR_IPV4_SRC,           /* be32 src IP address. */
+	PSAMPLE_TUNNEL_KEY_ATTR_IPV4_DST,           /* be32 dst IP address. */
+	PSAMPLE_TUNNEL_KEY_ATTR_TOS,                /* u8 Tunnel IP ToS. */
+	PSAMPLE_TUNNEL_KEY_ATTR_TTL,                /* u8 Tunnel IP TTL. */
+	PSAMPLE_TUNNEL_KEY_ATTR_DONT_FRAGMENT,      /* No argument, set DF. */
+	PSAMPLE_TUNNEL_KEY_ATTR_CSUM,               /* No argument. CSUM packet. */
+	PSAMPLE_TUNNEL_KEY_ATTR_OAM,                /* No argument. OAM frame.  */
+	PSAMPLE_TUNNEL_KEY_ATTR_GENEVE_OPTS,        /* Array of Geneve options. */
+	PSAMPLE_TUNNEL_KEY_ATTR_TP_SRC,	            /* be16 src Transport Port. */
+	PSAMPLE_TUNNEL_KEY_ATTR_TP_DST,		    /* be16 dst Transport Port. */
+	PSAMPLE_TUNNEL_KEY_ATTR_VXLAN_OPTS,	    /* Nested VXLAN opts* */
+	PSAMPLE_TUNNEL_KEY_ATTR_IPV6_SRC,           /* struct in6_addr src IPv6 address. */
+	PSAMPLE_TUNNEL_KEY_ATTR_IPV6_DST,           /* struct in6_addr dst IPv6 address. */
+	PSAMPLE_TUNNEL_KEY_ATTR_PAD,
+	PSAMPLE_TUNNEL_KEY_ATTR_ERSPAN_OPTS,        /* struct erspan_metadata */
+	PSAMPLE_TUNNEL_KEY_ATTR_IPV4_INFO_BRIDGE,   /* No argument. IPV4_INFO_BRIDGE mode.*/
+	__PSAMPLE_TUNNEL_KEY_ATTR_MAX
+};
+
 /* Can be overridden at runtime by module option */
 #define PSAMPLE_ATTR_MAX (__PSAMPLE_ATTR_MAX - 1)
 
diff --git a/net/psample/psample.c b/net/psample/psample.c
index 6f2fbc6b9eb2..34a74043840b 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -14,6 +14,8 @@
 #include <net/genetlink.h>
 #include <net/psample.h>
 #include <linux/spinlock.h>
+#include <net/ip_tunnels.h>
+#include <net/dst_metadata.h>
 
 #define PSAMPLE_MAX_PACKET_SIZE 0xffff
 
@@ -207,10 +209,155 @@ void psample_group_put(struct psample_group *group)
 }
 EXPORT_SYMBOL_GPL(psample_group_put);
 
+static int __psample_ip_tun_to_nlattr(struct sk_buff *skb,
+			      struct ip_tunnel_info *tun_info)
+{
+	unsigned short tun_proto = ip_tunnel_info_af(tun_info);
+	const void *tun_opts = ip_tunnel_info_opts(tun_info);
+	const struct ip_tunnel_key *tun_key = &tun_info->key;
+	int tun_opts_len = tun_info->options_len;
+
+	if (tun_key->tun_flags & TUNNEL_KEY &&
+	    nla_put_be64(skb, PSAMPLE_TUNNEL_KEY_ATTR_ID, tun_key->tun_id,
+			 PSAMPLE_TUNNEL_KEY_ATTR_PAD))
+		return -EMSGSIZE;
+
+	if (tun_info->mode & IP_TUNNEL_INFO_BRIDGE &&
+	    nla_put_flag(skb, PSAMPLE_TUNNEL_KEY_ATTR_IPV4_INFO_BRIDGE))
+		return -EMSGSIZE;
+
+	switch (tun_proto) {
+	case AF_INET:
+		if (tun_key->u.ipv4.src &&
+		    nla_put_in_addr(skb, PSAMPLE_TUNNEL_KEY_ATTR_IPV4_SRC,
+				    tun_key->u.ipv4.src))
+			return -EMSGSIZE;
+		if (tun_key->u.ipv4.dst &&
+		    nla_put_in_addr(skb, PSAMPLE_TUNNEL_KEY_ATTR_IPV4_DST,
+				    tun_key->u.ipv4.dst))
+			return -EMSGSIZE;
+		break;
+	case AF_INET6:
+		if (!ipv6_addr_any(&tun_key->u.ipv6.src) &&
+		    nla_put_in6_addr(skb, PSAMPLE_TUNNEL_KEY_ATTR_IPV6_SRC,
+				     &tun_key->u.ipv6.src))
+			return -EMSGSIZE;
+		if (!ipv6_addr_any(&tun_key->u.ipv6.dst) &&
+		    nla_put_in6_addr(skb, PSAMPLE_TUNNEL_KEY_ATTR_IPV6_DST,
+				     &tun_key->u.ipv6.dst))
+			return -EMSGSIZE;
+		break;
+	}
+	if (tun_key->tos &&
+	    nla_put_u8(skb, PSAMPLE_TUNNEL_KEY_ATTR_TOS, tun_key->tos))
+		return -EMSGSIZE;
+	if (nla_put_u8(skb, PSAMPLE_TUNNEL_KEY_ATTR_TTL, tun_key->ttl))
+		return -EMSGSIZE;
+	if ((tun_key->tun_flags & TUNNEL_DONT_FRAGMENT) &&
+	    nla_put_flag(skb, PSAMPLE_TUNNEL_KEY_ATTR_DONT_FRAGMENT))
+		return -EMSGSIZE;
+	if ((tun_key->tun_flags & TUNNEL_CSUM) &&
+	    nla_put_flag(skb, PSAMPLE_TUNNEL_KEY_ATTR_CSUM))
+		return -EMSGSIZE;
+	if (tun_key->tp_src &&
+	    nla_put_be16(skb, PSAMPLE_TUNNEL_KEY_ATTR_TP_SRC, tun_key->tp_src))
+		return -EMSGSIZE;
+	if (tun_key->tp_dst &&
+	    nla_put_be16(skb, PSAMPLE_TUNNEL_KEY_ATTR_TP_DST, tun_key->tp_dst))
+		return -EMSGSIZE;
+	if ((tun_key->tun_flags & TUNNEL_OAM) &&
+	    nla_put_flag(skb, PSAMPLE_TUNNEL_KEY_ATTR_OAM))
+		return -EMSGSIZE;
+	if (tun_opts_len) {
+		if (tun_key->tun_flags & TUNNEL_GENEVE_OPT &&
+		    nla_put(skb, PSAMPLE_TUNNEL_KEY_ATTR_GENEVE_OPTS,
+			    tun_opts_len, tun_opts))
+			return -EMSGSIZE;
+		else if (tun_key->tun_flags & TUNNEL_ERSPAN_OPT &&
+			 nla_put(skb, PSAMPLE_TUNNEL_KEY_ATTR_ERSPAN_OPTS,
+				 tun_opts_len, tun_opts))
+			return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
+static int psample_ip_tun_to_nlattr(struct sk_buff *skb,
+			    struct ip_tunnel_info *tun_info)
+{
+	struct nlattr *nla;
+	int err;
+
+	nla = nla_nest_start_noflag(skb, PSAMPLE_ATTR_TUNNEL);
+	if (!nla)
+		return -EMSGSIZE;
+
+	err = __psample_ip_tun_to_nlattr(skb, tun_info);
+	if (err) {
+		nla_nest_cancel(skb, nla);
+		return err;
+	}
+
+	nla_nest_end(skb, nla);
+
+	return 0;
+}
+
+static int psample_tunnel_meta_len(struct ip_tunnel_info *tun_info)
+{
+	unsigned short tun_proto = ip_tunnel_info_af(tun_info);
+	const struct ip_tunnel_key *tun_key = &tun_info->key;
+	int tun_opts_len = tun_info->options_len;
+	int sum = 0;
+
+	if (tun_key->tun_flags & TUNNEL_KEY)
+		sum += nla_total_size(sizeof(u64));
+
+	if (tun_info->mode & IP_TUNNEL_INFO_BRIDGE)
+		sum += nla_total_size(0);
+
+	switch (tun_proto) {
+	case AF_INET:
+		if (tun_key->u.ipv4.src)
+			sum += nla_total_size(sizeof(u32));
+		if (tun_key->u.ipv4.dst)
+			sum += nla_total_size(sizeof(u32));
+		break;
+	case AF_INET6:
+		if (!ipv6_addr_any(&tun_key->u.ipv6.src))
+			sum += nla_total_size(sizeof(struct in6_addr));
+		if (!ipv6_addr_any(&tun_key->u.ipv6.dst))
+			sum += nla_total_size(sizeof(struct in6_addr));
+		break;
+	}
+	if (tun_key->tos)
+		sum += nla_total_size(sizeof(u8));
+	sum += nla_total_size(sizeof(u8));	/* TTL */
+	if (tun_key->tun_flags & TUNNEL_DONT_FRAGMENT)
+		sum += nla_total_size(0);
+	if (tun_key->tun_flags & TUNNEL_CSUM)
+		sum += nla_total_size(0);
+	if (tun_key->tp_src)
+		sum += nla_total_size(sizeof(u16));
+	if (tun_key->tp_dst)
+		sum += nla_total_size(sizeof(u16));
+	if (tun_key->tun_flags & TUNNEL_OAM)
+		sum += nla_total_size(0);
+	if (tun_opts_len) {
+		if (tun_key->tun_flags & TUNNEL_GENEVE_OPT)
+			sum += nla_total_size(tun_opts_len);
+		else if (tun_key->tun_flags & TUNNEL_ERSPAN_OPT)
+			sum += nla_total_size(tun_opts_len);
+	}
+
+	return sum;
+}
+
 void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 			   u32 trunc_size, int in_ifindex, int out_ifindex,
 			   u32 sample_rate)
 {
+	struct ip_tunnel_info *tun_info;
 	struct sk_buff *nl_skb;
 	int data_len;
 	int meta_len;
@@ -224,6 +371,10 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 		   nla_total_size(sizeof(u32)) +	/* group_num */
 		   nla_total_size(sizeof(u32));		/* seq */
 
+	tun_info = skb_tunnel_info(skb);
+	if (tun_info)
+		meta_len += psample_tunnel_meta_len(tun_info);
+
 	data_len = min(skb->len, trunc_size);
 	if (meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
 		data_len = PSAMPLE_MAX_PACKET_SIZE - meta_len - NLA_HDRLEN
@@ -278,6 +429,12 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 			goto error;
 	}
 
+	if (tun_info) {
+		ret = psample_ip_tun_to_nlattr(nl_skb, tun_info);
+		if (unlikely(ret < 0))
+			goto error;
+	}
+
 	genlmsg_end(nl_skb, data);
 	genlmsg_multicast_netns(&psample_nl_family, group->net, nl_skb, 0,
 				PSAMPLE_NL_MCGRP_SAMPLE, GFP_ATOMIC);
-- 
2.21.1

