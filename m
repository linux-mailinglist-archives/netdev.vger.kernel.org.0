Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C09130CE
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfECPBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:01:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43238 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbfECPBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 11:01:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 20936314CE42;
        Fri,  3 May 2019 15:01:48 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A2C850C0A;
        Fri,  3 May 2019 15:01:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/4] net: use indirect calls helpers for ptype hook
Date:   Fri,  3 May 2019 17:01:36 +0200
Message-Id: <e49a56bf6b08ec729f302aeeaba88ef7cd2a3a45.1556889691.git.pabeni@redhat.com>
In-Reply-To: <cover.1556889691.git.pabeni@redhat.com>
References: <cover.1556889691.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 03 May 2019 15:01:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This avoids an indirect call per RX IPv6/IPv4 packet.
Note that we don't want to use the indirect calls helper for taps.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/dev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 22f2640f559a..108ac8137b9b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4987,7 +4987,8 @@ static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
 
 	ret = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
 	if (pt_prev)
-		ret = pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
+		ret = INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
+					 skb->dev, pt_prev, orig_dev);
 	return ret;
 }
 
@@ -5033,7 +5034,8 @@ static inline void __netif_receive_skb_list_ptype(struct list_head *head,
 	else
 		list_for_each_entry_safe(skb, next, head, list) {
 			skb_list_del_init(skb);
-			pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
+			INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
+					   skb->dev, pt_prev, orig_dev);
 		}
 }
 
-- 
2.20.1

