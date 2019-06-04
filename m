Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B483437A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 11:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfFDJpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 05:45:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfFDJpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 05:45:05 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8DA9130C0DCF;
        Tue,  4 Jun 2019 09:45:05 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A4F460579;
        Tue,  4 Jun 2019 09:45:04 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net v2] net: fix indirect calls helpers for ptype list hooks.
Date:   Tue,  4 Jun 2019 11:44:06 +0200
Message-Id: <678856f4fc73bbcd0de07a97c9d59996b6b8b585.1559641396.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 04 Jun 2019 09:45:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Eric noted, the current wrapper for ptype func hook inside
__netif_receive_skb_list_ptype() has no chance of avoiding the indirect
call: we enter such code path only for protocols other than ipv4 and
ipv6.

Instead we can wrap the list_func invocation.

v1 -> v2:
 - use the correct fix tag

Fixes: f5737cbadb7d ("net: use indirect calls helpers for ptype hook")
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Edward Cree <ecree@solarflare.com>
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

