Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490E72C5A5F
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 18:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391655AbgKZRSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 12:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgKZRSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 12:18:03 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5192C0613D4;
        Thu, 26 Nov 2020 09:18:02 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id f15so1538305qto.13;
        Thu, 26 Nov 2020 09:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=NlnPCPQITjmSXFl1L+TUPev6YuSEWNSwz5CfAUfaxWg=;
        b=Y+lK59zgAc7OeKkt4BvWOO2TKG7rCo7HSK+If1sur+tuYObu9RHzste+FG49qmc62D
         GVVChe7PXttGvWhfrMDStP/cGpdpE9ULBRN2lW0BnamDELg8Ps1g4AT7OoyWMJ8lXOXS
         gSAY0jfnj2eW1h95jPVofp7c4az/wsy7qUlQuR6ickfABV5ofL7lOBVDIo1Wcou0DSBu
         XSggCktHTkcVMExKLxRGKg84js+Hn796fQvhQEFJsQehIj9K52EshWWl8IBjwhJ1xxLr
         3p5Gw3flfhWuWi2AqEEgsNHCTBwjJ0AJ6aSK+34n3EV1AZnLEwyYUX5CPYtaeI06SIse
         sO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:date:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=NlnPCPQITjmSXFl1L+TUPev6YuSEWNSwz5CfAUfaxWg=;
        b=HHO3jv7kvNH5QTx0JQ+SFLwGjSZ6mIWPZvJM9DRj8jExnR9mvG7K5V0e5AWbk4r26g
         n67Rp7smz7QCmG/boAmXDibtHdaJMLHru3uDxy1CWY/T6xGMPsZfUTMqM7KxZdB2C3JX
         7f6iBnlSouKdjnffY4MyMkDGw39yLYYbsf2ybpkW0kjJpdGviDMRvtvZnaskMETEsEvo
         ajsnGaYJwgRJDM7KcRhtDg75Ugohnn8S/y5P19zMTY+Cm4CcHvaLwMu6wePdKt6Xj7nG
         1AjhKeIMKC907oUSJ/wlwbDx7N5QN/kXTdVzp+TJaHtxnKg3Z2/JSqB0xMN4uNKuNDve
         BBvg==
X-Gm-Message-State: AOAM530x6pItYDNdBn08VdGRE9tJCFAvR2lLiwoYMkaO1jAjRdjBFnMt
        PVl3onnfdAqbm3lr6GwLdkLpxdX+p+k=
X-Google-Smtp-Source: ABdhPJxAex6EDg0GwUzyEJ/IEsXgxYMEAr9yfFBGzWMJ4c3z7QuGTnxn3krOGD0Iojhk7QBMNGZhgA==
X-Received: by 2002:ac8:5412:: with SMTP id b18mr4154768qtq.220.1606411081556;
        Thu, 26 Nov 2020 09:18:01 -0800 (PST)
Received: from gateway.1015granger.net (c-68-61-232-219.hsd1.mi.comcast.net. [68.61.232.219])
        by smtp.gmail.com with ESMTPSA id k188sm3190416qkd.98.2020.11.26.09.18.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Nov 2020 09:18:00 -0800 (PST)
Sender: Chuck Lever <chucklever@gmail.com>
Received: from klimt.1015granger.net (klimt.1015granger.net [192.168.1.55])
        by gateway.1015granger.net (8.14.7/8.14.7) with ESMTP id 0AQHHwCs018350;
        Thu, 26 Nov 2020 17:17:58 GMT
Subject: [PATCH v2] SUNRPC: Use zero-copy to perform socket send operations
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Date:   Thu, 26 Nov 2020 12:17:58 -0500
Message-ID: <160641091184.350621.18059939865682566764.stgit@klimt.1015granger.net>
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
zero-copy mechanism in tcp_sendmsg. The server side enables full
zero-copy, but the client side does not, because pages passed to the
the RPC layer are not guaranteed to be stable. They include unlocked
page cache pages as well as O_DIRECT pages.

Reported-by: Daire Byrne <daire@dneg.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209439
Fixes: da1661b93bf4 ("SUNRPC: Teach server to use xprt_sock_sendmsg for socket sends")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/sunrpc/socklib.c |    5 ++++-
 net/sunrpc/svcsock.c |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

Hi-

Because I got a 0-day regression report this morning based on the
original version of this patch, I thought I should repost with a
revised version that is corrected to disable zero-copy on the
client-side, as we previously discussed.


Changes since v1:
- Disable zero-copy optimization on the client-side

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
index b248f2349437..6f199cbb055d 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1176,6 +1176,7 @@ static void svc_tcp_init(struct svc_sock *svsk, struct svc_serv *serv)
 		svsk->sk_datalen = 0;
 		memset(&svsk->sk_pages[0], 0, sizeof(svsk->sk_pages));
 
+		sock_set_flag(sk, SOCK_ZEROCOPY);
 		tcp_sk(sk)->nonagle |= TCP_NAGLE_OFF;
 
 		set_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);


