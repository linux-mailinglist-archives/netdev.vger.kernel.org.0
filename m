Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EA01DD920
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgEUVKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:10:54 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA608C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:53 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id s21so10597975ejd.2
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZonQOyncl1AtkOCcxLI36jYh3pCrGXGOAlprW87oCJk=;
        b=Tt+K23IOr1yopG5GgYPNr6BrLVrbtwxyDn1lf9Wljz9ge49Fl8Xnold1V0GA+Ih4FL
         R+hgcxZhinRbnRPyfKYuWFNAeOI5BCY6RMWoQzbahUeCpCEoJK7U/8thrFTlcYzNwzKx
         b6VrwNktOdlHGgY9Dz5XV21TXdukX9O160DWhiiaBCb3TY90+te8YjurwcFtSJosAfyF
         l0v88AULr5JrBN/4h4WRd8tMdKwpuMam5Od190qpZ7Xga0SeXRYRvR/gDD2qMydahKhL
         wnF/yDX3x2bKAA7CpVdDtPJfsSqyClEAKmfYmlQkQyNxoEuUUzmU3EIuuZBnXHzRuRv/
         sJSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZonQOyncl1AtkOCcxLI36jYh3pCrGXGOAlprW87oCJk=;
        b=ea8EqgX/kqjTf+e7NCbU83zycJWA4dPSA1NGXH2aFoGf1TWr9csXypzNN5Xbqdv3ej
         D2HM2D0mZLwKH0Im01B/7bRdCi4UAcCY70CTQsohx+iBIV4YbGVbUtlxMw0xGczEyTNa
         txHahX9aO0Wj665XOCcVE/uVSIqoqXJ7igtFM/PfdDQhqZ34ttn4d77aNHLyHxdvZroa
         Lh4XCHnCRNbUBR1JxecimlN249/k4PMOtH8OwH0fkgyudE1gJplLJUwahcfAbK8xUf54
         EBeMx/IN/giC4HgmIT4noZdyxXaYvsdSacrtktifCySt9Y1Z+EC8tRvRtXii4vsZeLX3
         hezA==
X-Gm-Message-State: AOAM53070GDu0X2lpT6OxzSGg/UNjN0gjB4m8nTdcy1MaFA5D4y+w3fL
        u+oLbOA1gQ4y4V7/IYok8kM=
X-Google-Smtp-Source: ABdhPJxi5ZlR5eJOzEssB/VDGZOvtIKOspvoagW0I1K5BlrVni7iEg/TR2v4Oqm23BtRKEhBTDRoVw==
X-Received: by 2002:a17:906:2e0e:: with SMTP id n14mr5183079eji.545.1590095452268;
        Thu, 21 May 2020 14:10:52 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:10:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 01/13] net: core: dev_addr_lists: add VID to device address
Date:   Fri, 22 May 2020 00:10:24 +0300
Message-Id: <20200521211036.668624-2-olteanv@gmail.com>
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

Despite this is supposed to be used for Ethernet VLANs, not Ethernet
addresses with space for VID also can reuse this, so VID is considered
as virtual ID extension, not belonging strictly to Ethernet VLAN VIDs,
and overall change can be named individual virtual device filtering
(IVDF).

This patch adds VID tag at the end of each address. The actual
reserved address size is 32 bytes. For Ethernet addresses with 6 bytes
long that's possible to add tag w/o increasing address size. Thus,
each address for the case has 32 - 6 = 26 bytes to hold additional
info, say VID for virtual device addresses.

Therefore, when addresses are synced to the address list of parent
device the address list of latter can contain separate addresses for
virtual devices. It allows to track separate address tables for
virtual devices if they present and the device can be placed on
any place of device tree as the address is propagated to to the end
real device thru *_sync()/ndo_set_rx_mode() APIs. Also it simplifies
handling VID addresses at real device when it supports IVDF.

If parent device doesn't want to have virtual addresses in its address
space the vid_len has to be 0, thus its address space is "shrunk" to
the state as before this patch. For now it's 0 for every device. It
allows two devices with and w/o IVDF to be part of same bond device
for instance.

The end real device supporting IVDF can retrieve VID tag from an
address and set it for a given virtual device only. By default, vid 0
is used for real devices to distinguish it from virtual addresses.

See next patches to see how it's used.

