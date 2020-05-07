Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9052A1C9693
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgEGQca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726393AbgEGQca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 12:32:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9AAC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 09:32:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i2so7248302ybg.17
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 09:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zeGPKskZNg7xzx9oQOqcfGVAIVAnt39IEvTs0OFD+1k=;
        b=TBZoueCU8vcoHPdonzciDT9l7Dcjkx1hVrWza4Pd8ou3BIvqdai4CTVNYNdd4xuNzp
         A10+U/COdRLIfPQMs9wt4wE6KOL29ErmESfVLDnaLUHDK7Q50vmZRUKVagM4q470HC0h
         Qb9ryzS4C3TcO41IDMjEeHczVDaM86a0K9WgP35lH3kQmWU7uiFVoA+bcyNX+LtP3JIw
         TwVTgom2OeVj6RaOGFnMxvk27kdsoiAQlpjwVhnIcU4LuC7tRg19CMtZLQkajoa2eYbS
         VxUYAU32R1FPeCLVZ3f1Yz5oKgw8LCcNAQUojyliYK1SDl3SBYm3I/9bth8g0KJN3+xI
         EtCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zeGPKskZNg7xzx9oQOqcfGVAIVAnt39IEvTs0OFD+1k=;
        b=lO2/5AD3l0JK2vsMRUVjz0pMRu6UWjRtqBW/WTbKtM/6PYPlCRd6FHUcq7Te+5slrM
         VmTw1XmXIrN9hovxvVwH7mu2301T2IOFVJtF07BBHTdlW3pOFJV7q98TKckXjD1OcpfC
         8PV+mRfQI8njdosp3HeshxV9eBSHba66HljgSyCf7KRqj92OWtOZudrOIhVcomRXvMma
         7n7BQ9+Nz8WOlBZoZysSEweXw2CGRdrf8Q6U1J/TX1tmmcXEdrcJ/Y0fN4CdVLJfo6LZ
         szpDmteXIXA/1TbuS4hiSKIzjYBlv3/mmo4Y5Y7MWiY82PfpQ+Z4JZaInsjiVoqkyRZt
         KYQg==
X-Gm-Message-State: AGi0PuaZxi6YPD3jOW2KrZ2dV1430RXBSr/TpLU79RwWUm5jkCC1PebX
        AVPwHW3PFCRJ9CkBmFCspEIEHUohqqShpQ==
X-Google-Smtp-Source: APiQypILgQubyjXuefr8D6nPiQQfXwJf+ZjwE0hMRgxJ+qWIXwTBI+QAk7YBZm9GoEVeYI7rD7c69PzcAkJMbQ==
X-Received: by 2002:a25:ac19:: with SMTP id w25mr21638634ybi.185.1588869147783;
 Thu, 07 May 2020 09:32:27 -0700 (PDT)
Date:   Thu,  7 May 2020 09:32:18 -0700
In-Reply-To: <20200507163222.122469-1-edumazet@google.com>
Message-Id: <20200507163222.122469-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200507163222.122469-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 1/5] netpoll: remove dev argument from netpoll_send_skb_on_dev()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netpoll_send_skb_on_dev() can get the device pointer directly from np->dev

Rename it to __netpoll_send_skb()

Following patch will move netpoll_send_skb() out-of-line.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netpoll.h |  5 ++---
 net/core/netpoll.c      | 10 ++++++----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index 676f1ff161a98cd185d2f8cfff561779722fab29..00e0bae3d402e7388742373e81600e962c945ea5 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -63,13 +63,12 @@ int netpoll_setup(struct netpoll *np);
 void __netpoll_cleanup(struct netpoll *np);
 void __netpoll_free(struct netpoll *np);
 void netpoll_cleanup(struct netpoll *np);
-void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
-			     struct net_device *dev);
+void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb);
 static inline void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	unsigned long flags;
 	local_irq_save(flags);
-	netpoll_send_skb_on_dev(np, skb, np->dev);
+	__netpoll_send_skb(np, skb);
 	local_irq_restore(flags);
 }
 
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 15b366a1a9585f1aa15d642f208b0f4ae6effa34..c5059b7ffc9446e2c777c2b81f0ae59882d6f265 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -305,17 +305,19 @@ static int netpoll_owner_active(struct net_device *dev)
 }
 
 /* call with IRQ disabled */
-void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
-			     struct net_device *dev)
+void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	netdev_tx_t status = NETDEV_TX_BUSY;
+	struct net_device *dev;
 	unsigned long tries;
 	/* It is up to the caller to keep npinfo alive. */
 	struct netpoll_info *npinfo;
 
 	lockdep_assert_irqs_disabled();
 
-	npinfo = rcu_dereference_bh(np->dev->npinfo);
+	dev = np->dev;
+	npinfo = rcu_dereference_bh(dev->npinfo);
+
 	if (!npinfo || !netif_running(dev) || !netif_device_present(dev)) {
 		dev_kfree_skb_irq(skb);
 		return;
@@ -358,7 +360,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}
 }
-EXPORT_SYMBOL(netpoll_send_skb_on_dev);
+EXPORT_SYMBOL(__netpoll_send_skb);
 
 void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 {
-- 
2.26.2.526.g744177e7f7-goog

