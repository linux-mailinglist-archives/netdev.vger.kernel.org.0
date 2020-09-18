Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A0926FCF4
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgIRMqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgIRMpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:45:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C586C061756;
        Fri, 18 Sep 2020 05:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=JS63/rqkwUNTXwLowQfzdacfYjAtRcLXlr++78o/BT4=; b=sY+q9nG0cOiCMUx60dsbMGVPCz
        LVrYVhlOm2U0rDRkmCim2mpUjwSFA6xVzz7XwcQDo4SGRAVwynXQreWP6XBiVGi0g8W953f/N5oAl
        fMg12npyy16DCpLmH5VyXk669QwmnN85j6R0RkgK4f6gMcC3WoQ2pca3RMQOVsobTRfwuN1EThzdb
        jmGzqX9W6pU1MU4WfYmm+VGPkudgq8nJGWoYHdACNbyNatdhwXgx392LSabw4WcTao2KVrdLM7tlC
        iBsImmimlsk8J7PE28Q6ManmOx7kcJttWHAavkEleNAMRyHiwRuRenktDL1zD4kI4xDUsqKE4hm8M
        JLB9Xxjg==;
Received: from [80.122.85.238] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJFlk-0008T4-DQ; Fri, 18 Sep 2020 12:45:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 3/9] fs: explicitly check for CHECK_IOVEC_ONLY in rw_copy_check_uvector
Date:   Fri, 18 Sep 2020 14:45:27 +0200
Message-Id: <20200918124533.3487701-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918124533.3487701-1-hch@lst.de>
References: <20200918124533.3487701-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly check for the magic value insted of implicitly relying on
its number representation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 5db58b8c78d0dd..f153116bc5399b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -840,8 +840,7 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			ret = -EINVAL;
 			goto out;
 		}
-		if (type >= 0
-		    && unlikely(!access_ok(buf, len))) {
+		if (type != CHECK_IOVEC_ONLY && unlikely(!access_ok(buf, len))) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -911,7 +910,7 @@ ssize_t compat_rw_copy_check_uvector(int type,
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

