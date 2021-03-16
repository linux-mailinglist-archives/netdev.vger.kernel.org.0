Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8AF33CEC9
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 08:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhCPHol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 03:44:41 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:55535 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbhCPHoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 03:44:21 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 65B5EE02B29;
        Tue, 16 Mar 2021 15:44:18 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, mleitner@redhat.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, davem@davemloft.net
Subject: [PATCH net] net/sched: cls_flower: fix only mask bit check in the validate_ct_state
Date:   Tue, 16 Mar 2021 15:44:17 +0800
Message-Id: <1615880657-10364-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZThoaSE5PT05DQh0aVkpNSk5DQ0tNTkNOSkhVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PUk6Eyo6ST05DyMfHDYYTk5M
        LTYKCitVSlVKTUpOQ0NLTU5DTU1OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhPQ0k3Bg++
X-HM-Tid: 0a7839fe1e4220bdkuqy65b5ee02b29
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The ct_state validate should not only check the mask bit and also
check the state bit.
For the +new+est case example, The 'new' and 'est' bits should be
set in both state_mask and state flags. Or the -new-est case also
will be reject by kernel.

Fixes: 	1bcc51ac0731 ("net/sched: cls_flower: Reject invalid ct_state flags rules")
Fixes: 	3aed8b63336c ("net/sched: cls_flower: validate ct_state for invalid and reply flags")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/cls_flower.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index d097b5c..92659e1 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1401,31 +1401,37 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 	return 0;
 }
 
-static int fl_validate_ct_state(u16 state, struct nlattr *tb,
+static int fl_validate_ct_state(u16 state_mask, u16 state,
+				struct nlattr *tb,
 				struct netlink_ext_ack *extack)
 {
-	if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
+	if (state_mask && !(state_mask & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
 		NL_SET_ERR_MSG_ATTR(extack, tb,
 				    "no trk, so no other flag can be set");
 		return -EINVAL;
 	}
 
-	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	if (state_mask & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state_mask & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED &&
 	    state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
 		NL_SET_ERR_MSG_ATTR(extack, tb,
 				    "new and est are mutually exclusive");
 		return -EINVAL;
 	}
 
-	if (state & TCA_FLOWER_KEY_CT_FLAGS_INVALID &&
-	    state & ~(TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
+	if (state_mask & TCA_FLOWER_KEY_CT_FLAGS_INVALID &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_INVALID &&
+	    state_mask & ~(TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
 		      TCA_FLOWER_KEY_CT_FLAGS_INVALID)) {
 		NL_SET_ERR_MSG_ATTR(extack, tb,
 				    "when inv is set, only trk may be set");
 		return -EINVAL;
 	}
 
-	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	if (state_mask & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state_mask & TCA_FLOWER_KEY_CT_FLAGS_REPLY &&
 	    state & TCA_FLOWER_KEY_CT_FLAGS_REPLY) {
 		NL_SET_ERR_MSG_ATTR(extack, tb,
 				    "new and rpl are mutually exclusive");
@@ -1451,7 +1457,7 @@ static int fl_set_key_ct(struct nlattr **tb,
 			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
 			       sizeof(key->ct_state));
 
-		err = fl_validate_ct_state(mask->ct_state,
+		err = fl_validate_ct_state(mask->ct_state, key->ct_state,
 					   tb[TCA_FLOWER_KEY_CT_STATE_MASK],
 					   extack);
 		if (err)
-- 
1.8.3.1

