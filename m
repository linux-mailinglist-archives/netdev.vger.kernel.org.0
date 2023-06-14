Return-Path: <netdev+bounces-10681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FFC672FC0E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 097D828142F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095B4847D;
	Wed, 14 Jun 2023 11:10:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E3279E1
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:10:29 +0000 (UTC)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC50199B;
	Wed, 14 Jun 2023 04:10:25 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4f63ab1ac4aso8268012e87.0;
        Wed, 14 Jun 2023 04:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686741023; x=1689333023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bVmEOXEjwmudHUkRx4Y0SQYham7m2mb1hbXq7ueWQ90=;
        b=GuXyeq/ZCE9MhXJwHaWCuWsgLkXG93L9d6GXawE2FHYdiTmBtfvve6d7JWIx2DrM8I
         PGQrlhc+5xG4hf4qO5+A4nubZ+kAXstzRfvmhFE5nPLRNih9FAsO7xEM6MFgsePAYsV1
         psUuEDfk8AQPkFRZKEr0rYtn1jrpAx3o6WbwqhiiiTBqqmGbk46hEuMMlywNvBUNAvrS
         caYboT6I5CbygCrSZVn99ovMJF9r0OSIOGiZzZiBy4tN6S9uSt9wjTtF0wcCEO4U3IyU
         TB8ENfsrJsQVmejMrfSyffBlZ8br2/NJtC7JJOgaWeKqK9Y1BsabvtQog2jJtlKS4dNa
         d+iQ==
X-Gm-Message-State: AC+VfDyKZ2/LUoz2w+Eh4x1stE+/oBqO1mV3iXcSkCjPqW2xuvhy0qmu
	OA2ld4sPc+HnDYWCGrsJKUguLOnpu2ZyMQ==
X-Google-Smtp-Source: ACHHUZ4rnVKCvf3QnEMYouypeeGamJpIVkfUH1vY/5ugedGI4ZicXO0wiXf7mvAOD9N1/VgQ2IedLQ==
X-Received: by 2002:a19:ab02:0:b0:4f6:3000:94a0 with SMTP id u2-20020a19ab02000000b004f6300094a0mr6630041lfe.61.1686741023155;
        Wed, 14 Jun 2023 04:10:23 -0700 (PDT)
Received: from localhost (fwdproxy-cln-013.fbsv.net. [2a03:2880:31ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c230800b003f7ed9dae70sm17145918wmo.0.2023.06.14.04.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 04:10:22 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
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
Subject: [RFC PATCH v2 2/4] net: add uring_cmd callback to UDP
Date: Wed, 14 Jun 2023 04:07:55 -0700
Message-Id: <20230614110757.3689731-3-leitao@debian.org>
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

This is the implementation of uring_cmd for the UDP protocol. It
basically encompasses SOCKET_URING_OP_SIOCOUTQ and
SOCKET_URING_OP_SIOCINQ, which is the io_uring representation for
SIOCOUTQ and SIOCINQ.

SIOCINQ and SIOCOUTQ are the only two CMDs handled by udp_ioctl().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/net/udp.h        |  2 ++
 include/uapi/linux/net.h |  5 +++++
 net/ipv4/udp.c           | 22 ++++++++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index 10d94a42117b..046ca7231d27 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -285,6 +285,8 @@ int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
 void udp4_hwcsum(struct sk_buff *skb, __be32 src, __be32 dst);
 int udp_rcv(struct sk_buff *skb);
 int udp_ioctl(struct sock *sk, int cmd, int *karg);
+int udp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags);
 int udp_init_sock(struct sock *sk);
 int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 int __udp_disconnect(struct sock *sk, int flags);
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
index 6a09757f287b..5e06b6de1c08 100644
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
@@ -1687,6 +1688,26 @@ static int first_packet_length(struct sock *sk)
 	return res;
 }
 
+int udp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags)
+{
+	int ret;
+
+	switch (cmd->sqe->cmd_op) {
+	case SOCKET_URING_OP_SIOCINQ:
+		if (udp_ioctl(sk, SIOCINQ, &ret))
+			return -EFAULT;
+		return ret;
+	case SOCKET_URING_OP_SIOCOUTQ:
+		if (udp_ioctl(sk, SIOCOUTQ, &ret))
+			return -EFAULT;
+		return ret;
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL_GPL(udp_uring_cmd);
+
 /*
  *	IOCTL requests applicable to the UDP protocol
  */
@@ -2925,6 +2946,7 @@ struct proto udp_prot = {
 	.connect		= ip4_datagram_connect,
 	.disconnect		= udp_disconnect,
 	.ioctl			= udp_ioctl,
+	.uring_cmd		= udp_uring_cmd,
 	.init			= udp_init_sock,
 	.destroy		= udp_destroy_sock,
 	.setsockopt		= udp_setsockopt,
-- 
2.34.1