Note that adding the vid_len member to struct net_device is not intended
to change the structure layout. Here is the output of pahole:

For ARM 32, on 1 hole less:
---------------------------

before (https://pastebin.com/DG1SVpFR):

/* size: 1344, cachelines: 21, members: 123 */
/* sum members: 1304, holes: 5, sum holes: 28 */
/* padding: 12 */
/* bit_padding: 31 bits */

after (https://pastebin.com/ZUMhxGkA):

/* size: 1344, cachelines: 21, members: 124 */
/* sum members: 1305, holes: 5, sum holes: 27 */
/* padding: 12 */
/* bit_padding: 31 bits */

For ARM 64, on 1 hole less:
---------------------------

before (https://pastebin.com/5CdTQWkc):

/* size: 2048, cachelines: 32, members: 120 */
/* sum members: 1972, holes: 7, sum holes: 48 */
/* padding: 28 */
/* bit_padding: 31 bits */

after (https://pastebin.com/32ktb1iV):

/* size: 2048, cachelines: 32, members: 121 */
/* sum members: 1973, holes: 7, sum holes: 47 */
/* padding: 28 */
/* bit_padding: 31 bits */

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/netdevice.h |   4 ++
 net/core/dev_addr_lists.c | 127 ++++++++++++++++++++++++++++++++------
 2 files changed, 111 insertions(+), 20 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a18f8fdf4260..2d11b93f3af4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1698,6 +1698,7 @@ enum netdev_priv_flags {
  * 	@perm_addr:		Permanent hw address
  * 	@addr_assign_type:	Hw address assignment type
  * 	@addr_len:		Hardware address length
+ *	@vid_len:		Virtual ID length, set in case of IVDF
  *	@upper_level:		Maximum depth level of upper devices.
  *	@lower_level:		Maximum depth level of lower devices.
  *	@neigh_priv_len:	Used in neigh_alloc()
@@ -1950,6 +1951,7 @@ struct net_device {
 	unsigned char		perm_addr[MAX_ADDR_LEN];
 	unsigned char		addr_assign_type;
 	unsigned char		addr_len;
+	unsigned char		vid_len;
 	unsigned char		upper_level;
 	unsigned char		lower_level;
 	unsigned short		neigh_priv_len;
@@ -4316,8 +4318,10 @@ int dev_addr_init(struct net_device *dev);
 
 /* Functions used for unicast addresses handling */
 int dev_uc_add(struct net_device *dev, const unsigned char *addr);
+int dev_vid_uc_add(struct net_device *dev, const unsigned char *addr);
 int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr);
 int dev_uc_del(struct net_device *dev, const unsigned char *addr);
+int dev_vid_uc_del(struct net_device *dev, const unsigned char *addr);
 int dev_uc_sync(struct net_device *to, struct net_device *from);
 int dev_uc_sync_multiple(struct net_device *to, struct net_device *from);
 void dev_uc_unsync(struct net_device *to, struct net_device *from);
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 2f949b5a1eb9..90eaa99b19e5 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -541,6 +541,35 @@ int dev_addr_del(struct net_device *dev, const unsigned char *addr,
 }
 EXPORT_SYMBOL(dev_addr_del);
 
+static int get_addr_len(struct net_device *dev)
+{
+	return dev->addr_len + dev->vid_len;
+}
+
+/**
+ *	set_vid_addr - Copy a device address into a new address with IVDF.
+ *	@dev: device
+ *	@addr: address to copy
+ *	@naddr: location of new address
+ *
+ *	Transform a regular device address into one with IVDF (Individual
+ *	Virtual Device Filtering). If the device does not support IVDF, the
+ *	original device address length is returned and no copying is done.
+ *	Otherwise, the length of the IVDF address is returned.
+ *	The VID is set to zero which denotes the address of a real device.
+ */
+static int set_vid_addr(struct net_device *dev, const unsigned char *addr,
+			unsigned char *naddr)
+{
+	if (!dev->vid_len)
+		return dev->addr_len;
+
+	memcpy(naddr, addr, dev->addr_len);
+	memset(naddr + dev->addr_len, 0, dev->vid_len);
+
+	return get_addr_len(dev);
+}
+
 /*
  * Unicast list handling functions
  */
@@ -552,18 +581,22 @@ EXPORT_SYMBOL(dev_addr_del);
  */
 int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr)
 {
+	unsigned char naddr[MAX_ADDR_LEN];
 	struct netdev_hw_addr *ha;
-	int err;
+	int addr_len, err;
+
+	addr_len = set_vid_addr(dev, addr, naddr);
+	addr = dev->vid_len ? naddr : addr;
 
 	netif_addr_lock_bh(dev);
 	list_for_each_entry(ha, &dev->uc.list, list) {
-		if (!memcmp(ha->addr, addr, dev->addr_len) &&
+		if (!memcmp(ha->addr, addr, addr_len) &&
 		    ha->type == NETDEV_HW_ADDR_T_UNICAST) {
 			err = -EEXIST;
 			goto out;
 		}
 	}
-	err = __hw_addr_create_ex(&dev->uc, addr, dev->addr_len,
+	err = __hw_addr_create_ex(&dev->uc, addr, addr_len,
 				  NETDEV_HW_ADDR_T_UNICAST, true, false);
 	if (!err)
 		__dev_set_rx_mode(dev);
@@ -574,47 +607,89 @@ int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr)
 EXPORT_SYMBOL(dev_uc_add_excl);
 
 /**
- *	dev_uc_add - Add a secondary unicast address
+ *	dev_vid_uc_add - Add a secondary unicast address with tag
  *	@dev: device
- *	@addr: address to add
+ *	@addr: address to add, includes vid tag already
  *
  *	Add a secondary unicast address to the device or increase
  *	the reference count if it already exists.
  */
-int dev_uc_add(struct net_device *dev, const unsigned char *addr)
+int dev_vid_uc_add(struct net_device *dev, const unsigned char *addr)
 {
 	int err;
 
 	netif_addr_lock_bh(dev);
-	err = __hw_addr_add(&dev->uc, addr, dev->addr_len,
+	err = __hw_addr_add(&dev->uc, addr, get_addr_len(dev),
 			    NETDEV_HW_ADDR_T_UNICAST);
 	if (!err)
 		__dev_set_rx_mode(dev);
 	netif_addr_unlock_bh(dev);
 	return err;
 }
+EXPORT_SYMBOL(dev_vid_uc_add);
+
+/**
+ *	dev_uc_add - Add a secondary unicast address
+ *	@dev: device
+ *	@addr: address to add
+ *
+ *	Add a secondary unicast address to the device or increase
+ *	the reference count if it already exists.
+ */
+int dev_uc_add(struct net_device *dev, const unsigned char *addr)
+{
+	unsigned char naddr[MAX_ADDR_LEN];
+	int err;
+
+	set_vid_addr(dev, addr, naddr);
+	addr = dev->vid_len ? naddr : addr;
+
+	err = dev_vid_uc_add(dev, addr);
+	return err;
+}
 EXPORT_SYMBOL(dev_uc_add);
 
 /**
  *	dev_uc_del - Release secondary unicast address.
  *	@dev: device
- *	@addr: address to delete
+ *	@addr: address to delete, includes vid tag already
  *
  *	Release reference to a secondary unicast address and remove it
  *	from the device if the reference count drops to zero.
  */
-int dev_uc_del(struct net_device *dev, const unsigned char *addr)
+int dev_vid_uc_del(struct net_device *dev, const unsigned char *addr)
 {
 	int err;
 
 	netif_addr_lock_bh(dev);
-	err = __hw_addr_del(&dev->uc, addr, dev->addr_len,
+	err = __hw_addr_del(&dev->uc, addr, get_addr_len(dev),
 			    NETDEV_HW_ADDR_T_UNICAST);
 	if (!err)
 		__dev_set_rx_mode(dev);
 	netif_addr_unlock_bh(dev);
 	return err;
 }
+EXPORT_SYMBOL(dev_vid_uc_del);
+
+/**
+ *	dev_uc_del - Release secondary unicast address.
+ *	@dev: device
+ *	@addr: address to delete
+ *
+ *	Release reference to a secondary unicast address and remove it
+ *	from the device if the reference count drops to zero.
+ */
+int dev_uc_del(struct net_device *dev, const unsigned char *addr)
+{
+	unsigned char naddr[MAX_ADDR_LEN];
+	int err;
+
+	set_vid_addr(dev, addr, naddr);
+	addr = dev->vid_len ? naddr : addr;
+
+	err = dev_vid_uc_del(dev, addr);
+	return err;
+}
 EXPORT_SYMBOL(dev_uc_del);
 
 /**
@@ -638,7 +713,7 @@ int dev_uc_sync(struct net_device *to, struct net_device *from)
 		return -EINVAL;
 
 	netif_addr_lock(to);
-	err = __hw_addr_sync(&to->uc, &from->uc, to->addr_len);
+	err = __hw_addr_sync(&to->uc, &from->uc, get_addr_len(to));
 	if (!err)
 		__dev_set_rx_mode(to);
 	netif_addr_unlock(to);
@@ -668,7 +743,7 @@ int dev_uc_sync_multiple(struct net_device *to, struct net_device *from)
 		return -EINVAL;
 
 	netif_addr_lock(to);
-	err = __hw_addr_sync_multiple(&to->uc, &from->uc, to->addr_len);
+	err = __hw_addr_sync_multiple(&to->uc, &from->uc, get_addr_len(to));
 	if (!err)
 		__dev_set_rx_mode(to);
 	netif_addr_unlock(to);
@@ -692,7 +767,7 @@ void dev_uc_unsync(struct net_device *to, struct net_device *from)
 
 	netif_addr_lock_bh(from);
 	netif_addr_lock(to);
-	__hw_addr_unsync(&to->uc, &from->uc, to->addr_len);
+	__hw_addr_unsync(&to->mc, &from->mc, get_addr_len(to));
 	__dev_set_rx_mode(to);
 	netif_addr_unlock(to);
 	netif_addr_unlock_bh(from);
@@ -736,18 +811,22 @@ EXPORT_SYMBOL(dev_uc_init);
  */
 int dev_mc_add_excl(struct net_device *dev, const unsigned char *addr)
 {
+	unsigned char naddr[MAX_ADDR_LEN];
 	struct netdev_hw_addr *ha;
-	int err;
+	int addr_len, err;
+
+	addr_len = set_vid_addr(dev, addr, naddr);
+	addr = dev->vid_len ? naddr : addr;
 
 	netif_addr_lock_bh(dev);
 	list_for_each_entry(ha, &dev->mc.list, list) {
-		if (!memcmp(ha->addr, addr, dev->addr_len) &&
+		if (!memcmp(ha->addr, addr, addr_len) &&
 		    ha->type == NETDEV_HW_ADDR_T_MULTICAST) {
 			err = -EEXIST;
 			goto out;
 		}
 	}
-	err = __hw_addr_create_ex(&dev->mc, addr, dev->addr_len,
+	err = __hw_addr_create_ex(&dev->mc, addr, addr_len,
 				  NETDEV_HW_ADDR_T_MULTICAST, true, false);
 	if (!err)
 		__dev_set_rx_mode(dev);
@@ -760,10 +839,14 @@ EXPORT_SYMBOL(dev_mc_add_excl);
 static int __dev_mc_add(struct net_device *dev, const unsigned char *addr,
 			bool global)
 {
-	int err;
+	unsigned char naddr[MAX_ADDR_LEN];
+	int addr_len, err;
+
+	addr_len = set_vid_addr(dev, addr, naddr);
+	addr = dev->vid_len ? naddr : addr;
 
 	netif_addr_lock_bh(dev);
-	err = __hw_addr_add_ex(&dev->mc, addr, dev->addr_len,
+	err = __hw_addr_add_ex(&dev->mc, addr, addr_len,
 			       NETDEV_HW_ADDR_T_MULTICAST, global, false, 0);
 	if (!err)
 		__dev_set_rx_mode(dev);
@@ -800,10 +883,14 @@ EXPORT_SYMBOL(dev_mc_add_global);
 static int __dev_mc_del(struct net_device *dev, const unsigned char *addr,
 			bool global)
 {
-	int err;
+	unsigned char naddr[MAX_ADDR_LEN];
+	int addr_len, err;
+
+	addr_len = set_vid_addr(dev, addr, naddr);
+	addr = dev->vid_len ? naddr : addr;
 
 	netif_addr_lock_bh(dev);
-	err = __hw_addr_del_ex(&dev->mc, addr, dev->addr_len,
+	err = __hw_addr_del_ex(&dev->mc, addr, addr_len,
 			       NETDEV_HW_ADDR_T_MULTICAST, global, false);
 	if (!err)
 		__dev_set_rx_mode(dev);
-- 
2.25.1

