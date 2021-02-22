Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21F23210B9
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 07:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhBVGKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 01:10:55 -0500
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:25180 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhBVGKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 01:10:50 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 1D546E0284E;
        Mon, 22 Feb 2021 14:09:51 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, mleitner@redhat.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com
Subject: [PATCH net-next] net/sched: cls_flower: validate ct_state for invalid and reply flags
Date:   Mon, 22 Feb 2021 14:09:50 +0800
Message-Id: <1613974190-12108-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSRkdSB1NS0hLGExJVkpNSkhCTE9KQkpJS0lVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Myo6GBw6Gj02IT9LPCwwNDUe
        E1FPCy9VSlVKTUpIQkxPSkJKT01JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpNSE83Bg++
X-HM-Tid: 0a77c85bbc2720bdkuqy1d546e0284e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add invalid and reply flags validate in the fl_validate_ct_state.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/cls_flower.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 2409e52..18430db 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1417,6 +1417,21 @@ static int fl_validate_ct_state(u16 state, struct nlattr *tb,
 		return -EINVAL;
 	}
 
+	if (state & TCA_FLOWER_KEY_CT_FLAGS_INVALID &&
+	    state & ~(TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
+		      TCA_FLOWER_KEY_CT_FLAGS_INVALID)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "when inv is set, only trk also be set");
+		return -EINVAL;
+	}
+
+	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_REPLY) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "new and rpl are mutually exclusive");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
1.8.3.1

