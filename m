Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBD91770F9
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 09:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgCCIWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 03:22:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:55336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbgCCIWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 03:22:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6472FBA48;
        Tue,  3 Mar 2020 08:22:53 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 81F7FE1F46; Tue,  3 Mar 2020 09:22:52 +0100 (CET)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] tun: fix ethtool_ops get_msglvl and set_msglvl handlers
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-Id: <20200303082252.81F7FE1F46@unicorn.suse.cz>
Date:   Tue,  3 Mar 2020 09:22:52 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The get_msglvl and setmsglvl handlers only work as expected if TUN_DEBUG
is defined (which required editing the source). Otherwise tun_get_msglvl()
returns -EOPNOTSUPP but as this handler is not supposed to return error
code, it is not recognized as one and passed to userspace as is, resulting
in bogus output of ethtool command. The set_msglvl handler ignores its
argument and does nothing if TUN_DEBUG is left undefined.

The way to return EOPNOTSUPP to userspace for both requests is not to
provide these ethtool_ops callbacks at all if TUN_DEBUG is left undefined.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/tun.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 650c937ed56b..0aae2d208398 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3557,23 +3557,21 @@ static void tun_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 	}
 }
 
+#ifdef TUN_DEBUG
 static u32 tun_get_msglevel(struct net_device *dev)
 {
-#ifdef TUN_DEBUG
 	struct tun_struct *tun = netdev_priv(dev);
+
 	return tun->debug;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static void tun_set_msglevel(struct net_device *dev, u32 value)
 {
-#ifdef TUN_DEBUG
 	struct tun_struct *tun = netdev_priv(dev);
+
 	tun->debug = value;
-#endif
 }
+#endif /* TUN_DEBUG */
 
 static int tun_get_coalesce(struct net_device *dev,
 			    struct ethtool_coalesce *ec)
@@ -3600,8 +3598,10 @@ static int tun_set_coalesce(struct net_device *dev,
 
 static const struct ethtool_ops tun_ethtool_ops = {
 	.get_drvinfo	= tun_get_drvinfo,
+#ifdef TUN_DEBUG
 	.get_msglevel	= tun_get_msglevel,
 	.set_msglevel	= tun_set_msglevel,
+#endif
 	.get_link	= ethtool_op_get_link,
 	.get_ts_info	= ethtool_op_get_ts_info,
 	.get_coalesce   = tun_get_coalesce,
-- 
2.25.1

