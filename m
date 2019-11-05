Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBAFEF234
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbfKEApd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:45:33 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:32346 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730080AbfKEApd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 19:45:33 -0500
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 04 Nov 2019 16:45:29 -0800
IronPort-SDR: XHo6M1cfd6qA+NxwbSvC2gFnAJJkue3M7W0c7Bwq9R8SVGyhalI7zNhS8tSZePE+2tsL2leK1S
 5aEjYX8enJkoHxOs6q75uueCQ1e242ZmM=
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 04 Nov 2019 16:45:29 -0800
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id B8A4C46A3; Mon,  4 Nov 2019 17:45:28 -0700 (MST)
From:   Sean Tranchetti <stranche@codeaurora.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net] net: qualcomm: rmnet: Fix potential UAF when unregistering
Date:   Mon,  4 Nov 2019 17:45:18 -0700
Message-Id: <1572914718-17893-1-git-send-email-stranche@codeaurora.org>
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

Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
---
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

