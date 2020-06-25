Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E9C209DEB
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 13:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404653AbgFYLzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 07:55:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29329 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404622AbgFYLzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 07:55:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593086111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ld4Tn0L3Y5q550WDsn2Rq+n4f7sbKAnDUn1LS0FKjWo=;
        b=fUb7c6foeFjkrs98flJzYuaWcwKDP/7j4hE2n6j/SaXVYnWPcLDYr9YNgfVLM08FO/4ZO/
        v6PQctW7uMxecP+wX3X0ZblkXNXa/Ks2s93yAwz/r+YEPjv4MgOn6RYH/fRQ38SnvSzAon
        KD28lFkyl17zc+N+7PsX3ztG3fEDJe8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-3wrIJhHeO1iNa1N5GyrXMA-1; Thu, 25 Jun 2020 07:55:10 -0400
X-MC-Unique: 3wrIJhHeO1iNa1N5GyrXMA-1
Received: by mail-wm1-f69.google.com with SMTP id o138so5595540wme.4
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 04:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Ld4Tn0L3Y5q550WDsn2Rq+n4f7sbKAnDUn1LS0FKjWo=;
        b=iPgtPKiRmtCG0CtdB1T5ExhzonOp+hHky0AJ9LIN78uR+WvYvSEGakdWjvRWvQDYt4
         8nBq4nlJAUKC1PaW3lJeWIfQKEHgI2UX+HKqEDAI4H0fgZDZ6lhYxFkd6Isz68SDduRU
         QQ3Nbpq+15A9vXXcdYK8vLs0zwpgpzGRLBq9batV1lve3NWlXLh2UbzWtqmBPRpQZFdp
         O+kC+Fz2F8kB/MsC+i2XQtlxoJI4Aa8cUvQFkGT00MBLnHjIyTqf5t4zh19PUoZ+2NEt
         n+ctFJvGv/yxGiMP6ZqUONIpVi3b8CnbJfGoOE8WKKlkZ7f/CUpw9swo/xeNnB2mAWwA
         4N9Q==
X-Gm-Message-State: AOAM533ZuVMMkwMCdq6o5XcnQ32GxIhSdLIP8f46f0yL4GFGNhEo1voX
        lGbIzHB63dY/s9ezIfjMKUAMXqBmoL9PMB4FfoKTp/o8cDjOWVXhlF+9OueaD755cjTMCsF24Ah
        6sRgk0NVqG7Ylz4Uy
X-Received: by 2002:a1c:dd86:: with SMTP id u128mr2946090wmg.123.1593086108601;
        Thu, 25 Jun 2020 04:55:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOOk93C4793Qkapy2JpGSur7LO8UZd2j77wFa1YhFtXy6B7IQG+K6TsroaWQhOPlXEUAeAwA==
X-Received: by 2002:a1c:dd86:: with SMTP id u128mr2946062wmg.123.1593086108132;
        Thu, 25 Jun 2020 04:55:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a22sm12361179wmj.9.2020.06.25.04.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 04:55:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2B1EF1814FE; Thu, 25 Jun 2020 13:55:06 +0200 (CEST)
Subject: [PATCH net-next 3/5] sch_cake: don't call diffserv parsing code when
 it is not needed
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Date:   Thu, 25 Jun 2020 13:55:06 +0200
Message-ID: <159308610609.190211.12172433725292686379.stgit@toke.dk>
In-Reply-To: <159308610282.190211.9431406149182757758.stgit@toke.dk>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

As a further optimisation of the diffserv parsing codepath, we can skip it
entirely if CAKE is neither configured to use diffserv-based
classification, nor to zero out the diffserv bits.

Fixes: c87b4ecdbe8d ("sch_cake: Make sure we can write the IP header before changing DSCP bits")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/sch_cake.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index cebcc36755ac..958523c777be 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1597,7 +1597,7 @@ static unsigned int cake_drop(struct Qdisc *sch, struct sk_buff **to_free)
 	return idx + (tin << 16);
 }
 
-static u8 cake_handle_diffserv(struct sk_buff *skb, u16 wash)
+static u8 cake_handle_diffserv(struct sk_buff *skb, bool wash)
 {
 	const int offset = skb_network_offset(skb);
 	u16 *buf, buf_;
@@ -1658,14 +1658,17 @@ static struct cake_tin_data *cake_select_tin(struct Qdisc *sch,
 {
 	struct cake_sched_data *q = qdisc_priv(sch);
 	u32 tin, mark;
+	bool wash;
 	u8 dscp;
 
 	/* Tin selection: Default to diffserv-based selection, allow overriding
-	 * using firewall marks or skb->priority.
+	 * using firewall marks or skb->priority. Call DSCP parsing early if
+	 * wash is enabled, otherwise defer to below to skip unneeded parsing.
 	 */
-	dscp = cake_handle_diffserv(skb,
-				    q->rate_flags & CAKE_FLAG_WASH);
 	mark = (skb->mark & q->fwmark_mask) >> q->fwmark_shft;
+	wash = !!(q->rate_flags & CAKE_FLAG_WASH);
+	if (wash)
+		dscp = cake_handle_diffserv(skb, wash);
 
 	if (q->tin_mode == CAKE_DIFFSERV_BESTEFFORT)
 		tin = 0;
@@ -1679,6 +1682,8 @@ static struct cake_tin_data *cake_select_tin(struct Qdisc *sch,
 		tin = q->tin_order[TC_H_MIN(skb->priority) - 1];
 
 	else {
+		if (!wash)
+			dscp = cake_handle_diffserv(skb, wash);
 		tin = q->tin_index[dscp];
 
 		if (unlikely(tin >= q->tin_cnt))

