Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 716EC4CF34
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731985AbfFTNmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:42:43 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43628 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731834AbfFTNmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 09:42:35 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Jun 2019 16:42:29 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5KDgSlO022418;
        Thu, 20 Jun 2019 16:42:29 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Jiri Pirko <jiri@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: [PATCH net-next v2 3/4] net/sched: cls_flower: Add matching on conntrack info
Date:   Thu, 20 Jun 2019 16:42:20 +0300
Message-Id: <1561038141-31370-4-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
References: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New matches for conntrack mark, label, zone, and state.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Yossi Kuperman <yossiku@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/pkt_cls.h |  16 ++++++
 net/sched/cls_flower.c       | 127 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 138 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 7c9d701..6992df1 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -536,12 +536,28 @@ enum {
 	TCA_FLOWER_KEY_PORT_DST_MIN,	/* be16 */
 	TCA_FLOWER_KEY_PORT_DST_MAX,	/* be16 */
 
+	TCA_FLOWER_KEY_CT_STATE,	/* u16 */
+	TCA_FLOWER_KEY_CT_STATE_MASK,	/* u16 */
+	TCA_FLOWER_KEY_CT_ZONE,		/* u16 */
+	TCA_FLOWER_KEY_CT_ZONE_MASK,	/* u16 */
+	TCA_FLOWER_KEY_CT_MARK,		/* u32 */
+	TCA_FLOWER_KEY_CT_MARK_MASK,	/* u32 */
+	TCA_FLOWER_KEY_CT_LABELS,	/* u128 */
+	TCA_FLOWER_KEY_CT_LABELS_MASK,	/* u128 */
+
 	__TCA_FLOWER_MAX,
 };
 
 #define TCA_FLOWER_MAX (__TCA_FLOWER_MAX - 1)
 
 enum {
+	TCA_FLOWER_KEY_CT_FLAGS_NEW = 1 << 0, /* Beginning of a new connection. */
+	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
+	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
+	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
+};
+
+enum {
 	TCA_FLOWER_KEY_ENC_OPTS_UNSPEC,
 	TCA_FLOWER_KEY_ENC_OPTS_GENEVE, /* Nested
 					 * TCA_FLOWER_KEY_ENC_OPT_GENEVE_
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index bd1767d..883bb3b 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -26,6 +26,8 @@
 #include <net/dst.h>
 #include <net/dst_metadata.h>
 
+#include <uapi/linux/netfilter/nf_conntrack_common.h>
+
 struct fl_flow_key {
 	int	indev_ifindex;
 	struct flow_dissector_key_control control;
@@ -54,6 +56,7 @@ struct fl_flow_key {
 	struct flow_dissector_key_enc_opts enc_opts;
 	struct flow_dissector_key_ports tp_min;
 	struct flow_dissector_key_ports tp_max;
+	struct flow_dissector_key_ct ct;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct fl_flow_mask_range {
@@ -272,14 +275,27 @@ static struct cls_fl_filter *fl_lookup(struct fl_flow_mask *mask,
 	return __fl_lookup(mask, mkey);
 }
 
+static u16 fl_ct_info_to_flower_map[] = {
+	[IP_CT_ESTABLISHED] =		TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
+					TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED,
+	[IP_CT_RELATED] =		TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
+					TCA_FLOWER_KEY_CT_FLAGS_RELATED,
+	[IP_CT_ESTABLISHED_REPLY] =	TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
+					TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED,
+	[IP_CT_RELATED_REPLY] =		TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
+					TCA_FLOWER_KEY_CT_FLAGS_RELATED,
+	[IP_CT_NEW] =			TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
+					TCA_FLOWER_KEY_CT_FLAGS_NEW,
+};
+
 static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		       struct tcf_result *res)
 {
 	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
-	struct cls_fl_filter *f;
-	struct fl_flow_mask *mask;
-	struct fl_flow_key skb_key;
 	struct fl_flow_key skb_mkey;
+	struct fl_flow_key skb_key;
+	struct fl_flow_mask *mask;
+	struct cls_fl_filter *f;
 
 	list_for_each_entry_rcu(mask, &head->masks, list) {
 		fl_clear_masked_range(&skb_key, mask);
@@ -290,6 +306,9 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		 */
 		skb_key.basic.n_proto = skb->protocol;
 		skb_flow_dissect_tunnel_info(skb, &mask->dissector, &skb_key);
+		skb_flow_dissect_ct(skb, &mask->dissector, &skb_key,
+				    fl_ct_info_to_flower_map,
+				    ARRAY_SIZE(fl_ct_info_to_flower_map));
 		skb_flow_dissect(skb, &mask->dissector, &skb_key, 0);
 
 		fl_set_masked_key(&skb_mkey, &skb_key, mask);
@@ -704,6 +723,16 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
 	[TCA_FLOWER_KEY_ENC_IP_TTL_MASK] = { .type = NLA_U8 },
 	[TCA_FLOWER_KEY_ENC_OPTS]	= { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_OPTS_MASK]	= { .type = NLA_NESTED },
+	[TCA_FLOWER_KEY_CT_STATE]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_STATE_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_ZONE]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_ZONE_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_MARK]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_CT_MARK_MASK]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_CT_LABELS]	= { .type = NLA_BINARY,
+					    .len = 128 / BITS_PER_BYTE },
+	[TCA_FLOWER_KEY_CT_LABELS_MASK]	= { .type = NLA_BINARY,
+					    .len = 128 / BITS_PER_BYTE },
 };
 
 static const struct nla_policy
