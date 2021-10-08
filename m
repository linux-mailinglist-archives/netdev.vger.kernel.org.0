Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F573426FD1
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 19:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239341AbhJHSBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238085AbhJHSBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 14:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C728C61038;
        Fri,  8 Oct 2021 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633715958;
        bh=RZJBIXFEFsqHIOHyIXgcmo7WmXnfN0cD+i7fSd7DzXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUE6M5jJEVwu0eKX0o54+pla6JW0bzpw44NlE5pnjErMbhYzKf5qPIYquhVqf926o
         9piT1jAsURSXDLR1/p91Iv9hYOM5F8qYK/9KseDPdkL1KysrdblEjcFdSKTbAq2Jka
         P3jxcihlEwLC5M1r86fVWSZyVarp+VwO9SGvE4tSu+kEa1FRIePiIf4bfaM4WlX4Tr
         14xRmOPTOTB1mOJAPvJbcfFnho+KKw397C0SAqPg2KGY8uwcAPotPoOTQ8D0XG6iSc
         PmXbHMD3uM2mxclKdIpg7XLaJLdYbezJShgRjd1H0b5LWk9PwoNDPPPxpqgcEvbDhp
         icyUQfD2NG13w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Subject: [PATCH net-next 2/5] ethernet: tg3: remove direct netdev->dev_addr writes
Date:   Fri,  8 Oct 2021 10:59:10 -0700
Message-Id: <20211008175913.3754184-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008175913.3754184-1-kuba@kernel.org>
References: <20211008175913.3754184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tg3 does various forms of direct writes to netdev->dev_addr.
Use a local buffer. Make sure local buffer is aligned since
eth_platform_get_mac_address() may call ether_addr_copy().

tg3_get_device_address() returns whenever it finds a method
that found a valid address. Instead of modifying all the exit
points pass the buffer from the outside and commit the address
in the caller.

Constify the argument of the set addr helper.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Siva Reddy Kallam <siva.kallam@broadcom.com>
CC: Prashant Sreedharan <prashant@broadcom.com>
CC: Michael Chan <mchan@broadcom.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 48 +++++++++++++++--------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5a50ea75094f..b7e7d7cc59b1 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -3942,7 +3942,8 @@ static int tg3_load_tso_firmware(struct tg3 *tp)
 }
 
 /* tp->lock is held. */
-static void __tg3_set_one_mac_addr(struct tg3 *tp, u8 *mac_addr, int index)
+static void __tg3_set_one_mac_addr(struct tg3 *tp, const u8 *mac_addr,
+				   int index)
 {
 	u32 addr_high, addr_low;
 
@@ -16911,19 +16912,18 @@ static int tg3_get_invariants(struct tg3 *tp, const struct pci_device_id *ent)
 	return err;
 }
 
