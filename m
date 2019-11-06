Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3391EF14AC
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 12:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfKFLMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 06:12:31 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32960 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725890AbfKFLMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 06:12:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 8615A49141;
        Wed,  6 Nov 2019 22:12:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1573038745; bh=nsPVx
        +Gy/eCt7BO6nj9LsG0kBPo04HarGc4MmuqLquQ=; b=ey7EWWcLurejZxa97zGjY
        /YZh7D546VpAUheXMl/e+FsK43blno8xLnsQCztY5/ryqCZ2fwzgrNcjAigStvjB
        cdRQpxa5wIk3D/z5PGZ14LniF5jXj1yM5O46tsgr8WukB0RK/hl2eHoUDRD9faga
        c7XSYMVZsIvrQcgzQHezZ4=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id A7rQPwA9KJry; Wed,  6 Nov 2019 22:12:25 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 2DBCA4945B;
        Wed,  6 Nov 2019 22:12:24 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id BFE4F49141;
        Wed,  6 Nov 2019 22:12:23 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next] tipc: eliminate the dummy packet in link synching
Date:   Wed,  6 Nov 2019 18:12:17 +0700
Message-Id: <20191106111217.23178-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When preparing tunnel packets for the link failover or synchronization,
as for the safe algorithm, we added a dummy packet on the pair link but
never sent it out. In the case of failover, the pair link will be reset
anyway. But for link synching, it will always result in retransmission
of the dummy packet after that.
We have also observed that such the retransmission at the early stage
when a new node comes in a large cluster will take some time and hard
to be done, leading to the repeated retransmit failures and the link is
reset.

Since in commit 4929a932be33 ("tipc: optimize link synching mechanism")
we have already built a dummy 'TUNNEL_PROTOCOL' message on the new link
for the synchronization, there's no need for the dummy on the pair one,
this commit will skip it when the new mechanism takes in place. In case
nothing exists in the pair link's transmq, the link synching will just
start and stop shortly on the peer side.

The patch is backward compatible.

Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Tested-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/link.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 999eab592de8..7e36b7ba61a9 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1728,21 +1728,6 @@ void tipc_link_tnl_prepare(struct tipc_link *l, struct tipc_link *tnl,
 		return;
 
 	__skb_queue_head_init(&tnlq);
-	__skb_queue_head_init(&tmpxq);
-	__skb_queue_head_init(&frags);
-
-	/* At least one packet required for safe algorithm => add dummy */
-	skb = tipc_msg_create(TIPC_LOW_IMPORTANCE, TIPC_DIRECT_MSG,
-			      BASIC_H_SIZE, 0, l->addr, tipc_own_addr(l->net),
-			      0, 0, TIPC_ERR_NO_PORT);
-	if (!skb) {
-		pr_warn("%sunable to create tunnel packet\n", link_co_err);
-		return;
-	}
-	__skb_queue_tail(&tnlq, skb);
-	tipc_link_xmit(l, &tnlq, &tmpxq);
-	__skb_queue_purge(&tmpxq);
-
 	/* Link Synching:
 	 * From now on, send only one single ("dummy") SYNCH message
 	 * to peer. The SYNCH message does not contain any data, just
@@ -1768,6 +1753,20 @@ void tipc_link_tnl_prepare(struct tipc_link *l, struct tipc_link *tnl,
 		return;
 	}
 
+	__skb_queue_head_init(&tmpxq);
+	__skb_queue_head_init(&frags);
+	/* At least one packet required for safe algorithm => add dummy */
+	skb = tipc_msg_create(TIPC_LOW_IMPORTANCE, TIPC_DIRECT_MSG,
+			      BASIC_H_SIZE, 0, l->addr, tipc_own_addr(l->net),
+			      0, 0, TIPC_ERR_NO_PORT);
+	if (!skb) {
+		pr_warn("%sunable to create tunnel packet\n", link_co_err);
+		return;
+	}
+	__skb_queue_tail(&tnlq, skb);
+	tipc_link_xmit(l, &tnlq, &tmpxq);
+	__skb_queue_purge(&tmpxq);
+
 	/* Initialize reusable tunnel packet header */
 	tipc_msg_init(tipc_own_addr(l->net), &tnlhdr, TUNNEL_PROTOCOL,
 		      mtyp, INT_H_SIZE, l->addr);
-- 
2.13.7

