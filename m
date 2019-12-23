Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D918129A4C
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 20:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfLWTN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 14:13:29 -0500
Received: from mail-qk1-f202.google.com ([209.85.222.202]:36157 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfLWTN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 14:13:29 -0500
Received: by mail-qk1-f202.google.com with SMTP id w64so11817768qka.3
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 11:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Yd20JQaLyT3au5XqoALHJFuM3Fv27549rEUtCSVPnqo=;
        b=h/HBgpc+E0rConqoDeosAVfzHybuSNh2hjIyi7iIEUtqF0y+NmrRclwMqGzYbRt9aM
         oDg0qfMfpi7sM/XkKpcggCHDLexN3YbuXPYqNsHCKwd8UDEye3elgUG5g+yImTIughHa
         FR+CTifkutVOfJhiM5xSr9PxnGz/zY4Ddl9pGeVnR/oPPgjXJAqnp1nkKXvfhm3jRzLU
         urvoxm3F0vyGeDZYQXZpLw9OF4riwGVAd8TfHugZCV+UR42jzYZIDyzo2ozrORbyKz1t
         t2Mss4bQ1mQPLAcnbK9xBhIpP+MFsCrpGWlyVD2POrMwfvAsvXn47DLicbN7F5fAsAjR
         L0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Yd20JQaLyT3au5XqoALHJFuM3Fv27549rEUtCSVPnqo=;
        b=W4/XGDcJ2S6L2B5+ZGgVTDvKLHTuQa3bobnH4qd6fHhlb6TJudLZC+CTege1uk2JPp
         xaqYcHECGeYDKj5kiMeg53HjssOTNTAzilCgkb9tDKywyGeKKbXrozvQ64MVEmzOIYuf
         DvULcfQ+nkYzMyKdvgHaryAgE6a2/xdP5o5j5/xkmRZFLkCQWC4dG4ve+yoa/DX66myY
         5jj/57g8ShQITuIye9Q5eBw9Ic5RmxCjipEWmNXvqdZEhL2Xfth/2oMP5lZ3v4sXgru3
         U1rrUtH0n/4+n6bprbJWvut2H1M9mCtSKV+Aso6m32YgwxuAOvs2Ui4exS0DLG1705vJ
         uEfQ==
X-Gm-Message-State: APjAAAWumPceg5z5QDoxU5QdUTgQi5WX5+M59UcQvf+oeiwR4ZNEDnX/
        iysCvj+GMoJlMJvfE0SLX6W/g0hB54OVfw==
X-Google-Smtp-Source: APXvYqyahv8ReYkXbmWEbk7uqBcFZ/swXQMcFng/dWQvGp7daUMOpkklNOWu/mb0Z/XD+ThWdiWAnLBXnKoUVg==
X-Received: by 2002:aed:27de:: with SMTP id m30mr24215771qtg.151.1577128407414;
 Mon, 23 Dec 2019 11:13:27 -0800 (PST)
Date:   Mon, 23 Dec 2019 11:13:24 -0800
Message-Id: <20191223191324.49554-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net] net_sched: sch_fq: properly set sk->sk_pacing_status
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If fq_classify() recycles a struct fq_flow because
a socket structure has been reallocated, we do not
set sk->sk_pacing_status immediately, but later if the
flow becomes detached.

This means that any flow requiring pacing (BBR, or SO_MAX_PACING_RATE)
might fallback to TCP internal pacing, which requires a per-socket
high resolution timer, and therefore more cpu cycles.

Fixes: 218af599fa63 ("tcp: internal implementation for pacing")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 net/sched/sch_fq.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index b1c7e726ce5d1ae139f765c5b92dfdaea9bee258..ff4c5e9d0d7778d86f20f4bd67cc627eed0713d9 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -301,6 +301,9 @@ static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
 				     f->socket_hash != sk->sk_hash)) {
 				f->credit = q->initial_quantum;
 				f->socket_hash = sk->sk_hash;
+				if (q->rate_enable)
+					smp_store_release(&sk->sk_pacing_status,
+							  SK_PACING_FQ);
 				if (fq_flow_is_throttled(f))
 					fq_flow_unset_throttled(q, f);
 				f->time_next_packet = 0ULL;
@@ -322,8 +325,12 @@ static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
 
 	fq_flow_set_detached(f);
 	f->sk = sk;
-	if (skb->sk == sk)
+	if (skb->sk == sk) {
 		f->socket_hash = sk->sk_hash;
+		if (q->rate_enable)
+			smp_store_release(&sk->sk_pacing_status,
+					  SK_PACING_FQ);
+	}
 	f->credit = q->initial_quantum;
 
 	rb_link_node(&f->fq_node, parent, p);
@@ -428,17 +435,9 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	f->qlen++;
 	qdisc_qstats_backlog_inc(sch, skb);
 	if (fq_flow_is_detached(f)) {
-		struct sock *sk = skb->sk;
-
 		fq_flow_add_tail(&q->new_flows, f);
 		if (time_after(jiffies, f->age + q->flow_refill_delay))
 			f->credit = max_t(u32, f->credit, q->quantum);
-		if (sk && q->rate_enable) {
-			if (unlikely(smp_load_acquire(&sk->sk_pacing_status) !=
-				     SK_PACING_FQ))
-				smp_store_release(&sk->sk_pacing_status,
-						  SK_PACING_FQ);
-		}
 		q->inactive_flows--;
 	}
 
-- 
2.24.1.735.g03f4e72817-goog

