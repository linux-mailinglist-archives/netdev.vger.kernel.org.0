Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4446E1CB342
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgEHPhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgEHPgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:36:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E19C061A0C;
        Fri,  8 May 2020 08:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Y6GByYBpY6pH5k9QcdAJgxxwyoCDdXaPGt39GnAtfcU=; b=r/T2Qu4Dq2EPB6e8g5rt10rdUS
        xxIMdT2OcwOzQanXgb4lV4q1HK2YMY6jUhqZw4kqLXgZCPDWdZw6jUGIRcchb87UWGNEuuzBouvX4
        4YS6XQKp60nPAtzrXWUhDMdzUDn2lFo59J/30GXVF9vyt86zvxErfvhDIjdhWfDQu5QTV2MczwT2x
        fGalI5f7Wmy57824Eoy61rqGOadOiirp9dqXejOb+NK5CiWjdMnCeU4VkmDWFCec3wc6SAXB9cpOu
        qVjmdlypsglLL/MZUS2SpJ5wA9C0Z291fcC9yHzmdGJanj/2UhJ/FJKsXGQ6ggPMKfRpM8NzQ3VrW
        aO9USAMw==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX53V-0004Cz-VR; Fri, 08 May 2020 15:36:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 06/12] eventpoll: use __anon_inode_getfd
Date:   Fri,  8 May 2020 17:36:28 +0200
Message-Id: <20200508153634.249933-7-hch@lst.de>
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
 fs/eventpoll.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8c596641a72b0..8abdb9fff611a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2055,23 +2055,14 @@ static int do_epoll_create(int flags)
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure and a free file descriptor.
 	 */
-	fd = get_unused_fd_flags(O_RDWR | (flags & O_CLOEXEC));
-	if (fd < 0) {
-		error = fd;
+	fd = __anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
+				 O_RDWR | (flags & O_CLOEXEC), &file);
+	if (fd < 0)
 		goto out_free_ep;
-	}
-	file = anon_inode_getfile("[eventpoll]", &eventpoll_fops, ep,
-				 O_RDWR | (flags & O_CLOEXEC));
-	if (IS_ERR(file)) {
-		error = PTR_ERR(file);
-		goto out_free_fd;
-	}
 	ep->file = file;
 	fd_install(fd, file);
 	return fd;
 
-out_free_fd:
-	put_unused_fd(fd);
 out_free_ep:
 	ep_free(ep);
 	return error;
-- 
2.26.2

