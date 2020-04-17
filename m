Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC411AE87C
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgDQXEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:04:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45436 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbgDQXEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 19:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bcC2F6UWuLePq6HSHxKGCa/LvP9GuTbpDW+8vhfrnX8=; b=HetiyI7WPh3jj2NbF4Ss9onnfI
        fvf/6a78efAAelW0DhdMz3ig2mOSyjRnqfmsCkr0Vdr9uIjFc7sXJoGlzcIgdkrthXusyhaeT8c1h
        4DI3w5muDpbqQa1eJ6pWVw9K+7e3CCURFa/2VqkS4lrvVBfSXe5lncWcW8IjjnRVbBLs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPa2J-003MpU-0u; Sat, 18 Apr 2020 01:04:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/3] net: Add IF_OPER_TESTING
Date:   Sat, 18 Apr 2020 01:03:48 +0200
Message-Id: <20200417230350.802675-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200417230350.802675-1-andrew@lunn.ch>
References: <20200417230350.802675-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 2863 defines the operational state testing. Add support for this
state, both as a IF_LINK_MODE_ and __LINK_STATE_.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/netdevice.h | 41 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/if.h   |  1 +
 net/core/dev.c            |  5 +++++
 net/core/link_watch.c     | 12 ++++++++++--
 net/core/rtnetlink.c      |  9 ++++++++-
 5 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 130a668049ab..0750b54b3765 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -288,6 +288,7 @@ enum netdev_state_t {
 	__LINK_STATE_NOCARRIER,
 	__LINK_STATE_LINKWATCH_PENDING,
 	__LINK_STATE_DORMANT,
+	__LINK_STATE_TESTING,
 };
 
 
@@ -3907,6 +3908,46 @@ static inline bool netif_dormant(const struct net_device *dev)
 }
 
 
+/**
+ *	netif_testing_on - mark device as under test.
+ *	@dev: network device
+ *
+ * Mark device as under test (as per RFC2863).
+ *
+ * The testing state indicates that some test(s) must be performed on
+ * the interface. After completion, of the test, the interface state
+ * will change to up, dormant, or down, as appropriate.
+ */
+static inline void netif_testing_on(struct net_device *dev)
+{
+	if (!test_and_set_bit(__LINK_STATE_TESTING, &dev->state))
+		linkwatch_fire_event(dev);
+}
+
+/**
+ *	netif_testing_off - set device as not under test.
+ *	@dev: network device
+ *
+ * Device is not in testing state.
+ */
+static inline void netif_testing_off(struct net_device *dev)
+{
+	if (test_and_clear_bit(__LINK_STATE_TESTING, &dev->state))
+		linkwatch_fire_event(dev);
+}
+
+/**
+ *	netif_testing - test if device is under test
+ *	@dev: network device
+ *
+ * Check if device is under test
+ */
+static inline bool netif_testing(const struct net_device *dev)
+{
+	return test_bit(__LINK_STATE_TESTING, &dev->state);
+}
+
+
 /**
  *	netif_oper_up - test if device is operational
  *	@dev: network device
diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
index be714cd8c826..797ba2c1562a 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -178,6 +178,7 @@ enum {
 enum {
 	IF_LINK_MODE_DEFAULT,
 	IF_LINK_MODE_DORMANT,	/* limit upward transition to dormant */
+	IF_LINK_MODE_TESTING,	/* limit upward transition to testing */
 };
 
 /*
diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..fb61522b1ce1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9136,6 +9136,11 @@ void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 	else
 		netif_dormant_off(dev);
 
+	if (rootdev->operstate == IF_OPER_TESTING)
+		netif_testing_on(dev);
+	else
+		netif_testing_off(dev);
+
 	if (netif_carrier_ok(rootdev))
 		netif_carrier_on(dev);
 	else
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index f153e0601838..75431ca9300f 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -34,6 +34,9 @@ static DEFINE_SPINLOCK(lweventlist_lock);
 
 static unsigned char default_operstate(const struct net_device *dev)
 {
+	if (netif_testing(dev))
+		return IF_OPER_TESTING;
+
 	if (!netif_carrier_ok(dev))
 		return (dev->ifindex != dev_get_iflink(dev) ?
 			IF_OPER_LOWERLAYERDOWN : IF_OPER_DOWN);
@@ -55,11 +58,15 @@ static void rfc2863_policy(struct net_device *dev)
 	write_lock_bh(&dev_base_lock);
 
 	switch(dev->link_mode) {
+	case IF_LINK_MODE_TESTING:
+		if (operstate == IF_OPER_UP)
+			operstate = IF_OPER_TESTING;
+		break;
+
 	case IF_LINK_MODE_DORMANT:
 		if (operstate == IF_OPER_UP)
 			operstate = IF_OPER_DORMANT;
 		break;
-
 	case IF_LINK_MODE_DEFAULT:
 	default:
 		break;
@@ -74,7 +81,8 @@ static void rfc2863_policy(struct net_device *dev)
 void linkwatch_init_dev(struct net_device *dev)
 {
 	/* Handle pre-registration link state changes */
-	if (!netif_carrier_ok(dev) || netif_dormant(dev))
+	if (!netif_carrier_ok(dev) || netif_dormant(dev) ||
+	    netif_testing(dev))
 		rfc2863_policy(dev);
 }
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 709ebbf8ab5b..d6f4f4a9e8ba 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -829,11 +829,18 @@ static void set_operstate(struct net_device *dev, unsigned char transition)
 	switch (transition) {
 	case IF_OPER_UP:
 		if ((operstate == IF_OPER_DORMANT ||
+		     operstate == IF_OPER_TESTING ||
 		     operstate == IF_OPER_UNKNOWN) &&
-		    !netif_dormant(dev))
+		    !netif_dormant(dev) && !netif_testing(dev))
 			operstate = IF_OPER_UP;
 		break;
 
+	case IF_OPER_TESTING:
+		if (operstate == IF_OPER_UP ||
+		    operstate == IF_OPER_UNKNOWN)
+			operstate = IF_OPER_TESTING;
+		break;
+
 	case IF_OPER_DORMANT:
 		if (operstate == IF_OPER_UP ||
 		    operstate == IF_OPER_UNKNOWN)
-- 
2.26.1

