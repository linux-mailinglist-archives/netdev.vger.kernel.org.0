Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03306421393
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 18:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbhJDQH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 12:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236252AbhJDQHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 12:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52F95613DB;
        Mon,  4 Oct 2021 16:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633363536;
        bh=5FivIqS1C9WwNIDdKrHogKpwSKWTX2irBi86X37GOBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3FOLP3P944JOHUD9kCPQwW+9IHI21MdmIXFjwzNW1YyoXX09pG58+MjdHP9meSL6
         85+zPs5HS8Calnt4PfZ+xDWQxDU3Q3FEDPOO9XFQcmuFSqbhOAcCP+u4xuf5kEPDKY
         vuSNLOtYHMUB/Sp8cPWmPMujy5zmoH6b+Rn9KeYm4ndcE8t4Dz2DCbiJNn5GuPVbf8
         24xBfCwnz4NoDOErlZnRfTM8dr/MVJ0trXW0pme92VSme7icUDkcWVj8JNe94+Q76v
         hvv9Aq/qWlOlm5cYZp5KXAfsBqUQEPgROahE6bkkB2JWy7wo35hasV+9KUD/nBcV2p
         EWcA1tGoTIXhw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>
Subject: [PATCH net-next 2/2] net: usb: use eth_hw_addr_set() for dev->addr_len cases
Date:   Mon,  4 Oct 2021 09:05:22 -0700
Message-Id: <20211004160522.1974052-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211004160522.1974052-1-kuba@kernel.org>
References: <20211004160522.1974052-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert usb drivers from memcpy(... dev->addr_len)
to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - memcpy(dev->dev_addr, np, dev->addr_len)
  + eth_hw_addr_set(dev, np)

Manually checked these are either usbnet or pure etherdevs.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: linux-usb@vger.kernel.org
CC: Oliver Neukum <oliver@neukum.org>

 drivers/net/usb/dm9601.c  | 2 +-
 drivers/net/usb/mcs7830.c | 2 +-
 drivers/net/usb/r8152.c   | 2 +-
 drivers/net/usb/rtl8150.c | 2 +-
 drivers/net/usb/sr9700.c  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index f4b03202472d..dcdb46314685 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -331,7 +331,7 @@ static int dm9601_set_mac_address(struct net_device *net, void *p)
 		return -EINVAL;
 	}
 
-	memcpy(net->dev_addr, addr->sa_data, net->addr_len);
+	eth_hw_addr_set(net, addr->sa_data);
 	__dm9601_set_mac_address(dev);
 
 	return 0;
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 66866bef25df..cead742da381 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -159,7 +159,7 @@ static int mcs7830_set_mac_address(struct net_device *netdev, void *p)
 		return ret;
 
 	/* it worked --> adopt it on netdev side */
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 
 	return 0;
 }
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d762462d34f2..b7fde8d448ff 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1570,7 +1570,7 @@ static int __rtl8152_set_mac_address(struct net_device *netdev, void *p,
 
 	mutex_lock(&tp->control);
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_CONFIG);
 	pla_ocp_write(tp, PLA_IDR, BYTE_EN_SIX_BYTES, 8, addr->sa_data);
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index a8ae395fa26d..3d2bf2acca94 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -278,7 +278,7 @@ static int rtl8150_set_mac_address(struct net_device *netdev, void *p)
 	if (netif_running(netdev))
 		return -EBUSY;
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	netdev_dbg(netdev, "Setting MAC address to %pM\n", netdev->dev_addr);
 	/* Set the IDR registers. */
 	set_registers(dev, IDR, netdev->addr_len, netdev->dev_addr);
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 6516a37893e2..068f197f1786 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -296,7 +296,7 @@ static int sr9700_set_mac_address(struct net_device *netdev, void *p)
 		return -EINVAL;
 	}
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	eth_hw_addr_set(netdev, addr->sa_data);
 	sr_write_async(dev, SR_PAR, 6, netdev->dev_addr);
 
 	return 0;
-- 
2.31.1

