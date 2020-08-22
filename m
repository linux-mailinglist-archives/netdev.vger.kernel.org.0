Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8752224E574
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 06:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgHVElQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 00:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgHVElP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 00:41:15 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF72C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 21:41:14 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id v15so1945468pgh.6
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 21:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4tycrz9+mrs9bI0PZ0O9ZszH/0ecSjNeZ2XrreQ/rwY=;
        b=QkuZQr9GVfMuRqkUhnD3xS5UB7z8gnQG4Ie8qKXvXhceV0S7P0CsAH+j+6K7KHVyh/
         FLarobTYQoCKGl2zKsocvB7dXwrLFceajMvFN3TJ0NzvX9WVpTVM/gNoEgPHWUy69zVG
         Z+HKf1V7koc2DyzX6PmuP5EXa3GbEv0EFoZU2eLNMpuryNGpxb/KnvrA7LY2bJACi4pT
         0xMOj4F+8hA8qbdjTgmlRe6tONq+bDVo3np0DFcRA0tQe9MC7lIYeyr+SLbLoTWcMpXS
         7oe2y2ABaxSCvVZvp3fBYSiz5tRdFQ+MheV0WUw6jZcpNZlJp3T58ta2BfLwMCLNPdTX
         zilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4tycrz9+mrs9bI0PZ0O9ZszH/0ecSjNeZ2XrreQ/rwY=;
        b=QWkSgS+LmVoQteEsLU6REnr9hEfUZhw8kQRsXZT1wpKRJrojrpZ9X06mlCZbJNq2Kr
         MmoinA81v9gBBj05hAm8W9DCeqELcL2Xaqt/TTrcuqJSpAAOBX076iy+pg1OrGkbuhob
         xj+nichMdOxmP7zI271j7MhXeb/wVZmeL7Edn+5qhjue/8d3EZhelrwLODaQXJaJt18B
         PGoK89npGWMTWiWylrxKzR5nX7BlESsrIWHtp5htg3yW2P8tA452ukDIuU8PshEmM4dN
         rIaWdQWZJPsTdK+mCgM8adIQ2quTDTDxqqu/NdJqHtQJLENj3t3+KIcM7M5JQX8vsPDS
         g0CA==
X-Gm-Message-State: AOAM5306zO8fDNv4QDpZZ5PYEES73Gze4AbkqGLzS2LTGDE5SmUEfOZn
        UzcLR6UgtdROpgP03EgQ00w=
X-Google-Smtp-Source: ABdhPJzPgQUf3FVfoME54NbERD4jqxuJgZaHCNczKWqNVoUosNnOa0XBVSJBc8IufDmYBA5AXDfl+A==
X-Received: by 2002:a62:764e:: with SMTP id r75mr5057446pfc.234.1598071273711;
        Fri, 21 Aug 2020 21:41:13 -0700 (PDT)
Received: from lukehsiao.c.googlers.com.com (40.156.233.35.bc.googleusercontent.com. [35.233.156.40])
        by smtp.gmail.com with ESMTPSA id u29sm4338997pfl.180.2020.08.21.21.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 21:41:12 -0700 (PDT)
From:   Luke Hsiao <luke.w.hsiao@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jakub Kicinski <kuba@kernel.org>,
        Luke Hsiao <lukehsiao@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jann Horn <jannh@google.com>
Subject: [PATCH net-next v3 1/2] io_uring: allow tcp ancillary data for __sys_recvmsg_sock()
Date:   Fri, 21 Aug 2020 21:41:04 -0700
Message-Id: <20200822044105.3097613-1-luke.w.hsiao@gmail.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
In-Reply-To: <0bc6cc65-e764-6fe0-9b0a-431015835770@kernel.dk>
References: <0bc6cc65-e764-6fe0-9b0a-431015835770@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Hsiao <lukehsiao@google.com>

For TCP tx zero-copy, the kernel notifies the process of completions by
queuing completion notifications on the socket error queue. This patch
allows reading these notifications via recvmsg to support TCP tx
zero-copy.

Ancillary data was originally disallowed due to privilege escalation
via io_uring's offloading of sendmsg() onto a kernel thread with kernel
credentials (https://crbug.com/project-zero/1975). So, we must ensure
that the socket type is one where the ancillary data types that are
delivered on recvmsg are plain data (no file descriptors or values that
are translated based on the identity of the calling process).

This was tested by using io_uring to call recvmsg on the MSG_ERRQUEUE
with tx zero-copy enabled. Before this patch, we received -EINVALID from
this specific code path. After this patch, we could read tcp tx
zero-copy completion notifications from the MSG_ERRQUEUE.

Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Arjun Roy <arjunroy@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Luke Hsiao <lukehsiao@google.com>
---
 include/linux/net.h | 3 +++
 net/ipv4/af_inet.c  | 1 +
 net/ipv6/af_inet6.c | 1 +
 net/socket.c        | 8 +++++---
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index d48ff1180879..7657c6432a69 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -41,6 +41,8 @@ struct net;
 #define SOCK_PASSCRED		3
 #define SOCK_PASSSEC		4
 
+#define PROTO_CMSG_DATA_ONLY	0x0001
+
 #ifndef ARCH_HAS_SOCKET_TYPES
 /**
  * enum sock_type - Socket types
@@ -135,6 +137,7 @@ typedef int (*sk_read_actor_t)(read_descriptor_t *, struct sk_buff *,
 
 struct proto_ops {
 	int		family;
+	unsigned int	flags;
 	struct module	*owner;
 	int		(*release)   (struct socket *sock);
 	int		(*bind)	     (struct socket *sock,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 4307503a6f0b..b7260c8cef2e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1017,6 +1017,7 @@ static int inet_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned lon
 
 const struct proto_ops inet_stream_ops = {
 	.family		   = PF_INET,
+	.flags		   = PROTO_CMSG_DATA_ONLY,
 	.owner		   = THIS_MODULE,
 	.release	   = inet_release,
 	.bind		   = inet_bind,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 0306509ab063..d9a14935f402 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -661,6 +661,7 @@ int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 const struct proto_ops inet6_stream_ops = {
 	.family		   = PF_INET6,
+	.flags		   = PROTO_CMSG_DATA_ONLY,
 	.owner		   = THIS_MODULE,
 	.release	   = inet6_release,
 	.bind		   = inet6_bind,
diff --git a/net/socket.c b/net/socket.c
index dbbe8ea7d395..e84a8e281b4c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2628,9 +2628,11 @@ long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
 			struct user_msghdr __user *umsg,
 			struct sockaddr __user *uaddr, unsigned int flags)
 {
-	/* disallow ancillary data requests from this path */
-	if (msg->msg_control || msg->msg_controllen)
-		return -EINVAL;
+	if (msg->msg_control || msg->msg_controllen) {
+		/* disallow ancillary data reqs unless cmsg is plain data */
+		if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
+			return -EINVAL;
+	}
 
 	return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
 }
-- 
2.28.0.297.g1956fa8f8d-goog

