Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A865032F8
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiDPAOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiDPAN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:57 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417E54163A
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:27 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e8-20020a17090a118800b001cb13402ea2so9463521pja.0
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VFPB/o/p02yEpoXVsNv474y8sumijZGgXHbx6Fsoz20=;
        b=Kybh6ZK/VBSagT+7FD/wihHbyht6DSqd8yvB43FHAY6Mf460TUhcKpZyS0FKmRlqKt
         JuTdWTiwYdtRLZp5WukxFNoAW+SSuMzd2nyMI1yT2pXPtH9hujpwWttUaFuC83EfxqWq
         Gd9R92Hi61i+nj9COIL4fQMnw9DPw6gs6+gJUBlE0VCQl3r9QqeyAzE+fhCmtgPVOIGI
         kqp7QgJsJIqbefqVljIWYFVOzdYhf/msVBs2Vw8jBYigtxRqBNEUK3ZpzBuqP1jNqLiD
         3EVfyuTGVU4WgwEMdEE5geG9QTrnrmbZyRXVJ74sXFmxrIr+NdZyKvbbEpuy8ycpmOEt
         dq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VFPB/o/p02yEpoXVsNv474y8sumijZGgXHbx6Fsoz20=;
        b=A16bukj+UmFNsYHEBWg9h1kCwuq9NQqSJoBgJ5tqMKPUPFt1lvnqBjvXMzBQgvtytF
         58jYfFwYq5KAr0BYHmJsLQJELC11fDw6EO0YTDsvk+mVSm3RflGCTEX26kla3uRMEbF4
         cHTwKKT2RV3aY1VOydmRb25e7/GnuPE8W3FzxaK4e54dXD2cUJXr190gYH4aXbXYKHLy
         UEh2O/UxREQuB8g6LW+F2/BgBi42T4VIVWHR4tau8/Cv1xhUAV94Cj/R6UW/kntmE5wz
         o1Hkz/WJSJqpV8xl1XXWZYe4rAa2i5qYfihjLF8YxfWx8XzxmLjDu+ogsp7tqzYo/Ydp
         WhkA==
X-Gm-Message-State: AOAM532lj7eZ1JCiWY1iG1HqSvoX2+CmCmMgt7EWT6P1pHzn6FvCH+tv
        ERdUdS/QPhPCAih5Cd8asYyON8XRfdg=
X-Google-Smtp-Source: ABdhPJwrbKAbpq4FBP2fihXnNpRnvzBoWnxuMONmjhrKu7FuurJmGb/ndknnMWrritArJ4hGtGLf0A==
X-Received: by 2002:a17:902:f68e:b0:154:6518:69ba with SMTP id l14-20020a170902f68e00b00154651869bamr1479430plg.60.1650067886585;
        Fri, 15 Apr 2022 17:11:26 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:26 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 09/10] tcp: add drop reasons to tcp_rcv_synsent_state_process()
Date:   Fri, 15 Apr 2022 17:10:47 -0700
Message-Id: <20220416001048.2218911-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220416001048.2218911-1-eric.dumazet@gmail.com>
References: <20220416001048.2218911-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Re-use existing reasons.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cd9f5c39f85a042751ef78132860a2a6cc96bccc..339cc3d40745a0ea2a9f66b03dfda5aa6800d4a2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6144,6 +6144,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 	struct tcp_fastopen_cookie foc = { .len = -1 };
 	int saved_clamp = tp->rx_opt.mss_clamp;
 	bool fastopen_fail;
+	SKB_DR(reason);
 
 	tcp_parse_options(sock_net(sk), skb, &tp->rx_opt, 0, &foc);
 	if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr)
@@ -6198,9 +6199,10 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 *    See note below!
 		 *                                        --ANK(990513)
 		 */
-		if (!th->syn)
+		if (!th->syn) {
+			SKB_DR_SET(reason, TCP_FLAGS);
 			goto discard_and_undo;
-
+		}
 		/* rfc793:
 		 *   "If the SYN bit is on ...
 		 *    are acceptable then ...
@@ -6291,15 +6293,16 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 *
 		 *      Otherwise (no ACK) drop the segment and return."
 		 */
-
+		SKB_DR_SET(reason, TCP_RESET);
 		goto discard_and_undo;
 	}
 
 	/* PAWS check. */
 	if (tp->rx_opt.ts_recent_stamp && tp->rx_opt.saw_tstamp &&
-	    tcp_paws_reject(&tp->rx_opt, 0))
+	    tcp_paws_reject(&tp->rx_opt, 0)) {
+		SKB_DR_SET(reason, TCP_RFC7323_PAWS);
 		goto discard_and_undo;
-
+	}
 	if (th->syn) {
 		/* We see SYN without ACK. It is attempt of
 		 * simultaneous connect with crossed SYNs.
@@ -6358,7 +6361,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 discard_and_undo:
 	tcp_clear_options(&tp->rx_opt);
 	tp->rx_opt.mss_clamp = saved_clamp;
-	tcp_drop(sk, skb);
+	tcp_drop_reason(sk, skb, reason);
 	return 0;
 
 reset_and_undo:
-- 
2.36.0.rc0.470.gd361397f0d-goog

