Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9ABF3006BE
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbhAVPJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729155AbhAVPIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:08:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51889C061788;
        Fri, 22 Jan 2021 07:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=bAJe67MUPaZRQXdHzBs/ansU7ORV2YMYxU9r3Futc8E=; b=jvq4zMP0LGCoZx9IbCiiUXu9o4
        D/x2nf9W+XBGyqcXBHwha3laO2WHyXO5TFRZp/9t8SbC4U16Vmz72F2rmm9BHpPWvPKbl2ECRYcru
        nL8ZPfi5+9Zo1xYwVX4ztBesb0CPODKL0+7OsLhXS0+rsn+GtdGVnYcu0NSWqZbpvsCAbfrdwVYwa
        M5JY2HiBwuRnsjVVy3nlJL96LOumrUuuSgD0OB+GRBhPqIxi2GSlM8r44b1zYLzR5xgi0EHBPeggK
        fo7gojjGeYQHUB+Z6U7vY47ZQ84PyD2vcy75TxSkKke/gl7N4sBOKNSrWDOaFmTL2IU1NKIPkUbxH
        fM7fHQrg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l2y1K-000t40-Qq; Fri, 22 Jan 2021 15:06:46 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, andy.rudoff@intel.com
Cc:     Rao Shoaib <rao.shoaib@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
Date:   Fri, 22 Jan 2021 15:06:37 +0000
Message-Id: <20210122150638.210444-1-willy@infradead.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

TCP sockets allow SIGURG to be sent to the process holding the other
end of the socket.  Extend Unix sockets to have the same ability.

The API is the same in that the sender uses sendmsg() with MSG_OOB to
raise SIGURG.  Unix sockets behave in the same way as TCP sockets with
SO_OOBINLINE set.

SIGURG is ignored by default, so applications which do not know about this
feature will be unaffected.  In addition to installing a SIGURG handler,
the receiving application must call F_SETOWN or F_SETOWN_EX to indicate
which process or thread should receive the signal.

Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/unix/af_unix.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 41c3303c3357..849dff688c2c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1837,8 +1837,6 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		return err;
 
 	err = -EOPNOTSUPP;
-	if (msg->msg_flags&MSG_OOB)
-		goto out_err;
 
 	if (msg->msg_namelen) {
 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
@@ -1903,6 +1901,9 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		sent += size;
 	}
 
+	if (msg->msg_flags & MSG_OOB)
+		sk_send_sigurg(other);
+
 	scm_destroy(&scm);
 
 	return sent;
-- 
2.29.2

