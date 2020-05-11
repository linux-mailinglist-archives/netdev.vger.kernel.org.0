Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008FD1CD92F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgEKL7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729645AbgEKL7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 07:59:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DF9C05BD09;
        Mon, 11 May 2020 04:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3KzJfnIrMOX10B1smfo4qeEM4MM1jluWGd/OiMkNXVc=; b=D0bz4+3nUcmIBLGugGcmJZOw/i
        2ybM76T3XhoNAhvDG2Vu84QStYUI0Fyf4f98sjlPJp0tj57gvNlkAWGPpFbFlubDHXcf5bJy8nxHU
        JhWRbvQLZivDClQdADk3KG06vfGJrH3O8535gbUD+Cg9zpQ6py5oJ8iSi2of6tNnhwE4JN3yyYJ0A
        fp4L99A+npTq6vLDe42/fTjH7MC7ncJcsPa7dW/arNKGVtiuN6ohC+zGqIpa+rRePvMBDMg9tTspu
        yMZPxgS7WtEo4xw78y1JZd9XxehEg70DIjUQuBxSRFwLgmgIxEDLVBeQiU39DoyR5n/n06aItYQ3b
        ht20r09w==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY75a-0007TM-Jf; Mon, 11 May 2020 11:59:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: add a CMSG_USER_DATA macro
Date:   Mon, 11 May 2020 13:59:11 +0200
Message-Id: <20200511115913.1420836-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511115913.1420836-1-hch@lst.de>
References: <20200511115913.1420836-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a variant of CMSG_DATA that operates on user pointer to avoid
sparse warnings about casting to/from user pointers.  Also fix up
CMSG_DATA to rely on the gcc extension that allows void pointer
arithmetics to cut down on the amount of casts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/socket.h | 5 ++++-
 net/core/scm.c         | 4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 54338fac45cb7..4cc64d611cf49 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -94,7 +94,10 @@ struct cmsghdr {
 
 #define CMSG_ALIGN(len) ( ((len)+sizeof(long)-1) & ~(sizeof(long)-1) )
 
-#define CMSG_DATA(cmsg)	((void *)((char *)(cmsg) + sizeof(struct cmsghdr)))
+#define CMSG_DATA(cmsg) \
+	((void *)(cmsg) + sizeof(struct cmsghdr))
+#define CMSG_USER_DATA(cmsg) \
+	((void __user *)(cmsg) + sizeof(struct cmsghdr))
 #define CMSG_SPACE(len) (sizeof(struct cmsghdr) + CMSG_ALIGN(len))
 #define CMSG_LEN(len) (sizeof(struct cmsghdr) + (len))
 
diff --git a/net/core/scm.c b/net/core/scm.c
index dc6fed1f221c4..abfdc85a64c1b 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -236,7 +236,7 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 	err = -EFAULT;
 	if (copy_to_user(cm, &cmhdr, sizeof cmhdr))
 		goto out;
-	if (copy_to_user(CMSG_DATA(cm), data, cmlen - sizeof(struct cmsghdr)))
+	if (copy_to_user(CMSG_USER_DATA(cm), data, cmlen - sizeof(*cm)))
 		goto out;
 	cmlen = CMSG_SPACE(len);
 	if (msg->msg_controllen < cmlen)
@@ -300,7 +300,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 	if (fdnum < fdmax)
 		fdmax = fdnum;
 
-	for (i=0, cmfptr=(__force int __user *)CMSG_DATA(cm); i<fdmax;
+	for (i=0, cmfptr =(int __user *)CMSG_USER_DATA(cm); i<fdmax;
 	     i++, cmfptr++)
 	{
 		struct socket *sock;
-- 
2.26.2

