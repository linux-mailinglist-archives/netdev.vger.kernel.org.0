Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C35437C51
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhJVR6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233901AbhJVR6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9325661371;
        Fri, 22 Oct 2021 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634925348;
        bh=KcKBNLfbCfbtFE0C0qkwoVRS6kdQoaVuFNTo+tLxiH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHxnFYVP4U/Eh0jTQzsKmKi4CjmfjU90Kh/ap6LncBOu1j+mVSotu9g+Mo1ADk9vC
         fE/cofSSTC5ZsMb3hT6IMiZ+p7v+RkT9WHV9kZDud35GdTC+widktHzIax/AVliM0j
         zi3ptIEUVqktJ3qVl+mkvN8WwaOzS69tBEEK79eHGKIrqsENnJBZeRHPEFx/ano44m
         5htT1M9bayXxy3cST8Od/cp50DplMpKb23GiNr9ZPs0kyrab4GO/jB+7cLf8+3uGT8
         rOz4GJacQfWloFy4kv1lE8V7Wf3YlmUUDPRW1tz2Z9gjlgLq4OL2pYWgKrimregilw
         s2g8/Wkk+1a1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        doshir@vmware.com, pv-drivers@vmware.com
Subject: [PATCH net-next 7/8] net: drivers: get ready for const netdev->dev_addr
Date:   Fri, 22 Oct 2021 10:55:42 -0700
Message-Id: <20211022175543.2518732-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022175543.2518732-1-kuba@kernel.org>
References: <20211022175543.2518732-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers. We will make
netdev->dev_addr a const.

Make sure local references to netdev->dev_addr are constant.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: doshir@vmware.com
CC: pv-drivers@vmware.com
---
 drivers/net/macsec.c              | 2 +-
 drivers/net/macvlan.c             | 3 ++-
 drivers/net/vmxnet3/vmxnet3_drv.c | 4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 18b6dba9394e..16aa3a478e9e 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -250,7 +250,7 @@ static bool send_sci(const struct macsec_secy *secy)
 		(secy->n_rx_sc > 1 && !tx_sc->end_station && !tx_sc->scb);
 }
 
-static sci_t make_sci(u8 *addr, __be16 port)
+static sci_t make_sci(const u8 *addr, __be16 port)
 {
 	sci_t sci;
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 6189acb33973..d2f830ec2969 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -698,7 +698,8 @@ static int macvlan_stop(struct net_device *dev)
 	return 0;
 }
 
-static int macvlan_sync_address(struct net_device *dev, unsigned char *addr)
+static int macvlan_sync_address(struct net_device *dev,
+				const unsigned char *addr)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	struct net_device *lowerdev = vlan->lowerdev;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 7a205ddf0060..3e1b7746cce4 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -46,7 +46,7 @@ MODULE_DEVICE_TABLE(pci, vmxnet3_pciid_table);
 static int enable_mq = 1;
 
 static void
-vmxnet3_write_mac_addr(struct vmxnet3_adapter *adapter, u8 *mac);
+vmxnet3_write_mac_addr(struct vmxnet3_adapter *adapter, const u8 *mac);
 
 /*
  *    Enable/Disable the given intr
@@ -2806,7 +2806,7 @@ vmxnet3_quiesce_dev(struct vmxnet3_adapter *adapter)
 
 
 static void
-vmxnet3_write_mac_addr(struct vmxnet3_adapter *adapter, u8 *mac)
+vmxnet3_write_mac_addr(struct vmxnet3_adapter *adapter, const u8 *mac)
 {
 	u32 tmp;
 
-- 
2.31.1

