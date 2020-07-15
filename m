Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E17222146D
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgGOSlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgGOSlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:41:25 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A7FC061755;
        Wed, 15 Jul 2020 11:41:24 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 06FIfKd0016716
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 15 Jul 2020 20:41:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1594838480; bh=+ZJVeOnCYoH1fL1NMNFU0O6QN6yyjfZ/F9a8MtxC+uw=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=itXv+UWH0Q5HikHZybIMXFMbbOfuybGU2Xs36JkLHG+B7VVPm7dybw+NNawRxMKkm
         5saiBn13YlZTCrfb+KmhdXC5bijIqF4+MlRZtQCDR/l6YHE1oZznonr3viT4GIKH3m
         O1ER9MiR26q7iB7xCwcDuuEi4EpxEuKFvGDcnFlQ=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1jvmLH-000SSc-Us; Wed, 15 Jul 2020 20:41:19 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, wxcafe@wxcafe.net, oliver@neukum.org,
        =?UTF-8?q?Miguel=20Rodr=C3=ADguez=20P=C3=A9rez?= 
        <miguel@det.uvigo.gal>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v5 net-next 4/5] net: cdc_ncm: add .ndo_set_rx_mode to cdc_ncm_netdev_ops
Date:   Wed, 15 Jul 2020 20:40:59 +0200
Message-Id: <20200715184100.109349-5-bjorn@mork.no>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200715184100.109349-1-bjorn@mork.no>
References: <20200715184100.109349-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>

The cdc_ncm driver overrides the net_device_ops structure used by usbnet
to be able to hook into .ndo_change_mtu. However, the structure was
missing the .ndo_set_rx_mode field, preventing the driver from
hooking into usbnet's set_rx_mode. This patch adds the missing callback to
usbnet_set_rx_mode in net_device_ops.

Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/cdc_ncm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 8929669b5e6d..f5d7b933792b 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -792,6 +792,7 @@ static const struct net_device_ops cdc_ncm_netdev_ops = {
 	.ndo_stop	     = usbnet_stop,
 	.ndo_start_xmit	     = usbnet_start_xmit,
 	.ndo_tx_timeout	     = usbnet_tx_timeout,
+	.ndo_set_rx_mode     = usbnet_set_rx_mode,
 	.ndo_get_stats64     = usbnet_get_stats64,
 	.ndo_change_mtu	     = cdc_ncm_change_mtu,
 	.ndo_set_mac_address = eth_mac_addr,
-- 
2.27.0

