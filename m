Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E198527279B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgIUOf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbgIUOef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:34:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457F5C0613D0;
        Mon, 21 Sep 2020 07:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hvHVjgb7+ogIHMv2QziVfmEo4wIHVDzxSBO7sgqq+LI=; b=Cr3xQBVQWALKH7tuoir4RRrOx5
        ObtytscKgX2pD9jdFKZl7OAaSGqHvKMY6QdN1AAeL7iPRdfGMnnuAKRp2fO3zs/Qa1qanBrJcMzlp
        2i6iNQiXjZlAfSdr8eSouVvMxW6Jwy5mKeEirvXr3ZTTiIIwvkxrQMh9XAJw5QuRUQsbNqdCQQyyW
        WDrgFWFBzIj4YkZNzY0XDygo/V19wuSoL2WQzUur+fGNL+3uLi2J6QXLcsQR+yhOTXD5FmYG9PgHH
        hyhjGiAZI27lRyg9jFDzu3lo4ZZQVp8d384XapZSVtaSeOjqaz3u6nukSqWN2rkY3CEe6gIiU4FAO
        cLQDX6OQ==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMtc-0007rU-GX; Mon, 21 Sep 2020 14:34:24 +0000
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
        linux-security-module@vger.kernel.org
Subject: [PATCH 04/11] iov_iter: explicitly check for CHECK_IOVEC_ONLY in rw_copy_check_uvector
Date:   Mon, 21 Sep 2020 16:34:27 +0200
Message-Id: <20200921143434.707844-5-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143434.707844-1-hch@lst.de>
References: <20200921143434.707844-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly check for the magic value insted of implicitly relying on
its numeric representation.   Also drop the rather pointless unlikely
annotation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/iov_iter.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index d7e72343c360eb..a64867501a7483 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1709,8 +1709,7 @@ static ssize_t rw_copy_check_uvector(int type,
 			ret = -EINVAL;
 			goto out;
 		}
-		if (type >= 0
-		    && unlikely(!access_ok(buf, len))) {
+		if (type != CHECK_IOVEC_ONLY && !access_ok(buf, len)) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1824,7 +1823,7 @@ static ssize_t compat_rw_copy_check_uvector(int type,
 		}
 		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
 			goto out;
-		if (type >= 0 &&
+		if (type != CHECK_IOVEC_ONLY &&
 		    !access_ok(compat_ptr(buf), len)) {
 			ret = -EFAULT;
 			goto out;
-- 
2.28.0

