Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6460A1E7CCA
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgE2MKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgE2MKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 08:10:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CA6C08C5C8;
        Fri, 29 May 2020 05:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cWUTtlFm6rduEFgMkQS8bZjX0MpfbR8IuxRNGH3yJJc=; b=UiTm5TXo3XhgmygPM/PMI0rR1l
        3yCIF0cohJnlB1P55KtB7hwAFF49699wcL4qaZGU0X11Ut65chg1ryEhI/MynDN1eTDWO/ESIksHY
        PhUzpbdYGKja0twp5uJi0wgCVVRSlfntPLHnvCao3xXV/1rPHr2cERLnF/5xWQDsNQNrgyHsSGcaj
        ud1Z/QfOSgXXhDIz13gK0yRKMUWhsUiRiYRA04dFU6RneahfgolKYaTQlpyc6bxJNX6RnRKpcvxSJ
        Ucn1DRv5JQcMUhRh6NMx1PZteSDfSZ6b8wrqQXAnaZW4QDeU3qsIsi1U8FJfDquuvl4KwpF9cWwFc
        gGXlKlng==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jedpk-0006Ko-Pu; Fri, 29 May 2020 12:09:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH 2/4] sctp: refactor sctp_setsockopt_bindx
Date:   Fri, 29 May 2020 14:09:41 +0200
Message-Id: <20200529120943.101454-3-hch@lst.de>
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

Split out a sctp_setsockopt_bindx_kernel that takes a kernel pointer
to the sockaddr and make sctp_setsockopt_bindx a small wrapper around
it.  This prepares for adding a new bind_add proto op.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 61 ++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 827a9903ee288..6e745ac3c4a59 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -972,23 +972,22 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
  * it.
  *
  * sk        The sk of the socket
- * addrs     The pointer to the addresses in user land
+ * addrs     The pointer to the addresses
  * addrssize Size of the addrs buffer
  * op        Operation to perform (add or remove, see the flags of
  *           sctp_bindx)
  *
  * Returns 0 if ok, <0 errno code on error.
  */
-static int sctp_setsockopt_bindx(struct sock *sk,
-				 struct sockaddr __user *addrs,
-				 int addrs_size, int op)
+static int sctp_setsockopt_bindx_kernel(struct sock *sk,
+					struct sockaddr *addrs, int addrs_size,
+					int op)
 {
-	struct sockaddr *kaddrs;
 	int err;
 	int addrcnt = 0;
 	int walk_size = 0;
 	struct sockaddr *sa_addr;
-	void *addr_buf;
+	void *addr_buf = addrs;
 	struct sctp_af *af;
 
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d opt:%d\n",
@@ -997,17 +996,10 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	if (unlikely(addrs_size <= 0))
 		return -EINVAL;
 
-	kaddrs = memdup_user(addrs, addrs_size);
-	if (IS_ERR(kaddrs))
-		return PTR_ERR(kaddrs);
-
 	/* Walk through the addrs buffer and count the number of addresses. */
-	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
-		if (walk_size + sizeof(sa_family_t) > addrs_size) {
-			kfree(kaddrs);
+		if (walk_size + sizeof(sa_family_t) > addrs_size)
 			return -EINVAL;
-		}
 
 		sa_addr = addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa_family);
@@ -1015,10 +1007,8 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 		/* If the address family is not supported or if this address
 		 * causes the address buffer to overflow return EINVAL.
 		 */
-		if (!af || (walk_size + af->sockaddr_len) > addrs_size) {
-			kfree(kaddrs);
+		if (!af || (walk_size + af->sockaddr_len) > addrs_size)
 			return -EINVAL;
-		}
 		addrcnt++;
 		addr_buf += af->sockaddr_len;
 		walk_size += af->sockaddr_len;
@@ -1029,31 +1019,36 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	case SCTP_BINDX_ADD_ADDR:
 		/* Allow security module to validate bindx addresses. */
 		err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_BINDX_ADD,
-						 (struct sockaddr *)kaddrs,
-						 addrs_size);
+						 addrs, addrs_size);
 		if (err)
-			goto out;
-		err = sctp_bindx_add(sk, kaddrs, addrcnt);
+			return err;
+		err = sctp_bindx_add(sk, addrs, addrcnt);
 		if (err)
-			goto out;
-		err = sctp_send_asconf_add_ip(sk, kaddrs, addrcnt);
-		break;
-
+			return err;
+		return sctp_send_asconf_add_ip(sk, addrs, addrcnt);
 	case SCTP_BINDX_REM_ADDR:
-		err = sctp_bindx_rem(sk, kaddrs, addrcnt);
+		err = sctp_bindx_rem(sk, addrs, addrcnt);
 		if (err)
-			goto out;
-		err = sctp_send_asconf_del_ip(sk, kaddrs, addrcnt);
-		break;
+			return err;
+		return sctp_send_asconf_del_ip(sk, addrs, addrcnt);
 
 	default:
-		err = -EINVAL;
-		break;
+		return -EINVAL;
 	}
+}
 
-out:
-	kfree(kaddrs);
+static int sctp_setsockopt_bindx(struct sock *sk,
+				 struct sockaddr __user *addrs,
+				 int addrs_size, int op)
+{
+	struct sockaddr *kaddrs;
+	int err;
 
+	kaddrs = memdup_user(addrs, addrs_size);
+	if (IS_ERR(kaddrs))
+		return PTR_ERR(kaddrs);
+	err = sctp_setsockopt_bindx_kernel(sk, kaddrs, addrs_size, op);
+	kfree(kaddrs);
 	return err;
 }
 
-- 
2.26.2

