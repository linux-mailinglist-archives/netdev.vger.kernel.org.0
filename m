Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A8C1E7CC4
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgE2MKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgE2MKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 08:10:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980CCC03E969;
        Fri, 29 May 2020 05:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jyyKSsv2ojCllyHR6oLPZbDWIQjSKqRL9iRFY8LVQRE=; b=iNffGeA/5apqAq049Vefb7clnf
        42PPPLdS7Jbx3l39eX/tSq7mWUY3FLKEskZ70zLSnA4S9ogou5efvAj8PSQMb6i89RjbRR8IPmMSr
        0XBE/pYDc6uLzrBi7k5+R00kcWtMu2RAe9KNff1M9AgKqIFpd9R5yFQijW1C1iyzJawqOU6VQCNh7
        dsT5VDBRxU7qnGaNeH4fwsVOLbFGSLtGLSF4ZamWmp+D4l/xYyLJcsMPUCfEVfiedseMvHnrWlgXB
        iRBxbPAcpKPVXEoHQVd9zYT1F3bgxQa25lNgQmj9OhFDeXBzVVGHV9FVRxvnd/KKlo43m5xdjoQ4h
        a73bH4iQ==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jedpp-0006LP-IU; Fri, 29 May 2020 12:10:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH 4/4] net: remove kernel_setsockopt
Date:   Fri, 29 May 2020 14:09:43 +0200
Message-Id: <20200529120943.101454-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529120943.101454-1-hch@lst.de>
References: <20200529120943.101454-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No users left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/net.h |  2 --
 net/socket.c        | 31 -------------------------------
 2 files changed, 33 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 74ef5d7315f70..e10f378194a59 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -303,8 +303,6 @@ int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen,
 		   int flags);
 int kernel_getsockname(struct socket *sock, struct sockaddr *addr);
 int kernel_getpeername(struct socket *sock, struct sockaddr *addr);
-int kernel_setsockopt(struct socket *sock, int level, int optname, char *optval,
-		      unsigned int optlen);
 int kernel_sendpage(struct socket *sock, struct page *page, int offset,
 		    size_t size, int flags);
 int kernel_sendpage_locked(struct sock *sk, struct page *page, int offset,
diff --git a/net/socket.c b/net/socket.c
index 81a98b6cbd087..976426d03f099 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3624,37 +3624,6 @@ int kernel_getpeername(struct socket *sock, struct sockaddr *addr)
 }
 EXPORT_SYMBOL(kernel_getpeername);
 
-/**
- *	kernel_setsockopt - set a socket option (kernel space)
- *	@sock: socket
- *	@level: API level (SOL_SOCKET, ...)
- *	@optname: option tag
- *	@optval: option value
- *	@optlen: option length
- *
- *	Returns 0 or an error.
- */
-
-int kernel_setsockopt(struct socket *sock, int level, int optname,
-			char *optval, unsigned int optlen)
-{
-	mm_segment_t oldfs = get_fs();
-	char __user *uoptval;
-	int err;
-
-	uoptval = (char __user __force *) optval;
-
-	set_fs(KERNEL_DS);
-	if (level == SOL_SOCKET)
-		err = sock_setsockopt(sock, level, optname, uoptval, optlen);
-	else
-		err = sock->ops->setsockopt(sock, level, optname, uoptval,
-					    optlen);
-	set_fs(oldfs);
-	return err;
-}
-EXPORT_SYMBOL(kernel_setsockopt);
-
 /**
  *	kernel_sendpage - send a &page through a socket (kernel space)
  *	@sock: socket
-- 
2.26.2

