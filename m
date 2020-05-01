Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B8A1C1BA0
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 19:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbgEAR0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 13:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729447AbgEAR0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 13:26:37 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CECC061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 10:26:37 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f13so12229126wrm.13
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 10:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i6+T9ZY8miwi1Ht/A9pyx9HK6GZg44XuE8KhYVMh0dQ=;
        b=ANwixmv2EnUQiet41GLD91cNGyxeO7CF9LDnanHmxSL0o9uSe3ABBGcAjeli4RT5lL
         ZyC8250I+BAsgo7/v3ao+x4SV2In+uckLJxNQXAQT77vxXZxoYygDO7O1HLweC90S/Eo
         kvCuGSqjhCkhWDzimitjSbP0GtG2WJDKWaw++DMLcwmcdCp3642ymzY9ubWZURqNNAsW
         B+JfbpmikknlpJYoRhUCQQQPGjUuca3St1lW0/u3MF5fxES6/j4FdKEyaslQ38KD/Q5x
         g4IK4AT+zFO6q7G9rDEAGJM7gjoxHZhbLWnY9Bt7K2dNb7rgVDAMtP5uy1pGbdg6dndK
         AkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i6+T9ZY8miwi1Ht/A9pyx9HK6GZg44XuE8KhYVMh0dQ=;
        b=PMwEAf5xImCHO/JYJRNs7mHnVVwx/F2ZNOVW+3PK1x3M8GVmLSv0tZPp7VBSonNGNt
         pMmBLanvn9V/D5SiAmn9lNNc+4aQ2markqdHeSQXOc6+YaXWiOZ17u2pib5RJbz+8YqL
         xocJ3lT/E0nX0hxJir4L8rSwwQl3zI6KSyO7dhEfd0IsYNiA2PlBPIwDPbTc9IEBZ51c
         1tyREgC37vntnM84r4IpBJESX9dwjAiktULNFY4H1xRVKrlGbceMPdYM9nluNaUWWZFo
         XVyMigfKA7pRceHyAccb+jR6MY8mdyR2W6PfSAAYk4JhfHb+GBjkdv3kt0iGbtqITXy7
         F1zw==
X-Gm-Message-State: AGi0PuZfHCBF7CJhls78FiwS5DKonzAyJQbONPrYQjZGcZOdvVdMdtcX
        FNUgC3D52fQbspiNxjBGrjwQXxDt
X-Google-Smtp-Source: APiQypLc7gXBBFPNILtDtTKJMY/5p7KQwneKtlELlkjEjgXgpZQ7C50TGwYHPKfBTl5ZWWSSqK2cng==
X-Received: by 2002:a05:6000:108e:: with SMTP id y14mr5598220wrw.292.1588353995480;
        Fri, 01 May 2020 10:26:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f06:ee00:54e4:3086:385e:b03b? (p200300EA8F06EE0054E43086385EB03B.dip0.t-ipconnect.de. [2003:ea:8f06:ee00:54e4:3086:385e:b03b])
        by smtp.googlemail.com with ESMTPSA id b82sm394686wmh.1.2020.05.01.10.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 10:26:35 -0700 (PDT)
Subject: [PATCH net-next 4/4] r8169: switch from netif_xxx message functions
 to netdev_xxx
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0e2ab257-5564-f16a-92f9-d0635e140837@gmail.com>
Message-ID: <6afdb9d8-8769-874b-a3f5-0a3f13da2fe5@gmail.com>
Date:   Fri, 1 May 2020 19:26:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0e2ab257-5564-f16a-92f9-d0635e140837@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Considering the few messages we have in the driver, there's not really
a benefit in being able to control them on a message type level.
Therefore simplify the code and switch to the netdev_xxx message
functions. In addition add net_ratelimit() to messages that can be
printed from a hot path.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 68 ++++++++---------------
 1 file changed, 22 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 768721d56..8b665f2ec 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -59,9 +59,6 @@
 #define FIRMWARE_8107E_2	"rtl_nic/rtl8107e-2.fw"
 #define FIRMWARE_8125A_3	"rtl_nic/rtl8125a-3.fw"
 
-#define R8169_MSG_DEFAULT \
-	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
-
 /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
    The RTL chips use a 64 element hash table based on the Ethernet CRC. */
 #define	MC_FILTER_LIMIT	32
@@ -179,10 +176,6 @@ static const struct pci_device_id rtl8169_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, rtl8169_pci_tbl);
 
-static struct {
-	u32 msg_enable;
-} debug = { -1 };
-
 enum rtl_registers {
 	MAC0		= 0,	/* Ethernet hardware address. */
 	MAC4		= 4,
@@ -604,7 +597,6 @@ struct rtl8169_private {
 	struct net_device *dev;
 	struct phy_device *phydev;
 	struct napi_struct napi;
-	u32 msg_enable;
 	enum mac_version mac_version;
 	u32 cur_rx; /* Index into the Rx descriptor buffer of next Rx pkt. */
 	u32 cur_tx; /* Index into the Tx descriptor buffer of next Rx pkt. */
@@ -646,8 +638,6 @@ typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
 
 MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
 MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
-module_param_named(debug, debug.msg_enable, int, 0);
-MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 16=all)");
 MODULE_SOFTDEP("pre: realtek");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FIRMWARE_8168D_1);
@@ -751,8 +741,10 @@ static bool rtl_loop_wait(struct rtl8169_private *tp, const struct rtl_cond *c,
 			return true;
 		delay(d);
 	}
-	netif_err(tp, drv, tp->dev, "%s == %d (loop: %d, delay: %d).\n",
-		  c->msg, !high, n, d);
+
+	if (net_ratelimit())
+		netdev_err(tp->dev, "%s == %d (loop: %d, delay: %d).\n",
+			   c->msg, !high, n, d);
 	return false;
 }
 
