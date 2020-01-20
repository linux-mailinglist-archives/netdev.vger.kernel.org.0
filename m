Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A313D143352
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgATVUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:20:09 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44939 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgATVUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 16:20:08 -0500
Received: by mail-wr1-f67.google.com with SMTP id q10so962495wrm.11
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 13:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hkMKAoMPADiW9Z7XXvTVWIQlIIc1iVtqbxcy+bELZyg=;
        b=SATSU4glmmfXBVVpF7OAPpScBuFb7InfpnZTkoAdU/tPzA0Vp58CnfznG/XYe895+4
         5hPEkQO6n19RM9N8XTLRuXt8Qq+ob2OsK8W3zeEPZ0WA+1quDHYoVixMsZWfGHoVRWj1
         G52/drKKEzlm8rYEgHIm3g0KoeGHRvFfah/cCxYHoGVSRgBJUdmxXp2GSDpi99twgpuK
         9SwaRxY0sIpTzdXc5LeyM/PwgYDW0wMxAs0Jfbmck/spYxLf8rvIlc/MmUlUdMVVzgxU
         kOl/LLk/uel7ybGZOOnVRL4SiuzarTQsSMoKijhAg0VtbDE0nRe9NweIG0UlvlvuT/eF
         s6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hkMKAoMPADiW9Z7XXvTVWIQlIIc1iVtqbxcy+bELZyg=;
        b=tmGQ5timxwdczYWHbf5cDYEzFBLx/TC2RsZFU8CuzxtykM/WVclGcUeOt8T0cQlBVK
         BfySSDWnu8JScHH98VlYSYbaC08C/M1mAeokQlDw5McO3ydgkW2OOIyEu+d2EuXAiKmE
         SLCzSvWOr+NCqJt/BX/0SYv6NzL9Z3kHP12prAgsVMTqjeJSM8/XPBjtFE3JrO7HnBni
         cxZWlR4+i9LrbZtC0SKMMbD2yWVfpyvrHdI9n9llRILUCLy7I2EtGZ2ho3DWKA2lEcUs
         i3quj/mNEpx4CuVrJ9j/qds+47P8EHh2WEdNKF42ORa4B2pJXpmM1WyTb2kbMmcCvznp
         owqw==
X-Gm-Message-State: APjAAAVJUg4pNiIAiBLUs5Gu++aEEw3EVRhn4gbTPJoHUvSUroGVlfsV
        eUBzlDI3kZj2QNVLvtdnZHQXRkKL
X-Google-Smtp-Source: APXvYqxV68KzrbP+l0Ka8mNduolL5WLotzgNKqJPmgcaazfryXzm0HSAur1LFWxOC/dct9rZj0i2Uw==
X-Received: by 2002:a5d:67c7:: with SMTP id n7mr1337922wrw.319.1579555206699;
        Mon, 20 Jan 2020 13:20:06 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id c17sm49131564wrr.87.2020.01.20.13.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 13:20:06 -0800 (PST)
Subject: [PATCH net-next 3/3] net: convert suitable network drivers to use
 phy_do_ioctl
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
Message-ID: <793a9ff0-3fa1-c811-fdd3-4a704d680371@gmail.com>
Date:   Mon, 20 Jan 2020 22:18:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert suitable network drivers to use phy_do_ioctl.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/agere/et131x.c          | 11 +----------
 drivers/net/ethernet/atheros/ag71xx.c        | 10 +---------
 drivers/net/ethernet/faraday/ftgmac100.c     | 11 +----------
 drivers/net/ethernet/freescale/fec_mpc52xx.c | 12 +-----------
 drivers/net/ethernet/rdc/r6040.c             | 10 +---------
 5 files changed, 5 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index 3c51d8c50..cb6a761d5 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -3651,15 +3651,6 @@ static int et131x_close(struct net_device *netdev)
 	return del_timer_sync(&adapter->error_timer);
 }
 
