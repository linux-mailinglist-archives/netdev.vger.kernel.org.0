Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CAA272726
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgIUOem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgIUOed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:34:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CFCC0613D0;
        Mon, 21 Sep 2020 07:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=puJFCdMF2FXbv89uAHf/KkyLCkpGKdSCiHzE06eX0/Y=; b=GRkfTBxWaYN59mWczbVBJZ/J4z
        kVM8Nphlbf3FY02zkGWWBVM283NPs2K9y+IDVdwyxNN1Q6a4B7YoCyWtJodiottCcy6XpP96dRyGn
        JHkp6fow0Ism2aY5WYKFck/rP6z+BMXBmYaJqqKRA5DWZwKptXaUZhs1y+Gx9Hcs78ge5sNfRyKIN
        h2HYTgdyzISCw5GbBnBiQ0zAOMx4TZdmJQTPfx5COcVblaZe9D1Cqm0YVjyEpK04tgDaqtazmJ5UR
        ftg8Mk3Zj7g+8AAriBQApIZOIJYX0rTvWCnxH8RgTXNwePT8RLDRBDPDY+Cv19f1nEHzB8vcryJzp
        d7oTPRIQ==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMtZ-0007rC-EL; Mon, 21 Sep 2020 14:34:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>,
        David Laight <david.laight@aculab.com>
Subject: [PATCH 02/11] mm: call import_iovec() instead of rw_copy_check_uvector() in process_vm_rw()
Date:   Mon, 21 Sep 2020 16:34:25 +0200
Message-Id: <20200921143434.707844-3-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143434.707844-1-hch@lst.de>
References: <20200921143434.707844-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>

This is the only direct call of rw_copy_check_uvector().  Removing it
will allow rw_copy_check_uvector() to be inlined into import_iovec(),
while only paying a minor price by setting up an otherwise unused
iov_iter in the process_vm_readv/process_vm_writev syscalls that aren't
in a super hot path.

Signed-off-by: David Laight <david.laight@aculab.com>
[hch: expanded the commit log, pass CHECK_IOVEC_ONLY instead of 0 for the
      compat case, handle CHECK_IOVEC_ONLY in iov_iter_init]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/iov_iter.c         |  2 +-
 mm/process_vm_access.c | 33 ++++++++++++++++++---------------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 5e40786c8f1232..db54588406dfae 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -443,7 +443,7 @@ void iov_iter_init(struct iov_iter *i, unsigned int direction,
 			const struct iovec *iov, unsigned long nr_segs,
 			size_t count)
 {
-	WARN_ON(direction & ~(READ | WRITE));
+	WARN_ON(direction & ~(READ | WRITE | CHECK_IOVEC_ONLY));
 	direction &= READ | WRITE;
 
 	/* It will get better.  Eventually... */
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 29c052099affdc..40cd502c337534 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -264,7 +264,7 @@ static ssize_t process_vm_rw(pid_t pid,
 	struct iovec iovstack_r[UIO_FASTIOV];
 	struct iovec *iov_l = iovstack_l;
 	struct iovec *iov_r = iovstack_r;
-	struct iov_iter iter;
+	struct iov_iter iter_l, iter_r;
 	ssize_t rc;
 	int dir = vm_write ? WRITE : READ;
 
@@ -272,23 +272,25 @@ static ssize_t process_vm_rw(pid_t pid,
 		return -EINVAL;
 
 	/* Check iovecs */
-	rc = import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter);
+	rc = import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter_l);
 	if (rc < 0)
 		return rc;
-	if (!iov_iter_count(&iter))
+	if (!iov_iter_count(&iter_l))
 		goto free_iovecs;
 
-	rc = rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV,
-				   iovstack_r, &iov_r);
+	rc = import_iovec(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV, &iov_r,
+			  &iter_r);
 	if (rc <= 0)
 		goto free_iovecs;
 
-	rc = process_vm_rw_core(pid, &iter, iov_r, riovcnt, flags, vm_write);
+	rc = process_vm_rw_core(pid, &iter_l, iter_r.iov, iter_r.nr_segs,
+				flags, vm_write);
 
 free_iovecs:
 	if (iov_r != iovstack_r)
 		kfree(iov_r);
-	kfree(iov_l);
+	if (iov_l != iovstack_l)
+		kfree(iov_l);
 
 	return rc;
 }
@@ -322,30 +324,31 @@ compat_process_vm_rw(compat_pid_t pid,
 	struct iovec iovstack_r[UIO_FASTIOV];
 	struct iovec *iov_l = iovstack_l;
 	struct iovec *iov_r = iovstack_r;
-	struct iov_iter iter;
+	struct iov_iter iter_l, iter_r;
 	ssize_t rc = -EFAULT;
 	int dir = vm_write ? WRITE : READ;
 
 	if (flags != 0)
 		return -EINVAL;
 
-	rc = compat_import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter);
+	rc = compat_import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter_l);
 	if (rc < 0)
 		return rc;
-	if (!iov_iter_count(&iter))
+	if (!iov_iter_count(&iter_l))
 		goto free_iovecs;
-	rc = compat_rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt,
-					  UIO_FASTIOV, iovstack_r,
-					  &iov_r);
+	rc = compat_import_iovec(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV,
+				 &iov_r, &iter_r);
 	if (rc <= 0)
 		goto free_iovecs;
 
-	rc = process_vm_rw_core(pid, &iter, iov_r, riovcnt, flags, vm_write);
+	rc = process_vm_rw_core(pid, &iter_l, iter_r.iov, iter_r.nr_segs,
+				flags, vm_write);
 
 free_iovecs:
 	if (iov_r != iovstack_r)
 		kfree(iov_r);
-	kfree(iov_l);
+	if (iov_l != iovstack_l)
+		kfree(iov_l);
 	return rc;
 }
 
-- 
2.28.0

