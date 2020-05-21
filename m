Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD991DD923
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbgEUVK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:10:57 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE64C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:55 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id d7so10554012eja.7
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XHvVDx0bn4cAErYabGuB0Tm/Q0t8MyOtAfbMRm6tWGc=;
        b=P1aVlaj7P/tjZ2lwJwJvr+7f43sjMVXItZQMs/Vl+yXY4hC+UQ2OHUZRy65Wd6VRAt
         aeVbcwtuO7yLm3HQZ7QvkeJ7foHdU3RHmtwacKZlDm7rZxsyWebljKB6oI1xlClMA8pd
         929mmmX9TBhNX+PhucfdwyT6mljiG1sCeZE2fE1hnuHlNpftNDfAuJhcP0gYC5Mg4/mD
         JyGzrJympvGEysd+jnyf+3MJ1MApDCx6h4JP6+J3Iad+uBrC2SPF7qAi1jbJsjGj/1tr
         PWHjrjBtR4rr537uJL+GdAs0ra+sloWhSjHEsbHEsSOAzcQve4qGmuhRIppdVdCGrAgV
         1BWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XHvVDx0bn4cAErYabGuB0Tm/Q0t8MyOtAfbMRm6tWGc=;
        b=jrqenADgtQrvwB0LFvjDFXTwbLWRxucZHnQukbs117TRC9uxI4MPPX3rwVmTbA2AOd
         ftsydGKRAohyUX+Cojx98RmJmPDNTd0N47ZPNSyml2tbbtpDW+En6Aakrp7otbNiWiPC
         43Z3V/p2V3X+4MOrL9/oNdaY4OlBN7/kHZAHeYwjDl/Vb+k5xWOOMjMUhRveaxKRENow
         SD6ghZRc852SxB126TBcGNmh/mBUQw+TJNZzRj0uVosqi7jtReuDXjvhyOHtjz5U1BSJ
         nFRdeAceEnRMD+9eQkRQQO1U7h+Q0h7f4TA22UPv0zazuPLZYkBcp5gWgaRclsFPIOl2
         Hx2A==
X-Gm-Message-State: AOAM531l1UtAxxMzgoQep7kS9Y8kaPkrWa5rZH8tkp+LHLm5SuBBGHo4
        NxPwIMuC/8813PIk3+hIfHU=
X-Google-Smtp-Source: ABdhPJzfu6PLzY56K18O5JU7AN3ZJlRdFpN7ahVYFSIWotzlVt8BFsSuTRWcWShkGmQJkZ/hqE0+ZQ==
X-Received: by 2002:a17:906:4088:: with SMTP id u8mr5506778ejj.444.1590095454668;
        Thu, 21 May 2020 14:10:54 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:10:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 03/13] net: 8021q: vlan_dev: add vid tag for vlan device own address
Date:   Fri, 22 May 2020 00:10:26 +0300
Message-Id: <20200521211036.668624-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

