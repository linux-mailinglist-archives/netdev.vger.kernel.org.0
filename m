Return-Path: <netdev+bounces-10680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0569A72FC0C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 376081C20C89
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE6F79D9;
	Wed, 14 Jun 2023 11:10:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BAE6FD3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:10:29 +0000 (UTC)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9571BEF;
	Wed, 14 Jun 2023 04:10:27 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-3f7378a75c0so5164855e9.3;
        Wed, 14 Jun 2023 04:10:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686741025; x=1689333025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qkkE+Ruzq/uQr05Vb/IRsuaLy9Kdl2xaoXLCVAa73nU=;
        b=Ffc4zVjQGabstE656Dxw0WpMkANGe8mEcT19O3jvRkXKlR4LqCMlKULos/vTYO2k1W
         LVNuXA/CRAiCJTVdT+/u1svxPClaufVfy4yIHkE4LS5ewGvkzGSx6BB1oXZQmDCMyXzb
         oP71xl9DrWgeMoVUkvMCTe97Iznhbr1pL+LI2Z1n6szktiUZESF68nTnX+Dl68yDIKFE
         4B3499Cf6/EGasxC1yuV/gZm3X9cg3keybMSpcb9MeHjHVXOkLT1NsQpl5bqbVMjKB13
         Socir+0rgR2rIt1JuK395xz97niG0KOP3qd9BZetg7TYXA7zvvsrJoonmOZWw0bf68OP
         GWtA==
X-Gm-Message-State: AC+VfDwjTOSqyT7tRdGSpURmlg3csShEXw/SsV92v/zCV6Vj0X7luCBH
	v2q3i+JSu/t5v/O40RVwaS4boWrmcZIjEA==
X-Google-Smtp-Source: ACHHUZ4tnqlcsgs2dm8xr5gaCbxJU2IHbMPITeAK4rJDPfZMO4ktWYBZ+c7BfSSONtzeKSKABMbUgw==
X-Received: by 2002:a05:600c:228d:b0:3f7:8fbf:a21d with SMTP id 13-20020a05600c228d00b003f78fbfa21dmr10460822wmf.32.1686741025197;
        Wed, 14 Jun 2023 04:10:25 -0700 (PDT)
Received: from localhost (fwdproxy-cln-016.fbsv.net. [2a03:2880:31ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c114a00b003f7e60622f0sm17180504wmz.6.2023.06.14.04.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 04:10:24 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	David Ahern <dsahern@kernel.org>
Cc: leit@fb.com,
	asml.silence@gmail.com,
	matthieu.baerts@tessares.net,
	martineau@kernel.org,
	marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dccp@vger.kernel.org,
	mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org,
	ast@kernel.org,
	kuniyu@amazon.com,
	martin.lau@kernel.org
Subject: [RFC PATCH v2 3/4] net: add uring_cmd callback to TCP
Date: Wed, 14 Jun 2023 04:07:56 -0700
Message-Id: <20230614110757.3689731-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230614110757.3689731-1-leitao@debian.org>
References: <20230614110757.3689731-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is the implementation of uring_cmd for the TCP protocol. It
basically encompasses SOCKET_URING_OP_SIOCOUTQ and
SOCKET_URING_OP_SIOCINQ, which calls tcp_ioctl().

tcp_ioctl() has other CMDs, such as SIOCATMARK and SIOCOUTQNSD, but they
are not implemented, because they are TCP specific, and not available on
UDP and RAW sockets.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/net/tcp.h   |  2 ++
 net/ipv4/tcp.c      | 21 +++++++++++++++++++++
 net/ipv4/tcp_ipv4.c |  1 +
 3 files changed, 24 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 2a7289916d42..1100b0c9df98 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -340,6 +340,8 @@ void tcp_wfree(struct sk_buff *skb);
 void tcp_write_timer_handler(struct sock *sk);
 void tcp_delack_timer_handler(struct sock *sk);
 int tcp_ioctl(struct sock *sk, int cmd, int *karg);
+int tcp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags);
 int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb);
 void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
 void tcp_rcv_space_adjust(struct sock *sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2cb01880755a..8bf9a41d2a67 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -279,6 +279,7 @@
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
 #include <net/busy_poll.h>
+#include <linux/io_uring.h>
 
 /* Track pending CMSGs. */
 enum {
@@ -599,6 +600,26 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 }
 EXPORT_SYMBOL(tcp_poll);
 
+int tcp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags)
+{
+	int ret;
+
+	switch (cmd->sqe->cmd_op) {
+	case SOCKET_URING_OP_SIOCINQ:
+		if (tcp_ioctl(sk, SIOCINQ, &ret))
+			return -EFAULT;
+		return ret;
+	case SOCKET_URING_OP_SIOCOUTQ:
+		if (tcp_ioctl(sk, SIOCOUTQ, &ret))
+			return -EFAULT;
+		return ret;
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL_GPL(tcp_uring_cmd);
+
 int tcp_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 84a5d557dc1a..dd93a862d195 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3107,6 +3107,7 @@ struct proto tcp_prot = {
 	.disconnect		= tcp_disconnect,
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
+	.uring_cmd		= tcp_uring_cmd,
 	.init			= tcp_v4_init_sock,
 	.destroy		= tcp_v4_destroy_sock,
 	.shutdown		= tcp_shutdown,
-- 
2.34.1


