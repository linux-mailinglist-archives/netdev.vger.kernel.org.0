Return-Path: <netdev+bounces-5844-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B013713215
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 05:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD9DD2819F6
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC9E9389;
	Sat, 27 May 2023 03:12:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12D5631
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 03:12:57 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466DAE3;
	Fri, 26 May 2023 20:12:56 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QSmvS304nzqSg2;
	Sat, 27 May 2023 11:08:20 +0800 (CST)
Received: from huawei.com (10.175.104.170) by canpemm500002.china.huawei.com
 (7.192.104.244) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sat, 27 May
 2023 11:12:53 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linmiaohe@huawei.com>
Subject: [PATCH] net: skbuff: fix missing a __noreturn annotation warning
Date: Sat, 27 May 2023 19:04:09 +0800
Message-ID: <20230527110409.497408-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.23.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.104.170]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add __noreturn annotation to fix the warning:
 net/core/skbuff.o: warning: objtool: skb_push+0x3c: skb_panic() is missing a __noreturn annotation
 net/core/skbuff.o: warning: objtool: skb_put+0x4e: skb_panic() is missing a __noreturn annotation

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6724a84ebb09..12b525aa4783 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -181,8 +181,8 @@ EXPORT_SYMBOL_GPL(drop_reasons_unregister_subsys);
  *	Keep out of line to prevent kernel bloat.
  *	__builtin_return_address is not used because it is not always reliable.
  */
-static void skb_panic(struct sk_buff *skb, unsigned int sz, void *addr,
-		      const char msg[])
+static void __noreturn skb_panic(struct sk_buff *skb, unsigned int sz, void *addr,
+				 const char msg[])
 {
 	pr_emerg("%s: text:%px len:%d put:%d head:%px data:%px tail:%#lx end:%#lx dev:%s\n",
 		 msg, addr, skb->len, sz, skb->head, skb->data,
-- 
2.27.0


