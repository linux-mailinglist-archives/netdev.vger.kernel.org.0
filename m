Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF6C1238FA
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfLQV5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:57:43 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36408 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfLQV5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:57:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so103535wru.3
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 13:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HxCOPPxNo9QVV0mdXr6sPeHM6dx50MAjO6ofVZSzW1g=;
        b=XH103DqUPlA8/XSJe4qGm7GSr1xJg86Dh3xPpYFM3FZWpRhxyh9d7fC5X25SBvSU7Y
         mkkoRNE38NNSmYRMPwFJRvJ5Wen/m9Gr43PYYQc7ogrYG3R6MckCHfeppEF4ZfSKvIwF
         CniAI9uu97AoaFtJfoyXrY28gWIdjRuoEF4/ZgaVPoa8+SZcCbhVKEmmOt+QJwXVnTX1
         8spYiBQJjgN6vDNkFea6nZHq/d5rjl6yxQqVQfK8rxN4tqn56cJLP+gnaAJvr7BCCgq1
         TIqwVp2o9XFralf8z43W3c8LrAL33s6kVw+D5knSTD9YOeey9y4usfFi86uQk0s4iwRg
         zVgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HxCOPPxNo9QVV0mdXr6sPeHM6dx50MAjO6ofVZSzW1g=;
        b=fUi5w532TbDyXxScff2lH3anOzr0qKXVbWveOv7G7D9tEknEziGUc7o4dKWxrOKytn
         kBxBZC8YPsutpNjFYIwHHhpQAbT3u8rZkJueRHLQ0OEhDtY73q5HNg+iTVxTLutpUZBe
         y2EUul1Ppp4o9Me68g+ByXbU7w3Ya30axstcjljtvR1viMgRoXIwXBOebvJQB3Isa9AS
         vcCIAnASLNq8bW8CjMDxL1vnzRkDXn6bH0iLjI4zScIPLk/FAlwx84r2ktBX7bSIkY2p
         9P8+p4asTHiy98o/KelSNF7JJ1nLqbz+RP/c9JKngXLxC8auL0bDC91YcyOJFu/TFsHb
         MNHA==
X-Gm-Message-State: APjAAAWMaIvlf7PygxqNvOa1njPoH14SKWsRBR0K3iXk5lIL2OgSUZFG
        N6yuoE3jCm62D7Xcs4uM/9k/jGy1zX1K/uGS7Pg2tCDQT7BY1KqEPn7zzORe36k1FOl17jS3p62
        PIbMZuke4bw9T0+XMYpB2HrkJygDecNoItG4VuiCSgqlJE2OAYuF56MRpoPsgyTbUne4ciCnogg
        ==
X-Google-Smtp-Source: APXvYqwKtcFavY3phXnm2wZzvmeRWKpEUV09U07aPAjwCv1kJGqrYFPiup+j5ZF+uWRmm25NGDpogA==
X-Received: by 2002:a5d:45c4:: with SMTP id b4mr39164095wrs.303.1576619858107;
        Tue, 17 Dec 2019 13:57:38 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u22sm157109wru.30.2019.12.17.13.57.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:57:37 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v2 5/9] nfp: flower: modify pre-tunnel and set tunnel action for ipv6
Date:   Tue, 17 Dec 2019 21:57:20 +0000
Message-Id: <1576619844-25413-6-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
References: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPv4 set tunnel action allows the setting of tunnel metadata such as
the TTL and ToS values. The pre-tunnel action includes the destination IP
address and is used to calculate the next hop from from the neighbour
table.

Much of the IPv4 tunnel actions can be reused for IPv6 tunnels. Change the
names of associated functions and structs to remove the IPv4 identifier
and make minor modifcations to support IPv6 tunnel actions.

