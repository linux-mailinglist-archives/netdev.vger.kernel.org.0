Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562816D9AFD
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbjDFOqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239216AbjDFOpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:45:43 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11980A27D;
        Thu,  6 Apr 2023 07:45:01 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id j18-20020a05600c1c1200b003ee5157346cso25667783wms.1;
        Thu, 06 Apr 2023 07:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680792237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DdgssL2Y+ar153QBlAv7JBtrBbAm616EZvQGP5HdHt4=;
        b=k0QRsq8ynYY37v5Kl0//zAYbx7ZbSuK7OXYRgJjMaSzObEkO30AuCs3Sqr2T1IOdyZ
         Lz+sqt2HlP02/4f9dUTMfrHBbGfMph8+Y8kwF7K/cwLvJmJtQDMTP17GuMBj1fIbUVmd
         Gy4oP0xAbRvMrNprHp6WAKQM7BlPqu0olVXfxHof5kFWYqxQZvhqIwt6YxGfTrPcLp8R
         y1AGGojXSjHlj4odjGA44P7IPxwtKEaOF5glKy0XaYvYCxd1BmoVqpbtTVgInOA1Do2U
         spJR0LbS+u/AhcY20JZ6si0bzoVQEtAmw/gJQXhV5/ry26KOCS6PRyjDamHXqMagijo8
         eJTQ==
X-Gm-Message-State: AAQBX9cS3wrwc6e5Jz+IZF8n7k5KWYs0HhnoES1rsBVhGR9wXz8dUuX5
        nj3fosARfkbJ0oBBKf4aK/PREqOuJloJgQ==
X-Google-Smtp-Source: AKy350ZnKTn89DhKxJeGfgPbuAFyAbgRVP4wqJkdvOw2VZiQJhmbrpuVfhfGag2Nw9LzoY39sAkViQ==
X-Received: by 2002:a7b:c384:0:b0:3e9:f15b:935b with SMTP id s4-20020a7bc384000000b003e9f15b935bmr7264583wmj.32.1680792236817;
        Thu, 06 Apr 2023 07:43:56 -0700 (PDT)
Received: from localhost (fwdproxy-cln-117.fbsv.net. [2a03:2880:31ff:75::face:b00c])
        by smtp.gmail.com with ESMTPSA id g23-20020a7bc4d7000000b003e91b9a92c9sm1773473wmk.24.2023.04.06.07.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 07:43:56 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        asml.silence@gmail.com, axboe@kernel.dk
Cc:     leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        willemdebruijn.kernel@gmail.com, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
Subject: [RFC PATCH 2/4] net: add uring_cmd callback to UDP
Date:   Thu,  6 Apr 2023 07:43:28 -0700
Message-Id: <20230406144330.1932798-3-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230406144330.1932798-1-leitao@debian.org>
References: <20230406144330.1932798-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the implementation of uring_cmd for the udp protocol. It
basically encompasses SOCKET_URING_OP_SIOCOUTQ and
SOCKET_URING_OP_SIOCINQ, which is similar to the SIOCOUTQ and SIOCINQ
ioctls.

The return value is exactly the same as the regular ioctl (udp_ioctl()).

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/net/udp.h        |  2 ++
 include/uapi/linux/net.h |  5 +++++
 net/ipv4/udp.c           | 16 ++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index de4b528522bb..c0e829dacc2f 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -283,6 +283,8 @@ void udp_flush_pending_frames(struct sock *sk);
 int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
 void udp4_hwcsum(struct sk_buff *skb, __be32 src, __be32 dst);
 int udp_rcv(struct sk_buff *skb);
+int udp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags);
 int udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
 int udp_init_sock(struct sock *sk);
 int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
diff --git a/include/uapi/linux/net.h b/include/uapi/linux/net.h
index 4dabec6bd957..dd8e7ced7d24 100644
--- a/include/uapi/linux/net.h
+++ b/include/uapi/linux/net.h
@@ -55,4 +55,9 @@ typedef enum {
 
 #define __SO_ACCEPTCON	(1 << 16)	/* performed a listen		*/
 
+enum {
+	SOCKET_URING_OP_SIOCINQ		= 0,
+	SOCKET_URING_OP_SIOCOUTQ,
+};
+
 #endif /* _UAPI_LINUX_NET_H */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c605d171eb2d..d6d60600831b 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -113,6 +113,7 @@
 #include <net/sock_reuseport.h>
 #include <net/addrconf.h>
 #include <net/udp_tunnel.h>
+#include <linux/io_uring.h>
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6_stubs.h>
 #endif
@@ -1711,6 +1712,20 @@ static int first_packet_length(struct sock *sk)
 	return res;
 }
 
+int udp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags)
+{
+	switch (cmd->sqe->cmd_op) {
+	case SOCKET_URING_OP_SIOCOUTQ:
+		return sk_wmem_alloc_get(sk);
+	case SOCKET_URING_OP_SIOCINQ:
+		return max_t(int, 0, first_packet_length(sk));
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL_GPL(udp_uring_cmd);
+
 /*
  *	IOCTL requests applicable to the UDP protocol
  */
@@ -2952,6 +2967,7 @@ struct proto udp_prot = {
 	.connect		= ip4_datagram_connect,
 	.disconnect		= udp_disconnect,
 	.ioctl			= udp_ioctl,
+	.uring_cmd		= udp_uring_cmd,
 	.init			= udp_init_sock,
 	.destroy		= udp_destroy_sock,
 	.setsockopt		= udp_setsockopt,
-- 
2.34.1

