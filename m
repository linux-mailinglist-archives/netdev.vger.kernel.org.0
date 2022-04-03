Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEB34F0993
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245645AbiDCNKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236847AbiDCNKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:07 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AAE2714E
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:12 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id u16so10665489wru.4
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r6mHSY3rMp/h+hhho43L4evOYkmu9O/j90Xx3k1ptBQ=;
        b=B0eFqH01T/qQ/h0E9kkmFYGzyvqYzGGrzEXr7jAFfgWvJZFosPjM5+xMgsygUValhr
         9poJ34IhNAt/NZrSJMzlDChqR8AQUlc9gFWrVC09QjskR0YMvhXs/ONEpHMceQJcPCLT
         BS+flwvKjqpZrcg1d/rsn1ZRQ6+hz/cG7SX7g0CqPIU4/OxbH3BwcYToKUfG3UAoI1Ow
         OV1U4mTX67khDao3xARGoSrMgpuW9TQsmPoFSa7YXayoPphdmCAfd2so2LOY8x29QCgv
         a0RaJ6AhcXsBM4zEqX93WVu6QOIfo6bf/xyXJBs+ZRlUCAONZtzixohaa/XIESOSoQtp
         ggGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r6mHSY3rMp/h+hhho43L4evOYkmu9O/j90Xx3k1ptBQ=;
        b=SaUd6QlAGFCl4hwk8zjbnLa2qwN6SZmAHsBU1XFK8onV7AjLgvhvA6nSBf33vUB8I9
         VdMsuq9TKSZb6cRYITRd8jXtXSrs8Ja6UxJ5W0+K6tjJ/mU3bbp+If69LqWApb84Aii/
         OP44BZaqCg25Fm5GTPPAZPTY/ZK00W96TX7kah8HQn1/5A/lK5XcaYFx9JIzJ4vdjD/M
         MdYQsc9uslbbEw+YrHKaXkDvI8M2HTPSURv31n9aqUebs/YY4TTM8tjCtFXOUh3Aeneu
         XvrKH+BAk5uIsG52Qwb8QR0UJKx9BjLAHUMOA19ar7SNBCo524U+0BswWHrLzO/VJR8d
         Vslw==
X-Gm-Message-State: AOAM531bLIyLkikLbAZru1sg3pkpNhZjS4Duwx6WPgNPk6H4CrCqYQr3
        OkA2nqIAGZk5TxDhM/bY9E67qcgqBko=
X-Google-Smtp-Source: ABdhPJxiHQYGdnx7eepEY9TOiLoaiDVWu9PJjMboNxMBZK56LDymHRhpQvkNJ9B+WprdpTrkgDJbAg==
X-Received: by 2002:adf:dd49:0:b0:206:ce4:a004 with SMTP id u9-20020adfdd49000000b002060ce4a004mr2604472wrm.161.1648991291057;
        Sun, 03 Apr 2022 06:08:11 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 01/27] sock: deduplicate ->sk_wmem_alloc check
Date:   Sun,  3 Apr 2022 14:06:13 +0100
Message-Id: <2ba680102bcbdb9f0165aef89c41a43c9ada03c6.1648981570.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main ->sk_wmem_alloc check in sock_def_write_space() almost
completely repeats sock_writeable() apart from small differences like
rounding, so we should be able to replace the first check and remove
extra sock_writeable().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/sock.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 1180a0cb0110..f5766d6e27cb 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3174,15 +3174,14 @@ static void sock_def_write_space(struct sock *sk)
 	/* Do not wake up a writer until he can make "significant"
 	 * progress.  --DaveM
 	 */
-	if ((refcount_read(&sk->sk_wmem_alloc) << 1) <= READ_ONCE(sk->sk_sndbuf)) {
+	if (sock_writeable(sk)) {
 		wq = rcu_dereference(sk->sk_wq);
 		if (skwq_has_sleeper(wq))
 			wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
 						EPOLLWRNORM | EPOLLWRBAND);
 
 		/* Should agree with poll, otherwise some programs break */
-		if (sock_writeable(sk))
-			sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
+		sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
 	}
 
 	rcu_read_unlock();
-- 
2.35.1

