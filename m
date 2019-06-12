Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8563642B34
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440133AbfFLPpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:45:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440124AbfFLPpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ESAu6aZvuODjWp2FTnCWehHFMgQ6UuLRaW/KiZ0MigM=; b=mZGGswBKntob2Vks0pygiE2dk4
        /v+bdaM78rV35w3Vgtah63n7XXWschilLVGn8JkZ+Yo2n16eaaObhrGGRlDOtk6Tf4+YPiDcOYaB9
        ygqKMIHgnmSsiU2RE4V9jGjFtaWt+mPyElQ8WwHDvmPDbPP7GODjFl+qMZW7gdzqsJs8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5Qp-0005uu-W4; Wed, 12 Jun 2019 17:45:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 1/3] net: Add IF_OPER_TESTING
Date:   Wed, 12 Jun 2019 17:44:36 +0200
Message-Id: <20190612154438.22703-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612154438.22703-1-andrew@lunn.ch>
References: <20190612154438.22703-1-andrew@lunn.ch>
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
index eeacebd7debb..b1e8e2e2f9f0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -284,6 +284,7 @@ enum netdev_state_t {
 	__LINK_STATE_NOCARRIER,
 	__LINK_STATE_LINKWATCH_PENDING,
 	__LINK_STATE_DORMANT,
+	__LINK_STATE_TESTING,
 };
 
 
@@ -3809,6 +3810,46 @@ static inline bool netif_dormant(const struct net_device *dev)
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
index 7fea0fd7d6f5..ca8aa4127894 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -177,6 +177,7 @@ enum {
 enum {
 	IF_LINK_MODE_DEFAULT,
 	IF_LINK_MODE_DORMANT,	/* limit upward transition to dormant */
+	IF_LINK_MODE_TESTING,	/* limit upward transition to testing */
 };
 
 /*
diff --git a/net/core/dev.c b/net/core/dev.c
index eb7fb6daa1ef..df583040dca4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8483,6 +8483,11 @@ void netif_stacked_transfer_operstate(const struct net_device *rootdev,
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
index 04fdc9535772..cee61e52944b 100644
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
index cec60583931f..8ff7363690f2 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -825,11 +825,18 @@ static void set_operstate(struct net_device *dev, unsigned char transition)
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
2.20.1

