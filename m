Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878B01C2FE2
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgECWMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726825AbgECWMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:12:38 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539EBC061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:12:38 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 188so6242467wmc.2
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h1oqX0qcoFjTmmxWh5ubwYlhJBrdMiwB/36cUe6fTFQ=;
        b=DVdIz2RXx0BeKGBI4pc/Ajt30Qpv5RbSfQAE6L6UWzB4j4O5nFHqty5yaqZ3LKaxfs
         sFTnlx+EwiYCOMpsmIVs/adyqPMoL0UmKHneJ0TbPWGbii3vJeE8r24iPDRBDVJHk4mt
         WSuSXT5xJsrwTh/f8HuZp5HT2OL6nnOyqvfT5ruQe3iHZdl8I8C95UiGZMdJvfJFyFrY
         V01VGpG1TopL8jhWm9NY1Oo8A00E49nQqu99dTffqjBd/kdDXCoOsCszHrIFe26Ra6hs
         Z8IKYC8KjHAh259sd7FckIzuHQ3+VGzqgG6rQdHAQR7A/ATSdg28dLJotADoEryAnbYC
         7x5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h1oqX0qcoFjTmmxWh5ubwYlhJBrdMiwB/36cUe6fTFQ=;
        b=W/Z0eN3DGBYjLAJF0ps91+Kqehs77dLsjdvuMp/a6XD8VAEa19bSQv31HWtciogRI6
         kUCf/POTVxXq3G9OXvI7yAX6zR6sDdNgTr6fpxCs2VuPrg11iOqZdVP6haKuNSZXnaxv
         AKpqAQGnBInl+B90H0jwm+AOW2joQtTTw2bBaVCe1g9zzdnuk3Oo6qHKVe5Xdxp6ghSq
         Cz9P07FJB/eUnixgbr1vzaoby/O7ZJdWNDFVP7NjKDAlQyeoFfbzli7SOq7auToqTYZn
         V6VizZ8myCAlyP7v2mg1h3FgE0xSHx5REFUaL8B4J7Nbrk7DekJTVWBSvTFtpBJIbOc2
         XLqA==
X-Gm-Message-State: AGi0Pub1cTghWL3wk1nl0EnX5VRGJR1Q1fqbZqmwm/rPs1dhrt8lhZQY
        HeSh31N2yL5CkBhSarqWBu4=
X-Google-Smtp-Source: APiQypJTlHFMtLbW/Q1ze7Q0NVCczjZZG+otPmIlgLqkp5WXnd5hwPguCK2rdthkn1fxuWDbx6Pniw==
X-Received: by 2002:a7b:c3ca:: with SMTP id t10mr10933640wmj.94.1588543956852;
        Sun, 03 May 2020 15:12:36 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id q143sm10692188wme.31.2020.05.03.15.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 15:12:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, mingkai.hu@nxp.com
