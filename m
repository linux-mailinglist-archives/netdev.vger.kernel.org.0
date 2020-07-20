Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD4C225D85
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgGTLgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbgGTLgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 07:36:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7E7C061794;
        Mon, 20 Jul 2020 04:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=p0iwoGCkvJZcwbHnFm61xWYRiIRUAJSGvnjR7QZKDdg=; b=ezM213CZTPPS6HSORVwJNY4EKG
        R/4HU5dBmTi4a8Z3M4lWqQTnzQO28k8rSegjkSH7DjhaNYt/6nGNJ0sFan1bKBkcFNBmWoauJBhCK
        O8BKmhdD45V/bX8jhr7rmAIv8XF8dgWqr5g9o56j9TiizY70cGoEq+HvKW0aDAIMZPZ156h+CxUOH
        +daB8llARAezDJhHVA0QdcOVPmUu4dpHZkz0glzWWDgGe4HCN5woZpZuLiqfGYP9RmLx2mg75DxyE
        9tBhboVY1l26eW0c25T21dAlttlhCALa8CcN9V+RtTR9AxXNIKWlT78Q4Y8yY8i6iF4MVmGn12iGZ
        IXhipm4w==;
Received: from [2001:4bb8:105:4a81:ec09:aa20:3c1e:ebea] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxU5Z-0000eP-Pi; Mon, 20 Jul 2020 11:36:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     msalter@redhat.com, jacquiot.aurelien@gmail.com,
        ley.foon.tan@intel.com, arnd@arndb.de
Cc:     linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] arch, net: remove the last csum_partial_copy() leftovers
Date:   Mon, 20 Jul 2020 13:36:09 +0200
Message-Id: <20200720113609.177259-1-hch@lst.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the tree only uses and implements csum_partial_copy_nocheck,
but the c6x and lib/checksum.c implement a csum_partial_copy that
isn't used anywere except to define csum_partial_copy.  Get rid of
this pointless alias.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/c6x/lib/checksum.c           | 2 +-
 arch/c6x/lib/csum_64plus.S        | 8 ++++----
 arch/nios2/include/asm/checksum.h | 5 ++---
 include/asm-generic/checksum.h    | 6 ++----
 lib/checksum.c                    | 4 ++--
 5 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/c6x/lib/checksum.c b/arch/c6x/lib/checksum.c
index 335ca490080847..dff2e2ec6e6472 100644
--- a/arch/c6x/lib/checksum.c
+++ b/arch/c6x/lib/checksum.c
@@ -6,6 +6,6 @@
 
 /* These are from csum_64plus.S */
 EXPORT_SYMBOL(csum_partial);
-EXPORT_SYMBOL(csum_partial_copy);
+EXPORT_SYMBOL(csum_partial_copy_nocheck);
 EXPORT_SYMBOL(ip_compute_csum);
 EXPORT_SYMBOL(ip_fast_csum);
diff --git a/arch/c6x/lib/csum_64plus.S b/arch/c6x/lib/csum_64plus.S
index 8e625a30fd435a..9c07127485d165 100644
--- a/arch/c6x/lib/csum_64plus.S
+++ b/arch/c6x/lib/csum_64plus.S
@@ -10,8 +10,8 @@
 #include <linux/linkage.h>
 
 ;
-;unsigned int csum_partial_copy(const char *src, char * dst,
-;				int len, int sum)
+;unsigned int csum_partial_copy_nocheck(const char *src, char * dst,
+;					int len, int sum)
 ;
 ; A4:	src
 ; B4:	dst
@@ -21,7 +21,7 @@
 ;
 
 	.text
-ENTRY(csum_partial_copy)
+ENTRY(csum_partial_copy_nocheck)
 	MVC	.S2	ILC,B30
 
 	MV	.D1X	B6,A31		; given csum
@@ -149,7 +149,7 @@ L10:	ADD	.D1	A31,A9,A9
 
 	BNOP	.S2	B3,4
 	MVC	.S2	B30,ILC
-ENDPROC(csum_partial_copy)
+ENDPROC(csum_partial_copy_nocheck)
 
 ;
 ;unsigned short
diff --git a/arch/nios2/include/asm/checksum.h b/arch/nios2/include/asm/checksum.h
index ec39698d3beac8..b4316c361729f0 100644
--- a/arch/nios2/include/asm/checksum.h
+++ b/arch/nios2/include/asm/checksum.h
@@ -12,10 +12,9 @@
 
 /* Take these from lib/checksum.c */
 extern __wsum csum_partial(const void *buff, int len, __wsum sum);
-extern __wsum csum_partial_copy(const void *src, void *dst, int len,
+__wsum csum_partial_copy_nocheck(const void *src, void *dst, int len,
 				__wsum sum);
-#define csum_partial_copy_nocheck(src, dst, len, sum)	\
-	csum_partial_copy((src), (dst), (len), (sum))
+#define csum_partial_copy_nocheck csum_partial_copy_nocheck
 
 extern __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
 extern __sum16 ip_compute_csum(const void *buff, int len);
diff --git a/include/asm-generic/checksum.h b/include/asm-generic/checksum.h
index 5a80f8e543008a..cd8b75aa770d00 100644
--- a/include/asm-generic/checksum.h
+++ b/include/asm-generic/checksum.h
@@ -23,11 +23,9 @@ extern __wsum csum_partial(const void *buff, int len, __wsum sum);
  * here even more important to align src and dst on a 32-bit (or even
  * better 64-bit) boundary
  */
-extern __wsum csum_partial_copy(const void *src, void *dst, int len, __wsum sum);
-
 #ifndef csum_partial_copy_nocheck
-#define csum_partial_copy_nocheck(src, dst, len, sum)	\
-	csum_partial_copy((src), (dst), (len), (sum))
+__wsum csum_partial_copy_nocheck(const void *src, void *dst, int len,
+		__wsum sum);
 #endif
 
 #ifndef ip_fast_csum
diff --git a/lib/checksum.c b/lib/checksum.c
index 7ac65a0000ff09..c7861e84c5261a 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -149,12 +149,12 @@ EXPORT_SYMBOL(ip_compute_csum);
  * copy from ds while checksumming, otherwise like csum_partial
  */
 __wsum
-csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
+csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
 {
 	memcpy(dst, src, len);
 	return csum_partial(dst, len, sum);
 }
-EXPORT_SYMBOL(csum_partial_copy);
+EXPORT_SYMBOL(csum_partial_copy_nocheck);
 
 #ifndef csum_tcpudp_nofold
 static inline u32 from64to32(u64 x)
-- 
2.27.0

