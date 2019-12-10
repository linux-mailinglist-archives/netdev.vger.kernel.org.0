Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811BA119587
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbfLJVVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728840AbfLJVLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A20CA24697;
        Tue, 10 Dec 2019 21:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012307;
        bh=ZgnB4lFM8X3vrrBvyCDddzp2I40k+9vWfvOWfY48zDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIx0yhS2vzMelBtWSrSnYlS4Y5BkGNWh1HmNUJEsYtQXWdHs5fDn+LVeuQMpKfbjg
         cg0TE1ltgzk75StLY+3fD/DfV66WvM5tnOMkJAHXi0FjNtM6t64T23WrvC/YFvssPY
         e4hiYqNFewrwRsMGoafgTHnEBFSOzkGLPpgBbqB8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 243/350] s390/bpf: Use kvcalloc for addrs array
Date:   Tue, 10 Dec 2019 16:05:48 -0500
Message-Id: <20191210210735.9077-204-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 166f11d11f6f70439830d09bfa5552ec1b368494 ]

A BPF program may consist of 1m instructions, which means JIT
instruction-address mapping can be as large as 4m. s390 has
FORCE_MAX_ZONEORDER=9 (for memory hotplug reasons), which means maximum
kmalloc size is 1m. This makes it impossible to JIT programs with more
than 256k instructions.

Fix by using kvcalloc, which falls back to vmalloc for larger
allocations. An alternative would be to use a radix tree, but that is
not supported by bpf_prog_fill_jited_linfo.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191107141838.92202-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index ce88211b9c6cd..c8c16b5eed6be 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -23,6 +23,7 @@
 #include <linux/filter.h>
 #include <linux/init.h>
 #include <linux/bpf.h>
+#include <linux/mm.h>
 #include <asm/cacheflush.h>
 #include <asm/dis.h>
 #include <asm/facility.h>
@@ -1369,7 +1370,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	}
 
 	memset(&jit, 0, sizeof(jit));
-	jit.addrs = kcalloc(fp->len + 1, sizeof(*jit.addrs), GFP_KERNEL);
+	jit.addrs = kvcalloc(fp->len + 1, sizeof(*jit.addrs), GFP_KERNEL);
 	if (jit.addrs == NULL) {
 		fp = orig_fp;
 		goto out;
@@ -1422,7 +1423,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	if (!fp->is_func || extra_pass) {
 		bpf_prog_fill_jited_linfo(fp, jit.addrs + 1);
 free_addrs:
-		kfree(jit.addrs);
+		kvfree(jit.addrs);
 		kfree(jit_data);
 		fp->aux->jit_data = NULL;
 	}
-- 
2.20.1

