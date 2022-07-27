Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE348582362
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiG0JmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiG0Jl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:41:59 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9C23402CF;
        Wed, 27 Jul 2022 02:41:55 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 5C34C1E80D54;
        Wed, 27 Jul 2022 17:42:01 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yV9CtT5wv3fh; Wed, 27 Jul 2022 17:41:58 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 8A3BE1E80D05;
        Wed, 27 Jul 2022 17:41:58 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li zeming <zeming@nfschina.com>
Subject: [PATCH] sched/net/act: Remove temporary state variables
Date:   Wed, 27 Jul 2022 17:41:46 +0800
Message-Id: <20220727094146.5990-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The temporary variable ret could be removed and the corresponding state
can be directly returned.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 net/sched/act_api.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 817065aa2833..34b5eb52e68b 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -398,8 +398,6 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
 
 static int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 {
-	int ret = 0;
-
 	/* Release with strict==1 and bind==0 is only called through act API
 	 * interface (classifiers always bind). Only case when action with
 	 * positive reference count and zero bind count can exist is when it was
@@ -417,10 +415,10 @@ static int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 			return -EPERM;
 
 		if (__tcf_action_put(p, bind))
-			ret = ACT_P_DELETED;
+			return ACT_P_DELETED;
 	}
 
-	return ret;
+	return 0;
 }
 
 int tcf_idr_release(struct tc_action *a, bool bind)
-- 
2.18.2

