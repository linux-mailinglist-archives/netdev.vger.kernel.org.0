Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA34633E83F
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 05:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhCQEDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 00:03:09 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:8066 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhCQECq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 00:02:46 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id BA046E028E4;
        Wed, 17 Mar 2021 12:02:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, mleitner@redhat.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, davem@davemloft.net
Subject: [PATCH net v2] net/sched: cls_flower: fix only mask bit check in the validate_ct_state
Date:   Wed, 17 Mar 2021 12:02:43 +0800
Message-Id: <1615953763-23824-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTE4fGB8eSx8ZHhhDVkpNSk5CTkhMTUhDSk9VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PS46TRw*OT01PSM4Qyk1AzIL
        Tw4aCRNVSlVKTUpOQk5ITE1IQkxPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlLQ0w3Bg++
X-HM-Tid: 0a783e599dd320bdkuqyba046e028e4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The ct_state validate should not only check the mask bit and also
check mask_bit & key_bit..
For the +new+est case example, The 'new' and 'est' bits should be
set in both state_mask and state flags. Or the -new-est case also
will be reject by kernel.
When Openvswitch with two flows
ct_state=+trk+new,action=commit,forward
ct_state=+trk+est,action=forward

A packet go through the kernel  and the contrack state is invalid,
The ct_state will be +trk-inv. Upcall to the ovs-vswitchd, the
finally dp action will be drop with -new-est+trk.

Fixes: 1bcc51ac0731 ("net/sched: cls_flower: Reject invalid ct_state flags rules")
Fixes: 3aed8b63336c ("net/sched: cls_flower: validate ct_state for invalid and reply flags")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/cls_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index d097b5c..c69a4ba 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1451,7 +1451,7 @@ static int fl_set_key_ct(struct nlattr **tb,
 			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
 			       sizeof(key->ct_state));
 
-		err = fl_validate_ct_state(mask->ct_state,
+		err = fl_validate_ct_state(key->ct_state & mask->ct_state,
 					   tb[TCA_FLOWER_KEY_CT_STATE_MASK],
 					   extack);
 		if (err)
-- 
1.8.3.1

