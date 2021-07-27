Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C165E3D78AF
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbhG0OnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbhG0OnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 10:43:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CAEC061765
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:43:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q15-20020a25820f0000b029055bb0981111so18874915ybk.7
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X5GzPacoqmWKcqolIjhaSXxM8jBfub27LM1N+/rMMVY=;
        b=jCKNusFnZu02ZlaDcqBKQ11iF5dMjjeWPe48DHMuVs9+UXsP4aZuS5obbdnCua9bJa
         D08EoS3VvrVcvSEzm6ZbgTxGYOKpTyaI310Afaku2CqmeTOhVNxNheAqmVnTKLZ/noI4
         1E/TJ6ibkVRIvoB+m199ZDh3nc7psvJVyeW3uhEGdv7DqfuH/z60lkEtKWPQ8P9rCysO
         FuEgCdTtCznmoPY7Osx4GuZLBg+yqAS7bEhbn9trzfJQdq3Q+ZU8E2h58oBH0an89JfH
         JgYXQhcTPIzVh3XHHwQA5RLM9nrRKOGWGkdyGLU51C9krrDwngr5udzNSSGD8UJexazv
         Jjxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X5GzPacoqmWKcqolIjhaSXxM8jBfub27LM1N+/rMMVY=;
        b=qfr2ibbNpIyagCiAFMONLyTTPAfJhLcgi7xfbuSIA+xl/d/JoHs4IxewepHi9cblOg
         bU02Z07+CIJx1E2ke6/Y8kKtUyiU42BgSfswh4fTrnuhsMCK8saGzbiwMy+Po6fltuAP
         DL20FOWvRXhurQZqSYDfoZeF3quj6SGYlddhfVswjA+SEdpCLHJi5J37e13eYvroBc3/
         Xsh5Cr4vfnVyj3kxCXLrmeMY6XcVQo5mDi/txWSwB9WAGfScWIjJerQoGpWLSo9NsK80
         UwVHMsVCVByHyOHGeGW8vmvoOUNzFrZJFYb54OMeg83MR4q/0xiJ9BEhA94KRbtch2KX
         pCSg==
X-Gm-Message-State: AOAM532rG1pcOaZnBQr2yqv12jofhCUO54Xy02UZuew/ubM8qOd8YDcw
        IRs+97hDyfdfH1ipUvXEfs0ywOU4e85Ib60=
X-Google-Smtp-Source: ABdhPJwYGERG+GvnroqR0NBpl0KX0NHNRSd0jMW4+UTIrvv/a17ZP+qTEOf5E0mD9h18qtSe9d9NtngttLDWLSk=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:17c3:cd0f:c07d:756a])
 (user=ncardwell job=sendgmr) by 2002:a25:7ec4:: with SMTP id
 z187mr32046100ybc.136.1627396996434; Tue, 27 Jul 2021 07:43:16 -0700 (PDT)
Date:   Tue, 27 Jul 2021 10:42:58 -0400
In-Reply-To: <20210727144258.946533-1-ncardwell@google.com>
Message-Id: <20210727144258.946533-3-ncardwell@google.com>
Mime-Version: 1.0
References: <20210727144258.946533-1-ncardwell@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH net-next 2/2] tcp: more accurately check DSACKs to grow RACK
 reordering window
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Priyaranjan Jha <priyarjha@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, a DSACK could expand the RACK reordering window when no
reordering has been seen, and/or when the DSACK was due to an
unnecessary TLP retransmit (rather than a spurious fast recovery due
to reordering). This could result in unnecessarily growing the RACK
reordering window and thus unnecessarily delaying RACK-based fast
recovery episodes.

To avoid these issues, this commit tightens the conditions under which
a DSACK triggers the RACK reordering window to grow, so that a
connection only expands its RACK reordering window if:

(a) reordering has been seen in the connection
(b) a DSACKed range does not match the most recent TLP retransmit

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Priyaranjan Jha <priyarjha@google.com>
---
 net/ipv4/tcp_input.c    | 9 ++++++++-
 net/ipv4/tcp_recovery.c | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 98408d520c32..3f7bd7ae7d7a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1001,7 +1001,14 @@ static u32 tcp_dsack_seen(struct tcp_sock *tp, u32 start_seq,
 		return 0;
 
 	tp->rx_opt.sack_ok |= TCP_DSACK_SEEN;
-	tp->rack.dsack_seen = 1;
+	/* We increase the RACK ordering window in rounds where we receive
+	 * DSACKs that may have been due to reordering causing RACK to trigger
+	 * a spurious fast recovery. Thus RACK ignores DSACKs that happen
+	 * without having seen reordering, or that match TLP probes (TLP
+	 * is timer-driven, not triggered by RACK).
+	 */
+	if (tp->reord_seen && !(state->flag & FLAG_DSACK_TLP))
+		tp->rack.dsack_seen = 1;
 
 	state->flag |= FLAG_DSACKING_ACK;
 	/* A spurious retransmission is delivered */
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index 6f1b4ac7fe99..fd113f6226ef 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -172,7 +172,8 @@ void tcp_rack_reo_timeout(struct sock *sk)
 
 /* Updates the RACK's reo_wnd based on DSACK and no. of recoveries.
  *
- * If DSACK is received, increment reo_wnd by min_rtt/4 (upper bounded
+ * If a DSACK is received that seems like it may have been due to reordering
+ * triggering fast recovery, increment reo_wnd by min_rtt/4 (upper bounded
  * by srtt), since there is possibility that spurious retransmission was
  * due to reordering delay longer than reo_wnd.
  *
-- 
2.32.0.432.gabb21c7263-goog

