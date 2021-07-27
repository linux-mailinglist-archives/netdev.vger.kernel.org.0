Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE2E3D78AE
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbhG0OnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbhG0OnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 10:43:14 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA034C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:43:14 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so11827437qkd.0
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HI9N3kwYafXDHt7eo8Df3ukt9WAl+1iGr81tB1AijR4=;
        b=IDIkLC9BElF1WDlvqxLqYrkeT7qCpZkwBxBWf6cG3n5eqKPbbHvTMQ/AcG6dQjSLIz
         r0P2FYRkpkLOxd2MSQhhkQO4ykzWxdBm+6OX5RIILPxnuNxz9sfgz7VlPnN2qSaUmwgn
         Rbpgoh/KOmXutDfk/zBwrIVRKRwvs1G7hkiebUG7Lq4vAZyEqYgnuePbMamHTe3+luh/
         ln2+sk58A5l6aVhd3a8h+Cq3LBwJHqetamhiNoge0kEU6GiLEIgHmWDTouQcP5gIYDHa
         Jj1fmB6/eaxVuy9XK22/IK0uizf6qEoe6toganoWbsTjsDmJ/AVrvbiO64ZeG9Um6LMc
         7GzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HI9N3kwYafXDHt7eo8Df3ukt9WAl+1iGr81tB1AijR4=;
        b=hIjOY0BOXosIwhG7KqPX3MvuRQTHjuhhN49DoqYwwyee8yJaWH1jeh9y8amwEyBrIU
         WjHWVvJSWMqRWvUll5smXHJ+hwUCOmoYrAVSQin/tE72V5iK+8Yw5z9ExfY6VHkqOzEs
         kDdk8ap9pSIXjLCt8j7YWluoOqNA8/7BSkrNvjRl8ZECFTN0zOQnF12zJo2lxH9p+Vzp
         Usy88yo0ZoHMSS1wQ22jRgkT0VEMKvRmqsZgDM5m5wwDezPiYRSNiBoctnXrpBPxOWHY
         NPKb5LMoKMmEDy2knO06RmZjYduwSPHynqnCay1xXk0yM+q3qJC6IDreYuSd9IGmfKwk
         0JvQ==
X-Gm-Message-State: AOAM533kn8vmSys2efyScEmXd3hg9xxlrGY6juTZj3+QiJ3Cp2Jsz0Hv
        Av8Qu2vgS8a805fLkwB150Efu+oEXWq6fOA=
X-Google-Smtp-Source: ABdhPJxUy+iJxWguA9nCaRrjz8W9+yl0QjyAiEWIEQu6awFSE3ik1vPGu7zdHQPGfZQ3+ppSrPfcK0sA4pyTp3g=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:17c3:cd0f:c07d:756a])
 (user=ncardwell job=sendgmr) by 2002:a0c:ed21:: with SMTP id
 u1mr9249963qvq.6.1627396993908; Tue, 27 Jul 2021 07:43:13 -0700 (PDT)
Date:   Tue, 27 Jul 2021 10:42:57 -0400
In-Reply-To: <20210727144258.946533-1-ncardwell@google.com>
Message-Id: <20210727144258.946533-2-ncardwell@google.com>
Mime-Version: 1.0
References: <20210727144258.946533-1-ncardwell@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH net-next 1/2] tcp: more accurately detect spurious TLP probes
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Priyaranjan Jha <priyarjha@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

Previously TLP is considered spurious if the sender receives any
DSACK during a TLP episode. This patch further checks the DSACK
sequences match the TLP's to improve accuracy.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Priyaranjan Jha <priyarjha@google.com>
---
 net/ipv4/tcp_input.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 501d8d4d4ba4..98408d520c32 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -100,6 +100,7 @@ int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 #define FLAG_UPDATE_TS_RECENT	0x4000 /* tcp_replace_ts_recent() */
 #define FLAG_NO_CHALLENGE_ACK	0x8000 /* do not call tcp_send_challenge_ack()	*/
 #define FLAG_ACK_MAYBE_DELAYED	0x10000 /* Likely a delayed ACK */
+#define FLAG_DSACK_TLP		0x20000 /* DSACK for tail loss probe */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
 #define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
@@ -991,6 +992,8 @@ static u32 tcp_dsack_seen(struct tcp_sock *tp, u32 start_seq,
 		return 0;
 	if (seq_len > tp->mss_cache)
 		dup_segs = DIV_ROUND_UP(seq_len, tp->mss_cache);
+	else if (tp->tlp_high_seq && tp->tlp_high_seq == end_seq)
+		state->flag |= FLAG_DSACK_TLP;
 
 	tp->dsack_dups += dup_segs;
 	/* Skip the DSACK if dup segs weren't retransmitted by sender */
@@ -3650,7 +3653,7 @@ static void tcp_process_tlp_ack(struct sock *sk, u32 ack, int flag)
 	if (!tp->tlp_retrans) {
 		/* TLP of new data has been acknowledged */
 		tp->tlp_high_seq = 0;
-	} else if (flag & FLAG_DSACKING_ACK) {
+	} else if (flag & FLAG_DSACK_TLP) {
 		/* This DSACK means original and TLP probe arrived; no loss */
 		tp->tlp_high_seq = 0;
 	} else if (after(ack, tp->tlp_high_seq)) {
-- 
2.32.0.432.gabb21c7263-goog

