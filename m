Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386D66D53E4
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbjDCVrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbjDCVrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:47:10 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99504C0C
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:46:48 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id x5-20020a05622a000500b003e259c363f9so20714498qtw.22
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680558405;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mMe32NgYiZFo0joF6FuwLDLBtTH02CPQ27OIH9lg5qk=;
        b=OHZx/MIpAAhOAoBfyKUVxQKnpKyMti9RFLo8JSuJohHNCBg60BIl27SbhGkKIVeyj4
         mb/DwKCWt27q4myiVJLXOV3Ycc0gdJeiQi5iJHoulrfZz//I6ir4jDZvhWVctmlcimlF
         sP9ZlEvkGP6BHge70IFiijrDS1D8J6ZlfbIyQL/qSH+27/a7RNN1QGVJR4aXYKOHx6Tx
         NsJLMNYAJs8ZX+w+6mHh8Y6zUZkHI6IgPRglV1P4q008HGBdP/aviO0fZIIYTImhHu/F
         SRICtqVp5X2655JtVe4dNSSf80Dw/HRwLoO6/tnIhCtap4oKAkQCaq7SWQss5SpqKXmO
         ev0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680558405;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mMe32NgYiZFo0joF6FuwLDLBtTH02CPQ27OIH9lg5qk=;
        b=296bnQUnJYiTlanu3jkjWx3F0rMp1M6f7CNTemdio6vqBMkahNWdVMURlnIY+pUfOJ
         9YlkLc7CV1dX0swtz+VqZ6b1udcXcBaUpaS86iHadQU4yHLB2GohDrw2R7WCWzRScW5X
         CjvuE+hOMD3iGfXfpnXucmW+PQXgObwSQdACsda/DNmwGufe+RwMNFaMhJo2Agr2J2vY
         aveskwyIyj2sTgTsJICXqeoAa6FCYqdwAOb8+V3YYDqaafWYnhHoo3M2/4z57GslqnbH
         RQmJY5bbEQCyJ6nfmW2/aCy0npbzQmyqt5FX44UVhSDX9YuY2H3pG5U50NBiLlEudtwf
         guKg==
X-Gm-Message-State: AAQBX9e9SixgRRcZ5eMoJccC5CzSaqTntmxY/AqdzjjD1xrNGkZQg8KH
        gSBOlOIcQtoS9lFN8GoAVd3kTB40cNw8sw==
X-Google-Smtp-Source: AKy350b2eUC/PruHGiM4bYjBG/snKd/Hh5/Mu+ZOiT70GMkjnzMWwfjTzKtpg+Zel6t0qB3BYUYDv60uo9G5Ag==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:622a:1a84:b0:3de:bafb:82b0 with SMTP
 id s4-20020a05622a1a8400b003debafb82b0mr17653qtc.6.1680558405121; Mon, 03 Apr
 2023 14:46:45 -0700 (PDT)
Date:   Mon,  3 Apr 2023 21:46:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230403214643.768555-1-edumazet@google.com>
Subject: [PATCH net] netlink: annotate lockless accesses to nlk->max_recvmsg_len
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a data-race in data-race in netlink_recvmsg() [1]

Indeed, netlink_recvmsg() can be run concurrently,
and netlink_dump() also needs protection.

[1]
BUG: KCSAN: data-race in netlink_recvmsg / netlink_recvmsg

read to 0xffff888141840b38 of 8 bytes by task 23057 on cpu 0:
netlink_recvmsg+0xea/0x730 net/netlink/af_netlink.c:1988
sock_recvmsg_nosec net/socket.c:1017 [inline]
sock_recvmsg net/socket.c:1038 [inline]
__sys_recvfrom+0x1ee/0x2e0 net/socket.c:2194
__do_sys_recvfrom net/socket.c:2212 [inline]
__se_sys_recvfrom net/socket.c:2208 [inline]
__x64_sys_recvfrom+0x78/0x90 net/socket.c:2208
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

write to 0xffff888141840b38 of 8 bytes by task 23037 on cpu 1:
netlink_recvmsg+0x114/0x730 net/netlink/af_netlink.c:1989
sock_recvmsg_nosec net/socket.c:1017 [inline]
sock_recvmsg net/socket.c:1038 [inline]
____sys_recvmsg+0x156/0x310 net/socket.c:2720
___sys_recvmsg net/socket.c:2762 [inline]
do_recvmmsg+0x2e5/0x710 net/socket.c:2856
__sys_recvmmsg net/socket.c:2935 [inline]
__do_sys_recvmmsg net/socket.c:2958 [inline]
__se_sys_recvmmsg net/socket.c:2951 [inline]
__x64_sys_recvmmsg+0xe2/0x160 net/socket.c:2951
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x0000000000000000 -> 0x0000000000001000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 23037 Comm: syz-executor.2 Not tainted 6.3.0-rc4-syzkaller-00195-g5a57b48fdfcb #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023

Fixes: 9063e21fb026 ("netlink: autosize skb lengthes")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netlink/af_netlink.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c6427765975318b4c7fe3d5291dc4d69988f5249..f365dfdd672d7576b02bd5ae2871cf317e879248 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1952,7 +1952,7 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	struct scm_cookie scm;
 	struct sock *sk = sock->sk;
 	struct netlink_sock *nlk = nlk_sk(sk);
-	size_t copied;
+	size_t copied, max_recvmsg_len;
 	struct sk_buff *skb, *data_skb;
 	int err, ret;
 
@@ -1985,9 +1985,10 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 #endif
 
 	/* Record the max length of recvmsg() calls for future allocations */
-	nlk->max_recvmsg_len = max(nlk->max_recvmsg_len, len);
-	nlk->max_recvmsg_len = min_t(size_t, nlk->max_recvmsg_len,
-				     SKB_WITH_OVERHEAD(32768));
+	max_recvmsg_len = max(READ_ONCE(nlk->max_recvmsg_len), len);
+	max_recvmsg_len = min_t(size_t, max_recvmsg_len,
+				SKB_WITH_OVERHEAD(32768));
+	WRITE_ONCE(nlk->max_recvmsg_len, max_recvmsg_len);
 
 	copied = data_skb->len;
 	if (len < copied) {
@@ -2236,6 +2237,7 @@ static int netlink_dump(struct sock *sk)
 	struct netlink_ext_ack extack = {};
 	struct netlink_callback *cb;
 	struct sk_buff *skb = NULL;
+	size_t max_recvmsg_len;
 	struct module *module;
 	int err = -ENOBUFS;
 	int alloc_min_size;
@@ -2258,8 +2260,9 @@ static int netlink_dump(struct sock *sk)
 	cb = &nlk->cb;
 	alloc_min_size = max_t(int, cb->min_dump_alloc, NLMSG_GOODSIZE);
 
-	if (alloc_min_size < nlk->max_recvmsg_len) {
-		alloc_size = nlk->max_recvmsg_len;
+	max_recvmsg_len = READ_ONCE(nlk->max_recvmsg_len);
+	if (alloc_min_size < max_recvmsg_len) {
+		alloc_size = max_recvmsg_len;
 		skb = alloc_skb(alloc_size,
 				(GFP_KERNEL & ~__GFP_DIRECT_RECLAIM) |
 				__GFP_NOWARN | __GFP_NORETRY);
-- 
2.40.0.348.gf938b09366-goog

