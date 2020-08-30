Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B21256E54
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 16:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgH3OEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 10:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgH3ODD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 10:03:03 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50E0C061573
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 07:03:02 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id q3so1785135pls.11
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 07:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gogqH3O9vhsiI/45w3wZ1pyMR2KXZsdUpUj6VC0K718=;
        b=JYT7gbemYrJ1MvDvXCX3yVUguoeExYT+wZ31Avg1Uc8996ukk2dqhiKEq/xbPzRbHZ
         tsEDb2inEpxkPWzZwh3WMOnI7D2c/IGQ9DAgdOksJwmJKU8DTGyeapeDzsEWbGC0QH8j
         ljBVlTrxupboikuVmXmvkqfT5/hT99d2Lm7pqm6pIwuGcK9Za99GKuJKPKDkva+FBBoO
         qY2z1drIvkdMvOdP0FWC3qa3wt0NJeC24vsAU9tVwxsji5lgckWipDpqsXykivKNk1lZ
         v4jMVCasvS941qgKZJq8UtGuIxdY/UBf19fHq0t9wUeIjkgCtXsuzZmHf4tUR+7BUdd+
         +8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gogqH3O9vhsiI/45w3wZ1pyMR2KXZsdUpUj6VC0K718=;
        b=rhSFEQm8nbFpbOymR7f6muBDcymzwPV0/bDUVw8XqIpmgfxuUyRE2CMSdKRn5quCpY
         z3jO+OXz93XW/Rlr9TPackc8bZ4w1JLBI79nn2w9N+dhXg9KNtmlg27PbMrLCMzyyJrT
         ksrUL+4HOgjZoa+dOlLblk8SJF3Rl/je2t7Px0aRh++BEGzbOBa1g/B4eQCueqLHA2kA
         6Yo4Z6AvNF/b1l/eAsuBSEMYWjS05SXOGLN1LImcAiXGPt8ZmndnIeEAM/8cdztJM9F0
         dB5Ff7GYF3fR5mgeWoP3v7r/U1ktgYjduSrHLpnMDZKV/o7psztpjxIc3Ot9ziGsn8B7
         Xx+Q==
X-Gm-Message-State: AOAM5331OEb3ZNYB5EBlPye/bXn2ZvrFhH42NfIVFSHphNFo6ntQDIce
        r3hGkAgY62JfUeYMI5NED4s=
X-Google-Smtp-Source: ABdhPJzaLf6uvdRzGgcmQs+gAvmNgR+Tts5bDwtAjnGCtAujOUXBklQhNkiWT/Oax2GedKYN9WNRqA==
X-Received: by 2002:a17:90a:b108:: with SMTP id z8mr6392083pjq.39.1598796179341;
        Sun, 30 Aug 2020 07:02:59 -0700 (PDT)
Received: from localhost.localdomain (fp9f1cad42.knge118.ap.nuro.jp. [159.28.173.66])
        by smtp.gmail.com with ESMTPSA id f4sm4631361pgi.49.2020.08.30.07.02.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Aug 2020 07:02:58 -0700 (PDT)
From:   Yutaro Hayakawa <yhayakawa3720@gmail.com>
X-Google-Original-From: Yutaro Hayakawa <yutaro.hayakawa@linecorp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, michio.honda@ed.ac.uk,
        Yutaro Hayakawa <yhayakawa3720@gmail.com>
Subject: [PATCH RFC v2 net-next] net/tls: Implement getsockopt SOL_TLS TLS_RX
Date:   Sun, 30 Aug 2020 23:01:49 +0900
Message-Id: <20200830140149.17949-1-yutaro.hayakawa@linecorp.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200828095223.21d07617@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200828095223.21d07617@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
---
Changes in v2:
- Remove duplicated memcpy for each cipher suites

Thanks for your reply. Reflected the comments.

 net/tls/tls_main.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index bbc52b0..0271441 100644
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
+	struct tls_cipher_context *cctx;
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
