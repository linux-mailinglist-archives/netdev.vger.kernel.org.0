Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1421367E25
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbhDVJty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:49:54 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:34685 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235801AbhDVJtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:49:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UWOJIrC_1619084948;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWOJIrC_1619084948)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 22 Apr 2021 17:49:17 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2] kallsyms: Remove function arch_get_kallsym()
Date:   Thu, 22 Apr 2021 17:49:06 +0800
Message-Id: <1619084946-28509-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

kernel/kallsyms.c:457:12: warning: symbol 'arch_get_kallsym' was not
declared. Should it be static?

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -Remove function arch_get_kallsym().

 kernel/kallsyms.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 8043a90..49c4268 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -454,24 +454,10 @@ struct kallsym_iter {
 	int show_value;
 };
 
-int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
-			    char *type, char *name)
-{
-	return -EINVAL;
-}
-
 static int get_ksymbol_arch(struct kallsym_iter *iter)
 {
-	int ret = arch_get_kallsym(iter->pos - kallsyms_num_syms,
-				   &iter->value, &iter->type,
-				   iter->name);
-
-	if (ret < 0) {
-		iter->pos_arch_end = iter->pos;
-		return 0;
-	}
-
-	return 1;
+	iter->pos_arch_end = iter->pos;
+	return 0;
 }
 
 static int get_ksymbol_mod(struct kallsym_iter *iter)
-- 
1.8.3.1