Ensure the pre-tunnel action contains the IPv6 address along with an
identifying flag when an IPv6 tunnel action is required.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c | 65 ++++++++++++++++------
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   | 19 ++++---
 .../net/ethernet/netronome/nfp/flower/offload.c    |  8 +--
 3 files changed, 62 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 1b019fd..c06600f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -22,8 +22,9 @@
 #define NFP_FL_TUNNEL_CSUM			cpu_to_be16(0x01)
 #define NFP_FL_TUNNEL_KEY			cpu_to_be16(0x04)
 #define NFP_FL_TUNNEL_GENEVE_OPT		cpu_to_be16(0x0800)
-#define NFP_FL_SUPPORTED_TUNNEL_INFO_FLAGS	IP_TUNNEL_INFO_TX
-#define NFP_FL_SUPPORTED_IPV4_UDP_TUN_FLAGS	(NFP_FL_TUNNEL_CSUM | \
+#define NFP_FL_SUPPORTED_TUNNEL_INFO_FLAGS	(IP_TUNNEL_INFO_TX | \
+						 IP_TUNNEL_INFO_IPV6)
+#define NFP_FL_SUPPORTED_UDP_TUN_FLAGS		(NFP_FL_TUNNEL_CSUM | \
 						 NFP_FL_TUNNEL_KEY | \
 						 NFP_FL_TUNNEL_GENEVE_OPT)
 
@@ -394,19 +395,26 @@ nfp_fl_push_geneve_options(struct nfp_fl_payload *nfp_fl, int *list_len,
 }
 
 static int
-nfp_fl_set_ipv4_tun(struct nfp_app *app, struct nfp_fl_set_ipv4_tun *set_tun,
-		    const struct flow_action_entry *act,
-		    struct nfp_fl_pre_tunnel *pre_tun,
-		    enum nfp_flower_tun_type tun_type,
-		    struct net_device *netdev, struct netlink_ext_ack *extack)
+nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
+	       const struct flow_action_entry *act,
+	       struct nfp_fl_pre_tunnel *pre_tun,
+	       enum nfp_flower_tun_type tun_type,
+	       struct net_device *netdev, struct netlink_ext_ack *extack)
 {
-	size_t act_size = sizeof(struct nfp_fl_set_ipv4_tun);
 	const struct ip_tunnel_info *ip_tun = act->tunnel;
+	bool ipv6 = ip_tunnel_info_af(ip_tun) == AF_INET6;
+	size_t act_size = sizeof(struct nfp_fl_set_tun);
 	struct nfp_flower_priv *priv = app->priv;
 	u32 tmp_set_ip_tun_type_index = 0;
 	/* Currently support one pre-tunnel so index is always 0. */
 	int pretun_idx = 0;
 
+	if (!IS_ENABLED(CONFIG_IPV6) && ipv6)
+		return -EOPNOTSUPP;
+
+	if (ipv6 && !(priv->flower_ext_feats & NFP_FL_FEATS_IPV6_TUN))
+		return -EOPNOTSUPP;
+
 	BUILD_BUG_ON(NFP_FL_TUNNEL_CSUM != TUNNEL_CSUM ||
 		     NFP_FL_TUNNEL_KEY	!= TUNNEL_KEY ||
 		     NFP_FL_TUNNEL_GENEVE_OPT != TUNNEL_GENEVE_OPT);
@@ -417,19 +425,35 @@ nfp_fl_set_ipv4_tun(struct nfp_app *app, struct nfp_fl_set_ipv4_tun *set_tun,
 		return -EOPNOTSUPP;
 	}
 
-	set_tun->head.jump_id = NFP_FL_ACTION_OPCODE_SET_IPV4_TUNNEL;
+	set_tun->head.jump_id = NFP_FL_ACTION_OPCODE_SET_TUNNEL;
 	set_tun->head.len_lw = act_size >> NFP_FL_LW_SIZ;
 
 	/* Set tunnel type and pre-tunnel index. */
 	tmp_set_ip_tun_type_index |=
-		FIELD_PREP(NFP_FL_IPV4_TUNNEL_TYPE, tun_type) |
-		FIELD_PREP(NFP_FL_IPV4_PRE_TUN_INDEX, pretun_idx);
+		FIELD_PREP(NFP_FL_TUNNEL_TYPE, tun_type) |
+		FIELD_PREP(NFP_FL_PRE_TUN_INDEX, pretun_idx);
 
 	set_tun->tun_type_index = cpu_to_be32(tmp_set_ip_tun_type_index);
 	set_tun->tun_id = ip_tun->key.tun_id;
 
 	if (ip_tun->key.ttl) {
 		set_tun->ttl = ip_tun->key.ttl;
+#ifdef CONFIG_IPV6
+	} else if (ipv6) {
+		struct net *net = dev_net(netdev);
+		struct flowi6 flow = {};
+		struct dst_entry *dst;
+
+		flow.daddr = ip_tun->key.u.ipv6.dst;
+		flow.flowi4_proto = IPPROTO_UDP;
+		dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &flow, NULL);
+		if (!IS_ERR(dst)) {
+			set_tun->ttl = ip6_dst_hoplimit(dst);
+			dst_release(dst);
+		} else {
+			set_tun->ttl = net->ipv6.devconf_all->hop_limit;
+		}
+#endif
 	} else {
 		struct net *net = dev_net(netdev);
 		struct flowi4 flow = {};
@@ -455,7 +479,7 @@ nfp_fl_set_ipv4_tun(struct nfp_app *app, struct nfp_fl_set_ipv4_tun *set_tun,
 	set_tun->tos = ip_tun->key.tos;
 
 	if (!(ip_tun->key.tun_flags & NFP_FL_TUNNEL_KEY) ||
-	    ip_tun->key.tun_flags & ~NFP_FL_SUPPORTED_IPV4_UDP_TUN_FLAGS) {
+	    ip_tun->key.tun_flags & ~NFP_FL_SUPPORTED_UDP_TUN_FLAGS) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support tunnel flag offload");
 		return -EOPNOTSUPP;
 	}
@@ -467,7 +491,12 @@ nfp_fl_set_ipv4_tun(struct nfp_app *app, struct nfp_fl_set_ipv4_tun *set_tun,
 	}
 
 	/* Complete pre_tunnel action. */
-	pre_tun->ipv4_dst = ip_tun->key.u.ipv4.dst;
+	if (ipv6) {
+		pre_tun->flags |= cpu_to_be16(NFP_FL_PRE_TUN_IPV6);
+		pre_tun->ipv6_dst = ip_tun->key.u.ipv6.dst;
+	} else {
+		pre_tun->ipv4_dst = ip_tun->key.u.ipv4.dst;
+	}
 
 	return 0;
 }
