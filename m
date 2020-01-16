Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2A313EE07
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406950AbgAPSGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393470AbgAPRj0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:39:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CCF1246F2;
        Thu, 16 Jan 2020 17:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196365;
        bh=yETDCHaS0GNumaF6qSl588yc42UN+5m/IRjtrw7dan4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayOwF/SNsaSyUueFuUqOkUe3bn7fsEcbL8UZfxNWYQ+VMfPetAafnwQwpWF/0jTX4
         UgUhSaZWtY89tr20ovI11lMSI1fE1gbBN54/CdXaENm06AIUjibsGb5bpQslsGwiyn
         MS/BtNkLThYnBr5UgPpGeF98JqcIM83bEMABvhxo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        netem@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 154/251] net: netem: fix backlog accounting for corrupted GSO frames
Date:   Thu, 16 Jan 2020 12:35:03 -0500
Message-Id: <20200116173641.22137-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 177b8007463c4f36c9a2c7ce7aa9875a4cad9bd5 ]

When GSO frame has to be corrupted netem uses skb_gso_segment()
to produce the list of frames, and re-enqueues the segments one
by one.  The backlog length has to be adjusted to account for
new frames.

The current calculation is incorrect, leading to wrong backlog
lengths in the parent qdisc (both bytes and packets), and
incorrect packet backlog count in netem itself.

Parent backlog goes negative, netem's packet backlog counts
all non-first segments twice (thus remaining non-zero even
after qdisc is emptied).

Move the variables used to count the adjustment into local
scope to make 100% sure they aren't used at any stage in
backports.

Fixes: 6071bd1aa13e ("netem: Segment GSO packets on enqueue")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 95002e56fa48..308d92491757 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -437,8 +437,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct netem_skb_cb *cb;
 	struct sk_buff *skb2;
 	struct sk_buff *segs = NULL;
-	unsigned int len = 0, last_len, prev_len = qdisc_pkt_len(skb);
-	int nb = 0;
+	unsigned int prev_len = qdisc_pkt_len(skb);
 	int count = 1;
 	int rc = NET_XMIT_SUCCESS;
 	int rc_drop = NET_XMIT_DROP;
@@ -495,6 +494,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			segs = netem_segment(skb, sch, to_free);
 			if (!segs)
 				return rc_drop;
+			qdisc_skb_cb(segs)->pkt_len = segs->len;
 		} else {
 			segs = skb;
 		}
@@ -585,6 +585,11 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 finish_segs:
 	if (segs) {
+		unsigned int len, last_len;
+		int nb = 0;
+
+		len = skb->len;
+
 		while (segs) {
 			skb2 = segs->next;
 			segs->next = NULL;
@@ -600,9 +605,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			}
 			segs = skb2;
 		}
-		sch->q.qlen += nb;
-		if (nb > 1)
-			qdisc_tree_reduce_backlog(sch, 1 - nb, prev_len - len);
+		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
 	}
 	return NET_XMIT_SUCCESS;
 }
-- 
2.20.1

