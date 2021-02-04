Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB8230F6B8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbhBDPsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:48:11 -0500
Received: from mail-m2836.qiye.163.com ([103.74.28.36]:41086 "EHLO
        mail-m2836.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237517AbhBDPrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 10:47:05 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id 2AC67C02DB;
        Thu,  4 Feb 2021 23:46:12 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jhs@mojatatu.com, mleitner@redhat.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v2] net/sched: cls_flower: Reject invalid ct_state flags rules
Date:   Thu,  4 Feb 2021 23:46:11 +0800
Message-Id: <1612453571-3645-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQh1DGB9KHh9MH0wZVkpNSklPTkhOTElJTkxVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ky46HQw6Vj06HAIzMTVOSTQ*
        DhMwCzdVSlVKTUpJT05ITkxJT0hLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhPSkw3Bg++
X-HM-Tid: 0a776db8ee68841ekuqw2ac67c02db
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Reject the unsupported and invalid ct_state flags of cls flower rules.

Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/pkt_cls.h |  7 +++++++
 net/sched/cls_flower.c       | 30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

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
index 84f9325..1cfdbd4 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1390,12 +1390,37 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 	return 0;
 }
 
+static int fl_validate_ct_state(u16 state, struct netlink_ext_ack *extack)
+{
+	if (state & ~TCA_FLOWER_KEY_CT_FLAGS_MASK) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported ct_state flags");
+		return -EINVAL;
+	}
+
+	if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "ct_state trk unset, no other flag are set");
+		return -EINVAL;
+	}
+
+	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "ct_state new and est are exclusive");
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
@@ -1403,6 +1428,11 @@ static int fl_set_key_ct(struct nlattr **tb,
 		fl_set_key_val(tb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
 			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
 			       sizeof(key->ct_state));
+
+		err = fl_validate_ct_state(mask->ct_state, extack);
+		if (err)
+			return err;
+
 	}
 	if (tb[TCA_FLOWER_KEY_CT_ZONE]) {
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
-- 
1.8.3.1

