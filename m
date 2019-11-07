Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5A9F26B1
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 05:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733084AbfKGEwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 23:52:45 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:40952 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfKGEwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 23:52:45 -0500
Received: by mail-ua1-f73.google.com with SMTP id i7so386125uak.7
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 20:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1XoFM4cy2TSP8vA2jtERwbTlwFytidBJzPDR2ENaX6M=;
        b=FPJxi1aYjIQ1S0/A1jNtUCaWs+p/o4dQ1pcbrpTX/c5RqhOxX6/ATMRKk458dR9LrJ
         k7AdrHWP5wdIFZwUI0Ng9Zq/421ialogdh2wbaHLGvAJz5AEPkPkJhHFLedp3SHL/d3m
         KsGMfuHEULtkl+xOEyGJXOVlLK/ehHsMRBVP9pn99T1Tnv8oAqASl5QRd4VAank2Hx0I
         n4QV9/cwxTSMmTqR4GVb41uQ6FYj0JejYOVZls0nT/9DW0UIXhlBvqXB/3SZ/MgVQiJ7
         bQV5fEXPaKMyT3YpVnvYGi07vnxYAdUzFeamSTC3nBrx6TSEerrOtprK46J6WOuxp2av
         0iAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1XoFM4cy2TSP8vA2jtERwbTlwFytidBJzPDR2ENaX6M=;
        b=Bdze6t6IVPt2pxPOYSeRdmEF9gNzsNWxQL/BOzfz7/aY9rsCWExjmBL/TqSwApALRl
         qUiTYcRp3yH0JVUDFvWsyx8p9z3Q3zocNbAPOWM9FBcpJlvmCwUaPV0gJXBS0zcthZPM
         h5LQ/tmdlz5ySZ92+U3tNvBx66X5LCPAcr1rlt5OIF8lG4MwN3c9d4TvfzOmOHkVNdWS
         A07R4r9HdmFVnIqDT6AuhjYDmuFctSLXA6QgOS+8yKnThkFzf2VqBm31G1UdJ6QxBrMr
         17qqvtgTxlhV2g1GwRE64UEvCfL8krzEzL4H2xTpUw/vMaYNRsKFKdRg9PBt+YJJnmqj
         pU4Q==
X-Gm-Message-State: APjAAAXZAi2Srhi78vbSFaGB/DDbtXaXii1GHxemEKz86AIf2SLiHxIw
        3CmBPra5FSOr1K2VCcPTyuVU5Spgl8vyPw==
X-Google-Smtp-Source: APXvYqzIHtDn6oGRqdHEn4sdxFpwsvZTDdLzf3Ip/p1Z2JvzvZY5+R2gWh1X6+X1ydJwSr2dnnbQUvflXKxu7Q==
X-Received: by 2002:a05:6102:318e:: with SMTP id c14mr1313209vsh.45.1573102364492;
 Wed, 06 Nov 2019 20:52:44 -0800 (PST)
Date:   Wed,  6 Nov 2019 20:52:40 -0800
Message-Id: <20191107045240.211090-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] net_sched: gen_estimator: extend packet counter to 64bit
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I forgot to change last_packets field in struct net_rate_estimator.

Without this fix, rate estimators would misbehave after more
than 2^32 packets have been sent.

Another solution would be to be careful and only use the
32 least significant bits of packets counters, but we have
a hole in net_rate_estimator structure and this looks
easier to read/maintain.

Fixes: d0083d98f685 ("net_sched: extend packet counter to 64bit")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/gen_estimator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index bfe7bdd4c3406a40e3b53b0b6c8260112691582e..80dbf2f4016e26824bc968115503ca2072933f63 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -48,7 +48,7 @@ struct net_rate_estimator {
 	u8			intvl_log; /* period : (250ms << intvl_log) */
 
 	seqcount_t		seq;
-	u32			last_packets;
+	u64			last_packets;
 	u64			last_bytes;
 
 	u64			avpps;
@@ -83,7 +83,7 @@ static void est_timer(struct timer_list *t)
 	brate = (b.bytes - est->last_bytes) << (10 - est->ewma_log - est->intvl_log);
 	brate -= (est->avbps >> est->ewma_log);
 
-	rate = (u64)(b.packets - est->last_packets) << (10 - est->ewma_log - est->intvl_log);
+	rate = (b.packets - est->last_packets) << (10 - est->ewma_log - est->intvl_log);
 	rate -= (est->avpps >> est->ewma_log);
 
 	write_seqcount_begin(&est->seq);
-- 
2.24.0.432.g9d3f5f5b63-goog

