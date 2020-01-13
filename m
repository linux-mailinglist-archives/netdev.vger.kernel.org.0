Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A187139D96
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgAMXnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:43:01 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55249 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbgAMXnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 18:43:00 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f3c65720;
        Mon, 13 Jan 2020 22:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=dV/9ypqPU0loa5AZnhX0lQcT2
        OY=; b=ko0kmr7QFv4tP6TDHFbziU4Rkng32He06KpzSxDUNXPgDCxHEUgw3vvvm
        EjhHFfRcaQJUtw7Vm1nP+cqz0Kyjdt/ehAab9k2BJDzeknMD6OYLW71q8QYU2fL/
        jqlwjJJCumitaSqZJaIPs6+xEvpDH5jht32tq4tDB3JtTVj4TcEYi6fdMQ5RMPMs
        eCkstjXsVZI0EpKUX597/JM7dwegmVM9AoaOyQgf+5AOu3K7CGuUkfHYf5E1DLru
        KFl1y0Ul2QfPPlDYp+bOuHbUz5lGgzNsBpicYHKSNilLdNISMhgR7nqJKF52PqpV
        8hHpDB54nEasmsAT8bD/rDHRFQPwA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e38220c5 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jan 2020 22:42:58 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 7/8] net: netfilter: use skb_list_walk_safe helper for gso segments
Date:   Mon, 13 Jan 2020 18:42:32 -0500
Message-Id: <20200113234233.33886-8-Jason@zx2c4.com>
In-Reply-To: <20200113234233.33886-1-Jason@zx2c4.com>
References: <20200113234233.33886-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a straight-forward conversion case for the new function, keeping
the flow of the existing code as intact as possible.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/netfilter/nfnetlink_queue.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index feabdfb22920..76535fd9278c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -778,7 +778,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
 	unsigned int queued;
 	struct nfqnl_instance *queue;
-	struct sk_buff *skb, *segs;
+	struct sk_buff *skb, *segs, *nskb;
 	int err = -ENOBUFS;
 	struct net *net = entry->state.net;
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
@@ -815,8 +815,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		goto out_err;
 	queued = 0;
 	err = 0;
-	do {
-		struct sk_buff *nskb = segs->next;
+	skb_list_walk_safe(segs, segs, nskb) {
 		if (err == 0)
 			err = __nfqnl_enqueue_packet_gso(net, queue,
 							segs, entry);
@@ -824,8 +823,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 			queued++;
 		else
 			kfree_skb(segs);
-		segs = nskb;
-	} while (segs);
+	}
 
 	if (queued) {
 		if (err) /* some segments are already queued */
-- 
2.24.1

