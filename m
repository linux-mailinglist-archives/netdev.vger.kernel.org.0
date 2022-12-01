Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4019863F381
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiLAPQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiLAPQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:16:31 -0500
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 714899953F;
        Thu,  1 Dec 2022 07:16:29 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 358CC1E80D27;
        Thu,  1 Dec 2022 23:12:26 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bGIo08odmUoF; Thu,  1 Dec 2022 23:12:23 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 255531E80CD5;
        Thu,  1 Dec 2022 23:12:23 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhe <yuzhe@nfschina.com>, Li Qiong <liqiong@nfschina.com>
Subject: [PATCH] net: sched: fix a error path in fw_change()
Date:   Thu,  1 Dec 2022 23:15:32 +0800
Message-Id: <20221201151532.25433-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'pfp' pointer could be null if can't find the target filter.
Check 'pfp' pointer and fix this error path.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
 net/sched/cls_fw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index a32351da968c..b898e4a81146 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -289,6 +289,12 @@ static int fw_change(struct net *net, struct sk_buff *in_skb,
 			if (pfp == f)
 				break;
 
+		if (!pfp) {
+			tcf_exts_destroy(&fnew->exts);
+			kfree(fnew);
+			return err;
+		}
+
 		RCU_INIT_POINTER(fnew->next, rtnl_dereference(pfp->next));
 		rcu_assign_pointer(*fp, fnew);
 		tcf_unbind_filter(tp, &f->res);
-- 
2.11.0

