Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5C23B9B1B
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 05:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbhGBDp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 23:45:57 -0400
Received: from mail-m2456.qiye.163.com ([220.194.24.56]:23734 "EHLO
        mail-m2456.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbhGBDp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 23:45:57 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2021 23:45:56 EDT
Received: from localhost.localdomain (unknown [117.50.0.204])
        by mail-m2456.qiye.163.com (Hmail) with ESMTPA id DCF9670016D;
        Fri,  2 Jul 2021 11:34:31 +0800 (CST)
From:   wenxu@ucloud.cn
To:     marcelo.leitner@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jhs@mojatatu.com
Subject: [PATCH] net/sched: act_ct: fix err check for nf_conntrack_confirm
Date:   Fri,  2 Jul 2021 11:34:31 +0800
Message-Id: <1625196871-2780-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGU5JHVZLSkxOTE5CGhlJGU9VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MTY6Dww6KT03Qkk#TUwPQzwW
        OhVPFB1VSlVKTUlOSkJNQ0xJSkpLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTFVO
        S1VLVUlLT1lXWQgBWUFKT01PNwY+
X-HM-Tid: 0a7a654840f58c15kuqtdcf9670016d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The confirm operation should be checked. If there are any failed,
the packet should be dropped like in ovs and netfilter.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/act_ct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index a656baa..a62f404 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1026,7 +1026,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		/* This will take care of sending queued events
 		 * even if the connection is already confirmed.
 		 */
-		nf_conntrack_confirm(skb);
+		if (nf_conntrack_confirm(skb) != NF_ACCEPT)
+			goto drop;
 	}
 
 	if (!skip_add)
-- 
1.8.3.1

