Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71FE4C4243
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfJAVCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:02:42 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:42150 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfJAVCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:02:42 -0400
Received: by mail-pf1-f202.google.com with SMTP id w16so11133645pfj.9
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 14:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pI+GljzLLxvJ5n7p2l8qpnPRP9jC+weEz+vO0i3MGs8=;
        b=qXVeK5uGPmx77uKMwY9Bpd0JRuR1I6lnoC/1YIeic/vqw0GWc+gsm6a8UivX5trfC1
         opPQ21RkmQICEW/uS2SvRca0XkmbM0sAVh/7NHlv0wyd9S8voumYd/7aQFaAFVQwtAs8
         gzsc5B1kgeh8uKXIqTG+C6LgSf/Ugw4dO5XicW+Wz2bcu3yDbtnPd5k6J2mkRlTkXtW+
         HZeHkfQHO8WC1fw5SMpEHVI9KdstjQJTraRmAq43bQZNW2+VD+2FL8acAKviRakQmi90
         BaUpvsUg86pKSekAKp+7vgjdEKaxgIfbIe53bm82N69GAvCeeuQvIRVlJVVXU3jY4ReE
         hPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pI+GljzLLxvJ5n7p2l8qpnPRP9jC+weEz+vO0i3MGs8=;
        b=G3r1F1N0vcRLYlvjsZnb4JZyOTZbQrYoaqpu2ULADxRIvIbf7ECeMmh5nvmO2GA37I
         8GMzsK9f88WnlOJE9QwDuqVgZSQqFRBRBaTA9QpjE01gWeNy1+IlNhvrTBWBCcjISsHW
         UG6S/Z9eYG9l4M9ZdpPWw941E3eKIPdPPP5pjrtL0O5aFybxS/6PPkNu1H6pdVZ078Bh
         PzCwxRUMFDFQze7+GyCIY8l+3K+Hi0WRqEMCBGhLmY8aqnFsuF5PrKx0MZ3McxYi0tmh
         2eWnNJV8H1uoaxNiBztoboQHni9DZvMzFF08M1pF1hmf4TL1hJSyxf4Zb9/b5GR2tEw+
         9p/w==
X-Gm-Message-State: APjAAAXz4lIqq/RXHgFXKg4cCFbuxuCF8GKkvbDcIouMw08LFEqWRf+c
        zuMXk9a4F9ighLNGmHjq+Mzkvt6wljsR9g==
X-Google-Smtp-Source: APXvYqz0aws6/pbteY/ig3DX1buFZSov6/J4/LnGET18K6m6NYo2xe5Q5hwwHTABUKle0XZO/Ptzw6ApMQtDkw==
X-Received: by 2002:a63:408:: with SMTP id 8mr32846975pge.334.1569963760145;
 Tue, 01 Oct 2019 14:02:40 -0700 (PDT)
Date:   Tue,  1 Oct 2019 14:02:36 -0700
Message-Id: <20191001210236.176111-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net-next] net_sched: remove need_resched() from qdisc_run()
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

The introduction of this schedule point was done in commit
2ba2506ca7ca ("[NET]: Add preemption point in qdisc_run")
at a time the loop was not bounded.

Then later in commit d5b8aa1d246f ("net_sched: fix dequeuer fairness")
we added a limit on the number of packets.

Now is the time to remove the schedule point, since the default
limit of 64 packets matches the number of packets a typical NAPI
poll can process in a row.

This solves a latency problem for most TCP receivers under moderate load :

1) host receives a packet.
   NET_RX_SOFTIRQ is raised by NIC hard IRQ handler

2) __do_softirq() does its first loop, handling NET_RX_SOFTIRQ
   and calling the driver napi->loop() function

3) TCP stores the skb in socket receive queue:

4) TCP calls sk->sk_data_ready() and wakeups a user thread
   waiting for EPOLLIN (as a result, need_resched() might now be true)

5) TCP cooks an ACK and sends it.

6) qdisc_run() processes one packet from qdisc, and sees need_resched(),
   this raises NET_TX_SOFTIRQ (even if there are no more packets in
   the qdisc)

Then we go back to the __do_softirq() in 2), and we see that new
softirqs were raised. Since need_resched() is true, we end up waking
ksoftirqd in this path :

    if (pending) {
            if (time_before(jiffies, end) && !need_resched() &&
                --max_restart)
                    goto restart;

            wakeup_softirqd();
    }

So we have many wakeups of ksoftirqd kernel threads,
and more calls to qdisc_run() with associated lock overhead.

Note that another way to solve the issue would be to change TCP
to first send the ACK packet, then signal the EPOLLIN,
but this changes P99 latencies, as sending the ACK packet
can add a long delay.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_generic.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 17bd8f539bc7f1d596e97c713467f953802c9b82..4c75dbabd343e4585da2f3b11105e436c872c4a8 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -382,13 +382,8 @@ void __qdisc_run(struct Qdisc *q)
 	int packets;
 
 	while (qdisc_restart(q, &packets)) {
-		/*
-		 * Ordered by possible occurrence: Postpone processing if
-		 * 1. we've exceeded packet quota
-		 * 2. another process needs the CPU;
-		 */
 		quota -= packets;
-		if (quota <= 0 || need_resched()) {
+		if (quota <= 0) {
 			__netif_schedule(q);
 			break;
 		}
-- 
2.23.0.581.g78d2f28ef7-goog

