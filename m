Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246D3534768
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 02:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244880AbiEZAR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 20:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244664AbiEZARy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 20:17:54 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9AE66AD5
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 17:17:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ob14-20020a17090b390e00b001dff2a43f8cso4737631pjb.1
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 17:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cr5L7SjMubi0RQ+Cv+ih4tqsWNzpzLkv26kDNDXMNsE=;
        b=dlJIzYQ8G6GQKpF6l8ez/7Y4QxnIK93SdF8xlHW+bvG/eAA+ZJhVTuPnRVrnCQhYGo
         HQQibHyHfKVi9ZbGFIau1ezX7JU3L4cVALKSoNvTFr7KXNhY+FmZDt0fR6or7GeS83Eh
         abIVGeUiDmNmJYowRPwn91XYW3WD3cArJMJswLT85xJwSSNYJtrb5A9WdUd+axSn+KtV
         ZYqBTpcFmQ9hDc5T8DUz4WSYGNbvRDb3SPsXoXX+5R+VVSJgNbcnHiRjX1vB6cdwyMn5
         0XVv+x3bnfevj4JU2kRwE+/Ax4aabBDuEFEDHAxiaTEaOD/toZicgr/Yk/LAISFFpmVl
         H1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cr5L7SjMubi0RQ+Cv+ih4tqsWNzpzLkv26kDNDXMNsE=;
        b=NsDAP98jQYBdy/MzSsMPa0nf84BWmJs7JZQvzthFops6Ch0jYLZqlxi+Qt9+g6t6UA
         GYqZpfD8alZHaWgLGvPWdHvD5cj3+OeVDiG3KyAnmEJISBNS0JdQZwDqMjN8vgTfE9No
         7n8rH4TDv8ogwmHqllPYAPxzI/G8TyU5HN9Rqx18tdFCsTNrbKZtkVPwyjaPsoI6n4gj
         o1iz4QCweraL8C7g3GrubB0odEA9VhYHw9XfBFb6jCFpFKLYmJpNHyfm/djKNikzQhfu
         naj2RmrrgHPIqJGO0vbRzKsL1YHeoO+0sYw+MmYZO88zsrQp+oB2D4KYHY/GWd/QvgEn
         elZQ==
X-Gm-Message-State: AOAM533gwmuTmv04vLuzpXXpoXHd4sWpXnUd7XUYvclry88PfeZ+fTUy
        qTctCgX6LABQoILo8wZxtTk=
X-Google-Smtp-Source: ABdhPJzqK8iFFyLbIQ29TnTnzYlNIFqbPzk/NDRdQSAxYNAB7oERepwUXSDyTNYr8L2gWAwA+NRYOA==
X-Received: by 2002:a17:902:f685:b0:161:8df3:7f50 with SMTP id l5-20020a170902f68500b001618df37f50mr34321289plg.106.1653524273137;
        Wed, 25 May 2022 17:17:53 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d156:3c09:f297:61a8])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902f68500b0015e8d4eb1d3sm7132plg.29.2022.05.25.17.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 17:17:52 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vincent Ray <vray@kalrayinc.com>
Subject: [PATCH v3 net] net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog
Date:   Wed, 25 May 2022 17:17:46 -0700
Message-Id: <20220526001746.2437669-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
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

From: Vincent Ray <vray@kalrayinc.com>

In qdisc_run_begin(), smp_mb__before_atomic() used before test_bit()
does not provide any ordering guarantee as test_bit() is not an atomic
operation. This, added to the fact that the spin_trylock() call at
the beginning of qdisc_run_begin() does not guarantee acquire
semantics if it does not grab the lock, makes it possible for the
following statement :

if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))

to be executed before an enqueue operation called before
qdisc_run_begin().

As a result the following race can happen :

           CPU 1                             CPU 2

      qdisc_run_begin()               qdisc_run_begin() /* true */
        set(MISSED)                            .
      /* returns false */                      .
          .                            /* sees MISSED = 1 */
          .                            /* so qdisc not empty */
          .                            __qdisc_run()
          .                                    .
          .                              pfifo_fast_dequeue()
 ----> /* may be done here */                  .
