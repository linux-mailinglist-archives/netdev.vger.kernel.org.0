Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405D7129ACA
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfLWUUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:20:18 -0500
Received: from mail-qv1-f73.google.com ([209.85.219.73]:39601 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfLWUUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:20:18 -0500
Received: by mail-qv1-f73.google.com with SMTP id e14so193059qvr.6
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Anzi+1t6PcAe6iqhvZbFZ2mRDmg10rGxXywKXYDuhag=;
        b=phmjhBuvPBMuOIwKWhN5JioctAae16AAMKL1HPclnsQxzHLlgkOUqPDQaFt3FGgGnf
         pfGKxf4pz0lTwr+5NX14Qfd+QglhT6tN/9haMxGgqXXY1p6pyNM0F6ipqtwSJlP8JmOp
         5adFMTf1pxgJ1n9npzx2UFrr9ZAk1wgAuBR/XwN4ntCyrjyPqGRqGas5AYet1E0DrqIf
         dQ6kWjz37sglueDWSG1zFhDsYVdKzJkDkuNPP73Qm0CdipxEzCDuPXg7WXQOMCI9t9yB
         wd5c4YQXWlKIP+ajgTOVNzV1PIK5tYAF7FtPHxxT14uvKpBp2rxap2UiOiVpF0QBOqpZ
         uvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Anzi+1t6PcAe6iqhvZbFZ2mRDmg10rGxXywKXYDuhag=;
        b=dIufSdHBCq3+vX+Yh+n0u3KMdL+2dqS4+EOggtEu6NftsyFUa6n6OPkyqAs6/U/sKB
         Ul5Agso0ud1y8VJiNNWVvV4AiXBWqAVd/qW7UNlczQhAK6JGhAVscQj9x9a3I/PEdKMv
         r/tv4+5TWJrIz3zsZQChOdccBsKXFRZcTPekDocuBuzeS0nkkFooz1Wt5KvFNnWOkNwk
         0iEBZm0LcDpZwY3WXDQzAWlPFmtsrE6Nk9eMuKC24aFgxEzsyQ9MwST7tmCbw0kObmj5
         1N3ESI5ZztbvmSf2+C6wVldJndKkr2dZ0t47sIkQzw5dyC6iYert7+HzWRKFpoDb4An1
         qeoA==
X-Gm-Message-State: APjAAAVyFICkCQlLEzeKZI7S6uDpxET6ghsmuV+eR48IDoA/DY6+GG0b
        ckU5iUfgZgY2r5BwcXYDHe7JguVyTvH83g==
X-Google-Smtp-Source: APXvYqxUFWorS1qzz+CNTVsUM/ihjcLh5OflFPdrEyz5sKKtaIU6JtS036HqLonMGRWhrZyB9l7diCfiC/w9gA==
X-Received: by 2002:ac8:1851:: with SMTP id n17mr25262908qtk.305.1577132415916;
 Mon, 23 Dec 2019 12:20:15 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:20:02 -0800
In-Reply-To: <20191223202005.104713-1-edumazet@google.com>
Message-Id: <20191223202005.104713-3-edumazet@google.com>
Mime-Version: 1.0
References: <20191223202005.104713-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next 2/5] tcp_cubic: remove one conditional from hystart_update()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we initialize ca->curr_rtt to ~0U, we do not need to test
for zero value in hystart_update()

We only read ca->curr_rtt if at least HYSTART_MIN_SAMPLES have
been processed, and thus ca->curr_rtt will have a sane value.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_cubic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 297936033c335ee57ba6205de50c5ef06b90da60..5eff762acd7fe1510eb39fc789b488de8ca648de 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -133,7 +133,7 @@ static inline void bictcp_hystart_reset(struct sock *sk)
 
 	ca->round_start = ca->last_ack = bictcp_clock();
 	ca->end_seq = tp->snd_nxt;
-	ca->curr_rtt = 0;
+	ca->curr_rtt = ~0U;
 	ca->sample_cnt = 0;
 }
 
@@ -402,7 +402,7 @@ static void hystart_update(struct sock *sk, u32 delay)
 	if (hystart_detect & HYSTART_DELAY) {
 		/* obtain the minimum delay of more than sampling packets */
 		if (ca->sample_cnt < HYSTART_MIN_SAMPLES) {
-			if (ca->curr_rtt == 0 || ca->curr_rtt > delay)
+			if (ca->curr_rtt > delay)
 				ca->curr_rtt = delay;
 
 			ca->sample_cnt++;
-- 
2.24.1.735.g03f4e72817-goog

