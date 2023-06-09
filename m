Return-Path: <netdev+bounces-9439-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26C2472908A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CDFB281841
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 07:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7951C6D39;
	Fri,  9 Jun 2023 07:01:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A49185A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:01:38 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E5B26AD;
	Fri,  9 Jun 2023 00:01:31 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vkh.u4r_1686294078;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Vkh.u4r_1686294078)
          by smtp.aliyun-inc.com;
          Fri, 09 Jun 2023 15:01:27 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: jhs@mojatatu.com
Cc: xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] net/sched: act_pedit: Use kmemdup() to replace kmalloc + memcpy
Date: Fri,  9 Jun 2023 15:01:17 +0800
Message-Id: <20230609070117.100507-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

./net/sched/act_pedit.c:245:21-28: WARNING opportunity for kmemdup.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5478
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/sched/act_pedit.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index fc945c7e4123..8c4e7fddddbf 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -242,14 +242,12 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	nparms->tcfp_flags = parm->flags;
 	nparms->tcfp_nkeys = parm->nkeys;
 
-	nparms->tcfp_keys = kmalloc(ksize, GFP_KERNEL);
+	nparms->tcfp_keys = kmemdup(parm->keys, ksize, GFP_KERNEL);
 	if (!nparms->tcfp_keys) {
 		ret = -ENOMEM;
 		goto put_chain;
 	}
 
-	memcpy(nparms->tcfp_keys, parm->keys, ksize);
-
 	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
 		u32 offmask = nparms->tcfp_keys[i].offmask;
 		u32 cur = nparms->tcfp_keys[i].off;
-- 
2.20.1.7.g153144c


