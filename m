Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22A446E260
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 07:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhLIGZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 01:25:15 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:50538 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232838AbhLIGZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 01:25:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0V-1Ukdr_1639030886;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V-1Ukdr_1639030886)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Dec 2021 14:21:39 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] bpf: use kmemdup() to replace kmalloc + memcpy
Date:   Thu,  9 Dec 2021 14:21:22 +0800
Message-Id: <1639030882-92383-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow coccicheck warning:

./kernel/bpf/btf.c:6537:13-20: WARNING opportunity for kmemdup.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 kernel/bpf/btf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 10e7a65..94f0342 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6534,12 +6534,11 @@ static struct bpf_cand_cache *populate_cand_cache(struct bpf_cand_cache *cands,
 		bpf_free_cands_from_cache(*cc);
 		*cc = NULL;
 	}
-	new_cands = kmalloc(sizeof_cands(cands->cnt), GFP_KERNEL);
+	new_cands = kmemdup(cands, sizeof_cands(cands->cnt), GFP_KERNEL);
 	if (!new_cands) {
 		bpf_free_cands(cands);
 		return ERR_PTR(-ENOMEM);
 	}
-	memcpy(new_cands, cands, sizeof_cands(cands->cnt));
 	/* strdup the name, since it will stay in cache.
 	 * the cands->name points to strings in prog's BTF and the prog can be unloaded.
 	 */
-- 
1.8.3.1

