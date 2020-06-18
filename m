Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA831FFDC7
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgFRWQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:16:16 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36865 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727827AbgFRWQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:16:15 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from lariel@mellanox.com)
        with SMTP; 19 Jun 2020 01:16:12 +0300
Received: from gen-l-vrt-029.mtl.labs.mlnx (gen-l-vrt-029.mtl.labs.mlnx [10.237.29.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 05IMG9Gf012581;
        Fri, 19 Jun 2020 01:16:12 +0300
From:   Ariel Levkovich <lariel@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Ariel Levkovich <lariel@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 2/3] net/flow_dissector: add packet hash dissection
Date:   Fri, 19 Jun 2020 01:15:47 +0300
Message-Id: <20200618221548.3805-3-lariel@mellanox.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200618221548.3805-1-lariel@mellanox.com>
References: <20200618221548.3805-1-lariel@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Retreive a hash value from the SKB and store it
in the dissector key for future matching.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/linux/skbuff.h       |  4 ++++
 include/net/flow_dissector.h |  9 +++++++++
 net/core/flow_dissector.c    | 17 +++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0c0377fc00c2..beb7fe2c7809 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1342,6 +1342,10 @@ skb_flow_dissect_tunnel_info(const struct sk_buff *skb,
 			     struct flow_dissector *flow_dissector,
 			     void *target_container);
 
+void skb_flow_dissect_hash(const struct sk_buff *skb,
+			   struct flow_dissector *flow_dissector,
+			   void *target_container);
+
 static inline __u32 skb_get_hash(struct sk_buff *skb)
 {
 	if (!skb->l4_hash && !skb->sw_hash)
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index a7eba43fe4e4..5cc0540ce3f7 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -243,6 +243,14 @@ struct flow_dissector_key_ct {
 	u32	ct_labels[4];
 };
 
+/**
+ * struct flow_dissector_key_hash:
+ * @hash: hash value
+ */
+struct flow_dissector_key_hash {
+	u32 hash;
+};
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -271,6 +279,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_ENC_OPTS, /* struct flow_dissector_key_enc_opts */
 	FLOW_DISSECTOR_KEY_META, /* struct flow_dissector_key_meta */
 	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
+	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index d02df0b6d0d9..c114f0e3ef4f 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -392,6 +392,23 @@ skb_flow_dissect_tunnel_info(const struct sk_buff *skb,
 }
 EXPORT_SYMBOL(skb_flow_dissect_tunnel_info);
 
+void skb_flow_dissect_hash(const struct sk_buff *skb,
+			   struct flow_dissector *flow_dissector,
+			   void *target_container)
+{
+	struct flow_dissector_key_hash *key;
+
+	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_HASH))
+		return;
+
+	key = skb_flow_dissector_target(flow_dissector,
+					FLOW_DISSECTOR_KEY_HASH,
+					target_container);
+
+	key->hash = skb_get_hash_raw(skb);
+}
+EXPORT_SYMBOL(skb_flow_dissect_hash);
+
 static enum flow_dissect_ret
 __skb_flow_dissect_mpls(const struct sk_buff *skb,
 			struct flow_dissector *flow_dissector,
-- 
2.25.2

