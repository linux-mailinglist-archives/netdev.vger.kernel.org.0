Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E2D129AD6
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfLWU2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:28:06 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:54834 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfLWU2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:28:05 -0500
Received: by mail-pf1-f201.google.com with SMTP id v14so12419052pfm.21
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Anzi+1t6PcAe6iqhvZbFZ2mRDmg10rGxXywKXYDuhag=;
        b=OZL4q8mB/gAa1VPayZ4NZ80WmStRaBP31541n8n33k9HWuXtRVq74BEwfVb9zl2+2F
         n1JXkA8F/q6w36tg7Grefol9ufj6mFinCmlGGe1e7ieYO8p69r2VQ/Y88KYshls8OU5i
         IwJPEGbD/f4ZpFDjMiM56thEhk8AwXadZB2VQ5N77oEw3CU3BFYgNSXFnPrer89gLE0l
         Y/hIPf4dKmg97AeWaIk5g1jonG51eJK0sdsC3XTvdtky4decRIM9vbpa2aCPE51gMM+R
         sPbmOvJBFiH0MLoai76nQWChjDEyyvFFmQlT9g69gF6hSFx1a22qu7RhVM6JKGN0RI8r
         hNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Anzi+1t6PcAe6iqhvZbFZ2mRDmg10rGxXywKXYDuhag=;
        b=i6bQ2ATgaUljUPVmZlGl4MF3U1pU/P6iyZpksa/oLFtvyJU+ak9VB3R5QkM3xF6Y1e
         eyoZBYjtEN+TEL38kZsxk6mzxilHiSKHhc6+Gpt3j7JPptD0syHl5sE32VTuoLJoV3Ih
         r+lxCScpjRxvdbhX1Zklrp5ZynBdFy3pDr4aDYGjx1VOjJsao0pNyibk9PhhaOPJw3aq
         /BVx9Z1TaGmDsISAxVeLOURHunfaNTHgsGyErqcmKCNnq/17//eq44AoeOVuKTq7wqko
         RuH0iDO8myJXjx55qfyR/pDfQ9asee9Xbd/3FTWks+3VA6nx7vfV8sazbXR7pbqLJvaB
         98+A==
X-Gm-Message-State: APjAAAUj0wOoSFVin58/dMoD7EwBwsmE/4iQsw1+uRrBFM8O2wEJ271k
        +EfO4/+IZanz/bo8FgTi7yQo9aYi74lriw==
X-Google-Smtp-Source: APXvYqwBFzLwwYLSB9xDJQz4ug1b+zwL1AqpULLp3rUXNzjkNkn4JFztb02gOmFb22nlh/B83dTVPWfUt0c3dA==
X-Received: by 2002:a65:5bc3:: with SMTP id o3mr32613346pgr.226.1577132884374;
 Mon, 23 Dec 2019 12:28:04 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:27:51 -0800
In-Reply-To: <20191223202754.127546-1-edumazet@google.com>
Message-Id: <20191223202754.127546-3-edumazet@google.com>
Mime-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next v2 2/5] tcp_cubic: remove one conditional from hystart_update()
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

