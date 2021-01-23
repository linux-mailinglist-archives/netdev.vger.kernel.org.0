Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE415301826
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbhAWUDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbhAWUAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:42 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A84C061220
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:43 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id v24so12320064lfr.7
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B+yKtN4JfFeKDZMuI5NuQ/ee2EcvA/pYHfvRmZfWYOA=;
        b=ZvqenGVPzOq82xfMV9LSaVjIr+IbO1FvF/ROAgD+TOIJpSyxdbzdebmjhohywz/M8s
         00u1dqrbo0GiLQG/MknyWcYeQ7jVOHKnJcixoRppw+y+w3kD9+jE7wUODtCNee1KqULm
         U+v8dp6p7jPoj9mzPJTJ+PgNN681doAF88ZRChOlJzJla46h8GoLvljmV4FYUqLDLf43
         Ral2kz9jGCg+bDBT0r8NGfxcAsCarYI0VavbgGzyTZ867Q3s0oJ9a950FmTCpaOXF5uC
         DLvsiVSVhdPdrfdglOTSNtsB26T6GettNZejheQXhyrFFFxhh9wsVsVv/E72Qbe2m9ni
         y39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B+yKtN4JfFeKDZMuI5NuQ/ee2EcvA/pYHfvRmZfWYOA=;
        b=i3JkYswF1dBugJjyanztp2lhVuI9HijmwNkWAk/NB1jrfxWFQG3YlED3LTMY8Gst0n
         Ds3by6Ny72sDWTPl07VIkCBbtWh8XeEanH4qMI3k2AinAFPxHhjIsc6xCyi0DBe0/McH
         8512KsroWOHZzKmpqciwspD5SlqfdEdvc5Ap2xAI0TzvRbnZ/vGxtkAQvDvMtAJLsBsq
         sTTS59q5pVxI42xl57h+5Ga/qX0Ub6WDq707QiOqy23kXyilTWfje4rhffwSgecIIHv2
         mAmCR8GoUlV5XGga4cbHwQxmiPoExbdP5LNdJV3Pbj8wZSOKViz/PFx/23OdpHexAm2y
         J1Qw==
X-Gm-Message-State: AOAM532Fmo8VRBUV7WH2DUfTuxyJ66hvnR03gyymLToagGzXhhalSunO
        Pemd9E3rHkmyxTvvIwfURaOld3xs0Y4cGQ==
X-Google-Smtp-Source: ABdhPJxuGRvxNtonQXWMuDCKnJ8zHHsATvMVKrHRuaCYOaDd9f6tDeji7LifpOvQbpgsGsgkq4oreg==
X-Received: by 2002:a19:40d4:: with SMTP id n203mr96853lfa.350.1611431981682;
        Sat, 23 Jan 2021 11:59:41 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:41 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 14/16] gtp: add support for flow based tunneling
Date:   Sat, 23 Jan 2021 20:59:14 +0100
Message-Id: <20210123195916.2765481-15-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pravin B Shelar <pbshelar@fb.com>

This patch adds support for flow based tunneling, allowing to send and
receive GTP tunneled packets via the (lightweight) tunnel metadata
mechanism.  This would allow integration with OVS and eBPF using flow
based tunneling APIs.

The mechanism used here is to get the required GTP tunnel parameters
from the tunnel metadata instead of looking up a pre-configured PDP
context.  The tunnel metadata contains the necessary information for
creating the GTP header.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c                  | 160 +++++++++++++++++++++++++----
 include/uapi/linux/gtp.h           |  12 +++
 include/uapi/linux/if_tunnel.h     |   1 +
 tools/include/uapi/linux/if_link.h |   1 +
 4 files changed, 156 insertions(+), 18 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 8aab46ec8a94..668ed8a4836e 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -21,6 +21,7 @@
 #include <linux/file.h>
 #include <linux/gtp.h>
 
+#include <net/dst_metadata.h>
 #include <net/net_namespace.h>
 #include <net/protocol.h>
 #include <net/ip.h>
@@ -74,6 +75,9 @@ struct gtp_dev {
 	unsigned int		hash_size;
 	struct hlist_head	*tid_hash;
 	struct hlist_head	*addr_hash;
+	/* Used by LWT tunnel. */
+	bool			collect_md;
+	struct socket		*collect_md_sock;
 };
 
 static unsigned int gtp_net_id __read_mostly;
@@ -224,6 +228,51 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 	return -1;
 }
 
