Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B91A2201D9
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 03:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGOB07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 21:26:59 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55091 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgGOB06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 21:26:58 -0400
Received: from cwh (fob.gandi.net [217.70.181.1])
        (Authenticated sender: wxcafe@wxcafe.net)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 3D05EE0003;
        Wed, 15 Jul 2020 01:26:56 +0000 (UTC)
Message-ID: <ce588610fb8e11046e10a62545f2c64eea354c31.camel@wxcafe.net>
Subject: [PATCH 3/4] cdc_ncm: replace the way cdc_ncm hooks into
 usbnet_change_mtu
From:   =?ISO-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
To:     linux-usb@vger.kernel.org
Cc:     Miguel =?ISO-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org, netdev@vger.kernel.org
Date:   Tue, 14 Jul 2020 21:26:53 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously cdc_ncm overwrited netdev_ops used by usbnet
thus preventing hooking into set_rx_mode. This patch
preserves usbnet hooks into netdev_ops, and add an
additional one for change_mtu needed by cdc_ncm.

Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
---
 drivers/net/usb/cdc_ncm.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 8929669b5e6d..2abaf5f8b23b 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -787,16 +787,7 @@ int cdc_ncm_change_mtu(struct net_device *net, int new_mtu)
 }
 EXPORT_SYMBOL_GPL(cdc_ncm_change_mtu);
 
-static const struct net_device_ops cdc_ncm_netdev_ops = {
-	.ndo_open	     = usbnet_open,
-	.ndo_stop	     = usbnet_stop,
-	.ndo_start_xmit	     = usbnet_start_xmit,
-	.ndo_tx_timeout	     = usbnet_tx_timeout,
-	.ndo_get_stats64     = usbnet_get_stats64,
-	.ndo_change_mtu	     = cdc_ncm_change_mtu,
-	.ndo_set_mac_address = eth_mac_addr,
-	.ndo_validate_addr   = eth_validate_addr,
-};
+static struct net_device_ops cdc_ncm_netdev_ops;
 
 int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_altsetting, int drvflags)
 {
@@ -953,6 +944,8 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 	dev->net->sysfs_groups[0] = &cdc_ncm_sysfs_attr_group;
 
 	/* must handle MTU changes */
+	cdc_ncm_netdev_ops = *dev->net->netdev_ops;
+	cdc_ncm_netdev_ops.ndo_change_mtu = cdc_ncm_change_mtu;
 	dev->net->netdev_ops = &cdc_ncm_netdev_ops;
 	dev->net->max_mtu = cdc_ncm_max_dgram_size(dev) - cdc_ncm_eth_hlen(dev);
 
-- 
2.27.0


-- 
Wxcafé <wxcafe@wxcafe.net>