@@ -725,11 +754,11 @@ static void fl_set_key_val(struct nlattr **tb,
 {
 	if (!tb[val_type])
 		return;
-	memcpy(val, nla_data(tb[val_type]), len);
+	nla_memcpy(val, tb[val_type], len);
 	if (mask_type == TCA_FLOWER_UNSPEC || !tb[mask_type])
 		memset(mask, 0xff, len);
 	else
-		memcpy(mask, nla_data(tb[mask_type]), len);
+		nla_memcpy(mask, tb[mask_type], len);
 }
 
 static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
@@ -1015,6 +1044,51 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 	return 0;
 }
 
+static int fl_set_key_ct(struct nlattr **tb,
+			 struct flow_dissector_key_ct *key,
+			 struct flow_dissector_key_ct *mask,
+			 struct netlink_ext_ack *extack)
+{
+	if (tb[TCA_FLOWER_KEY_CT_STATE]) {
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK)) {
+			NL_SET_ERR_MSG(extack, "Conntrack isn't enabled");
+			return -EOPNOTSUPP;
+		}
+		fl_set_key_val(tb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
+			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
+			       sizeof(key->ct_state));
+	}
+	if (tb[TCA_FLOWER_KEY_CT_ZONE]) {
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
+			NL_SET_ERR_MSG(extack, "Conntrack zones isn't enabled");
+			return -EOPNOTSUPP;
+		}
+		fl_set_key_val(tb, &key->ct_zone, TCA_FLOWER_KEY_CT_ZONE,
+			       &mask->ct_zone, TCA_FLOWER_KEY_CT_ZONE_MASK,
+			       sizeof(key->ct_zone));
+	}
+	if (tb[TCA_FLOWER_KEY_CT_MARK]) {
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)) {
+			NL_SET_ERR_MSG(extack, "Conntrack mark isn't enabled");
+			return -EOPNOTSUPP;
+		}
+		fl_set_key_val(tb, &key->ct_mark, TCA_FLOWER_KEY_CT_MARK,
+			       &mask->ct_mark, TCA_FLOWER_KEY_CT_MARK_MASK,
+			       sizeof(key->ct_mark));
+	}
+	if (tb[TCA_FLOWER_KEY_CT_LABELS]) {
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS)) {
+			NL_SET_ERR_MSG(extack, "Conntrack labels aren't enabled");
+			return -EOPNOTSUPP;
+		}
+		fl_set_key_val(tb, key->ct_labels, TCA_FLOWER_KEY_CT_LABELS,
+			       mask->ct_labels, TCA_FLOWER_KEY_CT_LABELS_MASK,
+			       sizeof(key->ct_labels));
+	}
+
+	return 0;
+}
+
 static int fl_set_key(struct net *net, struct nlattr **tb,
 		      struct fl_flow_key *key, struct fl_flow_key *mask,
 		      struct netlink_ext_ack *extack)
@@ -1224,6 +1298,10 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 			return ret;
 	}
 
+	ret = fl_set_key_ct(tb, &key->ct, &mask->ct, extack);
+	if (ret)
+		return ret;
+
 	if (tb[TCA_FLOWER_KEY_FLAGS])
 		ret = fl_set_key_flags(tb, &key->control.flags, &mask->control.flags);
 
@@ -1322,6 +1400,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_ENC_IP, enc_ip);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_ENC_OPTS, enc_opts);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_CT, ct);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -2076,6 +2156,40 @@ static int fl_dump_key_geneve_opt(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int fl_dump_key_ct(struct sk_buff *skb,
+			  struct flow_dissector_key_ct *key,
+			  struct flow_dissector_key_ct *mask)
+{
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK) &&
+	    fl_dump_key_val(skb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
+			    &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
+			    sizeof(key->ct_state)))
+		goto nla_put_failure;
+
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES) &&
+	    fl_dump_key_val(skb, &key->ct_zone, TCA_FLOWER_KEY_CT_ZONE,
+			    &mask->ct_zone, TCA_FLOWER_KEY_CT_ZONE_MASK,
+			    sizeof(key->ct_zone)))
+		goto nla_put_failure;
+
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK_MARK) &&
+	    fl_dump_key_val(skb, &key->ct_mark, TCA_FLOWER_KEY_CT_MARK,
+			    &mask->ct_mark, TCA_FLOWER_KEY_CT_MARK_MASK,
+			    sizeof(key->ct_mark)))
+		goto nla_put_failure;
+
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
+	    fl_dump_key_val(skb, &key->ct_labels, TCA_FLOWER_KEY_CT_LABELS,
+			    &mask->ct_labels, TCA_FLOWER_KEY_CT_LABELS_MASK,
+			    sizeof(key->ct_labels)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static int fl_dump_key_options(struct sk_buff *skb, int enc_opt_type,
 			       struct flow_dissector_key_enc_opts *enc_opts)
 {
@@ -2309,6 +2423,9 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 	    fl_dump_key_enc_opt(skb, &key->enc_opts, &mask->enc_opts))
 		goto nla_put_failure;
 
+	if (fl_dump_key_ct(skb, &key->ct, &mask->ct))
+		goto nla_put_failure;
+
 	if (fl_dump_key_flags(skb, key->control.flags, mask->control.flags))
 		goto nla_put_failure;
 
-- 
1.8.3.1

