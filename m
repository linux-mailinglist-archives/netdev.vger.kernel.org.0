Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0ADE5032FA
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbiDPAOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344642AbiDPANy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:54 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF03944757
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:24 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so9442087pjb.1
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hyYI31OehZRxF2H7hGB/TdSjORPpzBCzrIj/L2J8n/Q=;
        b=Rw8f1WJLYfkd0hC8RIfS4HdzpFRPvMVNl/Ke3deLI8fA7NRDz0e7ZeZK/lgPN6C6L3
         3d5NlNSuda4/aI0JEJafWuGXK64Gmx5Jb+wX2upr7AajAi8v4+N5R5TkkjDKtCzrQH5j
         SQSwpJNGp/KHkbMZCxyE7j3iiQFEWmyTL5VDJ/KQ3I8ID8yd/3gIwbhrv8jgaFYcF+Iw
         UkWusElS6Ey+IVsUxWBeP393v9NGC1G9+yAoPMJ2ppo0/lA6sc1gbu6+OfHEa2GnIHBu
         6Eq9ODrfNUCweQKNzLC1vFsvlx3/8Z/NsoHrGI8qNJmXca2rVrwC24adz6tUri/34hw3
         N6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hyYI31OehZRxF2H7hGB/TdSjORPpzBCzrIj/L2J8n/Q=;
        b=kmmTnTGgpFYp+ucSH67tdmMdxQk7pz2DV2L7tq2YnhHO9wE98MHY8EvERMQ/bVYkh2
         sVvwUe2BVxTnA8x0DQ1QK5EbhWjDGQDk+27SCfwWfhn46OxlWNAyjkc/yn0o7Hx6Y3Bo
         o4KCy0RrvMZfRRrWsceKRZFO1skNIzHTPzwNO0kfh2D0Hgcs0yu63uZnnbkVbxKIrljc
         n+VJVl7lf0RzFBHTjoh1mJuMvMBcT6Qf4MPU80ls0llHYEmoAjqhxW3CyRAAeZAUwZhW
         5GoXb8o4du6nzYfYrzimuKJOYIJIUwBzrzCGJtqvCHdTCpJw/i+JMuqCc7UG8xDBH+0S
         avSA==
X-Gm-Message-State: AOAM533x9kt+vdrwUkvx9jDRQONd8fXs7SmAuNHYu1+okBNxFIuYmh1S
        VAuOkUvXCcFd40ueqI37Bq4=
X-Google-Smtp-Source: ABdhPJwgcne68sLyvVsbZ43x0VQkGwSnqqgQjL/7Zdhv7OccBGchkJDfil50eStmAheIfQnrzvhERg==
X-Received: by 2002:a17:903:240c:b0:153:c8df:7207 with SMTP id e12-20020a170903240c00b00153c8df7207mr1366617plo.44.1650067884438;
        Fri, 15 Apr 2022 17:11:24 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:24 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 08/10] tcp: make tcp_rcv_synsent_state_process() drop monitor friend
Date:   Fri, 15 Apr 2022 17:10:46 -0700
Message-Id: <20220416001048.2218911-9-eric.dumazet@gmail.com>
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

1) A valid RST packet should be consumed, to not confuse drop monitor.

2) Same remark for packet validating cross syn setup,
   even if we might ignore part of it.

3) When third packet of 3WHS is delayed, do not pretend
   the SYNACK was dropped.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a1077adeb1b62d74b5f1c9a6fc34def44ae07790..cd9f5c39f85a042751ef78132860a2a6cc96bccc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6186,7 +6186,9 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 
 		if (th->rst) {
 			tcp_reset(sk, skb);
-			goto discard;
+consume:
+			__kfree_skb(skb);
+			return 0;
 		}
 
 		/* rfc793:
@@ -6275,13 +6277,9 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 			inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK,
 						  TCP_DELACK_MAX, TCP_RTO_MAX);
-
-discard:
-			tcp_drop(sk, skb);
-			return 0;
-		} else {
-			tcp_send_ack(sk);
+			goto consume;
 		}
+		tcp_send_ack(sk);
 		return -1;
 	}
 
@@ -6350,7 +6348,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 */
 		return -1;
 #else
-		goto discard;
+		goto consume;
 #endif
 	}
 	/* "fifth, if neither of the SYN or RST bits is set then
@@ -6360,7 +6358,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 discard_and_undo:
 	tcp_clear_options(&tp->rx_opt);
 	tp->rx_opt.mss_clamp = saved_clamp;
-	goto discard;
+	tcp_drop(sk, skb);
+	return 0;
 
 reset_and_undo:
 	tcp_clear_options(&tp->rx_opt);
-- 
2.36.0.rc0.470.gd361397f0d-goog

