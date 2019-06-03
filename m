Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C507132DDE
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 12:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfFCKrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 06:47:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727190AbfFCKrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 06:47:03 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC9A23107B1A;
        Mon,  3 Jun 2019 10:46:52 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCDD61001E73;
        Mon,  3 Jun 2019 10:46:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] net: fix indirect calls helpers for ptype list hooks.
Date:   Mon,  3 Jun 2019 12:46:43 +0200
Message-Id: <656fbe8fb21ca156d227cb012e65d017c62a1a91.1559558702.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 03 Jun 2019 10:47:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Eric noted, the current wrapper for ptype func hook inside
__netif_receive_skb_list_ptype() has no chance of avoiding the indirect
call: we enter such code path only for protocols other than ipv4 and
ipv6.

Instead we can wrap the list_func invocation.

Fixes: 92884ca8830b ("net: fix indirect calls helpers for ptype list hooks.")
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 66f7508825bd..1c4593ec4409 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5025,12 +5025,12 @@ static inline void __netif_receive_skb_list_ptype(struct list_head *head,
 	if (list_empty(head))
 		return;
 	if (pt_prev->list_func != NULL)
-		pt_prev->list_func(head, pt_prev, orig_dev);
+		INDIRECT_CALL_INET(pt_prev->list_func, ipv6_list_rcv,
+				   ip_list_rcv, head, pt_prev, orig_dev);
 	else
 		list_for_each_entry_safe(skb, next, head, list) {
 			skb_list_del_init(skb);
-			INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
-					   skb->dev, pt_prev, orig_dev);
+			pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
 		}
 }
 
-- 
2.20.1

