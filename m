Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C836950987A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385579AbiDUHHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 03:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385559AbiDUHHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 03:07:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4181115704;
        Thu, 21 Apr 2022 00:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=zBXWLNnXpk4rildATDLl07tkcfHH7qx/rs6eJc2jVvY=; b=QR0Xe8VEKwSitBZoLjmLhc8fq8
        Lr97HHHJhJPho3My5cPAj3WFl0XUehAS9E+qEfCT/Lq6WDrFnYeWYcShZdet8No9amJuD3NdnhpXg
        A2WH2R3rSaIEsCxFrj4AW4IgVwsRmuLSHamhv5gA1JmwuKLVy4Zwc1fRRbXymaAOFUWY/Fo25jO/Y
        Rv07h3ZFVNmYVZsAr2+KfR9itkDS/IPJLGd4Zit2F7zasrKi43a339FOQVRyOyxnkylnHwxU0xPsw
        c+T5CEboHhoU2XsgyUtATcYfhWl+O7Eg4aZlYpZqDsNyqmG71+b+KUGXTz4CsIQO92nqN/AR8/lSc
        vuSIbYrQ==;
Received: from [2001:4bb8:191:364b:7b50:153f:5622:82f7] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nhQrr-00BwId-CM; Thu, 21 Apr 2022 07:04:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     akpm@linux-foundation.org
Cc:     x86@kernel.org, linux-alpha@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: unexport csum_and_copy_{from,to}_user
Date:   Thu, 21 Apr 2022 09:04:40 +0200
Message-Id: <20220421070440.1282704-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

csum_and_copy_from_user and csum_and_copy_to_user are exported by
a few architectures, but not actually used in modular code.  Drop
the exports.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/alpha/lib/csum_partial_copy.c   | 1 -
 arch/m68k/lib/checksum.c             | 2 --
 arch/powerpc/lib/checksum_wrappers.c | 2 --
 arch/x86/lib/csum-wrappers_64.c      | 2 --
 4 files changed, 7 deletions(-)

diff --git a/arch/alpha/lib/csum_partial_copy.c b/arch/alpha/lib/csum_partial_copy.c
index 1931a04af85a2..4d180d96f09e4 100644
--- a/arch/alpha/lib/csum_partial_copy.c
+++ b/arch/alpha/lib/csum_partial_copy.c
@@ -353,7 +353,6 @@ csum_and_copy_from_user(const void __user *src, void *dst, int len)
 		return 0;
 	return __csum_and_copy(src, dst, len);
 }
-EXPORT_SYMBOL(csum_and_copy_from_user);
 
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len)
diff --git a/arch/m68k/lib/checksum.c b/arch/m68k/lib/checksum.c
index 7e6afeae62177..5acb821849d30 100644
--- a/arch/m68k/lib/checksum.c
+++ b/arch/m68k/lib/checksum.c
@@ -265,8 +265,6 @@ csum_and_copy_from_user(const void __user *src, void *dst, int len)
 	return sum;
 }
 
-EXPORT_SYMBOL(csum_and_copy_from_user);
-
 
 /*
  * copy from kernel space while checksumming, otherwise like csum_partial
diff --git a/arch/powerpc/lib/checksum_wrappers.c b/arch/powerpc/lib/checksum_wrappers.c
index f3999cbb2fcc4..1a14c8780278c 100644
--- a/arch/powerpc/lib/checksum_wrappers.c
+++ b/arch/powerpc/lib/checksum_wrappers.c
@@ -24,7 +24,6 @@ __wsum csum_and_copy_from_user(const void __user *src, void *dst,
 	user_read_access_end();
 	return csum;
 }
-EXPORT_SYMBOL(csum_and_copy_from_user);
 
 __wsum csum_and_copy_to_user(const void *src, void __user *dst, int len)
 {
@@ -38,4 +37,3 @@ __wsum csum_and_copy_to_user(const void *src, void __user *dst, int len)
 	user_write_access_end();
 	return csum;
 }
-EXPORT_SYMBOL(csum_and_copy_to_user);
diff --git a/arch/x86/lib/csum-wrappers_64.c b/arch/x86/lib/csum-wrappers_64.c
index 189344924a2be..145f9a0bde29a 100644
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@ -32,7 +32,6 @@ csum_and_copy_from_user(const void __user *src, void *dst, int len)
 	user_access_end();
 	return sum;
 }
-EXPORT_SYMBOL(csum_and_copy_from_user);
 
 /**
  * csum_and_copy_to_user - Copy and checksum to user space.
@@ -57,7 +56,6 @@ csum_and_copy_to_user(const void *src, void __user *dst, int len)
 	user_access_end();
 	return sum;
 }
-EXPORT_SYMBOL(csum_and_copy_to_user);
 
 /**
  * csum_partial_copy_nocheck - Copy and checksum.
-- 
2.30.2

