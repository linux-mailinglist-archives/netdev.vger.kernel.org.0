Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528743E8849
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 04:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhHKCyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 22:54:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232142AbhHKCyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 22:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628650427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LphRJfkQgBAH2831PhmRtzzJWAEJrVsGQTDyOH94A7Q=;
        b=M2fxmy38IYja1rQnbrgTLVo6U9WJ3N2HJRH+Q3JIiskXmzfsNXGdpuALLhB4XZfG20ailV
        UrItybqqXT+XwCs8BsjB0RXwN3IMtW729uYjke16RADjXBAKhLx2UP0ucmcs8jQUiuSHKs
        ARzKSbdRS974olCCQdId23FB2hkGglg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-EXCOIwaJPTK78EyOwnCttA-1; Tue, 10 Aug 2021 22:53:45 -0400
X-MC-Unique: EXCOIwaJPTK78EyOwnCttA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AAB0801AE7;
        Wed, 11 Aug 2021 02:53:44 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.16.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A3B11B472;
        Wed, 11 Aug 2021 02:53:43 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, joe@perches.com, leon@kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/2] bonding: combine netlink and console error messages
Date:   Tue, 10 Aug 2021 22:53:31 -0400
Message-Id: <e6b78ce8f5904a5411a809cf4205d745f8af98cb.1628650079.git.jtoppins@redhat.com>
In-Reply-To: <cover.1628650079.git.jtoppins@redhat.com>
References: <cover.1628650079.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There seems to be no reason to have different error messages between
netlink and printk. It also cleans up the function slightly.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---

Notes:
    v2:
     - changed the printks to reduce object code slightly
     - emit a single error message based on if netlink or sysfs is
       attempting to enslave
     - rebase on top of net-next/master and convert additional
       instances added by XDP additions

 drivers/net/bonding/bond_main.c | 69 ++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 365953e8013e..c0db4e2b2462 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1725,6 +1725,20 @@ void bond_lower_state_changed(struct slave *slave)
 	netdev_lower_state_changed(slave->dev, &info);
 }
 
+#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
+	if (extack)						\
+		NL_SET_ERR_MSG(extack, errmsg);			\
+	else							\
+		netdev_err(bond_dev, "Error: %s\n", errmsg);	\
+} while (0)
+
+#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {		\
+	if (extack)							\
+		NL_SET_ERR_MSG(extack, errmsg);				\
+	else								\
+		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
+} while (0)
+
 /* enslave device <slave> to bond device <master> */
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		 struct netlink_ext_ack *extack)
@@ -1738,9 +1752,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	if (slave_dev->flags & IFF_MASTER &&
 	    !netif_is_bond_master(slave_dev)) {
-		NL_SET_ERR_MSG(extack, "Device with IFF_MASTER cannot be enslaved");
-		netdev_err(bond_dev,
-			   "Error: Device with IFF_MASTER cannot be enslaved\n");
+		BOND_NL_ERR(bond_dev, extack,
+			    "Device with IFF_MASTER cannot be enslaved");
 		return -EPERM;
 	}
 
@@ -1752,15 +1765,13 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	/* already in-use? */
 	if (netdev_is_rx_handler_busy(slave_dev)) {
-		NL_SET_ERR_MSG(extack, "Device is in use and cannot be enslaved");
-		slave_err(bond_dev, slave_dev,
-			  "Error: Device is in use and cannot be enslaved\n");
+		SLAVE_NL_ERR(bond_dev, slave_dev, extack,
+			     "Device is in use and cannot be enslaved");
 		return -EBUSY;
 	}
 
 	if (bond_dev == slave_dev) {
-		NL_SET_ERR_MSG(extack, "Cannot enslave bond to itself.");
-		netdev_err(bond_dev, "cannot enslave bond to itself.\n");
+		BOND_NL_ERR(bond_dev, extack, "Cannot enslave bond to itself.");
 		return -EPERM;
 	}
 
