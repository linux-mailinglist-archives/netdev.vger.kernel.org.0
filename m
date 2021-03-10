Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D63333C6D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhCJMQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhCJMPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:47 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97576C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:47 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id r17so38220813ejy.13
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WReVT+8iTDPsI1Br/LD/Tfp05WC/XSuXJeUGHDdnG84=;
        b=C0Rlu3J6gUAYiEJQovpifyq51WU/AG7y3sg7CNJkHDD7yP2j72QY7LPdWCu0FLS+x/
         4nxnYC+DA9SnUrd8W+0JXEMM1JjB7bH+ycdcCeoqPN2NGrK9ttcfV3uJEowVJGtichuk
         MhfTO4gHArvn3WLHVHiYa0gBezOYCNzfAkpVJAwqXSKIqCOtgC1Z2+JCvO3msB7bqDN9
         X8AZw/dpL259McwLoerv9YYBwJdrk56XBQE13FAPATxOb1DhSZY0BfFApty/Tb0d4xuJ
         6Om6/amw/Hg0XiMwcG3cpEv9omxQZzXmWKBOWHu4eu/ppThmGxFXwqgbWWaWQaHBOxQb
         jLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WReVT+8iTDPsI1Br/LD/Tfp05WC/XSuXJeUGHDdnG84=;
        b=aeauCskj2ZHQQJP8Yz1HfmeuCO8H7vs2fuV4rM2/HKZFEZiMFgtCg2KXMs/1pFt1nT
         F4VGq4MkdRvNk2dwVlPe7j29lXV/NCGfxGDRP5D1VdaEPD7+73CtORVFHWHaXBfrd3fZ
         R3yJ/UdnjL+ZUPKRLzvNGIEOYBya68k6VblX0byFeqE0YW/Zjp8j2+Fi39cgu+4vJmDi
         rZDUetfxr9NfTcpOZa3ciWnr4iGkiGhSBdbhH6l2yJ/3tjS0Wxy9XL4TSQfhGTjkdwid
         1HhqWYkmBOgJ7Lui1bhbqSOV3IG9bLAjSFDrUfSImQO8YSmLygq0WAUC6r3WQg6I8DfQ
         Xv9Q==
X-Gm-Message-State: AOAM533JW3P/71goM9jGOTzVN9B4jQkqZ2XYfGc/wdu6gFwg5MM9br9O
        CC6UZnGDcZEn28nq4gP1YMA=
X-Google-Smtp-Source: ABdhPJxPcXEJRZC8DD4MfjnjnsgDOV980x3j9egXGZjNrun+YD3MCHeciZEfQFtyw77dd/Wr+xTBKA==
X-Received: by 2002:a17:906:52d0:: with SMTP id w16mr3346085ejn.172.1615378546311;
        Wed, 10 Mar 2021 04:15:46 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:45 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 14/15] staging: dpaa2-switch: prevent joining a bridge while VLAN uppers are present
Date:   Wed, 10 Mar 2021 14:14:51 +0200
Message-Id: <20210310121452.552070-15-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Each time a switch port joins a bridge, it will start to use a FDB table
common with all the other switch ports that are under the same bridge.
This means that any VLAN added prior to a bridge join, will retain its
previous FDB table destination. With this patch, I choose to restrict
when a switch port can change it's upper device (either join or leave)
so that the driver does not have to delete all the previously installed
VLANs from the previous FDB and add them into the new one.

Thus, in the PRECHANGEUPPER  notification we check if there are any VLAN
type upper devices and if that's true, deny the CHANGEUPPER.

This way, the user is not restricted in the topology but rather in the
order in which the setup is done: it must first create the bridging
domain layout and after that add the necessary VLAN devices if
necessary. The teardown is similar, the VLAN devices will need to be
destroyed prior to a change in the bridging layout.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 30 ++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 5fa7e41f6866..97292cf570c1 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1590,6 +1590,21 @@ static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
 					  BRIDGE_VLAN_INFO_UNTAGGED | BRIDGE_VLAN_INFO_PVID);
 }
 
+static int dpaa2_switch_prevent_bridging_with_8021q_upper(struct net_device *netdev)
+{
+	struct net_device *upper_dev;
+	struct list_head *iter;
+
+	/* RCU read lock not necessary because we have write-side protection
+	 * (rtnl_mutex), however a non-rcu iterator does not exist.
+	 */
+	netdev_for_each_upper_dev_rcu(netdev, upper_dev, iter)
+		if (is_vlan_dev(upper_dev))
+			return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 					     unsigned long event, void *ptr)
 {
@@ -1607,10 +1622,22 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
 		upper_dev = info->upper_dev;
-		if (netif_is_bridge_master(upper_dev) && !br_vlan_enabled(upper_dev)) {
+		if (!netif_is_bridge_master(upper_dev))
+			break;
+
+		if (!br_vlan_enabled(upper_dev)) {
 			NL_SET_ERR_MSG_MOD(extack, "Cannot join a VLAN-unaware bridge");
 			err = -EOPNOTSUPP;
+			goto out;
+		}
+
+		err = dpaa2_switch_prevent_bridging_with_8021q_upper(netdev);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Cannot join a bridge while VLAN uppers are present");
+			goto out;
 		}
+
 		break;
 	case NETDEV_CHANGEUPPER:
 		upper_dev = info->upper_dev;
@@ -1623,6 +1650,7 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 		break;
 	}
 
+out:
 	return notifier_from_errno(err);
 }
 
-- 
2.30.0

