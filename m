Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E1A258FCB
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgIAOGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgIAOAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:00:24 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87938C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 07:00:17 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d22so838839pfn.5
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 07:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8+JqP9S6aHTiD7tv7K45L0JvJv6lCxRwbyRlDuj0FJY=;
        b=UP/MM039bLg4QWmxqUCxkbmZRxT1BWnmO/2UCW668wtfsSrBQUzurpNHs/xlNNEfM7
         KxCimPUFnX664jv/yQ2Ewfv5tZBm7XhLVjuoasAWdWHEQkRneqI6SQpv6ajI/a1jsAQj
         w6sPMHYi/h09Zd7LtwOE0NUMr/7iAoCBq95JRs6JU1MhFDyCEDIqFxPO+UonjU0GXbNs
         vEQxsDEvn7qnIo+bpFrzSdEHTp1aZ71vQG9IrIJKFO3itTREFW1rBWeD5M37EInw0oya
         MjEbIk3p/AJMtnHalzodqIVqFOU7yO0fEirVQENM6UgXyNsSdzuVG2dAJQH42Gl20O+i
         nk2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8+JqP9S6aHTiD7tv7K45L0JvJv6lCxRwbyRlDuj0FJY=;
        b=eKsIPW1syokXCdCbkJSlJgZsd+WtD+rklIc6/pmy2z6j7757r3U6vPfIVgEoOT7N5N
         BPYNBzqG6ur803nSjk4BhsvCkAFP8A+/3NaPZTpynexlPYdSzS6GKZJnRp3wwaizz4Ha
         3ZutW1UgUst+TYs50kM6MxEzMUbpUuCezE9VKa/+sXXpRDDMTS6Hk/8UvqAhRP4qlia1
         b8B7uSNWp23Vzl8MCOLTWyBJlUbYoTGxNcMu44RKgEHVX2tWVu6Sg/Cfn4mNUTu7D77l
         DZeeKbIfxUs8T33GsbDRYgxThg1/IagcjS6BEyyJgmcKFx02y6zBa7ufuY6h+UEEanz4
         o3PA==
X-Gm-Message-State: AOAM533E4fOS0f6sA7Q968CcTayMfjjw7LEdtx3AjZgbWPMtXBFOEflT
        RCoxAj+KApZTY1nwZiPPws8=
X-Google-Smtp-Source: ABdhPJyy5oKLHG3h+XnkoeTOVpwiGFCi9/+w4iBHDL7ML9gzNFlvMN1/RulIrvoQVLr4hBbbkmGDzQ==
X-Received: by 2002:a65:58c9:: with SMTP id e9mr1629975pgu.66.1598968816884;
        Tue, 01 Sep 2020 07:00:16 -0700 (PDT)
Received: from localhost.localdomain (fp9f1cad42.knge118.ap.nuro.jp. [159.28.173.66])
        by smtp.gmail.com with ESMTPSA id s23sm1663914pjr.7.2020.09.01.07.00.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 07:00:16 -0700 (PDT)
From:   Yutaro Hayakawa <yhayakawa3720@gmail.com>
X-Google-Original-From: Yutaro Hayakawa <yutaro.hayakawa@linecorp.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>, michio.honda@ed.ac.uk,
        netdev@vger.kernel.org, Yutaro Hayakawa <yhayakawa3720@gmail.com>
Subject: [PATCH net-next] net/tls: Implement getsockopt SOL_TLS TLS_RX
Date:   Tue,  1 Sep 2020 22:59:45 +0900
Message-Id: <20200901135945.57072-1-yutaro.hayakawa@linecorp.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200831113010.0107dc5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200831113010.0107dc5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yutaro Hayakawa <yhayakawa3720@gmail.com>

Implement the getsockopt SOL_TLS TLS_RX which is currently missing. The
primary usecase is to use it in conjunction with TCP_REPAIR to
checkpoint/restore the TLS record layer state.

TLS connection state usually exists on the user space library. So
basically we can easily extract it from there, but when the TLS
connections are delegated to the kTLS, it is not the case. We need to
have a way to extract the TLS state from the kernel for both of TX and
RX side.

The new TLS_RX getsockopt copies the crypto_info to user in the same
way as TLS_TX does.

We have described use cases in our research work in Netdev 0x14
Transport Workshop [1].

Also, there is an TLS implementation called tlse [2] which supports
TLS connection migration. They have support of kTLS and their code
shows that they are expecting the future support of this option.

[1] https://speakerdeck.com/yutarohayakawa/prism-proxies-without-the-pain
[2] https://github.com/eduardsui/tlse

Signed-off-by: Yutaro Hayakawa <yhayakawa3720@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_main.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index bbc52b0..002b085 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -330,12 +330,13 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 		tls_ctx_free(sk, ctx);
 }

-static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
-				int __user *optlen)
+static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
+				  int __user *optlen, int tx)
 {
 	int rc = 0;
 	struct tls_context *ctx = tls_get_ctx(sk);
 	struct tls_crypto_info *crypto_info;
+	struct cipher_context *cctx;
 	int len;

 	if (get_user(len, optlen))
@@ -352,7 +353,13 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 	}

 	/* get user crypto info */
-	crypto_info = &ctx->crypto_send.info;
+	if (tx) {
+		crypto_info = &ctx->crypto_send.info;
+		cctx = &ctx->tx;
+	} else {
+		crypto_info = &ctx->crypto_recv.info;
+		cctx = &ctx->rx;
+	}

 	if (!TLS_CRYPTO_INFO_READY(crypto_info)) {
 		rc = -EBUSY;
@@ -379,9 +386,9 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 		}
 		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_128->iv,
-		       ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
+		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
-		memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
+		memcpy(crypto_info_aes_gcm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
 		release_sock(sk);
 		if (copy_to_user(optval,
@@ -403,9 +410,9 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 		}
 		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_256->iv,
-		       ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
+		       cctx->iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
-		memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
+		memcpy(crypto_info_aes_gcm_256->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
 		release_sock(sk);
 		if (copy_to_user(optval,
@@ -429,7 +436,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,

 	switch (optname) {
 	case TLS_TX:
-		rc = do_tls_getsockopt_tx(sk, optval, optlen);
+	case TLS_RX:
+		rc = do_tls_getsockopt_conf(sk, optval, optlen,
+					    optname == TLS_TX);
 		break;
 	default:
 		rc = -ENOPROTOOPT;
--
1.8.3.1