@@ -956,8 +985,8 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		       struct nfp_flower_pedit_acts *set_act, bool *pkt_host,
 		       struct netlink_ext_ack *extack, int act_idx)
 {
-	struct nfp_fl_set_ipv4_tun *set_tun;
 	struct nfp_fl_pre_tunnel *pre_tun;
+	struct nfp_fl_set_tun *set_tun;
 	struct nfp_fl_push_vlan *psh_v;
 	struct nfp_fl_push_mpls *psh_m;
 	struct nfp_fl_pop_vlan *pop_v;
@@ -1032,7 +1061,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		 * If none, the packet falls back before applying other actions.
 		 */
 		if (*a_len + sizeof(struct nfp_fl_pre_tunnel) +
-		    sizeof(struct nfp_fl_set_ipv4_tun) > NFP_FL_MAX_A_SIZ) {
+		    sizeof(struct nfp_fl_set_tun) > NFP_FL_MAX_A_SIZ) {
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at tunnel encap");
 			return -EOPNOTSUPP;
 		}
@@ -1046,11 +1075,11 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 			return err;
 
 		set_tun = (void *)&nfp_fl->action_data[*a_len];
-		err = nfp_fl_set_ipv4_tun(app, set_tun, act, pre_tun,
-					  *tun_type, netdev, extack);
+		err = nfp_fl_set_tun(app, set_tun, act, pre_tun, *tun_type,
+				     netdev, extack);
 		if (err)
 			return err;
-		*a_len += sizeof(struct nfp_fl_set_ipv4_tun);
+		*a_len += sizeof(struct nfp_fl_set_tun);
 		}
 		break;
 	case FLOW_ACTION_TUNNEL_DECAP:
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index cbb94cf..7537695 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -72,7 +72,7 @@
 #define NFP_FL_ACTION_OPCODE_POP_VLAN		2
 #define NFP_FL_ACTION_OPCODE_PUSH_MPLS		3
 #define NFP_FL_ACTION_OPCODE_POP_MPLS		4