|         .                                clear(MISSED)
|         .                                    .
|         .                                smp_mb __after_atomic();
|         .                                    .
|         .                                /* recheck the queue */
|         .                                /* nothing => exit   */
|   enqueue(skb1)
|         .
|   qdisc_run_begin()
|         .
|     spin_trylock() /* fail */
|         .
|     smp_mb__before_atomic() /* not enough */
|         .
 ---- if (test_bit(MISSED))
        return false;   /* exit */

In the above scenario, CPU 1 and CPU 2 both try to grab the
qdisc->seqlock at the same time. Only CPU 2 succeeds and enters the
bypass code path, where it emits its skb then calls __qdisc_run().

CPU1 fails, sets MISSED and goes down the traditionnal enqueue() +
dequeue() code path. But when executing qdisc_run_begin() for the
second time, after enqueuing its skbuff, it sees the MISSED bit still
set (by itself) and consequently chooses to exit early without setting
it again nor trying to grab the spinlock again.

Meanwhile CPU2 has seen MISSED = 1, cleared it, checked the queue
and found it empty, so it returned.

At the end of the sequence, we end up with skb1 enqueued in the
backlog, both CPUs out of __dev_xmit_skb(), the MISSED bit not set,
and no __netif_schedule() called made. skb1 will now linger in the
qdisc until somebody later performs a full __qdisc_run(). Associated
to the bypass capacity of the qdisc, and the ability of the TCP layer
to avoid resending packets which it knows are still in the qdisc, this
can lead to serious traffic "holes" in a TCP connection.

We fix this by replacing the smp_mb__before_atomic() / test_bit() /
set_bit() / smp_mb__after_atomic() sequence inside qdisc_run_begin()
by a single test_and_set_bit() call, which is more concise and
enforces the needed memory barriers.

Fixes: 89837eb4b246 ("net: sched: add barrier to ensure correct ordering for lockless qdisc")
Signed-off-by: Vincent Ray <vray@kalrayinc.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
v2, v3: adopted much cleaner test_and_set_bit().

 include/net/sch_generic.h | 36 ++++++++----------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9bab396c1f3ba3d143de4d63f4142cff3c9b9f3e..80973ce820f3ee80b7b3513466797768a71d4f77 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -187,37 +187,17 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 		if (spin_trylock(&qdisc->seqlock))
 			return true;
 
-		/* Paired with smp_mb__after_atomic() to make sure
-		 * STATE_MISSED checking is synchronized with clearing
-		 * in pfifo_fast_dequeue().
+		/* No need to insist if the MISSED flag was already set.
+		 * Note that test_and_set_bit() also gives us memory ordering
+		 * guarantees wrt potential earlier enqueue() and below
+		 * spin_trylock(), both of which are necessary to prevent races
 		 */
-		smp_mb__before_atomic();
-
-		/* If the MISSED flag is set, it means other thread has
-		 * set the MISSED flag before second spin_trylock(), so
-		 * we can return false here to avoid multi cpus doing
-		 * the set_bit() and second spin_trylock() concurrently.
-		 */
-		if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
+		if (test_and_set_bit(__QDISC_STATE_MISSED, &qdisc->state))
 			return false;
 
-		/* Set the MISSED flag before the second spin_trylock(),
-		 * if the second spin_trylock() return false, it means
-		 * other cpu holding the lock will do dequeuing for us
-		 * or it will see the MISSED flag set after releasing
-		 * lock and reschedule the net_tx_action() to do the
-		 * dequeuing.
-		 */
-		set_bit(__QDISC_STATE_MISSED, &qdisc->state);
-
-		/* spin_trylock() only has load-acquire semantic, so use
-		 * smp_mb__after_atomic() to ensure STATE_MISSED is set
-		 * before doing the second spin_trylock().
-		 */
-		smp_mb__after_atomic();
-
-		/* Retry again in case other CPU may not see the new flag
-		 * after it releases the lock at the end of qdisc_run_end().
+		/* Try to take the lock again to make sure that we will either
+		 * grab it or the CPU that still has it will see MISSED set
+		 * when testing it in qdisc_run_end()
 		 */
 		return spin_trylock(&qdisc->seqlock);
 	}
-- 
2.36.1.124.g0e6072fb45-goog

