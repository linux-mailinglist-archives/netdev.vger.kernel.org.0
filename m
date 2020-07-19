Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5449225008
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgGSHWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGSHWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0797C0619D6;
        Sun, 19 Jul 2020 00:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=YBJS0U3N0bDQziBJ4kOs9IwL4IuPhddysJqMqBUV/ec=; b=rK/8t27OwFtYKhAKxApWZpGR2o
        9GTMCQsq+AGcJEuMmUWxhx63LJZvKErSTdxJQ0PGp0YTABkVWqLXF4ZL2Bcnjhm5C3X5P2elOdOeY
        3juXrw5dMNvFhKCDPJTnSa0ocPvRF3452GLz+UGn8mgk5Pw48X1+T1E/7r2iYSEqF+4ZvydzD3nUQ
        O7WCdy3SL13MxdrMBKfK62K2KTzc3pvfyYI270oro/lbdtcaqXXbra59wjNJ0ro4b4o+7MX14CIVT
        5ZuffG22mgPjfP1N5PNS9CjBoUBkqm6A6y4Zut7Lc3DYQOa3Txem8NsHdXiw7cdrVPS2IHYP2tR53
        1cW1/ZUQ==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3eY-0000PW-Kx; Sun, 19 Jul 2020 07:22:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 01/51] sctp: copy the optval from user space in sctp_setsockopt
Date:   Sun, 19 Jul 2020 09:21:38 +0200
Message-Id: <20200719072228.112645-2-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
References: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for for moving the copy_from_user from the individual sockopts
to the main setsockopt helper.  As of this commit the kopt variable
is not used yet, but the following commits will start using it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d57e1a002ffc8f..af1ebc8313d303 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4677,6 +4677,7 @@ static int sctp_setsockopt_pf_expose(struct sock *sk,
 static int sctp_setsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, unsigned int optlen)
 {
+	void *kopt = NULL;
 	int retval = 0;
 
 	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
@@ -4693,6 +4694,12 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		goto out_nounlock;
 	}
 
+	if (optlen > 0) {
+		kopt = memdup_user(optval, optlen);
+		if (IS_ERR(kopt))
+			return PTR_ERR(kopt);
+	}
+
 	lock_sock(sk);
 
 	switch (optname) {
@@ -4878,6 +4885,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	}
 
 	release_sock(sk);
+	kfree(kopt);
 
 out_nounlock:
 	return retval;
-- 
2.27.0

