Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7076436793
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhJUQZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbhJUQZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:23 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE81C0613B9
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:05 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t11so759679plq.11
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b/jSjjS7bs3azpuJCi4HEo2XX+hkUefLN8oyIuzy4n8=;
        b=hGdqZ0X1N3wExR+i5LdFsIGrjDlJxkmX4ZzWoXAQXv2g2UYcmKMLuAOozJOqlG7eqI
         r6Q8UmQuqrf3jGjcJrE/hx0BRkGFEpSy0LaI68//e0xo9+uJ4fa3VNgXwGNu0PgJaZIJ
         4kuRKkun05KIwNwU2Dc/vtL7C/1+1tSTHSaeK499X/GReRDcDM55oRy8wNPR25TqI+q2
         yE+D5TRZTPMDQPmaqmKyN4DauEzGI5e+FJ+zmh0izhAbVFCYMltGlUXFwxEnror3tL+0
         5nZhnHAE43oOeEPqJcYHamfbBKsMJp1yI16OGw70U0NYo75YypXfnnImu2TfUUFRU8eq
         kNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b/jSjjS7bs3azpuJCi4HEo2XX+hkUefLN8oyIuzy4n8=;
        b=uXGwdZwo6rLAjxnzaOoHo4sP41Z47yolTWbZQFxR2MfkafyVAAaVR8lhPVxrnVxnH3
         xjoDWqdgWzu1P9vrEA2bFAGnZJR0WrzV/30tqUdqpe24qKhj/K8kqV1Ys2s43byT7gC0
         xdHkU9W7mJxcuWlcoQkQfVt4Hp0H0t8aNn8ThqGYNxLt+RlEcIKpPpmVp4iAxTB+ikkj
         sj7qr7RXKBreArv3gkM2+frxMngEazkJiEJlrT/FDW59GyncvfTU/dgABHr+yXTD0s3H
         gFjvrJH8GiPWvERTnjgMhiUQM0Qnld6a0lUjfHfhTklJ0HK63N8N/N+RrPw27imRJtYM
         SdmA==
X-Gm-Message-State: AOAM533Rl+QJ5se1M76IAGSTzUdtaJ5nwDLgQaUqFyn2M2yoEV+rcyqt
        Y8Ue6pM/ACLi4Q1vpbw+n3w=
X-Google-Smtp-Source: ABdhPJxzR2/dbptRLads2vvPiIJMdvHQkiA4hEagTbNSOtn7evBxmnijEsTSBnuJiMMCI8n9NP9+7w==
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr7657285pjb.131.1634833385234;
        Thu, 21 Oct 2021 09:23:05 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:04 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 2/2] net: sched: remove one pair of atomic operations
Date:   Thu, 21 Oct 2021 09:22:46 -0700
Message-Id: <20211021162253.333616-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
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

