Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58A6432B38
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 02:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhJSAgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 20:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJSAgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 20:36:22 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7248C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 17:34:10 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t184so4777599pgd.8
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 17:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b/jSjjS7bs3azpuJCi4HEo2XX+hkUefLN8oyIuzy4n8=;
        b=P2n9tkinEWVRm9T0Xn9q+bZ4m21yto/pXclxOnBRPN/9dJ7Pa47/Bqv0dOAwHZctAJ
         fFZbVZJIgCim+LF+C3EK/RLWtEmgnWQjL1RmowwSRduX5hUrEP35pznQr0+MTUFvPvqU
         AYyC3thoQSHzVbh+fv/VXNp77S1BM2KfIobycyQ3hXLPpLZV+bYj0vqBHhsRQKN/rQhp
         yhw3IQnGMjw3gMX7SWNKNvO3AnK9M4fit63jIIGeW63ykfq/QA4L5xBPZqSzbgXo6QYY
         p7ajPOXNsSPebGoXjWy0Nmo7JcHgCRJmPIAZFgMREe3FZuUDP1tgjToTFtj2ZyrQjdla
         5wbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b/jSjjS7bs3azpuJCi4HEo2XX+hkUefLN8oyIuzy4n8=;
        b=NnyrLnPItBOYLS08+2Gj1e5NUMMfsyxA+fwkP5u50R5vj7O6SGudyVFjLjGgvOFJ2V
         9LR0ekGVsXetYKUlZxtukZKQ2nP6rdIcvAVbqofzBofKQKwfxVGiNBOR4eOWB81lpkne
         1ynqlsZWohBBFQ690brD8MHY2NnSvhsYIqG7QvaapAimxJFlimQQnWrSH6p0wXDAUbfx
         IQrColDodrKh9cBpoBKJIV6C+iM8+FvcYNGeybSDZvEVbWskuFqFDjGOyMu4G9gycL+C
         WKBwn1ze5Ae3WRE5DsY6PdW1Bh4zeOhESvqIrvpXpCZ25gcNp+GDMEKMZxZQzM2jeVlt
         Vp+w==
X-Gm-Message-State: AOAM533pTQYkjQeXpeU/K3ep1N1GjRTBmhbRK8i9SebCUyarcqJ2ZjfS
        X1tVGSdAKrGK3T/oYX4Sbvk=
X-Google-Smtp-Source: ABdhPJzca408kxaZkbo7SrsrgdwmtT0m1vRqixU837ECnqkaKEx0VJmnFcSAjjOz66wpvS4GH0OfMg==
X-Received: by 2002:a05:6a00:140c:b0:447:96be:2ade with SMTP id l12-20020a056a00140c00b0044796be2ademr31445972pfu.26.1634603650382;
        Mon, 18 Oct 2021 17:34:10 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:85d3:2c8e:fcea:2b1e])
        by smtp.gmail.com with ESMTPSA id n22sm579675pjv.22.2021.10.18.17.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 17:34:10 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 2/2] net: sched: remove one pair of atomic operations
Date:   Mon, 18 Oct 2021 17:34:02 -0700
Message-Id: <20211019003402.2110017-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211019003402.2110017-1-eric.dumazet@gmail.com>
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

__QDISC_STATE_RUNNING is only set/cleared from contexts owning qdisc lock.

Thus we can use less expensive bit operations, as we were doing
before commit f9eb8aea2a1e ("net_sched: transform qdisc running bit into a seqcount")

Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/net/sch_generic.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index e0988c56dd8fd7aa3dff6bd971da3c81f1a20626..ada02c4a4f518b732d62561a22b1d9033516b494 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -38,10 +38,13 @@ enum qdisc_state_t {
 	__QDISC_STATE_DEACTIVATED,
 	__QDISC_STATE_MISSED,
 	__QDISC_STATE_DRAINING,
+};
+
+enum qdisc_state2_t {
 	/* Only for !TCQ_F_NOLOCK qdisc. Never access it directly.
 	 * Use qdisc_run_begin/end() or qdisc_is_running() instead.
 	 */
-	__QDISC_STATE_RUNNING,
+	__QDISC_STATE2_RUNNING,
 };
 
 #define QDISC_STATE_MISSED	BIT(__QDISC_STATE_MISSED)
@@ -114,6 +117,7 @@ struct Qdisc {
 	struct gnet_stats_basic_sync bstats;
 	struct gnet_stats_queue	qstats;
 	unsigned long		state;
+	unsigned long		state2; /* must be written under qdisc spinlock */
 	struct Qdisc            *next_sched;
 	struct sk_buff_head	skb_bad_txq;
 
@@ -154,7 +158,7 @@ static inline bool qdisc_is_running(struct Qdisc *qdisc)
 {
 	if (qdisc->flags & TCQ_F_NOLOCK)
 		return spin_is_locked(&qdisc->seqlock);
-	return test_bit(__QDISC_STATE_RUNNING, &qdisc->state);
+	return test_bit(__QDISC_STATE2_RUNNING, &qdisc->state2);
 }
 
 static inline bool nolock_qdisc_is_empty(const struct Qdisc *qdisc)
@@ -217,7 +221,7 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 		 */
 		return spin_trylock(&qdisc->seqlock);
 	}
-	return !test_and_set_bit(__QDISC_STATE_RUNNING, &qdisc->state);
+	return !__test_and_set_bit(__QDISC_STATE2_RUNNING, &qdisc->state2);
 }
 
 static inline void qdisc_run_end(struct Qdisc *qdisc)
@@ -229,7 +233,7 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
 				      &qdisc->state)))
 			__netif_schedule(qdisc);
 	} else {
-		clear_bit(__QDISC_STATE_RUNNING, &qdisc->state);
+		__clear_bit(__QDISC_STATE2_RUNNING, &qdisc->state2);
 	}
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

