Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E45552470
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 21:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245192AbiFTTOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 15:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241978AbiFTTN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 15:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2A315812;
        Mon, 20 Jun 2022 12:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81614615F5;
        Mon, 20 Jun 2022 19:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F67C341C5;
        Mon, 20 Jun 2022 19:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655752437;
        bh=fm216QCe5GtCFE+IohJi5m9T+OdkW82eZrUFigAy+Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouzVqjh1TZH3xr/NNWbbr3MY/i8NLDmg/lKSfIP5XK318L0eaDzEzo9VC5qBvSWfW
         Os5e365YCd/PFdW/o7xQaqOzYzY057idJU8LZDATBe76Pyh/4A0bKAo4GwTVFW9npc
         ptTiz+dDr5+bbHP6gWYC86L+ve4ikbx6GyRWPrzNs9lhXQXRRaMmpLShKAvBrmzYRi
         hKHCLCMiE7iWCykmxoEdD4jZ2oA7XNS4OPbo9UBlIJ1tSRhgB6FHRBPt8DD6irDj4c
         I+DReSPE7gB0RhEcKtxdp6k97aJ/uank34WsZ2FuCL7Xc1RXjeNsxII4N94pkqV0DV
         9Ui0K3lshymPQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, john.fastabend@gmail.com,
        jakub@cloudflare.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, borisp@nvidia.com, cong.wang@bytedance.com,
        bpf@vger.kernel.org
Subject: [PATCH net 2/2] sock: redo the psock vs ULP protection check
Date:   Mon, 20 Jun 2022 12:13:53 -0700
Message-Id: <20220620191353.1184629-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620191353.1184629-1-kuba@kernel.org>
References: <20220620191353.1184629-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
has moved the inet_csk_has_ulp(sk) check from sk_psock_init() to
the new tcp_bpf_update_proto() function. I'm guessing that this
was done to allow creating psocks for non-inet sockets.

Unfortunately the destruction path for psock includes the ULP
unwind, so we need to fail the sk_psock_init() itself.
Otherwise if ULP is already present we'll notice that later,
and call tcp_update_ulp() with the sk_proto of the ULP
itself, which will most likely result in the ULP looping
its callbacks.

Fixes: 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: john.fastabend@gmail.com
CC: jakub@cloudflare.com
CC: yoshfuji@linux-ipv6.org
CC: dsahern@kernel.org
CC: ast@kernel.org
CC: daniel@iogearbox.net
CC: andrii@kernel.org
CC: kafai@fb.com
CC: songliubraving@fb.com
CC: yhs@fb.com
CC: kpsingh@kernel.org
CC: borisp@nvidia.com
CC: cong.wang@bytedance.com
CC: bpf@vger.kernel.org
---
 include/net/inet_sock.h | 5 +++++
 net/core/skmsg.c        | 5 +++++
 net/ipv4/tcp_bpf.c      | 3 ---
 net/tls/tls_main.c      | 2 ++
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index c1b5dcd6597c..daead5fb389a 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -253,6 +253,11 @@ struct inet_sock {
 #define IP_CMSG_CHECKSUM	BIT(7)
 #define IP_CMSG_RECVFRAGSIZE	BIT(8)
 
+static inline bool sk_is_inet(struct sock *sk)
+{
+	return sk->sk_family == AF_INET || sk->sk_family == AF_INET6;
+}
+
 /**
  * sk_to_full_sk - Access to a full socket
  * @sk: pointer to a socket
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 22b983ade0e7..b0fcd0200e84 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -699,6 +699,11 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 
 	write_lock_bh(&sk->sk_callback_lock);
 
+	if (sk_is_inet(sk) && inet_csk_has_ulp(sk)) {
+		psock = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
 	if (sk->sk_user_data) {
 		psock = ERR_PTR(-EBUSY);
 		goto out;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index be3947e70fec..0d3f68bb51c0 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -611,9 +611,6 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 		return 0;
 	}
 
-	if (inet_csk_has_ulp(sk))
-		return -EINVAL;
-
 	if (sk->sk_family == AF_INET6) {
 		if (tcp_bpf_assert_proto_ops(psock->sk_proto))
 			return -EINVAL;
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index da176411c1b5..2ffede463e4a 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -921,6 +921,8 @@ static void tls_update(struct sock *sk, struct proto *p,
 {
 	struct tls_context *ctx;
 
+	WARN_ON_ONCE(sk->sk_prot == p);
+
 	ctx = tls_get_ctx(sk);
 	if (likely(ctx)) {
 		ctx->sk_write_space = write_space;
-- 
2.36.1