@@ -797,7 +789,8 @@ static bool name ## _check(struct rtl8169_private *tp)
 static bool rtl_ocp_reg_failure(struct rtl8169_private *tp, u32 reg)
 {
 	if (reg & 0xffff0001) {
-		netif_err(tp, drv, tp->dev, "Invalid ocp reg %x!\n", reg);
+		if (net_ratelimit())
+			netdev_err(tp->dev, "Invalid ocp reg %x!\n", reg);
 		return true;
 	}
 	return false;
@@ -1580,20 +1573,6 @@ static void rtl8169_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 	rtl_unlock_work(tp);
 }
 
-static u32 rtl8169_get_msglevel(struct net_device *dev)
-{
-	struct rtl8169_private *tp = netdev_priv(dev);
-
-	return tp->msg_enable;
-}
-
-static void rtl8169_set_msglevel(struct net_device *dev, u32 value)
-{
-	struct rtl8169_private *tp = netdev_priv(dev);
-
-	tp->msg_enable = value;
-}
-
 static const char rtl8169_gstrings[][ETH_GSTRING_LEN] = {
 	"tx_packets",
 	"rx_packets",
@@ -1985,8 +1964,6 @@ static const struct ethtool_ops rtl8169_ethtool_ops = {
 	.get_link		= ethtool_op_get_link,
 	.get_coalesce		= rtl_get_coalesce,
 	.set_coalesce		= rtl_set_coalesce,
-	.get_msglevel		= rtl8169_get_msglevel,
-	.set_msglevel		= rtl8169_set_msglevel,
 	.get_regs		= rtl8169_get_regs,
 	.get_wol		= rtl8169_get_wol,
 	.set_wol		= rtl8169_set_wol,
@@ -3868,8 +3845,7 @@ static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
 
 	mapping = dma_map_page(d, data, 0, R8169_RX_BUF_SIZE, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(d, mapping))) {
-		if (net_ratelimit())
-			netif_err(tp, drv, tp->dev, "Failed to map RX DMA!\n");
+		netdev_err(tp->dev, "Failed to map RX DMA!\n");
 		__free_pages(data, get_order(R8169_RX_BUF_SIZE));
 		return NULL;
 	}
@@ -4006,7 +3982,7 @@ static int rtl8169_tx_map(struct rtl8169_private *tp, const u32 *opts, u32 len,
 	ret = dma_mapping_error(d, mapping);
 	if (unlikely(ret)) {
 		if (net_ratelimit())
-			netif_err(tp, drv, tp->dev, "Failed to map TX data!\n");
+			netdev_err(tp->dev, "Failed to map TX data!\n");
 		return ret;
 	}
 
@@ -4172,7 +4148,8 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	txd_first = tp->TxDescArray + entry;
 
 	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
-		netif_err(tp, drv, dev, "BUG! Tx Ring full when queue awake!\n");
+		if (net_ratelimit())
+			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
 	}
 
@@ -4334,9 +4311,9 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 
 	pci_status_errs = pci_status_get_and_clear_errors(pdev);
 
-	netif_err(tp, intr, dev, "PCI error (cmd = 0x%04x, status_errs = 0x%04x)\n",
-		  pci_cmd, pci_status_errs);
-
+	if (net_ratelimit())
+		netdev_err(dev, "PCI error (cmd = 0x%04x, status_errs = 0x%04x)\n",
+			   pci_cmd, pci_status_errs);
 	/*
 	 * The recovery sequence below admits a very elaborated explanation:
 	 * - it seems to work;
@@ -4454,8 +4431,9 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 		dma_rmb();
 
 		if (unlikely(status & RxRES)) {
-			netif_info(tp, rx_err, dev, "Rx ERROR. status = %08x\n",
-				   status);
+			if (net_ratelimit())
+				netdev_warn(dev, "Rx ERROR. status = %08x\n",
+					    status);
 			dev->stats.rx_errors++;
 			if (status & (RxRWT | RxRUNT))
 				dev->stats.rx_length_errors++;
@@ -5326,7 +5304,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp = netdev_priv(dev);
 	tp->dev = dev;
 	tp->pci_dev = pdev;
-	tp->msg_enable = netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
 	tp->supports_gmii = ent->driver_data == RTL_CFG_NO_GBIT ? 0 : 1;
 	tp->eee_adv = -1;
 	tp->ocp_base = OCP_STD_PHY_BASE;
@@ -5484,15 +5461,14 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	netif_info(tp, probe, dev, "%s, %pM, XID %03x, IRQ %d\n",
-		   rtl_chip_infos[chipset].name, dev->dev_addr, xid,
-		   pci_irq_vector(pdev, 0));
+	netdev_info(dev, "%s, %pM, XID %03x, IRQ %d\n",
+		    rtl_chip_infos[chipset].name, dev->dev_addr, xid,
+		    pci_irq_vector(pdev, 0));
 
 	if (jumbo_max)
-		netif_info(tp, probe, dev,
-			   "jumbo features [frames: %d bytes, tx checksumming: %s]\n",
-			   jumbo_max, tp->mac_version <= RTL_GIGA_MAC_VER_06 ?
-			   "ok" : "ko");
+		netdev_info(dev, "jumbo features [frames: %d bytes, tx checksumming: %s]\n",
+			    jumbo_max, tp->mac_version <= RTL_GIGA_MAC_VER_06 ?
+			    "ok" : "ko");
 
 	if (r8168_check_dash(tp))
 		rtl8168_driver_start(tp);
-- 
2.26.2


