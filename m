Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B556F3B83
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfKGWf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:35:56 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51731 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfKGWfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:35:52 -0500
Received: by mail-wm1-f66.google.com with SMTP id q70so4249884wme.1;
        Thu, 07 Nov 2019 14:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AcTnY3ufSYpK0jcG/sY4nCHFU8f6RabMWktvqUikGdY=;
        b=GeVKX20MNdSj6gyGJ73kq/ocNKLYXobWIeEwyyc5BnLEVCz7pOuwf7QpTylUUGulhu
         SseZr64QIrgzQ6eoZZjmPy4vOmYw9uaXv83JB1KcxIkb42OsipjxN0lc98htgtfVsAC7
         WiVbh0CZgyA6NCFkny0GrjYc1fwyOO1Q8I0NLfS+E6RBxKV0tTGBv3VMc3OqHhjYYMoi
         64XB91F662UFD4lyd0QVWQ+/3BSYGj2KG7tIqdXXGAyDfcibLXbqFDkdKGOvvyp6TZJO
         X7G7fMxv+xrVXAUMyD6e3QDUp8xgj300SDmD3SF9O2JSpPchFiz2GZ1b1kuBfSIK+pZy
         SfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AcTnY3ufSYpK0jcG/sY4nCHFU8f6RabMWktvqUikGdY=;
        b=gS5glpbuE//4KOaxVbVemsqm06uu55FdvhbUvq25CR3tQEzsuTECjyP6HY7gNilxlM
         rEVhWYvP7WmMJJJQPMV33Db/IOJGkTcogMuc9mXWb/Fc5yQ1z0dl7y1FgNR1WNYt4GSc
         lDjts9f3ssJGpaHfIXPvNgbq1idfxx75N+V54NFjy5ctJzlxh178SscqnuOlapqO0Q32
         IbL5o+uAU51or6qhEpLJauugL1niocpYfshoLDmYPzRww/mKQfIVankCvemVR8sWnvZg
         dNkH2XTHGEN7TIbwQjr1WFbKbh+aBRpGSCumxjUtgFng9Jmp31TGzLzfiPvoQnG0A6Di
         hOMw==
X-Gm-Message-State: APjAAAWC5uwTSwcNySWCbzlLNijeFLP9mfx6r/06MS698s/r0aPuURkx
        fqHIiav/9A7wYMSQOGDYIaI8o/W9
X-Google-Smtp-Source: APXvYqwtjaGkfBjVqrnE5GGktuI7Sn4Y12+iQdfDrsnjTGdO9GWWBqUexDyUcocPUtQY754DR4VmNQ==
X-Received: by 2002:a1c:4045:: with SMTP id n66mr5148281wma.92.1573166148598;
        Thu, 07 Nov 2019 14:35:48 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y6sm3667194wrw.6.2019.11.07.14.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 14:35:48 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Timur Tabi <timur@kernel.org>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/2] net: ethernet: intel: Demote MTU change prints to debug
Date:   Thu,  7 Nov 2019 14:35:36 -0800
Message-Id: <20191107223537.23440-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107223537.23440-1-f.fainelli@gmail.com>
References: <20191107223537.23440-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing a network device MTU can be a fairly frequent operation, and
failure to change the MTU is reflected to user-space properly, both by
an appropriate message as well as by looking at whether the device's MTU
matches the configuration.

Demote the prints to debug prints by using netdev_dbg(), making all
Intel wired LAN drivers consistent, since they used a mixture of PCI
device and network device prints before.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 4 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c    | 3 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 4 ++--
 drivers/net/ethernet/intel/igb/igb_main.c     | 5 ++---
 drivers/net/ethernet/intel/igbvf/netdev.c     | 4 ++--
 drivers/net/ethernet/intel/igc/igc_main.c     | 5 ++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 86493fea56e4..416da9619928 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -3565,8 +3565,8 @@ static int e1000_change_mtu(struct net_device *netdev, int new_mtu)
 	     (max_frame == MAXIMUM_ETHERNET_VLAN_SIZE)))
 		adapter->rx_buffer_len = MAXIMUM_ETHERNET_VLAN_SIZE;
 
