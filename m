Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C721C9694
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgEGQcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726636AbgEGQce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 12:32:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54699C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 09:32:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r14so7556122ybk.21
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 09:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IxTaS4yjMivR/k8dwfX3FfHEKPX2fe6BkpEJCTnKwzk=;
        b=e0stjhR5oSIrFlTbl3tYUETyhxUYl/eQFjw38ch+oiKOjnL6jMip190P/tOWTLfg88
         mhlipGVc2iQ99WWJNo85LhbYIZ25O3yXEj0O9XU31/skjBwTSFrzlWQwKkmcbq7X2m2b
         a1mNVdUzZCmubvr+tw0ibyPx3NKf3M71y28SAHlBSOy1CMad8LdYhvM0JAgKbL9DYPnq
         DfpUiJDqaGTb0o+HIcfkvKJO91G5o9mWr15HNAitAxHZi4dJ4iPVL1g8CgdLoasrhjzw
         6HjyHNnvoPMutrsuDjjW6U+PANFejwx1pum4XJJT9yqMw/7h3sgcnDGKioDktetrkZqp
         I5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IxTaS4yjMivR/k8dwfX3FfHEKPX2fe6BkpEJCTnKwzk=;
        b=cyxQ0QVCXOMyjXX7CPN5FUsc01FSThJFK+fEgwFZ7+wPXTLw6tb9tTt+WUl6MWWfyy
         5TFryJGHuyvqA7VxrMMJZmxwudZDCme9OgnHTDkEjFvY7rGeB5LbCRpNuT3Sx8QeVob+
         WriADI9gtg1SXqSTEM0bGs/1ybN93smwNPngr7mq3eSv4zzGR/3B4xKePARfHGyXtrH4
         TvkA3yz92LrImoo3rGdKZ3uK+Rnf98SNT33MQMAt07hg95f+ccN7AZ1lkBxI8iDoFszG
         Y+pTtxBvIdwjZbo38VArEjt4l5Nm6LsJujf2dLbVE3ImaASgbO68jPHYZWw28M6ISY+u
         0VkA==
X-Gm-Message-State: AGi0PuaSKF9gjANHWH59fdPg/IK9kGQm9Dkk8E1FQcXiHBpItIbnLnEb
        /WbmE0ndHrsbza5uYGgR+KHZg5+KS/OBgA==
X-Google-Smtp-Source: APiQypKTjOGqaQrMOcfeCBJXMDnk8YNZ0NQHV1eDDEdkF5PWLVj1HgWYT1qi4U+KKzV9ujRLvl+IY8Whuz0GCQ==
X-Received: by 2002:a25:b9cd:: with SMTP id y13mr2426725ybj.433.1588869152574;
 Thu, 07 May 2020 09:32:32 -0700 (PDT)
Date:   Thu,  7 May 2020 09:32:20 -0700
In-Reply-To: <20200507163222.122469-1-edumazet@google.com>
Message-Id: <20200507163222.122469-4-edumazet@google.com>
Mime-Version: 1.0
References: <20200507163222.122469-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 3/5] netpoll: netpoll_send_skb() returns transmit status
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

Some callers want to know if the packet has been sent or
dropped, to inform upper stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netpoll.h |  2 +-
 net/core/netpoll.c      | 11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index e466ddffef61d6a8b1a70e40f7282540cb7d1cf5..f47af135bd56c1927ee2d15c2a20f5467e9b22a7 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -63,7 +63,7 @@ int netpoll_setup(struct netpoll *np);
 void __netpoll_cleanup(struct netpoll *np);
 void __netpoll_free(struct netpoll *np);
 void netpoll_cleanup(struct netpoll *np);
-void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb);
+netdev_tx_t netpoll_send_skb(struct netpoll *np, struct sk_buff *skb);
 
 #ifdef CONFIG_NETPOLL
 static inline void *netpoll_poll_lock(struct napi_struct *napi)
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 34cd34f244236b3e9973a1baf118136342850281..40d2753aa47dd0b83a10a97bb4bacccbc1aaf085 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -305,7 +305,7 @@ static int netpoll_owner_active(struct net_device *dev)
 }
 
 /* call with IRQ disabled */
-static void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
+static netdev_tx_t __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	netdev_tx_t status = NETDEV_TX_BUSY;
 	struct net_device *dev;
@@ -320,7 +320,7 @@ static void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 
 	if (!npinfo || !netif_running(dev) || !netif_device_present(dev)) {
 		dev_kfree_skb_irq(skb);
-		return;
+		return NET_XMIT_DROP;
 	}
 
 	/* don't get messages out of order, and no recursion */
@@ -359,15 +359,18 @@ static void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 		skb_queue_tail(&npinfo->txq, skb);
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}
+	return NETDEV_TX_OK;
 }
 
-void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
+netdev_tx_t netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	unsigned long flags;
+	netdev_tx_t ret;
 
 	local_irq_save(flags);
-	__netpoll_send_skb(np, skb);
+	ret = __netpoll_send_skb(np, skb);
 	local_irq_restore(flags);
+	return ret;
 }
 EXPORT_SYMBOL(netpoll_send_skb);
 
-- 
2.26.2.526.g744177e7f7-goog

