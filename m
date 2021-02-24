Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA3F323B6C
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbhBXLq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbhBXLpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:45:08 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1C0C061793
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:08 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id w21so2070883edc.7
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=14IFdbQi7qBTsEbIGGLHwEMAkDriFhkRYedkx1tDDg4=;
        b=IPBA2dR2qvxBUdw5SMnKg1sJuMP+lCiE8xmw5xZlJgF+2lNlMp3+Njz67+ckWveyc7
         XNygFPAyAEc13k+QNn5KDrmnPy/DNwGG94D2ESpM2qarBosfkpInz/SaVbVWy/JZG895
         7U6fIGbJiu6ZANAJnZsScYR87Irc7tc/zenU2xoELjaIqYKXQdagcbMo6RVIYPpQ4p3i
         sT3QYbtX2BrocVKuEPXVsHx00TvAl3qvOgMrVkzfrUy/qCEMksJ/YBXkyfQjuPqKzwCx
         XHCAzsFrcxO+tjoPF1yOotL5yXgdxnOP+ziz/DEAOX+CnhnaNiKBfBtx2RpFJXOiDlnz
         nTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=14IFdbQi7qBTsEbIGGLHwEMAkDriFhkRYedkx1tDDg4=;
        b=HkFBaynHjFY8Sl1EFWZtlhXdkN7gtYsS0ToN5BYygKohT+GGEWr4kaLzbSB+jy9Zl6
         GIuAKzYhK3OJ8Opg/JLyE02SOuswCNXdRZmd7enHCqNLQVy+X6JGwGVtYMaEETTORW9/
         IQKCIr/nF4Bs9qSUtpSBliTAa3oppho0o3FHCaiKgA+C6Mx2bm7lTEzhOX3+0WwIipXp
         2tunpcepujJuT0//gtRehC7S38g18y4OyaXVywb57lblwAvBw3XjTRN43OBLdUtHRQVx
         6GO4+PcKsGAC2MXF9BCKilC75EirKLwVFVZMPgOSi/28+xrE1r9kp9Sr+NVjWK98Zpcf
         zc8g==
X-Gm-Message-State: AOAM531SMX0zkQ/N7eR1hGtOIoG8tbl8j4LXiGL+WX0U9IO73hIYLq9/
        iQCPerxmT8Livv+BHrhU4/3G/tGwUTg=
X-Google-Smtp-Source: ABdhPJwPrZEvUdlt0Xowb3g/5EYFsSb/UA3Z6hYh1aybpoAJOtJTlQrTpOfwL/U/uadT5p/uGN7Bvg==
X-Received: by 2002:a05:6402:3133:: with SMTP id dd19mr32332904edb.337.1614167046597;
        Wed, 24 Feb 2021 03:44:06 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 05/17] net: bridge: implement unicast filtering for the bridge device
Date:   Wed, 24 Feb 2021 13:43:38 +0200
Message-Id: <20210224114350.2791260-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The bridge device currently goes into promiscuous mode when it has an
upper with a different MAC address than itself. But it could do better:
it could sync the MAC addresses of its uppers to the software FDB, as
local entries pointing to the bridge itself. This is compatible with
switchdev, since drivers are now instructed to trap these MAC addresses
to the CPU.

Note that the dev_uc_add API does not propagate VLAN ID, so this only
works for VLAN-unaware bridges.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_device.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 3f2f06b4dd27..a7d9d35e70d0 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -179,8 +179,25 @@ static int br_dev_open(struct net_device *dev)
 	return 0;
 }
 
-static void br_dev_set_multicast_list(struct net_device *dev)
+static int br_dev_sync_uc(struct net_device *dev, const unsigned char *addr)
 {
+	struct net_bridge *br = netdev_priv(dev);
+
+	return br_fdb_insert(br, NULL, addr, 0);
+}
+
+static int br_dev_unsync_uc(struct net_device *dev, const unsigned char *addr)
+{
+	struct net_bridge *br = netdev_priv(dev);
+
+	br_fdb_find_delete_local(br, NULL, addr, 0);
+
+	return 0;
+}
+
+static void br_dev_set_rx_mode(struct net_device *dev)
+{
+	__dev_uc_sync(dev, br_dev_sync_uc, br_dev_unsync_uc);
 }
 
 static void br_dev_change_rx_flags(struct net_device *dev, int change)
@@ -399,7 +416,7 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_start_xmit		 = br_dev_xmit,
 	.ndo_get_stats64	 = dev_get_tstats64,
 	.ndo_set_mac_address	 = br_set_mac_address,
-	.ndo_set_rx_mode	 = br_dev_set_multicast_list,
+	.ndo_set_rx_mode	 = br_dev_set_rx_mode,
 	.ndo_change_rx_flags	 = br_dev_change_rx_flags,
 	.ndo_change_mtu		 = br_change_mtu,
 	.ndo_do_ioctl		 = br_dev_ioctl,
@@ -436,7 +453,7 @@ void br_dev_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	dev->ethtool_ops = &br_ethtool_ops;
 	SET_NETDEV_DEVTYPE(dev, &br_type);
-	dev->priv_flags = IFF_EBRIDGE | IFF_NO_QUEUE;
+	dev->priv_flags = IFF_EBRIDGE | IFF_NO_QUEUE | IFF_UNICAST_FLT;
 
 	dev->features = COMMON_FEATURES | NETIF_F_LLTX | NETIF_F_NETNS_LOCAL |
 			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
-- 
2.25.1