-	pr_info("%s changing MTU from %d to %d\n",
-		netdev->name, netdev->mtu, new_mtu);
+	netdev_dbg(netdev, "changing MTU from %d to %d\n",
+		   netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
 
 	if (netif_running(netdev))
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 032b88619054..fe7997c18a10 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6031,7 +6031,8 @@ static int e1000_change_mtu(struct net_device *netdev, int new_mtu)
 		usleep_range(1000, 1100);
 	/* e1000e_down -> e1000e_reset dependent on max_frame_size & mtu */
 	adapter->max_frame_size = max_frame;
-	e_info("changing MTU from %d to %d\n", netdev->mtu, new_mtu);
+	netdev_dbg(netdev, "changing MTU from %d to %d\n",
+		   netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
 
 	pm_runtime_get_sync(netdev->dev.parent);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9fac1cea6fa5..1ccabeafa44c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2664,8 +2664,8 @@ static int i40e_change_mtu(struct net_device *netdev, int new_mtu)
 			return -EINVAL;
 	}
 
-	netdev_info(netdev, "changing MTU from %d to %d\n",
-		    netdev->mtu, new_mtu);
+	netdev_dbg(netdev, "changing MTU from %d to %d\n",
+		   netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
 	if (netif_running(netdev))
 		i40e_vsi_reinit_locked(vsi);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 48a40e4132f9..7337b3d3d1f6 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6236,7 +6236,6 @@ static void igb_get_stats64(struct net_device *netdev,
 static int igb_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
-	struct pci_dev *pdev = adapter->pdev;
 	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 
 	/* adjust max frame to be at least the size of a standard frame */
@@ -6252,8 +6251,8 @@ static int igb_change_mtu(struct net_device *netdev, int new_mtu)
 	if (netif_running(netdev))
 		igb_down(adapter);
 
-	dev_info(&pdev->dev, "changing MTU from %d to %d\n",
-		 netdev->mtu, new_mtu);
+	netdev_dbg(netdev, "changing MTU from %d to %d\n",
+		   netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
 
 	if (netif_running(netdev))
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 0f2b68f4bb0f..6003dc3ff5fd 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2437,8 +2437,8 @@ static int igbvf_change_mtu(struct net_device *netdev, int new_mtu)
 		adapter->rx_buffer_len = ETH_FRAME_LEN + VLAN_HLEN +
 					 ETH_FCS_LEN;
 
-	dev_info(&adapter->pdev->dev, "changing MTU from %d to %d\n",
-		 netdev->mtu, new_mtu);
+	netdev_dbg(netdev, "changing MTU from %d to %d\n",
+		   netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
 
 	if (netif_running(netdev))
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6105c6d1f3c9..b9d46cd57b6a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2272,7 +2272,6 @@ static int igc_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 	struct igc_adapter *adapter = netdev_priv(netdev);
-	struct pci_dev *pdev = adapter->pdev;
 
 	/* adjust max frame to be at least the size of a standard frame */
 	if (max_frame < (ETH_FRAME_LEN + ETH_FCS_LEN))
@@ -2287,8 +2286,8 @@ static int igc_change_mtu(struct net_device *netdev, int new_mtu)
 	if (netif_running(netdev))
 		igc_down(adapter);
 
-	dev_info(&pdev->dev, "changing MTU from %d to %d\n",
-		 netdev->mtu, new_mtu);
+	netdev_dbg(netdev, "changing MTU from %d to %d\n",
+		   netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
 
 	if (netif_running(netdev))
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1129ae70d5fb..25c097cd8100 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6725,7 +6725,8 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
 	    (new_mtu > ETH_DATA_LEN))
 		e_warn(probe, "Setting MTU > 1500 will disable legacy VFs\n");
 
-	e_info(probe, "changing MTU from %d to %d\n", netdev->mtu, new_mtu);
+	netdev_dbg(netdev, "changing MTU from %d to %d\n",
+		   netdev->mtu, new_mtu);
 
 	/* must set new MTU before calling down or up */
 	netdev->mtu = new_mtu;
-- 
2.17.1

