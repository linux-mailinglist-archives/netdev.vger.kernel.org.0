Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C6F5EF778
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiI2OZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235618AbiI2OZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:25:17 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA96936799
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:25:12 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id x18so915940qkn.6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=pD2Cm1YcPe3A/HeCfmz0z4zv9VRB8dQ8QJi/u9e1DVo=;
        b=mizBwoE6oBAaFR4HejgmbY+1hsZza9E5dpFzJWpmLzh8W4cPm1YIsDD6A28QqkJHUd
         SGUouRMME0uGOqR1DQrzss6aPG6XNn1mQ0gR/ivVlZfbz9HluhZO4QGRxmwbSEbBuAMF
         4TOidKD9NFmEz9+nrm8uwymKiuA9Lj/h8mTKMXSR5Tg7zDGk3E8gb7Dhl85gtjcnYGTV
         Svy0/DcoXvhoADj5xnkgsuH0mcvpREnKDYxl8FvUOLAZeSrGyteVzU007fCr09FsykBr
         tlTapo990vKiKGNehmBcUmJqd+D2zB6DWrrP1Uz6JKcs2iVICPUmqrP6zcxT92k4LynF
         UZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pD2Cm1YcPe3A/HeCfmz0z4zv9VRB8dQ8QJi/u9e1DVo=;
        b=s5WJat0CFkOOmsgWsISQk3sUdi4rf9rTYMwrE9r7p2RXmI8n45FItg65oEbzRuuB9K
         2aR963U0Y8F7T4b+IM/h0FWeasyJniBQ1SantxXuCEjJkzmMt77u5XuBZp5A6fHZ1V7K
         j913bg9qudPc9+UvvFeL/3ztgqP7wDzLdTNWAFg/Elta8MJGs9mSeoVc39SddwvRomIz
         g4D0si45F7tLXKcnAAeajVTa0HMPzuiMAU638zPDoH19RYyJLe43s5hFKdktLrc4GJTy
         CNrlk+T7gA+aYXHaKXyYJdey5m7kck8NsMZ+MyOSC3wD2mu6BuywniU7wYxvlJpHEqB7
         bHtA==
X-Gm-Message-State: ACrzQf3/4FWyTNw9hMxPHyFnjEda8RtzSYHBYXyPSiFKpA0i0PzHm38X
        2pkOME4/nGBj2g3M8FF7FRMVbvnHdlY=
X-Google-Smtp-Source: AMsMyM43oM8T8l795xb/pZv0Xj1wOq5FBlbcB3UDv+XdKlJupB+a/lzIdTvgQwSVWRZI3Xg1iekBaQ==
X-Received: by 2002:a05:620a:410b:b0:6ce:1edb:35f6 with SMTP id j11-20020a05620a410b00b006ce1edb35f6mr2389291qko.313.1664461511423;
        Thu, 29 Sep 2022 07:25:11 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id z21-20020ac87f95000000b00342f8984348sm5889952qtj.87.2022.09.29.07.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 07:25:11 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 3/5] tcp: add support for PLB in DCTCP
Date:   Thu, 29 Sep 2022 14:24:45 +0000
Message-Id: <20220929142447.3821638-4-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220929142447.3821638-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mubashir Adnan Qureshi <mubashirq@google.com>

PLB support is added to TCP DCTCP code. As DCTCP uses ECN as the
congestion signal, PLB also uses ECN to make decisions whether to change
the path or not upon sustained congestion.

Signed-off-by: Mubashir Adnan Qureshi <mubashirq@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_dctcp.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 2a6c0dd665a4..e0a2ca7456ff 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -54,6 +54,7 @@ struct dctcp {
 	u32 next_seq;
 	u32 ce_state;
 	u32 loss_cwnd;
+	struct tcp_plb_state plb;
 };
 
 static unsigned int dctcp_shift_g __read_mostly = 4; /* g = 1/2^4 */
@@ -91,6 +92,8 @@ static void dctcp_init(struct sock *sk)
 		ca->ce_state = 0;
 
 		dctcp_reset(tp, ca);
+		tcp_plb_init(sk, &ca->plb);
+
 		return;
 	}
 
@@ -117,14 +120,28 @@ static void dctcp_update_alpha(struct sock *sk, u32 flags)
 
 	/* Expired RTT */
 	if (!before(tp->snd_una, ca->next_seq)) {
+		u32 delivered = tp->delivered - ca->old_delivered;
 		u32 delivered_ce = tp->delivered_ce - ca->old_delivered_ce;
 		u32 alpha = ca->dctcp_alpha;
+		u32 ce_ratio = 0;
+
+		if (delivered > 0) {
+			/* dctcp_alpha keeps EWMA of fraction of ECN marked
+			 * packets. Because of EWMA smoothing, PLB reaction can
+			 * be slow so we use ce_ratio which is an instantaneous
+			 * measure of congestion. ce_ratio is the fraction of
+			 * ECN marked packets in the previous RTT.
+			 */
+			if (delivered_ce > 0)
+				ce_ratio = (delivered_ce << TCP_PLB_SCALE) / delivered;
+			tcp_plb_update_state(sk, &ca->plb, (int)ce_ratio);
+			tcp_plb_check_rehash(sk, &ca->plb);
+		}
 
 		/* alpha = (1 - g) * alpha + g * F */
 
 		alpha -= min_not_zero(alpha, alpha >> dctcp_shift_g);
 		if (delivered_ce) {
-			u32 delivered = tp->delivered - ca->old_delivered;
 
 			/* If dctcp_shift_g == 1, a 32bit value would overflow
 			 * after 8 M packets.
@@ -172,8 +189,12 @@ static void dctcp_cwnd_event(struct sock *sk, enum tcp_ca_event ev)
 		dctcp_ece_ack_update(sk, ev, &ca->prior_rcv_nxt, &ca->ce_state);
 		break;
 	case CA_EVENT_LOSS:
+		tcp_plb_update_state_upon_rto(sk, &ca->plb);
 		dctcp_react_to_loss(sk);
 		break;
+	case CA_EVENT_TX_START:
+		tcp_plb_check_rehash(sk, &ca->plb); /* Maybe rehash when inflight is 0 */
+		break;
 	default:
 		/* Don't care for the rest. */
 		break;
-- 
2.37.3.998.g577e59143f-goog

