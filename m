Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58752AC06C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbgKIQDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbgKIQDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:03:31 -0500
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E57C0613CF;
        Mon,  9 Nov 2020 08:03:31 -0800 (PST)
Received: by mail-qv1-xf41.google.com with SMTP id x13so2923412qvk.8;
        Mon, 09 Nov 2020 08:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=JFK5dzY/ExJkYmS7OjYI6bXdnmvaWPZaMlnpOs2/ScI=;
        b=mAFC1H96E5O6uf6Jc2qxg3GC5R6+jEBG4dY9tT4V2HcHS7LwJaMnzQWKXSMJrWlXag
         lPT7qxysTx/F3VMA7uVU1dtOGcZ5g23qAnmi/730CbWkP+Fj4uEQ7p9VOsSVnzWn7hhg
         QKN4FWv5+Eag3T6cVdIYxLHV0IDqOGgna5Yf45R7fjIQrvghyGVXWNuPZ9nVSKXOYGHs
         TiF+o0seeZHIzo9L8V4AtFLBHOFyN7J6mQcws2vp2L3nBHPJzYlhI3KvzKz3tAzSbnh7
         B7fhKfYTW7w/7126ZQSJOwM2is5gTNfnKRBWVi5kYMJyq20DPQ2rivPmGfZpflcxfE+f
         T25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:date:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=JFK5dzY/ExJkYmS7OjYI6bXdnmvaWPZaMlnpOs2/ScI=;
        b=Xb7+1BSOy+rjxEr9u8t2lt77qesBDBuy0c1qocwhvUG+eeGUJ65I8f67qRfowr3cwb
         BQPpCEtq9T5STtHKi4SXLKKqEBiOZx9uPCusFu6V/yCyinpV+hrO++NKe18jo4yvQ1qz
         oxVdAQ6r3hyBs+pE0wZAvwheH+8GZzuEwnme3VujNI3aKwaxHZK6/qGIFrFI7FE0W21t
         jYCXMFddjZ0xDt3zQp3NxRfgNqmXs4N3nwYlH/9LuDl6uuXPYbS/TJcCWtLk9PncAaY+
         T/dU2Lsq9yyG0Qa4Q23zvRLnGgtHfMxyXJ9jBjpoZ3jSAT9hWtTzVCrk8mWtzdUobJhd
         rbew==
X-Gm-Message-State: AOAM532+4ETRfWr3nVhYvSgSvbnSnfRFs8iQDFGV2zR0OYR+7IZ1Dj9C
        HlVuMRpzCe6vlaf3mt+pkm8dzptIE8s=
X-Google-Smtp-Source: ABdhPJzmaacYce0oLEOEPSE30QsgQ25KB/VonwChzlazNlkZxEFvadeWk/IgPM66AYucDcI//mUiyQ==
X-Received: by 2002:a0c:e585:: with SMTP id t5mr14665598qvm.6.1604937810164;
        Mon, 09 Nov 2020 08:03:30 -0800 (PST)
Received: from gateway.1015granger.net (c-68-61-232-219.hsd1.mi.comcast.net. [68.61.232.219])
        by smtp.gmail.com with ESMTPSA id n6sm6365192qkk.6.2020.11.09.08.03.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Nov 2020 08:03:29 -0800 (PST)
Sender: Chuck Lever <chucklever@gmail.com>
Received: from klimt.1015granger.net (klimt.1015granger.net [192.168.1.55])
        by gateway.1015granger.net (8.14.7/8.14.7) with ESMTP id 0A9G3RQO021418;
        Mon, 9 Nov 2020 16:03:27 GMT
Subject: [PATCH RFC] SUNRPC: Use zero-copy to perform socket send operations
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Date:   Mon, 09 Nov 2020 11:03:27 -0500
Message-ID: <160493771006.15633.8524084764848931537.stgit@klimt.1015granger.net>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daire Byrne reports a ~50% aggregrate throughput regression on his
Linux NFS server after commit da1661b93bf4 ("SUNRPC: Teach server to
use xprt_sock_sendmsg for socket sends"), which replaced
kernel_send_page() calls in NFSD's socket send path with calls to
sock_sendmsg() using iov_iter.

Investigation showed that tcp_sendmsg() was not using zero-copy to
send the xdr_buf's bvec pages, but instead was relying on memcpy.

Set up the socket and each msghdr that bears bvec pages to use the
zero-copy mechanism in tcp_sendmsg.

Reported-by: Daire Byrne <daire@dneg.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209439
Fixes: da1661b93bf4 ("SUNRPC: Teach server to use xprt_sock_sendmsg for socket sends")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/sunrpc/socklib.c  |    5 ++++-
 net/sunrpc/svcsock.c  |    1 +
 net/sunrpc/xprtsock.c |    1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

This patch does not fully resolve the issue. Daire reports high
softIRQ activity after the patch is applied, and this activity
seems to prevent full restoration of previous performance.


diff --git a/net/sunrpc/socklib.c b/net/sunrpc/socklib.c
index d52313af82bc..af47596a7bdd 100644
--- a/net/sunrpc/socklib.c
+++ b/net/sunrpc/socklib.c
@@ -226,9 +226,12 @@ static int xprt_send_pagedata(struct socket *sock, struct msghdr *msg,
 	if (err < 0)
 		return err;
 
+	msg->msg_flags |= MSG_ZEROCOPY;
 	iov_iter_bvec(&msg->msg_iter, WRITE, xdr->bvec, xdr_buf_pagecount(xdr),
 		      xdr->page_len + xdr->page_base);
-	return xprt_sendmsg(sock, msg, base + xdr->page_base);
+	err = xprt_sendmsg(sock, msg, base + xdr->page_base);
+	msg->msg_flags &= ~MSG_ZEROCOPY;
+	return err;
 }
 
 /* Common case:
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index c2752e2b9ce3..c814b4953b15 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1176,6 +1176,7 @@ static void svc_tcp_init(struct svc_sock *svsk, struct svc_serv *serv)
 		svsk->sk_datalen = 0;
 		memset(&svsk->sk_pages[0], 0, sizeof(svsk->sk_pages));
 
+		sock_set_flag(sk, SOCK_ZEROCOPY);
 		tcp_sk(sk)->nonagle |= TCP_NAGLE_OFF;
 
 		set_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 7090bbee0ec5..343c6396b297 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2175,6 +2175,7 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 
 		/* socket options */
 		sock_reset_flag(sk, SOCK_LINGER);
+		sock_set_flag(sk, SOCK_ZEROCOPY);
 		tcp_sk(sk)->nonagle |= TCP_NAGLE_OFF;
 
 		xprt_clear_connected(xprt);


