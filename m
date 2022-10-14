Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4AA5FECE3
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 13:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJNLGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 07:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiJNLGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 07:06:42 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208221C39DF;
        Fri, 14 Oct 2022 04:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=FEOtHOKod45cEEdAf3PmBMSdvIeW+CVTTBby9gmVxkc=; b=XkQmoHvXyAlOOls0KlV22rS4pw
        7jAKWijxCS4aoLV4PzzH4BZBbEj77g01jApQKfZJmHwptIN5zH72zH/veD4rfHT+uCTWfpCrnTQIs
        2ey3U4vRCMuUeQh1gCrMA5lLvmKvazLJoMhLnDHQ296diWmTp9CfUF3eFfEWzIAOOYAjecxxKV11J
        zWNXgrMVARLofATeiNgBL8nfDNJyacbiIbuf4MD96bMRBbYwK+2ded+ZJjz/U34Y0vek43WYxIgWB
        xUtHeEybWIhiFwY+ZaYusajpONvrHDLSCTnQg5uSnzhaf8qah+MjnUV0ICRas6pYcJm2zYJAbDOw2
        ocjR8xX+2QWm0Y1e2kJ8jdRy9N1dA7xgPlop7VkCHNr8giYoO5QwNoh8fF3mAa1I3hxMGcb4TDZC1
        1uB+JLMbCYtgUiWAq4Qx3mz83Gb95IBfwWeWWfeFrlCzEw7bhNAlp0/JTqJnlKXHsiH3llYHf5eFY
        P2YHm/1aGc+UnyZ8qO4QtVb3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1ojIWS-004EIw-QV; Fri, 14 Oct 2022 11:06:36 +0000
Message-ID: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
Date:   Fri, 14 Oct 2022 13:06:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>
From:   Stefan Metzmacher <metze@samba.org>
Subject: IORING_CQE_F_COPIED
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

In the tests I made I used this version of IORING_CQE_F_COPIED:
https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=645d3b584c417a247d92d71baa6266a5f3d0d17d
(also inlined at the end)

Would that something we want for 6.1? (Should I post that with a useful commit message, after doing some more tests)

metze

  include/uapi/linux/io_uring.h | 1 +
  io_uring/notif.c              | 5 +++++
  net/ipv4/ip_output.c          | 3 ++-
  net/ipv4/tcp.c                | 2 ++
  net/ipv6/ip6_output.c         | 3 ++-
  5 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 04729989e6ee..efeab6a9b4f3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -341,6 +341,7 @@ struct io_uring_cqe {
  #define IORING_CQE_F_MORE		(1U << 1)
  #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
  #define IORING_CQE_F_NOTIF		(1U << 3)
+#define IORING_CQE_F_COPIED		(1U << 4)

  enum {
  	IORING_CQE_BUFFER_SHIFT		= 16,
diff --git a/io_uring/notif.c b/io_uring/notif.c
index e37c6569d82e..2162d1af0b60 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -18,6 +18,8 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
  		__io_unaccount_mem(ctx->user, nd->account_pages);
  		nd->account_pages = 0;
  	}
+	if (!nd->uarg.zerocopy)
+		notif->cqe.flags |= IORING_CQE_F_COPIED;
  	io_req_task_complete(notif, locked);
  }

@@ -28,6 +30,8 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
  	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
  	struct io_kiocb *notif = cmd_to_io_kiocb(nd);

+	uarg->zerocopy = uarg->zerocopy & success;
+
  	if (refcount_dec_and_test(&uarg->refcnt)) {
  		notif->io_task_work.func = __io_notif_complete_tw;
  		io_req_task_work_add(notif);
@@ -53,6 +57,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)

  	nd = io_notif_to_data(notif);
  	nd->account_pages = 0;
+	nd->uarg.zerocopy = 1;
  	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
  	nd->uarg.callback = io_uring_tx_zerocopy_callback;
  	refcount_set(&nd->uarg.refcnt, 1);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 04e2034f2f8e..64d263a8ece8 100644
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
index cdf26724d7db..d3a2ed9f22df 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1247,6 +1247,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
  			uarg = msg->msg_ubuf;
  			net_zcopy_get(uarg);
  			zc = sk->sk_route_caps & NETIF_F_SG;
+			if (!zc)
+				uarg->zerocopy = 0;
  		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
  			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
  			if (!uarg) {
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index bb0f469a5247..3d75dd05ff98 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1559,7 +1559,8 @@ static int __ip6_append_data(struct sock *sk,
  				paged = true;
  				zc = true;
  				uarg = msg->msg_ubuf;
-			}
+			} else
+				msg->msg_ubuf->zerocopy = 0;
  		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
  			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
  			if (!uarg)



