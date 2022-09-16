Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF33D5BB408
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 23:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiIPVkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 17:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiIPVka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 17:40:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C382F009;
        Fri, 16 Sep 2022 14:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=7/bK9/j4+KDJ0CqnTjC8j/mEzvOMjp40NmmYbeModGU=; b=gV+hgdr99PEWfLxDGTYE1h9OWC
        vnCZRE1zKY1SatyZ7/7QlQlBeVCD4GTuVrbBmCNbNJlUuLzdysxcnCUWdu8U5L2jgAQUnkneYvJXn
        SFW6eTsYyuEDz6PY5hco0+AkXIvaCj7QptHJa9tZRzXc+8qnDXLGh+37/98HSgXpW8qrrwCB/dQ+j
        ZXG9nKnMpqge3h1MMYILkkG6qinSYIcSe5PrcSiN4qV1WsuCjvO+pWt2x/9ulUdkTzqcs5eanHVaB
        A2MXiV+tOpbxCQ+12ZGejd/1gtbKPfAu50wxcF524tS2k536825AVq5RT+duzjtXBDwWLdlTHFyO+
        ZEncZ+e4a9x0Hu6lbGEY6WGZ/TfVyPRvhK8SnEWdFzyNMZ9F7xAjRThjJ1IiYUK+MXxx5ppGQ7GdG
        H3MSAxB0olFfIQv41MlWtdEYyI5We7zp4nP2x2Rfu8Isx0VnNluQ+tVO5oN7685KOgL60Dx66A67l
        QEVB2EgQ2qBxStGPtU8fk6Dn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oZJ4T-000j7f-KT; Fri, 16 Sep 2022 21:40:26 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     Stefan Metzmacher <metze@samba.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 5/5] io_uring/notif: let userspace know how effective the zero copy usage was
Date:   Fri, 16 Sep 2022 23:36:29 +0200
Message-Id: <76cdd53f618e2793e1ec298c837bb17c3b9f12ee.1663363798.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663363798.git.metze@samba.org>
References: <cover.1663363798.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 2nd cqe for IORING_OP_SEND_ZC has IORING_CQE_F_NOTIF set in cqe->flags
and it will now have the number of successful completed
io_uring_tx_zerocopy_callback() callbacks in the lower 31-bits
of cqe->res, the high bit (0x80000000) is set when
io_uring_tx_zerocopy_callback() was called with success=false.

If cqe->res is still 0, zero copy wasn't used at all.

These values give userspace a change to adjust its strategy
choosing IORING_OP_SEND_ZC or IORING_OP_SEND. And it's a bit
richer than just a simple SO_EE_CODE_ZEROCOPY_COPIED indication.

Fixes: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")
Fixes: eb315a7d1396b ("tcp: support externally provided ubufs")
Fixes: 1fd3ae8c906c0 ("ipv6/udp: support externally provided ubufs")
Fixes: c445f31b3cfaa ("ipv4/udp: support externally provided ubufs")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 io_uring/notif.c      | 18 ++++++++++++++++++
 net/ipv4/ip_output.c  |  3 ++-
 net/ipv4/tcp.c        |  2 ++
 net/ipv6/ip6_output.c |  3 ++-
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index e37c6569d82e..b07d2a049931 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -28,7 +28,24 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
 	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
 
+	uarg->zerocopy = uarg->zerocopy & success;
+
+	if (success && notif->cqe.res < S32_MAX)
+		notif->cqe.res++;
+
 	if (refcount_dec_and_test(&uarg->refcnt)) {
+		/*
+		 * If we hit at least one case that
+		 * was not able to use zero copy,
+		 * we set the high bit 0x80000000
+		 * so that notif->cqe.res < 0, means it was
+		 * as least copied once.
+		 *
+		 * The other 31 bits are the success count.
+		 */
+		if (!uarg->zerocopy)
+			notif->cqe.res |= S32_MIN;
+
 		notif->io_task_work.func = __io_notif_complete_tw;
 		io_req_task_work_add(notif);
 	}
@@ -53,6 +70,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 
 	nd = io_notif_to_data(notif);
 	nd->account_pages = 0;
+	nd->uarg.zerocopy = 1;
 	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	nd->uarg.callback = io_uring_tx_zerocopy_callback;
 	refcount_set(&nd->uarg.refcnt, 1);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d7bd1daf022b..4bdea7a4b2f7 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1032,7 +1032,8 @@ static int __ip_append_data(struct sock *sk,
 				paged = true;
 				zc = true;
 				uarg = msg->msg_ubuf;
-			}
+			} else
+				msg->msg_ubuf->zerocopy = 0;
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
 			if (!uarg)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 970e9a2cca4a..27a22d470741 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1231,6 +1231,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			uarg = msg->msg_ubuf;
 			net_zcopy_get(uarg);
 			zc = sk->sk_route_caps & NETIF_F_SG;
+			if (!zc)
+				uarg->zerocopy = 0;
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
 			if (!uarg) {
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f152e51242cb..d85036e91cf7 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1556,7 +1556,8 @@ static int __ip6_append_data(struct sock *sk,
 				paged = true;
 				zc = true;
 				uarg = msg->msg_ubuf;
-			}
+			} else
+				msg->msg_ubuf->zerocopy = 0;
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
 			if (!uarg)
-- 
2.34.1

