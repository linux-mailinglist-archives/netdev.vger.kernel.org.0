Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9341613FE69
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 00:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403905AbgAPXci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 18:32:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403889AbgAPXch (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 18:32:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69BAE20684;
        Thu, 16 Jan 2020 23:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217555;
        bh=Y9zR/zTmFhs3FpnRvxKhdD2kucn2ce+WPJwdkc21DP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEHYBMlRiw8GFQ49CUalo+QwDmPgNciQCTFOVyp7SFVS/HcgI/Oc+FtZSeKcU14hg
         Pby+HzIDWoHgoNfVxYcbR0RYVmT0/MyWcCd0jJjV08IVW8N/tFoJ0VOykHDaU0hlQh
         U60jJkWRQCFT0+PK5w6h1qJFRZVpmZMDgCKYvSOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.14 46/71] af_unix: add compat_ioctl support
Date:   Fri, 17 Jan 2020 00:18:44 +0100
Message-Id: <20200116231716.118855040@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 5f6beb9e0f633f3cc845cdd67973c506372931b4 upstream.

The af_unix protocol family has a custom ioctl command (inexplicibly
based on SIOCPROTOPRIVATE), but never had a compat_ioctl handler for
32-bit applications.

Since all commands are compatible here, add a trivial wrapper that
performs the compat_ptr() conversion for SIOCOUTQ/SIOCINQ.  SIOCUNIXFILE
does not use the argument, but it doesn't hurt to also use compat_ptr()
here.

Fixes: ba94f3088b79 ("unix: add ioctl to open a unix socket file with O_PATH")
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/unix/af_unix.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -644,6 +644,9 @@ static unsigned int unix_poll(struct fil
 static unsigned int unix_dgram_poll(struct file *, struct socket *,
 				    poll_table *);
 static int unix_ioctl(struct socket *, unsigned int, unsigned long);
+#ifdef CONFIG_COMPAT
+static int unix_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
+#endif
 static int unix_shutdown(struct socket *, int);
 static int unix_stream_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_stream_recvmsg(struct socket *, struct msghdr *, size_t, int);
@@ -685,6 +688,9 @@ static const struct proto_ops unix_strea
 	.getname =	unix_getname,
 	.poll =		unix_poll,
 	.ioctl =	unix_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =	unix_compat_ioctl,
+#endif
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
 	.setsockopt =	sock_no_setsockopt,
@@ -708,6 +714,9 @@ static const struct proto_ops unix_dgram
 	.getname =	unix_getname,
 	.poll =		unix_dgram_poll,
 	.ioctl =	unix_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =	unix_compat_ioctl,
+#endif
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
 	.setsockopt =	sock_no_setsockopt,
@@ -730,6 +739,9 @@ static const struct proto_ops unix_seqpa
 	.getname =	unix_getname,
 	.poll =		unix_dgram_poll,
 	.ioctl =	unix_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =	unix_compat_ioctl,
+#endif
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
 	.setsockopt =	sock_no_setsockopt,
@@ -2650,6 +2662,13 @@ static int unix_ioctl(struct socket *soc
 	return err;
 }
 
+#ifdef CONFIG_COMPAT
+static int unix_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	return unix_ioctl(sock, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static unsigned int unix_poll(struct file *file, struct socket *sock, poll_table *wait)
 {
 	struct sock *sk = sock->sk;