@@ -1769,8 +1780,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	if (slave_dev->features & NETIF_F_VLAN_CHALLENGED) {
 		slave_dbg(bond_dev, slave_dev, "is NETIF_F_VLAN_CHALLENGED\n");
 		if (vlan_uses_dev(bond_dev)) {
-			NL_SET_ERR_MSG(extack, "Can not enslave VLAN challenged device to VLAN enabled bond");
-			slave_err(bond_dev, slave_dev, "Error: cannot enslave VLAN challenged slave on VLAN enabled bond\n");
+			SLAVE_NL_ERR(bond_dev, slave_dev, extack,
+				     "Can not enslave VLAN challenged device to VLAN enabled bond");
 			return -EPERM;
 		} else {
 			slave_warn(bond_dev, slave_dev, "enslaved VLAN challenged slave. Adding VLANs will be blocked as long as it is part of bond.\n");
@@ -1788,8 +1799,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	 * enslaving it; the old ifenslave will not.
 	 */
 	if (slave_dev->flags & IFF_UP) {
-		NL_SET_ERR_MSG(extack, "Device can not be enslaved while up");
-		slave_err(bond_dev, slave_dev, "slave is up - this may be due to an out of date ifenslave\n");
+		SLAVE_NL_ERR(bond_dev, slave_dev, extack,
+			     "Device can not be enslaved while up");
 		return -EPERM;
 	}
 
@@ -1828,17 +1839,15 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 						 bond_dev);
 		}
 	} else if (bond_dev->type != slave_dev->type) {
-		NL_SET_ERR_MSG(extack, "Device type is different from other slaves");
-		slave_err(bond_dev, slave_dev, "ether type (%d) is different from other slaves (%d), can not enslave it\n",
-			  slave_dev->type, bond_dev->type);
+		SLAVE_NL_ERR(bond_dev, slave_dev, extack,
+			     "Device type is different from other slaves");
 		return -EINVAL;
 	}
 
 	if (slave_dev->type == ARPHRD_INFINIBAND &&
 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
-		NL_SET_ERR_MSG(extack, "Only active-backup mode is supported for infiniband slaves");
-		slave_warn(bond_dev, slave_dev, "Type (%d) supports only active-backup mode\n",
-			   slave_dev->type);
+		SLAVE_NL_ERR(bond_dev, slave_dev, extack,
+			     "Only active-backup mode is supported for infiniband slaves");
 		res = -EOPNOTSUPP;
 		goto err_undo_flags;
 	}
@@ -1852,8 +1861,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 				bond->params.fail_over_mac = BOND_FOM_ACTIVE;
 				slave_warn(bond_dev, slave_dev, "Setting fail_over_mac to active for active-backup mode\n");
 			} else {
-				NL_SET_ERR_MSG(extack, "Slave device does not support setting the MAC address, but fail_over_mac is not set to active");
-				slave_err(bond_dev, slave_dev, "The slave device specified does not support setting the MAC address, but fail_over_mac is not set to active\n");
+				SLAVE_NL_ERR(bond_dev, slave_dev, extack,
+					     "Slave device does not support setting the MAC address, but fail_over_mac is not set to active");
 				res = -EOPNOTSUPP;
 				goto err_undo_flags;
 			}
@@ -2149,8 +2158,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	if (!slave_dev->netdev_ops->ndo_bpf ||
 	    !slave_dev->netdev_ops->ndo_xdp_xmit) {
 		if (bond->xdp_prog) {
-			NL_SET_ERR_MSG(extack, "Slave does not support XDP");
-			slave_err(bond_dev, slave_dev, "Slave does not support XDP\n");
+			SLAVE_NL_ERR(bond_dev, slave_dev, extack,
+				     "Slave does not support XDP");
 			res = -EOPNOTSUPP;
 			goto err_sysfs_del;
 		}
@@ -2163,10 +2172,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		};
 
 		if (dev_xdp_prog_count(slave_dev) > 0) {
-			NL_SET_ERR_MSG(extack,
-				       "Slave has XDP program loaded, please unload before enslaving");
-			slave_err(bond_dev, slave_dev,
-				  "Slave has XDP program loaded, please unload before enslaving\n");
+			SLAVE_NL_ERR(bond_dev, slave_dev, extack,
+				     "Slave has XDP program loaded, please unload before enslaving");
 			res = -EOPNOTSUPP;
 			goto err_sysfs_del;
 		}
@@ -5190,17 +5197,15 @@ static int bond_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 		if (!slave_dev->netdev_ops->ndo_bpf ||
 		    !slave_dev->netdev_ops->ndo_xdp_xmit) {
-			NL_SET_ERR_MSG(extack, "Slave device does not support XDP");
-			slave_err(dev, slave_dev, "Slave does not support XDP\n");
+			SLAVE_NL_ERR(dev, slave_dev, extack,
+				     "Slave device does not support XDP");
 			err = -EOPNOTSUPP;
 			goto err;
 		}
 
 		if (dev_xdp_prog_count(slave_dev) > 0) {
-			NL_SET_ERR_MSG(extack,
-				       "Slave has XDP program loaded, please unload before enslaving");
-			slave_err(dev, slave_dev,
-				  "Slave has XDP program loaded, please unload before enslaving\n");
+			SLAVE_NL_ERR(dev, slave_dev, extack,
+				     "Slave has XDP program loaded, please unload before enslaving");
 			err = -EOPNOTSUPP;
 			goto err;
 		}
-- 
2.27.0

