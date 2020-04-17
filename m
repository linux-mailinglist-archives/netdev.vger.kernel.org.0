Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F3D1AD656
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 08:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgDQGmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 02:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728210AbgDQGmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 02:42:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E595C061A0C;
        Thu, 16 Apr 2020 23:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=zWoJOhKhx/t/dtyAWbKx5+YCWW63dXo4J9Ws0Uu0ON8=; b=ZJKmNzp3SEZjMJGrcdTG3t8NEf
        shSas7x4hRyCclW9Mr2nGC8iXQFAMC2RAGs0lZk9B+THE/1qGEGRPOX3XpBRGWnGSWWTe2dVUw7U+
        jG9xRuerR/W+GII0cUnfQLNr8B+5iYd/WNFg/yYrjj3O+/4Vc4zTAp3+SqfJ4fCKjDfN70f3fKwcx
        tEadH9Wf8d5Bg5wvL1E+L9P+BqEMekd59ZEigTAcWW7n6DXSva/85YOYFHCfH8hsYM6f9c0zrJFze
        rqTxB6Iz7yomP1SbHqG5YC/D1SUC5F7w+VT4GHJgcj/A+vtVGzLiVXOSVVOpX8WWTSjWcife9+7BU
        wtyYE0Kg==;
Received: from [2001:4bb8:184:4aa1:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPKhJ-0002hz-Tv; Fri, 17 Apr 2020 06:41:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 3/6] mm: remove watermark_boost_factor_sysctl_handler
Date:   Fri, 17 Apr 2020 08:41:43 +0200
Message-Id: <20200417064146.1086644-4-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200417064146.1086644-1-hch@lst.de>
References: <20200417064146.1086644-1-hch@lst.de>
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
2.25.1

