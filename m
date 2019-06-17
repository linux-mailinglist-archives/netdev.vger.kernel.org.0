Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE41848B87
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfFQSLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:11:36 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46163 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfFQSLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:11:35 -0400
Received: by mail-qk1-f195.google.com with SMTP id x18so6749380qkn.13
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OaLXfJmWj2NzaEA4/IVizYTp/CawRSjDfR+pSrvSFqc=;
        b=WiPNym2pnalxsSfCQsdpOWAmh0boiPDEuG92f+PO5jo4qV5BCRn7EP5f7K4Xvf9Usl
         van4t4GAmf+cXE8PUeFcZiH1xVoa1dk6xibKhAb/aeFm4zNu/4x2HroRy58eN9w8eMDY
         wBuW81yL40XbLnTSnaG2yqTNZLNi5qaWTBH0ptXtjQ32UgWezamtu6p8JgaIYUe26FkQ
         w06t1ZRLwa20AEFZAiDZOiWcdFiY3jkCaIzF0+nlq2VNtu1Zs0XfsxRb/SVSDqLZbpRm
         8NHbREv70g4UX4bKOdsnNu9/5VaO8qcQoUCvb6qJEriUp/diWdT55M8hwaHuP5gzd7tD
         kw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OaLXfJmWj2NzaEA4/IVizYTp/CawRSjDfR+pSrvSFqc=;
        b=DMs4b9pwTvKelAoeXQ6Oep7UmT8f2qKNE5e8oLfJ2aQcr8m1CzLOcQSkiQk0Blxk+f
         4a7UNFlyU3o7ytAy30RBHK6a12BJ2HS7rlj7ZfWp1Us3XW3uWcd0AKr+hJFCKqo27Oof
         FUaubiFNP8IPu2n0aFW8kp2U6Bxq18ubzTaVk0Dj+ecQgbkP9ewnqf/gYFztqXOlem/+
         YTxKKAp7UtoPViJMyyPlhbImPvlkXPplJMYdcvZyM1i9BFZJ+MULjSTolZs1gaSF28/Z
         +3N7XvCS7AE06IB//4JM7YWoeo0PF27o14dXpHzoJ/gzNiVO0tB5wyDIZHfR0tqSlodo
         L0PQ==
X-Gm-Message-State: APjAAAWsFZmyiVFlWat8AsHUffsTCwnArsdQ+ZLNr1fZyWgwXJmkuxrh
        3Ea7uVumA0sQTlYc+3VNhrX2sg==
X-Google-Smtp-Source: APXvYqygouishKvy3XoRT3bQPiVMNhIqoE1utlidgHJ/ffVvNkkq/JusdMDCvACQyTYkYQaEYoGYYQ==
X-Received: by 2002:a05:620a:1661:: with SMTP id d1mr15155320qko.192.1560795094534;
        Mon, 17 Jun 2019 11:11:34 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x10sm9048564qtc.34.2019.06.17.11.11.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 11:11:33 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, xiyou.wangcong@gmail.com
Cc:     stephen@networkplumber.org, jhs@mojatatu.com, jiri@resnulli.us,
        netem@lists.linux-foundation.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, edumazet@google.com, posk@google.com,
        nhorman@tuxdriver.com
Subject: [PATCH net v2 2/2] net: netem: fix use after free and double free with packet corruption
Date:   Mon, 17 Jun 2019 11:11:11 -0700
Message-Id: <20190617181111.5025-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617181111.5025-1-jakub.kicinski@netronome.com>
References: <20190617181111.5025-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brendan reports that the use of netem's packet corruption capability
leads to strange crashes.  This seems to be caused by
commit d66280b12bd7 ("net: netem: use a list in addition to rbtree")
which uses skb->next pointer to construct a fast-path queue of
in-order skbs.

Packet corruption code has to invoke skb_gso_segment() in case
of skbs in need of GSO.  skb_gso_segment() returns a list of
skbs.  If next pointers of the skbs on that list do not get cleared
fast path list may point to freed skbs or skbs which are also on
the RB tree.

Let's say skb gets segmented into 3 frames:

A -> B -> C

A gets hooked to the t_head t_tail list by tfifo_enqueue(), but it's
next pointer didn't get cleared so we have:

h t
|/
A -> B -> C

Now if B and C get also get enqueued successfully all is fine, because
tfifo_enqueue() will overwrite the list in order.  IOW:

Enqueue B:

h    t
|    |
A -> B    C

Enqueue C:

h         t
|         |
A -> B -> C

But if B and C get reordered we may end up with:

h t            RB tree
|/                |
A -> B -> C       B
                   \
                    C

Or if they get dropped just:

h t
|/
A -> B -> C

where A and B are already freed.

To reproduce either limit has to be set low to cause freeing of
segs or reorders have to happen (due to delay jitter).

Note that we only have to mark the first segment as not on the
list, "finish_segs" handling of other frags already does that.

Another caveat is that qdisc_drop_all() still has to free all
segments correctly in case of drop of first segment, therefore
we re-link segs before calling it.

v2:
 - re-link before drop, v1 was leaking non-first segs if limit
   was hit at the first seg
 - better commit message which lead to discovering the above :)

Reported-by: Brendan Galloway <brendan.galloway@netronome.com>
Fixes: d66280b12bd7 ("net: netem: use a list in addition to rbtree")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/sched/sch_netem.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 3b3e2d772c3b..b17f2ed970e2 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -493,17 +493,14 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 */
 	if (q->corrupt && q->corrupt >= get_crandom(&q->corrupt_cor)) {
 		if (skb_is_gso(skb)) {
-			segs = netem_segment(skb, sch, to_free);
-			if (!segs)
+			skb = netem_segment(skb, sch, to_free);
+			if (!skb)
 				return rc_drop;
-			qdisc_skb_cb(segs)->pkt_len = segs->len;
-		} else {
-			segs = skb;
+			segs = skb->next;
+			skb_mark_not_on_list(skb);
+			qdisc_skb_cb(skb)->pkt_len = skb->len;
 		}
 
-		skb = segs;
-		segs = segs->next;
-
 		skb = skb_unshare(skb, GFP_ATOMIC);
 		if (unlikely(!skb)) {
 			qdisc_qstats_drop(sch);
@@ -520,6 +517,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	if (unlikely(sch->q.qlen >= sch->limit)) {
+		/* re-link segs, so that qdisc_drop_all() frees them all */
+		skb->next = segs;
 		qdisc_drop_all(skb, sch, to_free);
 		return rc_drop;
 	}
-- 
2.21.0

