Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A65F15C8E9
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgBMQyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:54:21 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50978 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727992AbgBMQyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 11:54:21 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ogerlitz@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 13 Feb 2020 18:54:19 +0200
Received: from dev-r-vrt-177.mtr.labs.mlnx. (dev-r-vrt-177.mtr.labs.mlnx [10.212.177.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01DGsJQv002266;
        Thu, 13 Feb 2020 18:54:19 +0200
From:   Or Gerlitz <ogerlitz@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH net] net/tls: Act on going down event
Date:   Thu, 13 Feb 2020 16:54:07 +0000
Message-Id: <20200213165407.60140-1-ogerlitz@mellanox.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By the time of the down event, the netdevice stop ndo was
already called and the nic driver is likely to destroy the HW
objects/constructs which are used for the tls_dev_resync op.

Instead, act on the going down event which is triggered before
the stop ndo.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
---

compile tested only.

# vim net/core/dev.c +1555
 *	This function moves an active device into down state. A
 *	%NETDEV_GOING_DOWN is sent to the netdev notifier chain. The device
 *	is then deactivated and finally a %NETDEV_DOWN is sent to the notifier chain.
[..]
void dev_close(struct net_device *dev)

 net/tls/tls_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 1ba5a92832bb..457c4b8352d8 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1246,7 +1246,7 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 			return NOTIFY_DONE;
 		else
 			return NOTIFY_BAD;
-	case NETDEV_DOWN:
+	case NETDEV_GOING_DOWN:
 		return tls_device_down(dev);
 	}
 	return NOTIFY_DONE;
-- 
2.20.1

