Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8506D9B02
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbjDFOqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239436AbjDFOqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:46:23 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E073B747;
        Thu,  6 Apr 2023 07:45:19 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso3639289wmo.0;
        Thu, 06 Apr 2023 07:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680792238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/E+V5ftFxihSr5OwTsP6mRvxZ0E7DUpfGVsbz2Q5J9s=;
        b=Heuf53frOnWj2vnEAdeLh528Qc+H4OuPe7T/yRLFykciqUSrY8Ofc/58Kdla1Y44Uz
         BAKI1CadIz93t50hCDLnuQ0lx82mJ2Ksz+0fozrtVEIePEz/Fq10R2IDDMtoC2Q70BMF
         81i4E2Jzc3iD4nClUwFIcjBMNFMBqzKE7JpFT53v39yIy529b2gAuZoWidf4DReEt4im
         kZ36KpwqlTZFomSLg1dqPSzyY3QoBzOl+YF5m9ibT57fPdhHQx35gAUlcosidioLwn4N
         Z/K5y8/RH7eMZO4RxYlY6x1QBgXVX4RxX0DSrn27selwVSIvvCOqeRmqudxYCY7hx5M/
         4DOA==
X-Gm-Message-State: AAQBX9d9Ij3IboppBa4JuxNyo3ENOgGpI9JjmKBR/SZ0dfyR+eMO0rXS
        bZGuuC2qDAJKqQJ22AupgA3oFL6PwjknLA==
X-Google-Smtp-Source: AKy350boXoaX2U+68b5W1nhQ1K2p9mO1JGBZo+3g2JbcFKZDQ8rkzAlnAxX6lWaojVTpVA42zxtfYg==
X-Received: by 2002:a1c:7515:0:b0:3ea:ed4d:38f6 with SMTP id o21-20020a1c7515000000b003eaed4d38f6mr7398933wmc.4.1680792238142;
        Thu, 06 Apr 2023 07:43:58 -0700 (PDT)
Received: from localhost (fwdproxy-cln-020.fbsv.net. [2a03:2880:31ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id jb10-20020a05600c54ea00b003ede2c4701dsm5430687wmb.14.2023.04.06.07.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 07:43:57 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        asml.silence@gmail.com, axboe@kernel.dk
Cc:     leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        willemdebruijn.kernel@gmail.com, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
Subject: [RFC PATCH 3/4] net: add uring_cmd callback to TCP
Date:   Thu,  6 Apr 2023 07:43:29 -0700
Message-Id: <20230406144330.1932798-4-leitao@debian.org>
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

This is the implementation of uring_cmd for the TCP protocol. It
basically encompasses SOCKET_URING_OP_SIOCOUTQ and
SOCKET_URING_OP_SIOCINQ, which is similar to the SIOCOUTQ and SIOCINQ
ioctls.

The return value is exactly the same as the regular ioctl (tcp_ioctl()).

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/net/tcp.h   |  2 ++
 net/ipv4/tcp.c      | 32 ++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c |  1 +
 3 files changed, 35 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index db9f828e9d1e..4dfd6bd63261 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -342,6 +342,8 @@ void tcp_release_cb(struct sock *sk);
 void tcp_wfree(struct sk_buff *skb);
 void tcp_write_timer_handler(struct sock *sk);
 void tcp_delack_timer_handler(struct sock *sk);
+int tcp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags);
 int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg);
 int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb);
 void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 288693981b00..cf2822242e28 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -279,6 +279,7 @@
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
 #include <net/busy_poll.h>
+#include <linux/io_uring.h>
 
 /* Track pending CMSGs. */
 enum {
@@ -596,6 +597,37 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 }
 EXPORT_SYMBOL(tcp_poll);
 
+int tcp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	bool slow;
+	int ret;
+
+	switch (cmd->sqe->cmd_op) {
+	case SOCKET_URING_OP_SIOCINQ:
+		if (sk->sk_state == TCP_LISTEN)
+			return -EINVAL;
+
+		slow = lock_sock_fast(sk);
+		ret = tcp_inq(sk);
+		unlock_sock_fast(sk, slow);
+		return ret;
+	case SOCKET_URING_OP_SIOCOUTQ:
+		if (sk->sk_state == TCP_LISTEN)
+			return -EINVAL;
+
+		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
+			ret = 0;
+		else
+			ret = READ_ONCE(tp->write_seq) - tp->snd_una;
+		return ret;
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL_GPL(tcp_uring_cmd);
+
 int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ea370afa70ed..900081fa2e1a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3103,6 +3103,7 @@ struct proto tcp_prot = {
 	.disconnect		= tcp_disconnect,
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
+	.uring_cmd		= tcp_uring_cmd,
 	.init			= tcp_v4_init_sock,
 	.destroy		= tcp_v4_destroy_sock,
 	.shutdown		= tcp_shutdown,
-- 
2.34.1