-static int tg3_get_device_address(struct tg3 *tp)
+static int tg3_get_device_address(struct tg3 *tp, u8 *addr)
 {
-	struct net_device *dev = tp->dev;
 	u32 hi, lo, mac_offset;
 	int addr_ok = 0;
 	int err;
 
-	if (!eth_platform_get_mac_address(&tp->pdev->dev, dev->dev_addr))
+	if (!eth_platform_get_mac_address(&tp->pdev->dev, addr))
 		return 0;
 
 	if (tg3_flag(tp, IS_SSB_CORE)) {
-		err = ssb_gige_get_macaddr(tp->pdev, &dev->dev_addr[0]);
-		if (!err && is_valid_ether_addr(&dev->dev_addr[0]))
+		err = ssb_gige_get_macaddr(tp->pdev, addr);
+		if (!err && is_valid_ether_addr(addr))
 			return 0;
 	}
 
@@ -16947,41 +16947,41 @@ static int tg3_get_device_address(struct tg3 *tp)
 	/* First try to get it from MAC address mailbox. */
 	tg3_read_mem(tp, NIC_SRAM_MAC_ADDR_HIGH_MBOX, &hi);
 	if ((hi >> 16) == 0x484b) {
-		dev->dev_addr[0] = (hi >>  8) & 0xff;
-		dev->dev_addr[1] = (hi >>  0) & 0xff;
+		addr[0] = (hi >>  8) & 0xff;
+		addr[1] = (hi >>  0) & 0xff;
 
 		tg3_read_mem(tp, NIC_SRAM_MAC_ADDR_LOW_MBOX, &lo);
-		dev->dev_addr[2] = (lo >> 24) & 0xff;
-		dev->dev_addr[3] = (lo >> 16) & 0xff;
-		dev->dev_addr[4] = (lo >>  8) & 0xff;
-		dev->dev_addr[5] = (lo >>  0) & 0xff;
+		addr[2] = (lo >> 24) & 0xff;
+		addr[3] = (lo >> 16) & 0xff;
+		addr[4] = (lo >>  8) & 0xff;
+		addr[5] = (lo >>  0) & 0xff;
 
 		/* Some old bootcode may report a 0 MAC address in SRAM */
-		addr_ok = is_valid_ether_addr(&dev->dev_addr[0]);
+		addr_ok = is_valid_ether_addr(addr);
 	}
 	if (!addr_ok) {
 		/* Next, try NVRAM. */
 		if (!tg3_flag(tp, NO_NVRAM) &&
 		    !tg3_nvram_read_be32(tp, mac_offset + 0, &hi) &&
 		    !tg3_nvram_read_be32(tp, mac_offset + 4, &lo)) {
-			memcpy(&dev->dev_addr[0], ((char *)&hi) + 2, 2);
-			memcpy(&dev->dev_addr[2], (char *)&lo, sizeof(lo));
+			memcpy(&addr[0], ((char *)&hi) + 2, 2);
+			memcpy(&addr[2], (char *)&lo, sizeof(lo));
 		}
 		/* Finally just fetch it out of the MAC control regs. */
 		else {
 			hi = tr32(MAC_ADDR_0_HIGH);
 			lo = tr32(MAC_ADDR_0_LOW);
 
-			dev->dev_addr[5] = lo & 0xff;
-			dev->dev_addr[4] = (lo >> 8) & 0xff;
-			dev->dev_addr[3] = (lo >> 16) & 0xff;
-			dev->dev_addr[2] = (lo >> 24) & 0xff;
-			dev->dev_addr[1] = hi & 0xff;
-			dev->dev_addr[0] = (hi >> 8) & 0xff;
+			addr[5] = lo & 0xff;
+			addr[4] = (lo >> 8) & 0xff;
+			addr[3] = (lo >> 16) & 0xff;
+			addr[2] = (lo >> 24) & 0xff;
+			addr[1] = hi & 0xff;
+			addr[0] = (hi >> 8) & 0xff;
 		}
 	}
 
-	if (!is_valid_ether_addr(&dev->dev_addr[0]))
+	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
 	return 0;
 }
@@ -17557,6 +17557,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 	char str[40];
 	u64 dma_mask, persist_dma_mask;
 	netdev_features_t features = 0;
+	u8 addr[ETH_ALEN] __aligned(2);
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -17779,12 +17780,13 @@ static int tg3_init_one(struct pci_dev *pdev,
 		tp->rx_pending = 63;
 	}
 
-	err = tg3_get_device_address(tp);
+	err = tg3_get_device_address(tp, addr);
 	if (err) {
 		dev_err(&pdev->dev,
 			"Could not obtain valid ethernet address, aborting\n");
 		goto err_out_apeunmap;
 	}
+	eth_hw_addr_set(dev, addr);
 
 	intmbx = MAILBOX_INTERRUPT_0 + TG3_64BIT_REG_LOW;
 	rcvmbx = MAILBOX_RCVRET_CON_IDX_0 + TG3_64BIT_REG_LOW;
-- 
2.31.1

