Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F921F3DA2
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 16:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgFIOJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 10:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729403AbgFIOJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 10:09:42 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568D5C08C5C2
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 07:09:42 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id y9so10131430qvs.4
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 07:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YLnEXrlYOroKY8SCoyQAl1ZA95PGGXG4GDfs22+XQDs=;
        b=LtVVjvigTy/Xt5SJ4AaABNiS/sldwjt4u8sEvvkcxGxHzeZBN0EhgzpQldwRrKQq1B
         Kb9hie9Gp3xH8PvuEyF3Upmh7VHoShc7pkRr4MOwb7PrviigFYDAnduii44n/FZXk69X
         6FE1LGixvcIkLzqo3oQIIKKAwyDv71kOwlavhUnScve6qbptluvxXCvwdYrABUToXsFU
         +iCmhdl+JbUWpgQTi9NOs2PaYSZIO4gj5PLmHkh2JaMQ4H2gc9YP0MGzb9yodLzW0ZEO
         QyPTjTk+9QZC6VA34rZ0hg2jIe45Urk3edAobnEheO4G7RiIfFBWUKKsYzMzWlbU/CSU
         1+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YLnEXrlYOroKY8SCoyQAl1ZA95PGGXG4GDfs22+XQDs=;
        b=ODKWLKN7r3F/euZ1ExHe/R0WJ3Yxe4VYDNY61IYzP80cuCMEHTPwP2zKpveRbfJ+pX
         3qP4/f5LaQFmVjZIFPl5e1YbqBHntWjGj85UdIc3SJCw/2LyJuPmnhuuqaLjodjzKeVa
         l7LlaM0V0SSwaP7yLs6Vxasu/5iyf5sV+oXcdWTFF9Xoq+F9L+xPLpzf+aTE+HIFxo78
         5AY2FA4f/NtQ3v3fKXwqJ3rX+VItgDhqn9wRbDJxclCPEVfR3bmLrQG2aNx0BDYYBzCB
         hEkPRNsqYl2MNo4M60RxkNud0Lx1rr56xnJlueEAq2NCVbITU7VzATheFh18r70kUAEP
         hqkA==
X-Gm-Message-State: AOAM533E0bakmbHqED2AgcVOUHrdtvfLEkv5Z8MSKANN/kkXVGqirKkY
        uFgrfWNiz6pXOtz3bdKyPYeu+mUP
X-Google-Smtp-Source: ABdhPJwNWztIPiNS43c6g6cDo8LV5q4Iwrl3UW8c4k/40txxuUPZBpHze3JzehYgeMOkhfxOkRbTOA==
X-Received: by 2002:a0c:f991:: with SMTP id t17mr4216552qvn.123.1591711781147;
        Tue, 09 Jun 2020 07:09:41 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id u25sm10454614qtc.11.2020.06.09.07.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:09:40 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
Subject: [PATCH RFC net-next 3/6] net_sched: sch_fq: multiple release time support
Date:   Tue,  9 Jun 2020 10:09:31 -0400
Message-Id: <20200609140934.110785-4-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
In-Reply-To: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
References: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Optionally segment skbs on FQ enqueue, to later send segments at
their individual delivery time.

Segmentation on enqueue is new for FQ, but already happens in TBF,
CAKE and netem.

This slow patch should probably be behind a static_branch.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/sched/sch_fq.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 8f06a808c59a..a5e2c35bb557 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -439,8 +439,8 @@ static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
 	return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
 }
 
-static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
-		      struct sk_buff **to_free)
+static int __fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+			struct sk_buff **to_free)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
 	struct fq_flow *f;
@@ -496,6 +496,35 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return NET_XMIT_SUCCESS;
 }
 
+static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+		      struct sk_buff **to_free)
+{
+	struct sk_buff *segs, *next;
+	int ret;
+
+	if (likely(!skb_is_gso(skb) || !skb->sk ||
+		   !skb->sk->sk_txtime_multi_release))
+		return __fq_enqueue(skb, sch, to_free);
+
+	segs = skb_gso_segment_txtime(skb);
+	if (IS_ERR(segs))
+		return qdisc_drop(skb, sch, to_free);
+	if (!segs)
+		return __fq_enqueue(skb, sch, to_free);
+
+	consume_skb(skb);
+
+	ret = NET_XMIT_DROP;
+	skb_list_walk_safe(segs, segs, next) {
+		skb_mark_not_on_list(segs);
+		qdisc_skb_cb(segs)->pkt_len = segs->len;
+		if (__fq_enqueue(segs, sch, to_free) == NET_XMIT_SUCCESS)
+			ret = NET_XMIT_SUCCESS;
+	}
+
+	return ret;
+}
+
 static void fq_check_throttled(struct fq_sched_data *q, u64 now)
 {
 	unsigned long sample;
-- 
2.27.0.278.ge193c7cf3a9-goog

