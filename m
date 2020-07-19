Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DF8225017
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgGSHXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgGSHXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DA2C0619D7;
        Sun, 19 Jul 2020 00:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=VrwAOl/7sBxtfaRGR/VQWGIl0G3vr5TxGHqcneVYtoQ=; b=n78HifMCfa+dnuNsJWHjSAFDSn
        15EUYe0nLSo80sxq4auq0emq03HYIiWewrUUwYGVNLpszL6J5kYixtjgyDn1JoQsYMF8UoFlRbNlc
        NhRMOeX8P9NcL5y1u98y74ZeGRhf7BI76zRxf6Zn+22NS8xaJGy1C9lXZ+h9NoncFAFAX0LSpcHuI
        4mU6cLO5TMvlm1whvRBgtNQ2YRMbrqrrb5zyLlb79MAKmjI/Q6C1UMFGsES9ZKBrUSSaZi34CPnh5
        rwLHYy9vFol1qBoF01zUp6A4mcT/7idYqTdfyySQliPYlD4V5CoKeMM38GtS6QzhkPRwty48frgIt
        Umewbdyw==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3ey-0000TX-44; Sun, 19 Jul 2020 07:22:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 20/51] sctp: pass a kernel pointer to sctp_setsockopt_adaptation_layer
Date:   Sun, 19 Jul 2020 09:21:57 +0200
Message-Id: <20200719072228.112645-21-hch@lst.de>
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

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cc7d5430ad8858..b29452f58ff988 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3336,17 +3336,14 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
 	return err;
 }
 
-static int sctp_setsockopt_adaptation_layer(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_adaptation_layer(struct sock *sk,
+					    struct sctp_setadaptation *adapt,
 					    unsigned int optlen)
 {
-	struct sctp_setadaptation adaptation;
-
 	if (optlen != sizeof(struct sctp_setadaptation))
 		return -EINVAL;
-	if (copy_from_user(&adaptation, optval, optlen))
-		return -EFAULT;
 
-	sctp_sk(sk)->adaptation_ind = adaptation.ssb_adaptation_ind;
+	sctp_sk(sk)->adaptation_ind = adapt->ssb_adaptation_ind;
 
 	return 0;
 }
@@ -4700,7 +4697,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_maxseg(sk, kopt, optlen);
 		break;
 	case SCTP_ADAPTATION_LAYER:
-		retval = sctp_setsockopt_adaptation_layer(sk, optval, optlen);
+		retval = sctp_setsockopt_adaptation_layer(sk, kopt, optlen);
 		break;
 	case SCTP_CONTEXT:
 		retval = sctp_setsockopt_context(sk, optval, optlen);
-- 
2.27.0

