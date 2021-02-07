Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CD231217A
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 06:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhBGFUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 00:20:21 -0500
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:30869 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhBGFUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 00:20:19 -0500
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Feb 2021 00:20:17 EST
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id D4E0EE01DD6;
        Sun,  7 Feb 2021 13:13:23 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jhs@mojatatu.com, mleitner@redhat.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v4] net/sched: cls_flower: Reject invalid ct_state flags rules
Date:   Sun,  7 Feb 2021 13:13:23 +0800
Message-Id: <1612674803-7912-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSkJDT0waQhgZGE9KVkpNSklNTE9DS0hCTkJVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ohw6Sgw*Lj09DAE2LFY0TCoR
        TzEwFCNVSlVKTUpJTUxPQ0tPSkhOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOSEI3Bg++
X-HM-Tid: 0a777ae8a8c520bdkuqyd4e0ee01dd6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Reject the unsupported and invalid ct_state flags of cls flower rules.

Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/cls_flower.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 84f9325..49ae67b 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -30,6 +30,11 @@
 
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
+#define TCA_FLOWER_KEY_CT_FLAGS_MASK (TCA_FLOWER_KEY_CT_FLAGS_NEW | \
+				      TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED | \
+				      TCA_FLOWER_KEY_CT_FLAGS_RELATED | \
+				      TCA_FLOWER_KEY_CT_FLAGS_TRACKED)
+
 struct fl_flow_key {
 	struct flow_dissector_key_meta meta;
 	struct flow_dissector_key_control control;
@@ -687,7 +692,8 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
 	[TCA_FLOWER_KEY_ENC_OPTS]	= { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_OPTS_MASK]	= { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_CT_STATE]	= { .type = NLA_U16 },
-	[TCA_FLOWER_KEY_CT_STATE_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_STATE_MASK]	=
+		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
 	[TCA_FLOWER_KEY_CT_ZONE]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_CT_ZONE_MASK]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_CT_MARK]	= { .type = NLA_U32 },
@@ -1390,12 +1396,33 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
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
@@ -1403,6 +1430,13 @@ static int fl_set_key_ct(struct nlattr **tb,
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

