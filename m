Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7354E1DD4EB
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbgEURsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730167AbgEURs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC19C061A0E;
        Thu, 21 May 2020 10:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1adSpIWXqy+C1EFl34YvAlizwhZxbqLineY2jUj7dw8=; b=V2fA60D5z3dWXjbZQfn4B7R6x5
        0kAqKV6olu1vEcXhx2n7Kf/zLORc2qmQtda2BmAeafE/FoejRkIIJULMeaobA/3D9GyABzYJm3ndF
        EOF8GV9iWo4J0o/yW6rFKiG1DZ3XyLyyqebvKDZ4HG/s/7KQJWxureXKpjXcoIsihtOPRVwH+8UBy
        U6NcJrVcgc3S/YL+FFueOqYydC3ul+Qxdwdv6Ui62DAhYlGEXahHQetW4nakL8dZTGPwXiMblGznC
        VpOt/yFlkIeZWaLJq0ODxMajnk516zvLEfQ/9xcZTVBFhaIJRHSXthPG90wfy4tvJEc0qZb9z5lRm
        roDr6Npg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIn-0003Fz-4s; Thu, 21 May 2020 17:48:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 18/49] sctp: pass a kernel pointer to sctp_setsockopt_mappedv4
Date:   Thu, 21 May 2020 19:46:53 +0200
Message-Id: <20200521174724.2635475-19-hch@lst.de>
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
 net/sctp/socket.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 161acd6253e06..41407d0ef2eca 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3170,16 +3170,14 @@ static int sctp_setsockopt_associnfo(struct sock *sk,
  * addresses and a user will receive both PF_INET6 and PF_INET type
  * addresses on the socket.
  */
-static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_mappedv4(struct sock *sk, int *val,
+				    unsigned int optlen)
 {
-	int val;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-	if (val)
+	if (*val)
 		sp->v4mapped = 1;
 	else
 		sp->v4mapped = 0;
@@ -4693,7 +4691,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_associnfo(sk, kopt, optlen);
 		break;
 	case SCTP_I_WANT_MAPPED_V4_ADDR:
-		retval = sctp_setsockopt_mappedv4(sk, optval, optlen);
+		retval = sctp_setsockopt_mappedv4(sk, kopt, optlen);
 		break;
 	case SCTP_MAXSEG:
 		retval = sctp_setsockopt_maxseg(sk, optval, optlen);
-- 
2.26.2