-#define NFP_FL_ACTION_OPCODE_SET_IPV4_TUNNEL	6
+#define NFP_FL_ACTION_OPCODE_SET_TUNNEL		6
 #define NFP_FL_ACTION_OPCODE_SET_ETHERNET	7
 #define NFP_FL_ACTION_OPCODE_SET_MPLS		8
 #define NFP_FL_ACTION_OPCODE_SET_IPV4_ADDRS	9
@@ -101,8 +101,8 @@
 
 /* Tunnel ports */
 #define NFP_FL_PORT_TYPE_TUN		0x50000000
-#define NFP_FL_IPV4_TUNNEL_TYPE		GENMASK(7, 4)
-#define NFP_FL_IPV4_PRE_TUN_INDEX	GENMASK(2, 0)
+#define NFP_FL_TUNNEL_TYPE		GENMASK(7, 4)
+#define NFP_FL_PRE_TUN_INDEX		GENMASK(2, 0)
 
 #define NFP_FLOWER_WORKQ_MAX_SKBS	30000
 
@@ -208,13 +208,16 @@ struct nfp_fl_pre_lag {
 
 struct nfp_fl_pre_tunnel {
 	struct nfp_fl_act_head head;
-	__be16 reserved;
-	__be32 ipv4_dst;
-	/* reserved for use with IPv6 addresses */
-	__be32 extra[3];
+	__be16 flags;
+	union {
+		__be32 ipv4_dst;
+		struct in6_addr ipv6_dst;
+	};
 };
 
-struct nfp_fl_set_ipv4_tun {
+#define NFP_FL_PRE_TUN_IPV6	BIT(0)
+
+struct nfp_fl_set_tun {
 	struct nfp_fl_act_head head;
 	__be16 reserved;
 	__be64 tun_id __packed;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 83ada1b..d512105 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -591,7 +591,7 @@ nfp_flower_update_merge_with_actions(struct nfp_fl_payload *flow,
 		case NFP_FL_ACTION_OPCODE_POP_VLAN:
 			merge->tci = cpu_to_be16(0);
 			break;
-		case NFP_FL_ACTION_OPCODE_SET_IPV4_TUNNEL:
+		case NFP_FL_ACTION_OPCODE_SET_TUNNEL:
 			/* New tunnel header means l2 to l4 can be matched. */
 			eth_broadcast_addr(&merge->l2.mac_dst[0]);
 			eth_broadcast_addr(&merge->l2.mac_src[0]);
@@ -814,15 +814,15 @@ nfp_fl_verify_post_tun_acts(char *acts, int len, struct nfp_fl_push_vlan **vlan)
 static int
 nfp_fl_push_vlan_after_tun(char *acts, int len, struct nfp_fl_push_vlan *vlan)
 {
-	struct nfp_fl_set_ipv4_tun *tun;
+	struct nfp_fl_set_tun *tun;
 	struct nfp_fl_act_head *a;
 	unsigned int act_off = 0;
 
 	while (act_off < len) {
 		a = (struct nfp_fl_act_head *)&acts[act_off];
 
-		if (a->jump_id == NFP_FL_ACTION_OPCODE_SET_IPV4_TUNNEL) {
-			tun = (struct nfp_fl_set_ipv4_tun *)a;
+		if (a->jump_id == NFP_FL_ACTION_OPCODE_SET_TUNNEL) {
+			tun = (struct nfp_fl_set_tun *)a;
 			tun->outer_vlan_tpid = vlan->vlan_tpid;
 			tun->outer_vlan_tci = vlan->vlan_tci;
 
-- 
2.7.4

