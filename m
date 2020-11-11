Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4CD2AF930
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgKKTi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:38:27 -0500
Received: from correo.us.es ([193.147.175.20]:45128 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgKKTiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 14:38:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 423221878CA
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31267DA85D
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 248C9DA852; Wed, 11 Nov 2020 20:38:03 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCAEEDA730;
        Wed, 11 Nov 2020 20:38:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Nov 2020 20:38:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 8790E42EF9E1;
        Wed, 11 Nov 2020 20:38:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        razor@blackwall.org, jeremy@azazel.net
Subject: [PATCH net-next,v3 4/9] net: 8021q: resolve forwarding path for vlan devices
Date:   Wed, 11 Nov 2020 20:37:32 +0100
Message-Id: <20201111193737.1793-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201111193737.1793-1-pablo@netfilter.org>
References: <20201111193737.1793-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add .ndo_fill_forward_path for vlan devices.

For instance, assuming the following topology:

                   IP forwarding
                  /             \
            eth0.100             eth0
            |
            eth0
            .
            .
            .
           ethX
     ab:cd:ef:ab:cd:ef

For packets going through IP forwarding to eth0.100 whose destination
MAC address is ab:cd:ef:ab:cd:ef, dev_fill_forward_path() provides the
following path:

        eth0.100 -> eth0

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h |  7 +++++++
 net/8021q/vlan_dev.c      | 15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 752649d8669f..ca8525a1a797 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -835,11 +835,18 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
 
 enum net_device_path_type {
 	DEV_PATH_ETHERNET = 0,
+	DEV_PATH_VLAN,
 };
 
 struct net_device_path {
 	enum net_device_path_type	type;
 	const struct net_device		*dev;
+	union {
+		struct {
+			u16		id;
+			__be16		proto;
+		} vlan;
+	};
 };
 
 #define NET_DEVICE_PATH_STACK_MAX	5
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index ec8408d1638f..f06a507557f9 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -767,6 +767,20 @@ static int vlan_dev_get_iflink(const struct net_device *dev)
 	return real_dev->ifindex;
 }
 
+static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
+				      struct net_device_path *path)
+{
+	struct vlan_dev_priv *vlan = vlan_dev_priv(ctx->dev);
+
+	path->type = DEV_PATH_VLAN;
+	path->vlan.id = vlan->vlan_id;
+	path->vlan.proto = vlan->vlan_proto;
+	path->dev = ctx->dev;
+	ctx->dev = vlan->real_dev;
+
+	return 0;
+}
+
 static const struct ethtool_ops vlan_ethtool_ops = {
 	.get_link_ksettings	= vlan_ethtool_get_link_ksettings,
 	.get_drvinfo	        = vlan_ethtool_get_drvinfo,
@@ -805,6 +819,7 @@ static const struct net_device_ops vlan_netdev_ops = {
 #endif
 	.ndo_fix_features	= vlan_dev_fix_features,
 	.ndo_get_iflink		= vlan_dev_get_iflink,
+	.ndo_fill_forward_path	= vlan_dev_fill_forward_path,
 };
 
 static void vlan_dev_free(struct net_device *dev)
-- 
2.20.1

