Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD86A3148FD
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhBIGin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:38:43 -0500
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:38418 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhBIGim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 01:38:42 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 8B225E02ADC;
        Tue,  9 Feb 2021 14:37:49 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jhs@mojatatu.com, mleitner@redhat.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v5] net/sched: cls_flower: Reject invalid ct_state flags rules
Date:   Tue,  9 Feb 2021 14:37:49 +0800
Message-Id: <1612852669-4165-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSUsfSUsaGE5NHR9CVkpNSklDTklNTUJNT01VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MAw6KQw5Vj0*OlFWFhc1Qw4y
        MxxPFBRVSlVKTUpJQ05JTU1CQ0pJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9KQk43Bg++
X-HM-Tid: 0a778582ac9a20bdkuqy8b225e02adc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Reject the unsupported and invalid ct_state flags of cls flower rules.

Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/pkt_cls.h |  2 ++
 net/sched/cls_flower.c       | 39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee95f42..88f4bf0 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -591,6 +591,8 @@ enum {
 	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
+
+	__TCA_FLOWER_KEY_CT_FLAGS_MAX,
 };
 
 enum {
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 84f9325..46c1b3e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -30,6 +30,11 @@
 
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
+#define TCA_FLOWER_KEY_CT_FLAGS_MAX \
+		((__TCA_FLOWER_KEY_CT_FLAGS_MAX - 1) << 1)
+#define TCA_FLOWER_KEY_CT_FLAGS_MASK \
+		(TCA_FLOWER_KEY_CT_FLAGS_MAX - 1)
+
 struct fl_flow_key {
 	struct flow_dissector_key_meta meta;
 	struct flow_dissector_key_control control;
@@ -686,8 +691,10 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
 	[TCA_FLOWER_KEY_ENC_IP_TTL_MASK] = { .type = NLA_U8 },
 	[TCA_FLOWER_KEY_ENC_OPTS]	= { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_OPTS_MASK]	= { .type = NLA_NESTED },
-	[TCA_FLOWER_KEY_CT_STATE]	= { .type = NLA_U16 },
-	[TCA_FLOWER_KEY_CT_STATE_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_STATE]	=
+		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
+	[TCA_FLOWER_KEY_CT_STATE_MASK]	=
+		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
 	[TCA_FLOWER_KEY_CT_ZONE]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_CT_ZONE_MASK]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_CT_MARK]	= { .type = NLA_U32 },
@@ -1390,12 +1397,33 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 	return 0;
 }
 
+static int fl_validate_ct_state(u16 state, struct nlattr *tb,
+				struct netlink_ext_ack *extack)
+{
+	if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "no trk, so no other flag can be set");
+		return -EINVAL;
+	}
+
+	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "new and est are mutually exclusive");
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
@@ -1403,6 +1431,13 @@ static int fl_set_key_ct(struct nlattr **tb,
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

