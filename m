Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD95D3CFD2C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238515AbhGTOdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239419AbhGTONr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:13:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD68461248;
        Tue, 20 Jul 2021 14:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792426;
        bh=sCWScan1YM+efElA/8QC1aA+DiJUApS8hHSW+UJyHbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTMp40i0h5537pdlTK3sM1ZkIMEONbJQltTOJwtU5thspznwDCkDxlKgOL3cZ9xlq
         VYI6PfzuQtg0vZBuThGzzq5TSTnh9umCwV4hOiHKe2/7/nI601K1gm9Ovp8KnB2c+O
         q7kEQugi8FiDYnoNoMHlX68tzAyq8kPMn07WYg5DjIT+ufCdI63DAKCv5nSY40/fJV
         Nnq6qWnvtl0UpcZHA7Kr/jkL5bbZjK5xRZ52izJShtUqFvQaQDT7tUc1yaZF41G51q
         V7ygkoQhg4venW7sk/pYJJIYSB6hdYKyyFbONA2EmP2TveuierYj5tkxcSA28XHkka
         nkEYfarRIoDcg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 12/31] eql: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:19 +0200
Message-Id: <20210720144638.2859828-13-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The private ioctls in eql pass the arguments correctly through ifr_data,
but the slaving_request_t and slave_config_t structures are incompatible
with compat mode and need special conversion code in the driver.

Convert to siocdevprivate for now, and return an error when called
in compat mode.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/eql.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/eql.c b/drivers/net/eql.c
index 74263f8efe1a..8ef34901c2d8 100644
--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -113,6 +113,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/compat.h>
 #include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -131,7 +132,8 @@
 
 static int eql_open(struct net_device *dev);
 static int eql_close(struct net_device *dev);
-static int eql_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+static int eql_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			      void __user *data, int cmd);
 static netdev_tx_t eql_slave_xmit(struct sk_buff *skb, struct net_device *dev);
 
 #define eql_is_slave(dev)	((dev->flags & IFF_SLAVE) == IFF_SLAVE)
@@ -170,7 +172,7 @@ static const char version[] __initconst =
 static const struct net_device_ops eql_netdev_ops = {
 	.ndo_open	= eql_open,
 	.ndo_stop	= eql_close,
-	.ndo_do_ioctl	= eql_ioctl,
+	.ndo_siocdevprivate = eql_siocdevprivate,
 	.ndo_start_xmit	= eql_slave_xmit,
 };
 
@@ -268,25 +270,29 @@ static int eql_s_slave_cfg(struct net_device *dev, slave_config_t __user *sc);
 static int eql_g_master_cfg(struct net_device *dev, master_config_t __user *mc);
 static int eql_s_master_cfg(struct net_device *dev, master_config_t __user *mc);
 
-static int eql_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int eql_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			      void __user *data, int cmd)
 {
 	if (cmd != EQL_GETMASTRCFG && cmd != EQL_GETSLAVECFG &&
 	    !capable(CAP_NET_ADMIN))
 	  	return -EPERM;
 
+	if (in_compat_syscall()) /* to be implemented */
+		return -EOPNOTSUPP;
+
 	switch (cmd) {
 		case EQL_ENSLAVE:
-			return eql_enslave(dev, ifr->ifr_data);
+			return eql_enslave(dev, data);
 		case EQL_EMANCIPATE:
-			return eql_emancipate(dev, ifr->ifr_data);
+			return eql_emancipate(dev, data);
 		case EQL_GETSLAVECFG:
-			return eql_g_slave_cfg(dev, ifr->ifr_data);
+			return eql_g_slave_cfg(dev, data);
 		case EQL_SETSLAVECFG:
-			return eql_s_slave_cfg(dev, ifr->ifr_data);
+			return eql_s_slave_cfg(dev, data);
 		case EQL_GETMASTRCFG:
-			return eql_g_master_cfg(dev, ifr->ifr_data);
+			return eql_g_master_cfg(dev, data);
 		case EQL_SETMASTRCFG:
-			return eql_s_master_cfg(dev, ifr->ifr_data);
+			return eql_s_master_cfg(dev, data);
 		default:
 			return -EOPNOTSUPP;
 	}
-- 
2.29.2