+static int gtp_set_tun_dst(struct pdp_ctx *pctx, struct sk_buff *skb,
+			   unsigned int hdrlen)
+{
+	struct metadata_dst *tun_dst;
+	struct gtp1_header *gtp1;
+	int opts_len = 0;
+	__be64 tid;
+
+	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
+
+	tid = key32_to_tunnel_id(gtp1->tid);
+
+	if (unlikely(gtp1->flags & GTP1_F_MASK))
+		opts_len = sizeof(struct gtpu_metadata);
+
+	tun_dst = udp_tun_rx_dst(skb,
+			pctx->sk->sk_family, TUNNEL_KEY, tid, opts_len);
+	if (!tun_dst) {
+		netdev_dbg(pctx->dev, "Failed to allocate tun_dst");
+		goto err;
+	}
+
+	netdev_dbg(pctx->dev, "attaching metadata_dst to skb, gtp ver %d hdrlen %d\n",
+		   pctx->gtp_version, hdrlen);
+	if (unlikely(opts_len)) {
+		struct gtpu_metadata *opts;
+
+		opts = ip_tunnel_info_opts(&tun_dst->u.tun_info);
+		opts->ver = GTP_METADATA_V1;
+		opts->flags = gtp1->flags;
+		opts->type = gtp1->type;
+		netdev_dbg(pctx->dev, "recved control pkt: flag %x type: %d\n",
+			   opts->flags, opts->type);
+		tun_dst->u.tun_info.key.tun_flags |= TUNNEL_GTPU_OPT;
+		tun_dst->u.tun_info.options_len = opts_len;
+		skb->protocol = htons(0xffff);         /* Unknown */
+	}
+
+	skb_dst_set(skb, &tun_dst->dst);
+	return 0;
+err:
+	return -1;
+}
+
+
 /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated. */
 static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 {
@@ -262,6 +311,7 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	unsigned int hdrlen = sizeof(struct udphdr) +
 			      sizeof(struct gtp1_header);
 	struct gtp1_header *gtp1;
+	struct pdp_ctx md_pctx;
 	struct pdp_ctx *pctx;
 
 	if (!pskb_may_pull(skb, hdrlen))
@@ -272,6 +322,24 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if ((gtp1->flags >> 5) != GTP_V1)
 		return 1;
 
+	if (ip_tunnel_collect_metadata() || gtp->collect_md) {
+		int err;
+
+		pctx = &md_pctx;
+
+		pctx->gtp_version = GTP_V1;
+		pctx->sk = gtp->sk1u;
+		pctx->dev = gtp->dev;
+
+		err = gtp_set_tun_dst(pctx, skb, hdrlen);
+		if (err) {
+			gtp->dev->stats.rx_dropped++;
+			return -1;
+		}
+
+		return gtp_rx(pctx, skb, hdrlen);
+	}
+
 	if (gtp1->type != GTP_TPDU)
 		return 1;
 
@@ -353,7 +421,8 @@ static int gtp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (!gtp)
 		return 1;
 
-	netdev_dbg(gtp->dev, "encap_recv sk=%p\n", sk);
+	netdev_dbg(gtp->dev, "encap_recv sk=%p type %d\n",
+		   sk, udp_sk(sk)->encap_type);
 
 	switch (udp_sk(sk)->encap_type) {
 	case UDP_ENCAP_GTP0:
@@ -539,7 +608,7 @@ static struct rtable *gtp_get_v4_rt(struct sk_buff *skb,
 	memset(&fl4, 0, sizeof(fl4));
 	fl4.flowi4_oif		= sk->sk_bound_dev_if;
 	fl4.daddr		= pctx->peer_addr_ip4.s_addr;
-	fl4.saddr		= inet_sk(sk)->inet_saddr;
+	fl4.saddr		= *saddr;
 	fl4.flowi4_tos		= RT_CONN_FLAGS(sk);
 	fl4.flowi4_proto	= sk->sk_protocol;
 
@@ -617,29 +686,84 @@ static void gtp_push_header(struct sk_buff *skb, struct pdp_ctx *pctx,
 static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
+	struct gtpu_metadata *opts = NULL;
+	struct pdp_ctx md_pctx;
 	struct pdp_ctx *pctx;
+	__be16 port;
 	struct rtable *rt;
-	__be32 saddr;
 	struct iphdr *iph;
+	__be32 saddr;
 	int headroom;
-	__be16 port;
+	__u8 tos;
 	int r;
 
-	/* Read the IP destination address and resolve the PDP context.
-	 * Prepend PDP header with TEI/TID from PDP ctx.
-	 */
-	iph = ip_hdr(skb);
-	if (gtp->role == GTP_ROLE_SGSN)
-		pctx = ipv4_pdp_find(gtp, iph->saddr);
-	else
-		pctx = ipv4_pdp_find(gtp, iph->daddr);
+	if (gtp->collect_md) {
+		/* LWT GTP1U encap */
+		struct ip_tunnel_info *info = NULL;
 
-	if (!pctx) {
-		netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
-			   &iph->daddr);
-		return -ENOENT;
+		info = skb_tunnel_info(skb);
+		if (!info) {
+			netdev_dbg(dev, "missing tunnel info");
+			return -ENOENT;
+		}
+		if (info->key.tp_dst && ntohs(info->key.tp_dst) != GTP1U_PORT) {
+			netdev_dbg(dev, "unexpected GTP dst port: %d", ntohs(info->key.tp_dst));
+			return -EOPNOTSUPP;
+		}
+
+		if (!gtp->sk1u) {
+			netdev_dbg(dev, "missing tunnel sock");
+			return -EOPNOTSUPP;
+		}
+
+		pctx = &md_pctx;
+		memset(pctx, 0, sizeof(*pctx));
+		pctx->sk = gtp->sk1u;
+		pctx->gtp_version = GTP_V1;
+		pctx->u.v1.o_tei = ntohl(tunnel_id_to_key32(info->key.tun_id));
+		pctx->peer_addr_ip4.s_addr = info->key.u.ipv4.dst;
+
+		saddr = info->key.u.ipv4.src;
+		tos = info->key.tos;
+
+		if (info->options_len != 0) {
+			if (info->key.tun_flags & TUNNEL_GTPU_OPT) {
+				opts = ip_tunnel_info_opts(info);
+			} else {
+				netdev_dbg(dev, "missing tunnel metadata for control pkt");
+				return -EOPNOTSUPP;
+			}
+		}
+		netdev_dbg(dev, "flow-based GTP1U encap: tunnel id %d\n",
+			   pctx->u.v1.o_tei);
+	} else {
+		struct iphdr *iph;
+
+		if (ntohs(skb->protocol) != ETH_P_IP)
+			return -EOPNOTSUPP;
+
+		iph = ip_hdr(skb);
+
+		/* Read the IP destination address and resolve the PDP context.
+		 * Prepend PDP header with TEI/TID from PDP ctx.
+		 */
+		if (gtp->role == GTP_ROLE_SGSN)
+			pctx = ipv4_pdp_find(gtp, iph->saddr);
+		else
+			pctx = ipv4_pdp_find(gtp, iph->daddr);
+
+		if (!pctx) {
+			netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
+				   &iph->daddr);
+			return -ENOENT;
+		}
+		netdev_dbg(dev, "found PDP context %p\n", pctx);
+
+		saddr = inet_sk(pctx->sk)->inet_saddr;
+		tos = iph->tos;
+		netdev_dbg(dev, "gtp -> IP src: %pI4 dst: %pI4\n",
+			   &iph->saddr, &iph->daddr);
 	}
-	netdev_dbg(dev, "found PDP context %p\n", pctx);
 
 	rt = gtp_get_v4_rt(skb, dev, pctx, &saddr);
 	if (IS_ERR(rt)) {
@@ -691,7 +815,7 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 
 	udp_tunnel_xmit_skb(rt, pctx->sk, skb,
 			    saddr, pctx->peer_addr_ip4.s_addr,
-			    iph->tos,
+			    tos,
 			    ip4_dst_hoplimit(&rt->dst),
 			    0,
 			    port, port,
diff --git a/include/uapi/linux/gtp.h b/include/uapi/linux/gtp.h
index 79f9191bbb24..62aff78b7c56 100644
--- a/include/uapi/linux/gtp.h
+++ b/include/uapi/linux/gtp.h
@@ -2,6 +2,8 @@
 #ifndef _UAPI_LINUX_GTP_H_
 #define _UAPI_LINUX_GTP_H_
 
+#include <linux/types.h>
+
 #define GTP_GENL_MCGRP_NAME	"gtp"
 
 enum gtp_genl_cmds {
@@ -34,4 +36,14 @@ enum gtp_attrs {
 };
 #define GTPA_MAX (__GTPA_MAX + 1)
 
+enum {
+	GTP_METADATA_V1
+};
+
+struct gtpu_metadata {
+	__u8    ver;
+	__u8    flags;
+	__u8    type;
+};
+
 #endif /* _UAPI_LINUX_GTP_H_ */
diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
index 7d9105533c7b..802da679fab1 100644
--- a/include/uapi/linux/if_tunnel.h
+++ b/include/uapi/linux/if_tunnel.h
@@ -176,6 +176,7 @@ enum {
 #define TUNNEL_VXLAN_OPT	__cpu_to_be16(0x1000)
 #define TUNNEL_NOCACHE		__cpu_to_be16(0x2000)
 #define TUNNEL_ERSPAN_OPT	__cpu_to_be16(0x4000)
+#define TUNNEL_GTPU_OPT		__cpu_to_be16(0x8000)
 
 #define TUNNEL_OPTIONS_PRESENT \
 		(TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index d208b2af697f..28d649bda686 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -617,6 +617,7 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
+	IFLA_GTP_COLLECT_METADATA,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
-- 
2.27.0

