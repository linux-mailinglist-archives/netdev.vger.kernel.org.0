Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C011454B6
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAVNFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:05:55 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41411 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgAVNFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:05:54 -0500
Received: by mail-lj1-f195.google.com with SMTP id h23so6709890ljc.8
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 05:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1WPgC+WzLyR0JTgO+VoeJbEDZ15TC0NlN7bHnmyGW2I=;
        b=guUnHF+b2XBtTH80NV9Ugt2prah8RfD9ICvqdTf6wYRCuFDHcqP241kWxkjWqlXKBy
         Gfk/P3WFa9x/4ComwvOktW1SbE9E/GkbEC0L8yPM7TmXmXS/9pBGdydfSQkqjty7D1we
         yCA3YGL4Xxr+HtnJiErSR8EyzgSgPM2K43yHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1WPgC+WzLyR0JTgO+VoeJbEDZ15TC0NlN7bHnmyGW2I=;
        b=oTuMszjFrKNHAvIl8ErMvZxq4ZcjvsXl/Pc5SOJXHSbksZwt3uH61XjTxY3+guIK87
         PO3ee2iqI/1yPSOmip30PUH6QNNqio1t/PShctBldonDhZ+OLamg22XesvDm+qo7lFwu
         dEJS7Oy3KbMlrI9468OO8IsR46NrGAxuyLd1QYczJZrXOz32D1oxeBwUSbydmdtBiOIq
         K2WZ9aZ08i6M9OcwdLA93NV1qRz9SnMWHgbsL5ObXfb51qK5wryhUmSiCVcMtSI5gEoX
         Clfw2tB2Fdcu2JdF59R0H/rnYkXoMbUuGDKn7s0XJQsa+RI+VZFztU/VOsM06j9u3Lz/
         kfvQ==
X-Gm-Message-State: APjAAAUNS61a1wrjXpop07H+qwvjNXCazkDRkI6Z5HOdIlrT+zVv5z9j
        deAQN4K39mB10kH61Jca4+Z9ug==
X-Google-Smtp-Source: APXvYqyM4b6klmHamWkPtjgtRzdMuQUoo5aDxQZglSZXnjldZxqa13QD2wdP7ZvSpwlOQrpdqlOzuA==
X-Received: by 2002:a2e:9e19:: with SMTP id e25mr3889597ljk.179.1579698352823;
        Wed, 22 Jan 2020 05:05:52 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n30sm24529109lfi.54.2020.01.22.05.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:05:52 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v3 01/12] bpf, sk_msg: Don't clear saved sock proto on restore
Date:   Wed, 22 Jan 2020 14:05:38 +0100
Message-Id: <20200122130549.832236-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122130549.832236-1-jakub@cloudflare.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to clear psock->sk_proto when restoring socket protocol
callbacks in sk->sk_prot. The psock is about to get detached from the sock
and eventually destroyed. At worst we will restore the protocol callbacks
twice.

This makes reasoning about psock state easier. Once psock is initialized,
we can count on psock->sk_proto always being set.

Also, we don't need a fallback for when socket is not using ULP.
tcp_update_ulp already does this for us.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/skmsg.h | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index ef7031f8a304..41ea1258d15e 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -359,17 +359,7 @@ static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
 	sk->sk_write_space = psock->saved_write_space;
-
-	if (psock->sk_proto) {
-		struct inet_connection_sock *icsk = inet_csk(sk);
-		bool has_ulp = !!icsk->icsk_ulp_data;
-
-		if (has_ulp)
-			tcp_update_ulp(sk, psock->sk_proto);
-		else
-			sk->sk_prot = psock->sk_proto;
-		psock->sk_proto = NULL;
-	}
+	tcp_update_ulp(sk, psock->sk_proto);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
-- 
2.24.1

