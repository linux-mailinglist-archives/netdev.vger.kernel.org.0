Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F8E1DD4ED
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgEURse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730206AbgEURsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295E8C05BD43;
        Thu, 21 May 2020 10:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+W6A8x+QQrTs5cRuqkGdWhnjYRP3hZU2/tpgA64vpx0=; b=utL85sTBSVJDA/PNnz1GacWJ3e
        o3pQwMsd+eVVDAN2Rux32yEZSk6XH9NxxEzWX48RESiQ19l6YurTA2KiXzldztqUb3CgxelLHzOvJ
        jfrRHG6fPyhSGECnvUYsdXkwR1xCQKuA/D+qVKxD5UMRvcNoFV5HpafBTHNAnOl4lhqKF863LwiG5
        YwCfyAyJ4rPpfsURSgZRFKfBkJFxHcHfP77TYcGno36hWU3YuJmIgI1ZGcjSXKlJpj7tEVMrB0cwK
        OgENtXRKO1sJaLE48DoKJcx/8P9nWgzmAi7FNEYo0fabFPgPIjmDpQun9ceILH1b8QdqRQId/R0eo
        aN9vAA4A==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIs-0003Gp-3m; Thu, 21 May 2020 17:48:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 20/49] sctp: pass a kernel pointer to sctp_setsockopt_adaptation_layer
Date:   Thu, 21 May 2020 19:46:55 +0200
Message-Id: <20200521174724.2635475-21-hch@lst.de>
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
 net/sctp/socket.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4374d4fff080a..b7bf09f86a5e7 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3333,17 +3333,14 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
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
@@ -4697,7 +4694,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_maxseg(sk, kopt, optlen);
 		break;
 	case SCTP_ADAPTATION_LAYER:
-		retval = sctp_setsockopt_adaptation_layer(sk, optval, optlen);
+		retval = sctp_setsockopt_adaptation_layer(sk, kopt, optlen);
 		break;
 	case SCTP_CONTEXT:
 		retval = sctp_setsockopt_context(sk, optval, optlen);
-- 
2.26.2

