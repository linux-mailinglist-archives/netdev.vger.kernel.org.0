Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CA71DD53A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgEURuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbgEURs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0896C061A0E;
        Thu, 21 May 2020 10:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5IN1aBCpBLLZ9sCvcwK6iOI33fnAAeuKBjBeDTHfjkI=; b=Aim4h4E6KqlmT9aS3M3MopKY+I
        avbZFBfbCBhxVnuEHshLfF+TUtxJKYB7/d67gK+cgA7rkyEjPg8l8EsC8GsasO0F8RfAX9QNcEMr+
        tVmLcoMBTQS+QK2l111yFd1Z7TDxyOrYdL4lZKM1FUaf0eDxV062YPwisYptM+qsbx+OlpRxDT0Rn
        uOBifceu4ZKby3wiLLLP2GLLfqXdx7NG8zEMPiwBBKJubaDb0j/B5nQnq31uymQ8eUg7k+0FEIc9C
        2TsVDAg431+lPi25Tdny4MnEhHJpwW0gfQ6OSfIWbXC+8K2CXbdKSzfJX727xdWGM60vQbCKeEm9L
        E/NiQzFw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIp-0003GO-KT; Thu, 21 May 2020 17:48:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 19/49] sctp: pass a kernel pointer to sctp_setsockopt_maxseg
Date:   Thu, 21 May 2020 19:46:54 +0200
Message-Id: <20200521174724.2635475-20-hch@lst.de>
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
 net/sctp/socket.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 41407d0ef2eca..4374d4fff080a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3212,11 +3212,13 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, int *val,
  *    changed (effecting future associations only).
  * assoc_value:  This parameter specifies the maximum size in bytes.
  */
-static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_maxseg(struct sock *sk,
+				  struct sctp_assoc_value *params,
+				  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
+	sctp_assoc_t assoc_id;
 	int val;
 
 	if (optlen == sizeof(int)) {
@@ -3225,19 +3227,17 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 				    "Use of int in maxseg socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&val, optval, optlen))
-			return -EFAULT;
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		assoc_id = SCTP_FUTURE_ASSOC;
+		val = *(int *)params;
 	} else if (optlen == sizeof(struct sctp_assoc_value)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-		val = params.assoc_value;
+		assoc_id = params->assoc_id;
+		val = params->assoc_value;
 	} else {
 		return -EINVAL;
 	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, assoc_id);
+	if (!asoc && assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
@@ -4694,7 +4694,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_mappedv4(sk, kopt, optlen);
 		break;
 	case SCTP_MAXSEG:
-		retval = sctp_setsockopt_maxseg(sk, optval, optlen);
+		retval = sctp_setsockopt_maxseg(sk, kopt, optlen);
 		break;
 	case SCTP_ADAPTATION_LAYER:
 		retval = sctp_setsockopt_adaptation_layer(sk, optval, optlen);
-- 
2.26.2

