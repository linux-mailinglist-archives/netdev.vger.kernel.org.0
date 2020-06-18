Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C801FFDCA
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgFRWQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:16:23 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36893 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729278AbgFRWQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:16:19 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from lariel@mellanox.com)
        with SMTP; 19 Jun 2020 01:16:15 +0300
Received: from gen-l-vrt-029.mtl.labs.mlnx (gen-l-vrt-029.mtl.labs.mlnx [10.237.29.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 05IMG9Gg012581;
        Fri, 19 Jun 2020 01:16:15 +0300
From:   Ariel Levkovich <lariel@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Ariel Levkovich <lariel@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 3/3] net/sched: cls_flower: Add hash info to flow classification
Date:   Fri, 19 Jun 2020 01:15:48 +0300
Message-Id: <20200618221548.3805-4-lariel@mellanox.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200618221548.3805-1-lariel@mellanox.com>
References: <20200618221548.3805-1-lariel@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding new cls flower keys for hash value and hash
mask and dissect the hash info from the skb into
the flow key towards flow classication.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/pkt_cls.h |  3 +++
 net/sched/cls_flower.c       | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 2fd93389d091..ef145320ee99 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -579,6 +579,9 @@ enum {
 
 	TCA_FLOWER_KEY_MPLS_OPTS,
 
+	TCA_FLOWER_KEY_HASH,		/* u32 */
+	TCA_FLOWER_KEY_HASH_MASK,	/* u32 */
+
 	__TCA_FLOWER_MAX,
 };
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index b2da37286082..ff739e0d86fc 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -64,6 +64,7 @@ struct fl_flow_key {
 		};
 	} tp_range;
 	struct flow_dissector_key_ct ct;
+	struct flow_dissector_key_hash hash;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct fl_flow_mask_range {
@@ -318,6 +319,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		skb_flow_dissect_ct(skb, &mask->dissector, &skb_key,
 				    fl_ct_info_to_flower_map,
 				    ARRAY_SIZE(fl_ct_info_to_flower_map));
+		skb_flow_dissect_hash(skb, &mask->dissector, &skb_key);
 		skb_flow_dissect(skb, &mask->dissector, &skb_key, 0);
 
 		f = fl_mask_lookup(mask, &skb_key);
@@ -694,6 +696,9 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_CT_LABELS_MASK]	= { .type = NLA_BINARY,
 					    .len = 128 / BITS_PER_BYTE },
 	[TCA_FLOWER_FLAGS]		= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_HASH]		= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_HASH_MASK]	= { .type = NLA_U32 },
+
 };
 
 static const struct nla_policy
@@ -1625,6 +1630,10 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 
 	fl_set_key_ip(tb, true, &key->enc_ip, &mask->enc_ip);
 
+	fl_set_key_val(tb, &key->hash.hash, TCA_FLOWER_KEY_HASH,
+		       &mask->hash.hash, TCA_FLOWER_KEY_HASH_MASK,
+		       sizeof(key->hash.hash));
+
 	if (tb[TCA_FLOWER_KEY_ENC_OPTS]) {
 		ret = fl_set_enc_opt(tb, key, mask, extack);
 		if (ret)
@@ -1739,6 +1748,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_ENC_OPTS, enc_opts);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_CT, ct);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_HASH, hash);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -2959,6 +2970,11 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 	if (fl_dump_key_flags(skb, key->control.flags, mask->control.flags))
 		goto nla_put_failure;
 
+	if (fl_dump_key_val(skb, &key->hash.hash, TCA_FLOWER_KEY_HASH,
+			     &mask->hash.hash, TCA_FLOWER_KEY_HASH_MASK,
+			     sizeof(key->hash.hash)))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
-- 
2.25.2

