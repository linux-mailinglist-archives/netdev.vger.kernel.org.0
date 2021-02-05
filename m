Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6931E310576
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 08:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhBEHI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 02:08:29 -0500
Received: from mail-m2836.qiye.163.com ([103.74.28.36]:50170 "EHLO
        mail-m2836.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhBEHIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 02:08:22 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id 583C9C00ED;
        Fri,  5 Feb 2021 15:07:30 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, mleitner@redhat.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com
Subject: [PATCH net v3] net/sched: cls_flower: Reject invalid ct_state flags rules
Date:   Fri,  5 Feb 2021 15:07:30 +0800
Message-Id: <1612508850-11577-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZThpMGB0YGh8dTUpCVkpNSklOS0NDTktOSE9VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MjY6DRw*PT0rMgIiD1EjSB8s
        DAswCTxVSlVKTUpJTktDQ05LTE1KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9JTU43Bg++
X-HM-Tid: 0a77710468e8841ekuqw583c9c00ed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Reject the unsupported and invalid ct_state flags of cls flower rules.

Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v3: using NLA_POLICY_MASK and NL_SET_ERR_MSG_ATTR

 include/uapi/linux/pkt_cls.h |  7 +++++++
 net/sched/cls_flower.c       | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee95f42..77df582 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -591,8 +591,15 @@ enum {
 	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
+
+	__TCA_FLOWER_KEY_CT_FLAGS_MAX,
 };
 
+#define TCA_FLOWER_KEY_CT_FLAGS_MAX \
+		((__TCA_FLOWER_KEY_CT_FLAGS_MAX - 1) << 1)
+#define TCA_FLOWER_KEY_CT_FLAGS_MASK \
+		(TCA_FLOWER_KEY_CT_FLAGS_MAX - 1)
+
 enum {
 	TCA_FLOWER_KEY_ENC_OPTS_UNSPEC,
 	TCA_FLOWER_KEY_ENC_OPTS_GENEVE, /* Nested
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 84f9325..4aebf4e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -30,6 +30,9 @@
 
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
+#define TCA_FLOWER_KEY_CT_STATE_MASK_TYPE \
+			NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK)
+
 struct fl_flow_key {
 	struct flow_dissector_key_meta meta;
 	struct flow_dissector_key_control control;
@@ -687,7 +690,7 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
 	[TCA_FLOWER_KEY_ENC_OPTS]	= { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_OPTS_MASK]	= { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_CT_STATE]	= { .type = NLA_U16 },
-	[TCA_FLOWER_KEY_CT_STATE_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_STATE_MASK]	= TCA_FLOWER_KEY_CT_STATE_MASK_TYPE,
 	[TCA_FLOWER_KEY_CT_ZONE]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_CT_ZONE_MASK]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_CT_MARK]	= { .type = NLA_U32 },
@@ -1390,12 +1393,33 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 	return 0;
 }
 
+static int fl_validate_ct_state(u16 state, struct nlattr *tb,
+				struct netlink_ext_ack *extack)
+{
+	if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "ct_state no trk, no other flag are set");
+		return -EINVAL;
+	}
+
+	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "ct_state new and est are exclusive");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int fl_set_key_ct(struct nlattr **tb,
 			 struct flow_dissector_key_ct *key,
 			 struct flow_dissector_key_ct *mask,
 			 struct netlink_ext_ack *extack)
 {
 	if (tb[TCA_FLOWER_KEY_CT_STATE]) {
+		int err;
+
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK)) {
 			NL_SET_ERR_MSG(extack, "Conntrack isn't enabled");
 			return -EOPNOTSUPP;
@@ -1403,6 +1427,13 @@ static int fl_set_key_ct(struct nlattr **tb,
 		fl_set_key_val(tb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
 			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
 			       sizeof(key->ct_state));
+
+		err = fl_validate_ct_state(mask->ct_state,
+					   tb[TCA_FLOWER_KEY_CT_STATE_MASK],
+					   extack);
+		if (err)
+			return err;
+
 	}
 	if (tb[TCA_FLOWER_KEY_CT_ZONE]) {
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
-- 
1.8.3.1

