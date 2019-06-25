Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFA5553BD
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbfFYPvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:51:48 -0400
Received: from sessmg22.ericsson.net ([193.180.251.58]:59526 "EHLO
        sessmg22.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYPvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 11:51:47 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2019 11:51:46 EDT
DKIM-Signature: v=1; a=rsa-sha256; d=ericsson.com; s=mailgw201801; c=relaxed/relaxed;
        q=dns/txt; i=@ericsson.com; t=1561477004; x=1564069004;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=58bOMnhE/wDvdWpdEUYrVf5VUvpFoYPxq/5U05f3Y7k=;
        b=YWtsqRu5DvsMBfVb7mnRxaKKHejvIB+4SwIHuURfrhLBkGyti9Jlc9zyoDgHwP2w
        ZE37n9XUrgPojbXCWWHqFHEZIbgvKjBG6ae2tID+wunasKhiJCCZ1Hs3P3Z6mu9c
        rK4qAC1T+B+u3zxEqu9ndJ3MgUHQGUXNIoXaziTAI9w=;
X-AuditID: c1b4fb3a-709ff7000000189f-12-5d123f8c5d6d
Received: from ESESBMB504.ericsson.se (Unknown_Domain [153.88.183.117])
        by sessmg22.ericsson.net (Symantec Mail Security) with SMTP id E3.C7.06303.C8F321D5; Tue, 25 Jun 2019 17:36:44 +0200 (CEST)
Received: from ESESSMR506.ericsson.se (153.88.183.128) by
 ESESBMB504.ericsson.se (153.88.183.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 25 Jun 2019 17:36:43 +0200
Received: from ESESBMB504.ericsson.se (153.88.183.171) by
 ESESSMR506.ericsson.se (153.88.183.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 25 Jun 2019 17:36:43 +0200
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.187) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 25 Jun 2019 17:36:43 +0200
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <gordan.mihaljevic@dektech.com.au>, <tung.q.nguyen@dektech.com.au>,
        <hoang.h.le@dektech.com.au>, <jon.maloy@ericsson.com>,
        <canh.d.luu@dektech.com.au>, <ying.xue@windriver.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net-next  1/1] tipc: simplify stale link failure criteria
Date:   Tue, 25 Jun 2019 17:36:43 +0200
Message-ID: <1561477003-25362-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsUyM2J7qW6PvVCsQecWfosbDT3MFnPOt7BY
        rNg9idXi7atZ7BbHFohZbDmfZXGl/Sy7xePr15kdODy2rLzJ5PHuCpvH7gWfmTw+b5LzWL9l
        K1MAaxSXTUpqTmZZapG+XQJXxrGzp5gKjkpUTDzSztzA+Fy4i5GTQ0LAROLWvK+sXYxcHEIC
        Rxkl3t7/ygLhfGOU6NvRywZSBeZ8/JoLkbjAKHFr6zEmkASbgIbEy2kdjCC2iICxxKuVnUwg
        RcwCjxklvtxfBdTNziEs4CyxnRmkhEVAVeLi5+Ng5bwCbhIN154zQVwhJ3H++E9miF3KEnM/
        TGOCqBGUODnzCQuIzSwgIXHwxQvmCYz8s5CkZiFJLWBkWsUoWpxaXJybbmSkl1qUmVxcnJ+n
        l5dasokRGLoHt/y22sF48LnjIUYBDkYlHt42W6FYIdbEsuLK3EOMEhzMSiK8SxMFYoV4UxIr
        q1KL8uOLSnNSiw8xSnOwKInzrvf+FyMkkJ5YkpqdmlqQWgSTZeLglGpgTHl7+c7PeZpu144s
        y/6SYNf6csW+Q669i0++2fj4yYmiNSvmhf8NZjCIC7IQMGdkM2afFV/5ui7q67OCGy6fNRMK
        5n6quJW7cs/W4FlxZV835HopreNeOdPKpKdG8+SeGj8Le501vzxm/zDzKzMTa0rwO6D713Zu
        +aNG1tnn6+fHRGir/ePuVGIpzkg01GIuKk4EAGvDUDxZAgAA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit a4dc70d46cf1 ("tipc: extend link reset criteria for stale
packet retransmission") we made link retransmission failure events
dependent on the link tolerance, and not only of the number of failed
retransmission attempts, as we did earlier. This works well. However,
keeping the original, additional criteria of 99 failed retransmissions
is now redundant, and may in some cases lead to failure detection
times in the order of minutes instead of the expected 1.5 sec link
tolerance value.

We now remove this criteria altogether.

Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/link.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index bcfb0a4..af50b53 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -107,7 +107,6 @@ struct tipc_stats {
  * @backlogq: queue for messages waiting to be sent
  * @snt_nxt: next sequence number to use for outbound messages
  * @prev_from: sequence number of most previous retransmission request
- * @stale_cnt: counter for number of identical retransmit attempts
  * @stale_limit: time when repeated identical retransmits must force link reset
  * @ackers: # of peers that needs to ack each packet before it can be released
  * @acked: # last packet acked by a certain peer. Used for broadcast.
@@ -167,7 +166,6 @@ struct tipc_link {
 	u16 snd_nxt;
 	u16 prev_from;
 	u16 window;
-	u16 stale_cnt;
 	unsigned long stale_limit;
 
 	/* Reception */
@@ -910,7 +908,6 @@ void tipc_link_reset(struct tipc_link *l)
 	l->acked = 0;
 	l->silent_intv_cnt = 0;
 	l->rst_cnt = 0;
-	l->stale_cnt = 0;
 	l->bc_peer_is_up = false;
 	memset(&l->mon_state, 0, sizeof(l->mon_state));
 	tipc_link_reset_stats(l);
@@ -1068,8 +1065,7 @@ static bool link_retransmit_failure(struct tipc_link *l, struct tipc_link *r,
 	if (r->prev_from != from) {
 		r->prev_from = from;
 		r->stale_limit = jiffies + msecs_to_jiffies(r->tolerance);
-		r->stale_cnt = 0;
-	} else if (++r->stale_cnt > 99 && time_after(jiffies, r->stale_limit)) {
+	} else if (time_after(jiffies, r->stale_limit)) {
 		pr_warn("Retransmission failure on link <%s>\n", l->name);
 		link_print(l, "State of link ");
 		pr_info("Failed msg: usr %u, typ %u, len %u, err %u\n",
@@ -1515,7 +1511,6 @@ int tipc_link_rcv(struct tipc_link *l, struct sk_buff *skb,
 
 		/* Forward queues and wake up waiting users */
 		if (likely(tipc_link_release_pkts(l, msg_ack(hdr)))) {
-			l->stale_cnt = 0;
 			tipc_link_advance_backlog(l, xmitq);
 			if (unlikely(!skb_queue_empty(&l->wakeupq)))
 				link_prepare_wakeup(l);
@@ -2584,7 +2579,7 @@ int tipc_link_dump(struct tipc_link *l, u16 dqueues, char *buf)
 	i += scnprintf(buf + i, sz - i, " %u", l->silent_intv_cnt);
 	i += scnprintf(buf + i, sz - i, " %u", l->rst_cnt);
 	i += scnprintf(buf + i, sz - i, " %u", l->prev_from);
-	i += scnprintf(buf + i, sz - i, " %u", l->stale_cnt);
+	i += scnprintf(buf + i, sz - i, " %u", 0);
 	i += scnprintf(buf + i, sz - i, " %u", l->acked);
 
 	list = &l->transmq;
-- 
2.1.4

