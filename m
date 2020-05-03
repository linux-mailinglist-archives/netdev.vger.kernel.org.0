Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DF21C296E
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 04:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgECCyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 22:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726737AbgECCyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 22:54:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC307C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 19:54:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w15so17607625ybp.16
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 19:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R7YnmYs9d6wLoe6DurJmu54SpzbXezhXrrfeGosy7lk=;
        b=hQ9+oYfFm1GM1UGhbHoSumgLSSVzzh6Xna9a64tI0+B8ZZZJJD/O2jQqhYp22i6cFp
         8gBmYTdSzhM33R7xaBpaEvuAgB9I40HfFoy0P6p+fjCZVd0mSb1f3xmNoLQHHWBeybsx
         N1U+ZXNpKYGCPcvjn6keEfVV9xJZ6wXCSlSFXhYAx28EdQy8giZU3Op80oYnyXP8VJo4
         pC4zgV1jIzfEgWZacplnvIZHWaryfYJaTh7W2iE2n1pWncNgKj+LcrX563NmisCXeY4f
         rGKRmUDuANp0AOxrdJifHX5B/2uV3c0bf/HeKwWmv+Ckp2MRpbY+++sZqqi2ZPqyBm8R
         6sJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R7YnmYs9d6wLoe6DurJmu54SpzbXezhXrrfeGosy7lk=;
        b=cwYQvVhBtM1OYc1+s+UNg6SkdslWhIKs1xGfuqe8EWnpV9LW7UuJz1Jq3BW5w6YmwT
         RUF59t2WLB0kW//Asro7yjQWr31E99N9im7r72Dv0zU5SLIymY9v1DYCoszT3kAgyZdM
         4bBJHSGH0E/3OnP/z3ZAg2/5A1ZAloAOCK9cbIOQandHnaxuYyrbz4Zw8tR9une93Eyr
         FPBWFhVAqrb/HzM4pOt9z92VtOwzLYeBbC5uP2kfvEiNeUsi0uJxLl4C7QAFVbfv2+PM
         shMUocusUHsq5BUWytxCZmJZP2Rdyi8gg469Nfir8pDmQyAmSek70oSzpB2Qtu5ArloD
         EAEQ==
X-Gm-Message-State: AGi0PuamlCIpBWdZnbVChKJgply8qOimIJI92DnEA0bk+Blf7bkcMVS3
        /hwV56Bq4Bkcr99Z8kXU88SM02F8OfqXDg==
X-Google-Smtp-Source: APiQypI55qP+HDVkEMY4wjctJUcZtSP4lUYw6avp+Y8mXezACf8VszC3/nD0yb5cyokVmQk8T7d926yeojl3EQ==
X-Received: by 2002:a5b:301:: with SMTP id j1mr16670692ybp.142.1588474470890;
 Sat, 02 May 2020 19:54:30 -0700 (PDT)
Date:   Sat,  2 May 2020 19:54:19 -0700
In-Reply-To: <20200503025422.219257-1-edumazet@google.com>
Message-Id: <20200503025422.219257-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200503025422.219257-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 2/5] net_sched: sch_fq: change fq_flow size/layout
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

sizeof(struct fq_flow) is 112 bytes on 64bit arches.

This means that half of them use two cache lines, but 50% use
three cache lines.

This patch adds cache line alignment, and makes sure that only
the first cache line is touched by fq_enqueue(), which is more
expensive that fq_dequeue() in general.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 1649928fe2c1b7476050e5eee3c494c76d114c62..7a2b3195938ede3c14c37b90c9604185cfa3f651 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -66,6 +66,7 @@ static inline struct fq_skb_cb *fq_skb_cb(struct sk_buff *skb)
  * in linear list (head,tail), otherwise are placed in a rbtree (t_root).
  */
 struct fq_flow {
+/* First cache line : used in fq_gc(), fq_enqueue(), fq_dequeue() */
 	struct rb_root	t_root;
 	struct sk_buff	*head;		/* list of skbs for this flow : first skb */
 	union {
@@ -74,14 +75,18 @@ struct fq_flow {
 	};
 	struct rb_node	fq_node;	/* anchor in fq_root[] trees */
 	struct sock	*sk;
+	u32		socket_hash;	/* sk_hash */
 	int		qlen;		/* number of packets in flow queue */
+
+/* Second cache line, used in fq_dequeue() */
 	int		credit;
-	u32		socket_hash;	/* sk_hash */
+	/* 32bit hole on 64bit arches */
+
 	struct fq_flow *next;		/* next pointer in RR lists */
 
 	struct rb_node  rate_node;	/* anchor in q->delayed tree */
 	u64		time_next_packet;
-};
+} ____cacheline_aligned_in_smp;
 
 struct fq_flow_head {
 	struct fq_flow *first;
-- 
2.26.2.526.g744177e7f7-goog

