Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF41D30EB8D
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 05:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhBDEZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 23:25:29 -0500
Received: from mail-m2836.qiye.163.com ([103.74.28.36]:58554 "EHLO
        mail-m2836.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhBDEZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 23:25:28 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Feb 2021 23:25:25 EST
Received: from localhost.localdomain (unknown [123.59.132.129])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id B1B3DC00A9;
        Thu,  4 Feb 2021 12:17:24 +0800 (CST)
From:   wenxu@ucloud.cn
To:     mleitner@redhat.com, i.maximets@ovn.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net/sched: cls_flower: Return invalid for unknown ct_state flags rules
Date:   Thu,  4 Feb 2021 12:17:24 +0800
Message-Id: <1612412244-26434-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZHUJDQh0dSRpOHh1MVkpNSklPSklJT09DSEtVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OEk6FCo*Qz0xEAIJPiwtNzUZ
        LR0KCwFVSlVKTUpJT0pJSU9PQk5DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlPSU83Bg++
X-HM-Tid: 0a776b42530d841ekuqwb1b3dc00a9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Reject the unknown ct_state flags of cls flower rules. This also make
the userspace like ovs to probe the ct_state flags support in the
kernel.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/pkt_cls.h | 9 +++++++++
 net/sched/cls_flower.c       | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee95f42..1ac8ff8 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -591,8 +591,17 @@ enum {
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
+#define TCA_FLOWER_KEY_CT_FLAGS_UNKNOWN(v) \
+		((v) & (~TCA_FLOWER_KEY_CT_FLAGS_MASK))
+
 enum {
 	TCA_FLOWER_KEY_ENC_OPTS_UNSPEC,
 	TCA_FLOWER_KEY_ENC_OPTS_GENEVE, /* Nested
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 84f9325..ebee70f 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1403,6 +1403,10 @@ static int fl_set_key_ct(struct nlattr **tb,
 		fl_set_key_val(tb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
 			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
 			       sizeof(key->ct_state));
+		if (TCA_FLOWER_KEY_CT_FLAGS_UNKNOWN(mask->ct_state)) {
+			NL_SET_ERR_MSG(extack, "invalid ct_state flags");
+			return -EINVAL;
+		}
 	}
 	if (tb[TCA_FLOWER_KEY_CT_ZONE]) {
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
-- 
1.8.3.1