The vlan device address is held separately from uc/mc lists and
handled differently. The vlan dev address is bound with real device
address only if it's inherited from init, in all other cases it's
separate address entry in uc list. With vid set, the address becomes
not inherited from real device after it's set manually as before, but
is part of uc list any way, with appropriate vid tag set. If vid_len
for real device is 0, the behaviour is the same as before this change,
so shouldn't be any impact on systems w/o individual virtual device
filtering (IVDF) enabled. This allows to control and sync vlan device
address and disable concrete vlan packet ingress when vlan interface is
down.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/8021q/vlan.c     |  3 ++
 net/8021q/vlan_dev.c | 75 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 60 insertions(+), 18 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index d4bcfd8f95bf..4cc341c191a4 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -298,6 +298,9 @@ static void vlan_sync_address(struct net_device *dev,
 	if (vlan_dev_inherit_address(vlandev, dev))
 		goto out;
 
+	if (dev->vid_len)
+		goto out;
+
 	/* vlan address was different from the old address and is equal to
 	 * the new address */
 	if (!ether_addr_equal(vlandev->dev_addr, vlan->real_dev_addr) &&
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index c2c3e5ae535c..f3f570a12ffd 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -252,12 +252,61 @@ static void vlan_dev_set_addr_vid(struct net_device *vlan_dev, u8 *addr)
 	addr[vlan_dev->addr_len + 1] = (vid >> 8) & 0xf;
 }
 
+static int vlan_dev_add_addr(struct net_device *dev, u8 *addr)
+{
+	struct net_device *real_dev = vlan_dev_real_dev(dev);
+	unsigned char naddr[ETH_ALEN + NET_8021Q_VID_TSIZE];
+
+	if (real_dev->vid_len) {
+		memcpy(naddr, addr, dev->addr_len);
+		vlan_dev_set_addr_vid(dev, naddr);
+		return dev_vid_uc_add(real_dev, naddr);
+	}
+
+	if (ether_addr_equal(addr, real_dev->dev_addr))
+		return 0;
+
+	return dev_uc_add(real_dev, addr);
+}
+
+static void vlan_dev_del_addr(struct net_device *dev, u8 *addr)
+{
+	struct net_device *real_dev = vlan_dev_real_dev(dev);
+	unsigned char naddr[ETH_ALEN + NET_8021Q_VID_TSIZE];
+
+	if (real_dev->vid_len) {
+		memcpy(naddr, addr, dev->addr_len);
+		vlan_dev_set_addr_vid(dev, naddr);
+		dev_vid_uc_del(real_dev, naddr);
+		return;
+	}
+
+	if (!ether_addr_equal(dev->dev_addr, real_dev->dev_addr))
+		dev_uc_del(real_dev, addr);
+}
+
+static int vlan_dev_subs_addr(struct net_device *dev, u8 *addr)
+{
+	int err;
+
+	err = vlan_dev_add_addr(dev, addr);
+	if (err < 0)
+		return err;
+
+	vlan_dev_del_addr(dev, dev->dev_addr);
+	return err;
+}
+
 bool vlan_dev_inherit_address(struct net_device *dev,
 			      struct net_device *real_dev)
 {
 	if (dev->addr_assign_type != NET_ADDR_STOLEN)
 		return false;
 
+	if (real_dev->vid_len)
+		if (vlan_dev_subs_addr(dev, real_dev->dev_addr))
+			return false;
+
 	ether_addr_copy(dev->dev_addr, real_dev->dev_addr);
 	call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 	return true;
@@ -273,9 +322,10 @@ static int vlan_dev_open(struct net_device *dev)
 	    !(vlan->flags & VLAN_FLAG_LOOSE_BINDING))
 		return -ENETDOWN;
 
-	if (!ether_addr_equal(dev->dev_addr, real_dev->dev_addr) &&
-	    !vlan_dev_inherit_address(dev, real_dev)) {
-		err = dev_uc_add(real_dev, dev->dev_addr);
+	if (ether_addr_equal(dev->dev_addr, real_dev->dev_addr) ||
+	    (!ether_addr_equal(dev->dev_addr, real_dev->dev_addr) &&
+	     !vlan_dev_inherit_address(dev, real_dev))) {
+		err = vlan_dev_add_addr(dev, dev->dev_addr);
 		if (err < 0)
 			goto out;
 	}
@@ -308,8 +358,7 @@ static int vlan_dev_open(struct net_device *dev)
 	if (dev->flags & IFF_ALLMULTI)
 		dev_set_allmulti(real_dev, -1);
 del_unicast:
-	if (!ether_addr_equal(dev->dev_addr, real_dev->dev_addr))
-		dev_uc_del(real_dev, dev->dev_addr);
+	vlan_dev_del_addr(dev, dev->dev_addr);
 out:
 	netif_carrier_off(dev);
 	return err;
@@ -327,8 +376,7 @@ static int vlan_dev_stop(struct net_device *dev)
 	if (dev->flags & IFF_PROMISC)
 		dev_set_promiscuity(real_dev, -1);
 
-	if (!ether_addr_equal(dev->dev_addr, real_dev->dev_addr))
-		dev_uc_del(real_dev, dev->dev_addr);
+	vlan_dev_del_addr(dev, dev->dev_addr);
 
 	if (!(vlan->flags & VLAN_FLAG_BRIDGE_BINDING))
 		netif_carrier_off(dev);
@@ -337,9 +385,7 @@ static int vlan_dev_stop(struct net_device *dev)
 
 static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
 	struct sockaddr *addr = p;
-	int err;
 
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
@@ -347,15 +393,8 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
 	if (!(dev->flags & IFF_UP))
 		goto out;
 
-	if (!ether_addr_equal(addr->sa_data, real_dev->dev_addr)) {
-		err = dev_uc_add(real_dev, addr->sa_data);
-		if (err < 0)
-			return err;
-	}
-
-	if (!ether_addr_equal(dev->dev_addr, real_dev->dev_addr))
-		dev_uc_del(real_dev, dev->dev_addr);
-
+	if (vlan_dev_subs_addr(dev, addr->sa_data))
+		return true;
 out:
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
 	return 0;
-- 
2.25.1

