Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E42FEF246
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbfKEAyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:54:37 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:48535 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729035AbfKEAyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 19:54:37 -0500
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 04 Nov 2019 16:54:36 -0800
IronPort-SDR: 3Ph92Zb+v2qsOQ2kBzJbvDrtjD49ZJMUHTRYvk/0hYBjkU5UnZY02npTUVdEx9YjoGwbhb3TQ1
 KBZKBGxdljTpeaC1QXziPG65VH/RjhZdZ79ku7bC5kfWctVUjRLPUIxI9xCc3bcTHRaFNdCCkJ
 R1PHMZZmRU3XlhWsvqTxgrd1QaMDRc2ApEgQm9Uypfr3lSZBUp1zfgF7xvPG0xgo2JUP4l3Q9H
 o+0Y47VBEDykmZqr0bxFhC9WpazQ9xFWXHcxTNIdRT33o90IMG3k0jPZi688X7HstdpfJmQeaz
 Mqu7qfQrfTJA6qbVtBLi71sJ
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg04-sd.qualcomm.com with ESMTP; 04 Nov 2019 16:54:36 -0800
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id CE18346A3; Mon,  4 Nov 2019 17:54:35 -0700 (MST)
From:   Sean Tranchetti <stranche@codeaurora.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net v2] net: qualcomm: rmnet: Fix potential UAF when unregistering
Date:   Mon,  4 Nov 2019 17:54:22 -0700
Message-Id: <1572915262-19149-1-git-send-email-stranche@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the exit/unregistration process of the RmNet driver, the function
rmnet_unregister_real_device() is called to handle freeing the driver's
internal state and removing the RX handler on the underlying physical
device. However, the order of operations this function performs is wrong
and can lead to a use after free of the rmnet_port structure.

Before calling netdev_rx_handler_unregister(), this port structure is
freed with kfree(). If packets are received on any RmNet devices before
synchronize_net() completes, they will attempt to use this already-freed
port structure when processing the packet. As such, before cleaning up any
other internal state, the RX handler must be unregistered in order to
guarantee that no further packets will arrive on the device.

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
---
 v1 -> v2: Added missing Fixes tag
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 9c54b71..06de595 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -57,10 +57,10 @@ static int rmnet_unregister_real_device(struct net_device *real_dev,
 	if (port->nr_rmnet_devs)
 		return -EINVAL;
 
-	kfree(port);
-
 	netdev_rx_handler_unregister(real_dev);
 
+	kfree(port);
+
 	/* release reference on real_dev */
 	dev_put(real_dev);
 
-- 
1.9.1

