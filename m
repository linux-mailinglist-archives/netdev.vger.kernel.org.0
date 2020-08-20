Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6BB24C8E5
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgHTX5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgHTX4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:56:10 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A89C06134C
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:50:24 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m71so170451pfd.1
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aNolZrFVM5fFg7pW0bukJjIqrtX1zSAqLqhSf5Fdn0=;
        b=T6P+WI0bJAuiWVP53rY1r2lIJj05UHq204WD9T+xrgAqkEUUeqrIomi7F5e6lOzJTS
         cPC1sTVPJ1LmyP96+6BjvCOyHEcz0pC6sC8Xr4JNG3Nbok1mjwFQqzIC1Ggu2ZW0/TrT
         ZqCTMWa8ekmt5DobVBDXiUUDV8vkoeuyjDJiJaBs0lAEcqqHAwdVRYASCstfeHsfjIOM
         p4fEHIyt5Edo9mCOXfdurYjHhcqcco3Fz6PHjS9GXuCOk1YPB5gsc8TvPW6n46C0LloQ
         RZhiDyBHlOvaXHmqGF/ZhuasiBG3WA1tlgtRDZWb8zkDeNvOuOLJhmepQHVN+AowTeei
         ADUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aNolZrFVM5fFg7pW0bukJjIqrtX1zSAqLqhSf5Fdn0=;
        b=nWOAJk1Tlg3T/anegIBpxwY6AKz/zc+fZU8aCHM4X2X0ZhbVLVSHu0yCXGtDoYP/co
         RwSiw43TLPRySmNc31owmKHRk6RENdXQp8H0fLMzHbUjfksZOoc0b4qWjT84eWMiM3Ps
         tIgkelT2mRshJBxqugT/co62Uyr0MdJ/OYxN6DQV/rccsN7y2ceE17Cukn7JgOdFNfJK
         NzJM9UymYebKgr2qNrufbdGMs2Pa6Nac2rbHzYlwggO5ZemKO+ae9dktOQO0f5rsM77D
         TGuL4DbWV2gRRLyDrbv5+Hs4Pcrscf0YETSvGO2B3qRASEr7ltbZuCcVdEnf76jEr4qM
         SKpA==
X-Gm-Message-State: AOAM533ewGdzG2FSw8N+P8uBwMtIXPMBd3HWl1Kz/rWp7ITaLdiFrtES
        YYjA28jN/Ds8zd6lRg3i72pv0InMlW0=
X-Google-Smtp-Source: ABdhPJzQzT0IkT6C5YA+iIDwdMxlZjBEhZKtLqIBkfwPARLWiGBdSW5gVjQibJ0YhStutjAxANYAPg==
X-Received: by 2002:a62:1c58:: with SMTP id c85mr227132pfc.105.1597967423637;
        Thu, 20 Aug 2020 16:50:23 -0700 (PDT)
Received: from lukehsiao.c.googlers.com.com (40.156.233.35.bc.googleusercontent.com. [35.233.156.40])
        by smtp.gmail.com with ESMTPSA id x9sm194815pff.145.2020.08.20.16.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 16:50:22 -0700 (PDT)
From:   Luke Hsiao <luke.w.hsiao@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Luke Hsiao <lukehsiao@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jann Horn <jannh@google.com>
Subject: [PATCH net-next 1/2] io_uring: allow tcp ancillary data for __sys_recvmsg_sock()
Date:   Thu, 20 Aug 2020 16:49:53 -0700
Message-Id: <20200820234954.1784522-2-luke.w.hsiao@gmail.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
In-Reply-To: <20200820234954.1784522-1-luke.w.hsiao@gmail.com>
References: <20200820234954.1784522-1-luke.w.hsiao@gmail.com>
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

