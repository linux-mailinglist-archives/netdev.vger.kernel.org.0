Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7D1B2DF3
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgDURPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729249AbgDURPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 13:15:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18270C061A41;
        Tue, 21 Apr 2020 10:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JQXbXAp9ulEWyhayBjCAHaJMTw8Jdhk9KH5wDvZocJU=; b=V7OZEPxWriIOq3sqWj8JVcXKkK
        GJ4IttwVrL8VDkeBCEKuvtwKKzhQ0V6J+pz6Tk9vBb78jt4QVM7zzQ2v9KtcITi90aXKr2Eu/r+qf
        tEdZNqhRemqmn3t05R0praYu/52YuxOi3olitJ05C1fPGWhkQRjW3FBKvgg8eu67mTOovaiiR0rZ8
        /e7Y6yAyLyAW5Umvg4QUuS6WqkwYBuWHYhNz7Dvj9QD03tTVPCu5gYw25my+2xqyvdWWQzs68nJop
        HF3AVfWrQ9Ix/qqR2tu0xn+8cCex1En1cRpXT2I/bI4rfuXjSFSdpjlstpuY9XS/smlhF0bX+JWFd
        5iwOA1bw==;
Received: from [2001:4bb8:191:e12c:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jQwUr-0006bW-RK; Tue, 21 Apr 2020 17:15:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 2/5] mm: remove watermark_boost_factor_sysctl_handler
Date:   Tue, 21 Apr 2020 19:15:36 +0200
Message-Id: <20200421171539.288622-3-hch@lst.de>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421171539.288622-1-hch@lst.de>
References: <20200421171539.288622-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

watermark_boost_factor_sysctl_handler is just a pointless wrapper for
proc_dointvec_minmax, so remove it and use proc_dointvec_minmax
directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/mmzone.h |  2 --
 kernel/sysctl.c        |  2 +-
 mm/page_alloc.c        | 12 ------------
 3 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1b9de7d220fb..f37bb8f187fc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -911,8 +911,6 @@ static inline int is_highmem(struct zone *zone)
 struct ctl_table;
 int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
-int watermark_boost_factor_sysctl_handler(struct ctl_table *, int,
-					void __user *, size_t *, loff_t *);
 int watermark_scale_factor_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES];
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a176d8727a3..99d27acf4646 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1491,7 +1491,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &watermark_boost_factor,
 		.maxlen		= sizeof(watermark_boost_factor),
 		.mode		= 0644,
-		.proc_handler	= watermark_boost_factor_sysctl_handler,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 	{
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 69827d4fa052..62c1550cd43e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7978,18 +7978,6 @@ int min_free_kbytes_sysctl_handler(struct ctl_table *table, int write,
 	return 0;
 }
 
-int watermark_boost_factor_sysctl_handler(struct ctl_table *table, int write,
-	void __user *buffer, size_t *length, loff_t *ppos)
-{
-	int rc;
-
-	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (rc)
-		return rc;
-
-	return 0;
-}
-
 int watermark_scale_factor_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
-- 
2.26.1

