Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A044830D281
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhBCETw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhBCESY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:18:24 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4CDC061794;
        Tue,  2 Feb 2021 20:17:09 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id e70so22106517ote.11;
        Tue, 02 Feb 2021 20:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GN8zP3UB5VJMaiI/5BQTm+oIsq+71H6Qn+yKzIEhQE8=;
        b=N4k6iB1iwAc4+xCCISbCeU7Le+8Cw7BkN9C2UpcKHeCaWPIM0BGYT6Cv0BAc+zQf0z
         UcThmK/mjM3AZ805CHXi+iKL/IuXxp4h9V2ciR9yiz2v+g7jiQCQy/qxaG4eIvNdOA+R
         MfKW5T09POMs8bUeygBdrR9JsLwC+BjnTtKy9YDITQbtheH7XyB/DcE3Iy8zTK6C7SLQ
         qnYHm2obNLADh2eqarfqHwUuhVktSv4lR0HAG3xUXjpuKbRx+t8KnTFA29hnuhfAXuYz
         BxIjNpDypqSbplTSPjPzOIZysfwOiRtfx5UeanIgt09OMB4kEQ9TY9LVbnh2XS+3ZMrH
         w+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GN8zP3UB5VJMaiI/5BQTm+oIsq+71H6Qn+yKzIEhQE8=;
        b=MJ+U5M/Nm1aiHvyKklSGyjsqVnBQoueSEfl8yhPIfZpyibDft4eQVu9dOAADAqOE0+
         9p/RsixMSYI5lMUgrAAdB0rWWgIyoxIAmOpIu1Z6Ibl72UD09MEEgnMuWw6xe5XVSNOh
         e4SWDI09/Z0uBU+VrdspWgxA4bANXrsp1xL7w4JJSV5/CF7Jo6NiyF6kgID57uCXUKWm
         Xhqv/m+zh5mf8mVkBwELztCjOGIo/OBdxXxuQSV/mz5K4ojLp4tJL3PIsjI5RE2Xkl2e
         ZbKsyM+3iR1O2ddEPWQo1PuOnawCOfPAfx0paHy+lHy2WUDGzztxKCLX1rsvG7Hc/ijM
         9pug==
X-Gm-Message-State: AOAM531rSDs+FX5o6uUrdsclhuMqxutSqskyVHtPQMIx9kpv2Qfnz7Lg
        ZQ0nB1CQ92aLl5PtA/shfqh+rHnKeRtrww==
X-Google-Smtp-Source: ABdhPJxCGYaDts//pAYD30pC10JIsY/BnC6sSVkE+STYVWl72C4V1snCvm9h8It6Z78JCNaRD6/0PA==
X-Received: by 2002:a9d:4e04:: with SMTP id p4mr770036otf.150.1612325828466;
        Tue, 02 Feb 2021 20:17:08 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:07 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 10/19] af_unix: implement ->sendmsg_locked for dgram socket
Date:   Tue,  2 Feb 2021 20:16:27 -0800
Message-Id: <20210203041636.38555-11-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We already have unix_dgram_sendmsg(), we can just build
its ->sendmsg_locked() on top of it.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 41c3303c3357..4e1fa4ecbcfb 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -659,6 +659,7 @@ static ssize_t unix_stream_sendpage(struct socket *, struct page *, int offset,
 static ssize_t unix_stream_splice_read(struct socket *,  loff_t *ppos,
 				       struct pipe_inode_info *, size_t size,
 				       unsigned int flags);
+static int __unix_dgram_sendmsg(struct sock*, struct msghdr *, size_t);
 static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
 static int unix_dgram_connect(struct socket *, struct sockaddr *,
@@ -738,6 +739,7 @@ static const struct proto_ops unix_dgram_ops = {
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
 	.sendmsg =	unix_dgram_sendmsg,
+	.sendmsg_locked = __unix_dgram_sendmsg,
 	.recvmsg =	unix_dgram_recvmsg,
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
@@ -1611,10 +1613,10 @@ static void scm_stat_del(struct sock *sk, struct sk_buff *skb)
  *	Send AF_UNIX data.
  */
 
-static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
-			      size_t len)
+static int __unix_dgram_sendmsg(struct sock *sk, struct msghdr *msg,
+				size_t len)
 {
-	struct sock *sk = sock->sk;
+	struct socket *sock = sk->sk_socket;
 	struct net *net = sock_net(sk);
 	struct unix_sock *u = unix_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_un *, sunaddr, msg->msg_name);
@@ -1814,6 +1816,12 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
+static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
+			      size_t len)
+{
+	return __unix_dgram_sendmsg(sock->sk, msg, len);
+}
+
 /* We use paged skbs for stream sockets, and limit occupancy to 32768
  * bytes, and a minimum of a full page.
  */
-- 
2.25.1

