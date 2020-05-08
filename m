Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85961CB357
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEHPgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgEHPgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:36:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC95C061A0C;
        Fri,  8 May 2020 08:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=gdo1CI68NGJpSv9H2lBuA2msCSuabwKNVFFgXf1S+fQ=; b=kXvLegnPNvMN1Xbz6imxQGM4XM
        Z8HFAC7hxbTwBWprI5Zanbre5K5ZwnCBBb4002EVizfDHTsu7wogMSR3nHOL7Ph1/16Aya6Jhb4dJ
        Eux8v6F6qPyHNsXqCoATHO+bgojB6GwUxNrouxkwQPZklS6F4DXUwsKb7vxpKNcraqET5L2x04Rqu
        nEUOVezhcTYa4Zw/6XTkgLDACTmIpGAZ1rX0Rl5VqNFyF/wKFnxjiNP/rhXXEmYd753MOqRvCuUvS
        OO7jQSd/2NZJu8y8Qss0YVUQz5fsROiTd5y+++Ve6eHFR2VVNhw2NSaRKJVviaOwWCwlhMrw3OLBv
        eNQEao8g==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX53N-00048d-Lx; Fri, 08 May 2020 15:36:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 03/12] pidfd: use __anon_inode_getfd
Date:   Fri,  8 May 2020 17:36:25 +0200
Message-Id: <20200508153634.249933-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508153634.249933-1-hch@lst.de>
References: <20200508153634.249933-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use __anon_inode_getfd instead of opencoding the logic using
get_unused_fd_flags + anon_inode_getfile.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/fork.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 4385f3d639f23..31e0face01072 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2113,19 +2113,11 @@ static __latent_entropy struct task_struct *copy_process(
 	 * if the fd table isn't shared).
 	 */
 	if (clone_flags & CLONE_PIDFD) {
-		retval = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+		retval = __anon_inode_getfd("[pidfd]", &pidfd_fops, pid,
+				O_RDWR | O_CLOEXEC, &pidfile);
 		if (retval < 0)
 			goto bad_fork_free_pid;
-
 		pidfd = retval;
-
-		pidfile = anon_inode_getfile("[pidfd]", &pidfd_fops, pid,
-					      O_RDWR | O_CLOEXEC);
-		if (IS_ERR(pidfile)) {
-			put_unused_fd(pidfd);
-			retval = PTR_ERR(pidfile);
-			goto bad_fork_free_pid;
-		}
 		get_pid(pid);	/* held by pidfile now */
 
 		retval = put_user(pidfd, args->pidfd);
-- 
2.26.2