-static int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf,
-			int cmd)
-{
-	if (!netdev->phydev)
-		return -EINVAL;
-
-	return phy_mii_ioctl(netdev->phydev, reqbuf, cmd);
-}
-
 /* et131x_set_packet_filter - Configures the Rx Packet filtering */
 static int et131x_set_packet_filter(struct et131x_adapter *adapter)
 {
@@ -3899,7 +3890,7 @@ static const struct net_device_ops et131x_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_get_stats		= et131x_stats,
-	.ndo_do_ioctl		= et131x_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl,
 };
 
 static int et131x_pci_setup(struct pci_dev *pdev,
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index f9db09e1f..e95687a78 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1394,14 +1394,6 @@ static netdev_tx_t ag71xx_hard_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-static int ag71xx_do_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
-{
-	if (!ndev->phydev)
-		return -EINVAL;
-
-	return phy_mii_ioctl(ndev->phydev, ifr, cmd);
-}
-
 static void ag71xx_oom_timer_handler(struct timer_list *t)
 {
 	struct ag71xx *ag = from_timer(ag, t, oom_timer);
@@ -1618,7 +1610,7 @@ static const struct net_device_ops ag71xx_netdev_ops = {
 	.ndo_open		= ag71xx_open,
 	.ndo_stop		= ag71xx_stop,
 	.ndo_start_xmit		= ag71xx_hard_start_xmit,
-	.ndo_do_ioctl		= ag71xx_do_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl,
 	.ndo_tx_timeout		= ag71xx_tx_timeout,
 	.ndo_change_mtu		= ag71xx_change_mtu,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 48b3b72fe..4572797f0 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1536,15 +1536,6 @@ static int ftgmac100_stop(struct net_device *netdev)
 	return 0;
 }
 
-/* optional */
-static int ftgmac100_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
-{
-	if (!netdev->phydev)
-		return -ENXIO;
-
-	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
-}
-
 static void ftgmac100_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
@@ -1597,7 +1588,7 @@ static const struct net_device_ops ftgmac100_netdev_ops = {
 	.ndo_start_xmit		= ftgmac100_hard_start_xmit,
 	.ndo_set_mac_address	= ftgmac100_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= ftgmac100_do_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl,
 	.ndo_tx_timeout		= ftgmac100_tx_timeout,
 	.ndo_set_rx_mode	= ftgmac100_set_rx_mode,
 	.ndo_set_features	= ftgmac100_set_features,
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index de5278485..7a3f066e6 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -785,16 +785,6 @@ static const struct ethtool_ops mpc52xx_fec_ethtool_ops = {
 };
 
 
-static int mpc52xx_fec_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct phy_device *phydev = dev->phydev;
-
-	if (!phydev)
-		return -ENOTSUPP;
-
-	return phy_mii_ioctl(phydev, rq, cmd);
-}
-
 static const struct net_device_ops mpc52xx_fec_netdev_ops = {
 	.ndo_open = mpc52xx_fec_open,
 	.ndo_stop = mpc52xx_fec_close,
@@ -802,7 +792,7 @@ static const struct net_device_ops mpc52xx_fec_netdev_ops = {
 	.ndo_set_rx_mode = mpc52xx_fec_set_multicast_list,
 	.ndo_set_mac_address = mpc52xx_fec_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
-	.ndo_do_ioctl = mpc52xx_fec_ioctl,
+	.ndo_do_ioctl = phy_do_ioctl,
 	.ndo_tx_timeout = mpc52xx_fec_tx_timeout,
 	.ndo_get_stats = mpc52xx_fec_get_stats,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index c23cb61bb..f5ecc410f 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -498,14 +498,6 @@ static int r6040_close(struct net_device *dev)
 	return 0;
 }
 
-static int r6040_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	if (!dev->phydev)
-		return -EINVAL;
-
-	return phy_mii_ioctl(dev->phydev, rq, cmd);
-}
-
 static int r6040_rx(struct net_device *dev, int limit)
 {
 	struct r6040_private *priv = netdev_priv(dev);
@@ -957,7 +949,7 @@ static const struct net_device_ops r6040_netdev_ops = {
 	.ndo_set_rx_mode	= r6040_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
-	.ndo_do_ioctl		= r6040_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl,
 	.ndo_tx_timeout		= r6040_tx_timeout,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= r6040_poll_controller,
-- 
2.25.0


