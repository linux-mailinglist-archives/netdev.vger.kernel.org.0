Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353681CB363
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgEHPgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgEHPgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:36:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74191C061A0C;
        Fri,  8 May 2020 08:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HULdF9UoUcZ31Eif+itgRwinLIB4tg9e/0hftHQA1OM=; b=EfHU8nIcGB1Jd19m6d5XJJ42pv
        FKTo8Gu20dJJHf04Xt1Kc7N/bZSEO90MNzQR0YdX4d2eyfRlvKxqg/Xb1yRV+O78nT7yGFG+X1+R8
        QYG7b9H5ylPc/OCKUcZGXKgH+TiaEqWphCx7N9YSmahjk7znkQKSk/zgUkgJyzOyyEKvAb3b1pMLR
        m0CJwmipsAFN6kBNoJTP9HE+LWyNkuqEF3W9BceShwWoM5h/9Hx2+jv/lplh973XJ0be0WKZvD4nS
        WEgHNS3m5vZSFuqk7qhXaA6+nthmcn3vtq5zzTZlJI6BU67trz+wFnLio6RzQnqFTGh1m7nhMHe5r
        /b+DXsMw==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX53K-00047r-Tp; Fri, 08 May 2020 15:36:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 02/12] kvm: use __anon_inode_getfd
Date:   Fri,  8 May 2020 17:36:24 +0200
Message-Id: <20200508153634.249933-3-hch@lst.de>
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
 virt/kvm/kvm_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74bdb7bf32952..d20a7c2a30f1d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3822,17 +3822,11 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	if (r < 0)
 		goto put_kvm;
 #endif
-	r = get_unused_fd_flags(O_CLOEXEC);
+	r = __anon_inode_getfd("kvm-vm", &kvm_vm_fops, kvm, O_CLOEXEC | O_RDWR,
+			&file);
 	if (r < 0)
 		goto put_kvm;
 
-	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
-	if (IS_ERR(file)) {
-		put_unused_fd(r);
-		r = PTR_ERR(file);
-		goto put_kvm;
-	}
-
 	/*
 	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
 	 * already set, with ->release() being kvm_vm_release().  In error
-- 
2.26.2

