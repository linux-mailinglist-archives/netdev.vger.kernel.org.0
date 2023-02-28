Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90A86A504A
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 01:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjB1Awj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 19:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjB1Awa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 19:52:30 -0500
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AF126857;
        Mon, 27 Feb 2023 16:52:21 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VcgbXXg_1677545538;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VcgbXXg_1677545538)
          by smtp.aliyun-inc.com;
          Tue, 28 Feb 2023 08:52:19 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, ralf@linux-mips.org, edumazet@google.com,
        pabeni@redhat.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next] net: rose: Remove NULL check before dev_{put, hold}
Date:   Tue, 28 Feb 2023 08:52:17 +0800
Message-Id: <20230228005217.105058-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call netdev_{put, hold} of dev_{put, hold} will check NULL,
so there is no need to check before using dev_{put, hold},
remove it to silence the warning：

./net/rose/rose_route.c:619:2-10: WARNING: NULL check before dev_{put, hold} functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4239
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/rose/rose_route.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index fee772b4637c..58d0312c0119 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -615,8 +615,7 @@ struct net_device *rose_dev_first(void)
 			if (first == NULL || strncmp(dev->name, first->name, 3) < 0)
 				first = dev;
 	}
-	if (first)
-		dev_hold(first);
+	dev_hold(first);
 	rcu_read_unlock();
 
 	return first;
-- 
2.20.1.7.g153144c