Subject: [PATCH v3 net-next 1/4] net: bridge: allow enslaving some DSA master network devices
Date:   Mon,  4 May 2020 01:12:25 +0300
Message-Id: <20200503221228.10928-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503221228.10928-1-olteanv@gmail.com>
References: <20200503221228.10928-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Commit 8db0a2ee2c63 ("net: bridge: reject DSA-enabled master netdevices
as bridge members") added a special check in br_if.c in order to check
for a DSA master network device with a tagging protocol configured. This
was done because back then, such devices, once enslaved in a bridge
would become inoperative and would not pass DSA tagged traffic anymore
due to br_handle_frame returning RX_HANDLER_CONSUMED.

But right now we have valid use cases which do require bridging of DSA
masters. One such example is when the DSA master ports are DSA switch
ports themselves (in a disjoint tree setup). This should be completely
equivalent, functionally speaking, from having multiple DSA switches
hanging off of the ports of a switchdev driver. So we should allow the
enslaving of DSA tagged master network devices.

Instead of the regular br_handle_frame(), install a new function
br_handle_frame_dummy() on these DSA masters, which returns
RX_HANDLER_PASS in order to call into the DSA specific tagging protocol
handlers, and lift the restriction from br_add_if.

Suggested-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
Changes in v3:
None.

Changes in v2:
* Removed the hotpath netdev_uses_dsa check and installed a dummy
  rx_handler for such net devices.
* Improved the check of which DSA master net devices are able to be
  bridged and which aren't.
* At this stage, the patch is different enough from where I took it from
  (aka https://github.com/ffainelli/linux/commit/75618cea75ada8d9eef7936c002b5ec3dd3e4eac)
  that I just added my authorship to it).

 include/net/dsa.h       |  2 +-
 net/bridge/br_if.c      | 32 +++++++++++++++++++++++---------
 net/bridge/br_input.c   | 23 ++++++++++++++++++++++-
 net/bridge/br_private.h |  6 +++---
 4 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fb3f9222f2a1..3c0ae84156c8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -650,7 +650,7 @@ struct dsa_switch_driver {
 struct net_device *dsa_dev_to_net_device(struct device *dev);
 
 /* Keep inline for faster access in hot path */
-static inline bool netdev_uses_dsa(struct net_device *dev)
+static inline bool netdev_uses_dsa(const struct net_device *dev)
 {
 #if IS_ENABLED(CONFIG_NET_DSA)
 	return dev->dsa_ptr && dev->dsa_ptr->rcv;
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index ca685c0cdf95..a0e9a7937412 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -563,18 +563,32 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	unsigned br_hr, dev_hr;
 	bool changed_addr;
 
-	/* Don't allow bridging non-ethernet like devices, or DSA-enabled
-	 * master network devices since the bridge layer rx_handler prevents
-	 * the DSA fake ethertype handler to be invoked, so we do not strip off
-	 * the DSA switch tag protocol header and the bridge layer just return
-	 * RX_HANDLER_CONSUMED, stopping RX processing for these frames.
-	 */
+	/* Don't allow bridging non-ethernet like devices. */
 	if ((dev->flags & IFF_LOOPBACK) ||
 	    dev->type != ARPHRD_ETHER || dev->addr_len != ETH_ALEN ||
-	    !is_valid_ether_addr(dev->dev_addr) ||
-	    netdev_uses_dsa(dev))
+	    !is_valid_ether_addr(dev->dev_addr))
 		return -EINVAL;
 
+	/* Also don't allow bridging of net devices that are DSA masters, since
+	 * the bridge layer rx_handler prevents the DSA fake ethertype handler
+	 * to be invoked, so we don't get the chance to strip off and parse the
+	 * DSA switch tag protocol header (the bridge layer just returns
+	 * RX_HANDLER_CONSUMED, stopping RX processing for these frames).
+	 * The only case where that would not be an issue is when bridging can
+	 * already be offloaded, such as when the DSA master is itself a DSA
+	 * or plain switchdev port, and is bridged only with other ports from
+	 * the same hardware device.
+	 */
+	if (netdev_uses_dsa(dev)) {
+		list_for_each_entry(p, &br->port_list, list) {
+			if (!netdev_port_same_parent_id(dev, p->dev)) {
+				NL_SET_ERR_MSG(extack,
+					       "Cannot do software bridging with a DSA master");
+				return -EINVAL;
+			}
+		}
+	}
+
 	/* No bridging of bridges */
 	if (dev->netdev_ops->ndo_start_xmit == br_dev_xmit) {
 		NL_SET_ERR_MSG(extack,
@@ -618,7 +632,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	if (err)
 		goto err3;
 
-	err = netdev_rx_handler_register(dev, br_handle_frame, p);
+	err = netdev_rx_handler_register(dev, br_get_rx_handler(dev), p);
 	if (err)
 		goto err4;
 
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index d5c34f36f0f4..59a318b9f646 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -17,6 +17,7 @@
 #endif
 #include <linux/neighbour.h>
 #include <net/arp.h>
+#include <net/dsa.h>
 #include <linux/export.h>
 #include <linux/rculist.h>
 #include "br_private.h"
@@ -257,7 +258,7 @@ static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
  * Return NULL if skb is handled
  * note: already called with rcu_read_lock
  */
-rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
+static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 {
 	struct net_bridge_port *p;
 	struct sk_buff *skb = *pskb;
@@ -359,3 +360,23 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 	}
 	return RX_HANDLER_CONSUMED;
 }
+
+/* This function has no purpose other than to appease the br_port_get_rcu/rtnl
+ * helpers which identify bridged ports according to the rx_handler installed
+ * on them (so there _needs_ to be a bridge rx_handler even if we don't need it
+ * to do anything useful). This bridge won't support traffic to/from the stack,
+ * but only hardware bridging. So return RX_HANDLER_PASS so we don't steal
+ * frames from the ETH_P_XDSA packet_type handler.
+ */
+static rx_handler_result_t br_handle_frame_dummy(struct sk_buff **pskb)
+{
+	return RX_HANDLER_PASS;
+}
+
+rx_handler_func_t *br_get_rx_handler(const struct net_device *dev)
+{
+	if (netdev_uses_dsa(dev))
+		return br_handle_frame_dummy;
+
+	return br_handle_frame;
+}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c35647cb138a..0defc2ff365f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -705,16 +705,16 @@ int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
 
 /* br_input.c */
 int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
-rx_handler_result_t br_handle_frame(struct sk_buff **pskb);
+rx_handler_func_t *br_get_rx_handler(const struct net_device *dev);
 
 static inline bool br_rx_handler_check_rcu(const struct net_device *dev)
 {
-	return rcu_dereference(dev->rx_handler) == br_handle_frame;
+	return rcu_dereference(dev->rx_handler) == br_get_rx_handler(dev);
 }
 
 static inline bool br_rx_handler_check_rtnl(const struct net_device *dev)
 {
-	return rcu_dereference_rtnl(dev->rx_handler) == br_handle_frame;
+	return rcu_dereference_rtnl(dev->rx_handler) == br_get_rx_handler(dev);
 }
 
 static inline struct net_bridge_port *br_port_get_check_rcu(const struct net_device *dev)
-- 
2.17.1

