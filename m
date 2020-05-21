Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F33C1DD4C8
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgEURru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgEURrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692DDC061A0E;
        Thu, 21 May 2020 10:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xriRSFhBjUZn87I8/ZlHJc6Fud4nO2hvhxfK6I1AnAA=; b=HW33xHDIM4qJusn5NLe0yZyHsr
        xeaLezxer9Q9Goi+IkqLXFNlZtWUufPWHjgibQEXjSFarhbIGi0zrdFzZGAlipTx6rY7hSe9qDwJf
        ZrnHDsVNetSKaBXwOgc3hLVcpb0rv0p7Mb7Art2pz/FU/+vhH7Gnfdxz7TjbEC1gYje07WipFs6d0
        xK8p3wmsIcKVKwXyjxDIoBUUCkYgSDTt5nO+p/4EjjbGsn9/nCJIGMKlDc9eEFajtDMytdnMDvWD2
        7Vxm0lB/6GMOFnnh1RngEcPMAJpSVttLAT9yo6bhD6sg8OWkVYml0vz3OHQDvxkgY0qUw6vrd656R
        hq9yHm4Q==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIA-00030i-Ql; Thu, 21 May 2020 17:47:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 04/49] sctp: pass a kernel pointer to sctp_setsockopt_disable_fragments
Date:   Thu, 21 May 2020 19:46:39 +0200
Message-Id: <20200521174724.2635475-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
References: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f7621ea99340e..0ca8001acfd50 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2180,20 +2180,12 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
  * exceeds the current PMTU size, the message will NOT be sent and
  * instead a error will be indicated to the user.
  */
-static int sctp_setsockopt_disable_fragments(struct sock *sk,
-					     char __user *optval,
+static int sctp_setsockopt_disable_fragments(struct sock *sk, int *val,
 					     unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->disable_fragments = (val == 0) ? 0 : 1;
-
+	sctp_sk(sk)->disable_fragments = (*val == 0) ? 0 : 1;
 	return 0;
 }
 
@@ -4697,7 +4689,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_DISABLE_FRAGMENTS:
-		retval = sctp_setsockopt_disable_fragments(sk, optval, optlen);
+		retval = sctp_setsockopt_disable_fragments(sk, kopt, optlen);
 		break;
 
 	case SCTP_EVENTS:
-- 
2.26.2

