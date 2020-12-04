Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2EF2CF101
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgLDPrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730395AbgLDPrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 10:47:18 -0500
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53122C061A55
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 07:46:38 -0800 (PST)
Received: from kero.packetmixer.de (p200300c59716c1e0c1b6a3b925be22c4.dip0.t-ipconnect.de [IPv6:2003:c5:9716:c1e0:c1b6:a3b9:25be:22c4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 23AF1174062;
        Fri,  4 Dec 2020 16:46:34 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/8] batman-adv: Prepare infrastructure for newlink settings
Date:   Fri,  4 Dec 2020 16:46:26 +0100
Message-Id: <20201204154631.21063-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201204154631.21063-1-sw@simonwunderlich.de>
References: <20201204154631.21063-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The batadv generic netlink family can be used to retrieve the current state
and set various configuration settings. But there are also settings which
must be set before the actual interface is created.

The rtnetlink already uses IFLA_INFO_DATA to allow net_device families to
transfer such configurations. The minimal required functionality for this
is now available for the batadv rtnl_link_ops. Also a new IFLA class of
attributes will be attached to it because rtnetlink only allows 51
different attributes but batadv_nl_attrs already contains 62 attributes.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 include/uapi/linux/batman_adv.h | 20 +++++++++++++++++
 net/batman-adv/soft-interface.c | 39 +++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/uapi/linux/batman_adv.h b/include/uapi/linux/batman_adv.h
index bb0ae945b36a..b05399d8a127 100644
--- a/include/uapi/linux/batman_adv.h
+++ b/include/uapi/linux/batman_adv.h
@@ -675,4 +675,24 @@ enum batadv_tp_meter_reason {
 	BATADV_TP_REASON_TOO_MANY		= 133,
 };
 
+/**
+ * enum batadv_ifla_attrs - batman-adv ifla nested attributes
+ */
+enum batadv_ifla_attrs {
+	/**
+	 * @IFLA_BATADV_UNSPEC: unspecified attribute which is not parsed by
+	 *  rtnetlink
+	 */
+	IFLA_BATADV_UNSPEC,
+
+	/* add attributes above here, update the policy in soft-interface.c */
+
+	/**
+	 * @__IFLA_BATADV_MAX: internal use
+	 */
+	__IFLA_BATADV_MAX,
+};
+
+#define IFLA_BATADV_MAX (__IFLA_BATADV_MAX - 1)
+
 #endif /* _UAPI_LINUX_BATMAN_ADV_H_ */
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 82e7ca886605..9c7b89689c97 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -38,6 +38,7 @@
 #include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <net/netlink.h>
 #include <uapi/linux/batadv_packet.h>
 #include <uapi/linux/batman_adv.h>
 
@@ -1073,6 +1074,37 @@ static void batadv_softif_init_early(struct net_device *dev)
 	dev->ethtool_ops = &batadv_ethtool_ops;
 }
 
+/**
+ * batadv_softif_validate() - validate configuration of new batadv link
+ * @tb: IFLA_INFO_DATA netlink attributes
+ * @data: enum batadv_ifla_attrs attributes
+ * @extack: extended ACK report struct
+ *
+ * Return: 0 if successful or error otherwise.
+ */
+static int batadv_softif_validate(struct nlattr *tb[], struct nlattr *data[],
+				  struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+/**
+ * batadv_softif_newlink() - pre-initialize and register new batadv link
+ * @src_net: the applicable net namespace
+ * @dev: network device to register
+ * @tb: IFLA_INFO_DATA netlink attributes
+ * @data: enum batadv_ifla_attrs attributes
+ * @extack: extended ACK report struct
+ *
+ * Return: 0 if successful or error otherwise.
+ */
+static int batadv_softif_newlink(struct net *src_net, struct net_device *dev,
+				 struct nlattr *tb[], struct nlattr *data[],
+				 struct netlink_ext_ack *extack)
+{
+	return register_netdevice(dev);
+}
+
 /**
  * batadv_softif_create() - Create and register soft interface
  * @net: the applicable net namespace
@@ -1171,9 +1203,16 @@ bool batadv_softif_is_valid(const struct net_device *net_dev)
 	return false;
 }
 
+static const struct nla_policy batadv_ifla_policy[IFLA_BATADV_MAX + 1] = {
+};
+
 struct rtnl_link_ops batadv_link_ops __read_mostly = {
 	.kind		= "batadv",
 	.priv_size	= sizeof(struct batadv_priv),
 	.setup		= batadv_softif_init_early,
+	.maxtype	= IFLA_BATADV_MAX,
+	.policy		= batadv_ifla_policy,
+	.validate	= batadv_softif_validate,
+	.newlink	= batadv_softif_newlink,
 	.dellink	= batadv_softif_destroy_netlink,
 };
-- 
2.20.1

