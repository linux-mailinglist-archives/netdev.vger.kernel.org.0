Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712501DD53B
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgEURrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728945AbgEURrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C581C061A0E;
        Thu, 21 May 2020 10:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/nNz1KnsGR8lgnp7Lmp7l1Ak2izDCKJXOc6/lLU/aBM=; b=f2PLyayQmLLwR0OBzcp+RMvArI
        2613pjklBcH/3io/zfuDt21TA4ww1F4tZEAg9hJyG5qLZXhe+NA3aAwmMTXHkkBPBUD15Fn/wYHCE
        snCqcrJszgqF33b4stcb7AJz3SZMU7BuQnhUtcYKA24e7CyNgORK4wQVGUuKdYsWQh7CEp5wr+d4h
        eVxyU58FSSiXaRXgOgJX0u1hjMwvOROtgTtg/fhUuaDVQXKljLm0XzzifCDeqLwOxuo9vrrnFo26w
        DyFacJqG2Y8tydO2ALa/F4AqLwB70HsN/BA/X95RtoHJ8dtctxH4s7ieKLXgp7qXGtxJ2UcshoOUN
        3b0KlS+A==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpI3-0002sW-BD; Thu, 21 May 2020 17:47:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 01/49] sctp: copy the optval from user space in sctp_setsockopt
Date:   Thu, 21 May 2020 19:46:36 +0200
Message-Id: <20200521174724.2635475-2-hch@lst.de>
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

Prepare for for moving the copy_from_user from the individual sockopts
to the main setsockopt helper.  As of this commit the kopt variable
is not used yet, but the following commits will start using it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 827a9903ee288..ee6a618ee3e8e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4670,6 +4670,7 @@ static int sctp_setsockopt_pf_expose(struct sock *sk,
 static int sctp_setsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, unsigned int optlen)
 {
+	void *kopt = NULL;
 	int retval = 0;
 
 	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
@@ -4686,6 +4687,12 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
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
@@ -4871,6 +4878,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	}
 
 	release_sock(sk);
+	kfree(kopt);
 
 out_nounlock:
 	return retval;
-- 
2.26.2

