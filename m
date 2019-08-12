Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF378A3EB
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 19:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfHLRCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 13:02:12 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54438 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725843AbfHLRCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 13:02:12 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Aug 2019 20:02:10 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7CH2ATv013648;
        Mon, 12 Aug 2019 20:02:10 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next] net: devlink: remove redundant rtnl lock assert
Date:   Mon, 12 Aug 2019 20:02:02 +0300
Message-Id: <20190812170202.32314-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is enough for caller of devlink_compat_switch_id_get() to hold the net
device to guarantee that devlink port is not destroyed concurrently. Remove
rtnl lock assertion and modify comment to warn user that they must hold
either rtnl lock or reference to net device. This is necessary to
accommodate future implementation of rtnl-unlocked TC offloads driver
callbacks.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e8f0b891f000..e98e7bd9740b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6938,11 +6938,10 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 {
 	struct devlink_port *devlink_port;
 
-	/* RTNL mutex is held here which ensures that devlink_port
-	 * instance cannot disappear in the middle. No need to take
+	/* Caller must hold RTNL mutex or reference to dev, which ensures that
+	 * devlink_port instance cannot disappear in the middle. No need to take
 	 * any devlink lock as only permanent values are accessed.
 	 */
-	ASSERT_RTNL();
 	devlink_port = netdev_to_devlink_port(dev);
 	if (!devlink_port || !devlink_port->attrs.switch_port)
 		return -EOPNOTSUPP;
-- 
2.21.0

