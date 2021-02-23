Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E28322593
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 06:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhBWFyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 00:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhBWFyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 00:54:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAE2C06178B
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 21:53:39 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lEQdP-0005FQ-Hu; Tue, 23 Feb 2021 06:53:23 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lEQdO-00012H-Dz; Tue, 23 Feb 2021 06:53:22 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net v2 1/2] skbuff: skb_clone_sk_optional(): add function to always clone a skb and increase refcount on sk if valid
Date:   Tue, 23 Feb 2021 06:53:19 +0100
Message-Id: <20210223055321.3891-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210223055321.3891-1-o.rempel@pengutronix.de>
References: <20210223055321.3891-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There already the function skb_clone_sk(), which clones the skb, but
only if the sk is valid.

There are several users in the networking stack, which always need a
clone of a skb with the sk refcount incremented (but only if the sk is
valid). This patch adds such a function.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/linux/skbuff.h |  1 +
 net/core/skbuff.c      | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6d0a33d1c0db..99d552017508 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3874,6 +3874,7 @@ static inline void skb_metadata_clear(struct sk_buff *skb)
 	skb_metadata_set(skb, 0);
 }
 
+struct sk_buff *skb_clone_sk_optional(struct sk_buff *skb);
 struct sk_buff *skb_clone_sk(struct sk_buff *skb);
 
 #ifdef CONFIG_NETWORK_PHY_TIMESTAMPING
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 545a472273a5..97341f173fb0 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4671,6 +4671,33 @@ struct sk_buff *sock_dequeue_err_skb(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_dequeue_err_skb);
 
+/**
+ * skb_clone_sk_optional - create clone of skb, and take reference to socket if
+ *                         socket is referenced in original skb
+ * @skb: the skb to clone
+ *
+ * This function always creates a clone of a buffer. If it that holds a valid
+ * reference on sk_refcnt this is increased.
+ */
+struct sk_buff *skb_clone_sk_optional(struct sk_buff *skb)
+{
+	struct sock *sk = skb->sk;
+	struct sk_buff *clone;
+
+	clone = skb_clone(skb, GFP_ATOMIC);
+	if (!clone)
+		return NULL;
+
+	if (!sk || !refcount_inc_not_zero(&sk->sk_refcnt))
+		return clone;
+
+	clone->sk = sk;
+	clone->destructor = sock_efree;
+
+	return clone;
+}
+EXPORT_SYMBOL(skb_clone_sk_optional);
+
 /**
  * skb_clone_sk - create clone of skb, and take reference to socket
  * @skb: the skb to clone
-- 
2.29.2

