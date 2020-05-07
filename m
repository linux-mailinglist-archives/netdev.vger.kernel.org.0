Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BFD1C9692
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgEGQcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726950AbgEGQcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 12:32:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3591C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 09:32:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e2so7507879ybm.19
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 09:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0tu1ANcsWVe4ayH5C9esW2XN9o8n68oE5qf1RzVYegQ=;
        b=oyEynPw20mua2PKlOoXS5ZXzX1oswxb7+faEMn0fifizYwQQRYyB3Geo0n4hNnk7FZ
         1m1GoukpGi7XH0HWpMQcX3HFxwcs0spy9I5WE86f3mOaHY4sCQdGcsVhuoXyt4Qa41aA
         KGVPBfRSaJphJ8Qh0i7p2Y/AC/eu9T9sVq0ID07if+19VQuQ+VronbPpIK6VHo0fFA0J
         8W+VuxYtkp7RPTSIQeXRXvNC+E4OMuj3edlCW7/8OY8m5Jzajg/n09rCpnCQ2zSfyh+p
         emPcpKnpI4W28RT4VOc3CW4NH6/09HDzyiPXiNWrDIrGWCZQxaeOVYGima3XDw60+MLT
         Hnvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0tu1ANcsWVe4ayH5C9esW2XN9o8n68oE5qf1RzVYegQ=;
        b=jYjzcMLgmqZtz8t/usCoT2MznVQRi1VdtKMBrW64qw/+T+Cw1CLxJumqKcJAlOGPIO
         tWAVPZVRwM0S1GNsI5niAWy4dNtgDFrefXye+XWRUHRO3DksDAAxFTRpm90xkNnHMtLk
         rFAztS0sns9/ds4bT3wmH4avRn0R2faKYxbkPT1wBm56dmRS2itVUrfKHM9NenVxAPoJ
         gQgNCSbMkZbikCYLp0j1uiOJeNakglYny2kw8DOpk/Tov6W0VMnwTR1yudN4sJ6TUXkH
         NymyONMBhJDvHw1xG1Sx0XxVNTXiUbheO7al0IWzAk0eC2j3NCydVa/SGCKlyC/HM3Z9
         newg==
X-Gm-Message-State: AGi0PuaRPZeXrqkK6iwoM3N4aU9FnOCKDS3sF4+vsePBEXZ1dXw/Geg8
        iBbxCLcmJev4vtsA5/Im7wthi8hkUmjjzg==
X-Google-Smtp-Source: APiQypLZ6GcHCoSuL3xBO8Aq55IibtXaGIQ7u8i+TqqmGo0WTcq+Zr2OBpWJxS9Y5dqJmxeLXaaRifhWXrfc+w==
X-Received: by 2002:a25:260d:: with SMTP id m13mr19831716ybm.39.1588869150052;
 Thu, 07 May 2020 09:32:30 -0700 (PDT)
Date:   Thu,  7 May 2020 09:32:19 -0700
In-Reply-To: <20200507163222.122469-1-edumazet@google.com>
Message-Id: <20200507163222.122469-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200507163222.122469-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 2/5] netpoll: move netpoll_send_skb() out of line
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

There is no need to inline this helper, as we intend to add more
code in this function.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netpoll.h |  9 +--------
 net/core/netpoll.c      | 13 +++++++++++--
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index 00e0bae3d402e7388742373e81600e962c945ea5..e466ddffef61d6a8b1a70e40f7282540cb7d1cf5 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -63,14 +63,7 @@ int netpoll_setup(struct netpoll *np);
 void __netpoll_cleanup(struct netpoll *np);
 void __netpoll_free(struct netpoll *np);
 void netpoll_cleanup(struct netpoll *np);
-void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb);
-static inline void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
-{
-	unsigned long flags;
-	local_irq_save(flags);
-	__netpoll_send_skb(np, skb);
-	local_irq_restore(flags);
-}
+void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb);
 
 #ifdef CONFIG_NETPOLL
 static inline void *netpoll_poll_lock(struct napi_struct *napi)
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index c5059b7ffc9446e2c777c2b81f0ae59882d6f265..34cd34f244236b3e9973a1baf118136342850281 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -305,7 +305,7 @@ static int netpoll_owner_active(struct net_device *dev)
 }
 
 /* call with IRQ disabled */
-void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
+static void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	netdev_tx_t status = NETDEV_TX_BUSY;
 	struct net_device *dev;
@@ -360,7 +360,16 @@ void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}
 }
-EXPORT_SYMBOL(__netpoll_send_skb);
+
+void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__netpoll_send_skb(np, skb);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(netpoll_send_skb);
 
 void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 {
-- 
2.26.2.526.g744177e7f7-goog

