Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C1D3D7725
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbhG0NqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236802AbhG0NqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20E7D61A80;
        Tue, 27 Jul 2021 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393573;
        bh=jEGLRjSxSpreeMNYZWv9qGfyBSmCVqlGarHcGd930ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVjxPzTpAMjvPH3OFSezDbICzfAIAhhjkOcOHrx9bDsc2c2xmbr6NZZIikLy4JrdI
         aaM6z7FZ72cAdIcgSw1378/Fxs1Ay+pC4l4MqBulc6Wp5A/10aMXjzoTLDMv7X/7VH
         VqxEhB3dUHAZ1T3qixsz9JDO8br7HevBN2hyM5eEL7T6kGkQfP2xtvWrKhUitXc3mG
         hKq2A4KbVmr6PrV47yq3Mj4xlnG/FrBBihxsQ2EtYZUz9yUVDkWKbBoHJ3KsrqNyUu
         0VN7ZG50a5M8w7MEam8iOtYkhCcBpI4xsEe8qrMVWjvqYXh2hdNdQMx19FzGcPkpak
         0HqmtD8g5rgOg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH net-next v3 08/31] bonding: use siocdevprivate
Date:   Tue, 27 Jul 2021 15:44:54 +0200
Message-Id: <20210727134517.1384504-9-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The bonding driver supports two command codes for each operation: one
in the SIOCDEVPRIVATE range and another one with the same definition
but a unique command code.

Only the second set currently works in compat mode, as the ifr_data
expansion overwrites part of the ifr_slave field.

Move the private ones into ndo_siocdevprivate and change the
implementation to call the other function.  This makes both version
work correctly.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/bonding/bond_main.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 31730efa7538..96864183f92e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4000,7 +4000,6 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 		}
 
 		return 0;
-	case BOND_INFO_QUERY_OLD:
 	case SIOCBONDINFOQUERY:
 		u_binfo = (struct ifbond __user *)ifr->ifr_data;
 
@@ -4012,7 +4011,6 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 			return -EFAULT;
 
 		return 0;
-	case BOND_SLAVE_INFO_QUERY_OLD:
 	case SIOCBONDSLAVEINFOQUERY:
 		u_sinfo = (struct ifslave __user *)ifr->ifr_data;
 
@@ -4042,19 +4040,15 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 		return -ENODEV;
 
 	switch (cmd) {
-	case BOND_ENSLAVE_OLD:
 	case SIOCBONDENSLAVE:
 		res = bond_enslave(bond_dev, slave_dev, NULL);
 		break;
-	case BOND_RELEASE_OLD:
 	case SIOCBONDRELEASE:
 		res = bond_release(bond_dev, slave_dev);
 		break;
-	case BOND_SETHWADDR_OLD:
 	case SIOCBONDSETHWADDR:
 		res = bond_set_dev_addr(bond_dev, slave_dev);
 		break;
-	case BOND_CHANGE_ACTIVE_OLD:
 	case SIOCBONDCHANGEACTIVE:
 		bond_opt_initstr(&newval, slave_dev->name);
 		res = __bond_opt_set_notify(bond, BOND_OPT_ACTIVE_SLAVE,
@@ -4067,6 +4061,29 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 	return res;
 }
 
+static int bond_siocdevprivate(struct net_device *bond_dev, struct ifreq *ifr,
+			       void __user *data, int cmd)
+{
+	struct ifreq ifrdata = { .ifr_data = data };
+
+	switch (cmd) {
+	case BOND_INFO_QUERY_OLD:
+		return bond_do_ioctl(bond_dev, &ifrdata, SIOCBONDINFOQUERY);
+	case BOND_SLAVE_INFO_QUERY_OLD:
+		return bond_do_ioctl(bond_dev, &ifrdata, SIOCBONDSLAVEINFOQUERY);
+	case BOND_ENSLAVE_OLD:
+		return bond_do_ioctl(bond_dev, ifr, SIOCBONDENSLAVE);
+	case BOND_RELEASE_OLD:
+		return bond_do_ioctl(bond_dev, ifr, SIOCBONDRELEASE);
+	case BOND_SETHWADDR_OLD:
+		return bond_do_ioctl(bond_dev, ifr, SIOCBONDSETHWADDR);
+	case BOND_CHANGE_ACTIVE_OLD:
+		return bond_do_ioctl(bond_dev, ifr, SIOCBONDCHANGEACTIVE);
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static void bond_change_rx_flags(struct net_device *bond_dev, int change)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
@@ -4956,6 +4973,7 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_select_queue	= bond_select_queue,
 	.ndo_get_stats64	= bond_get_stats,
 	.ndo_do_ioctl		= bond_do_ioctl,
+	.ndo_siocdevprivate	= bond_siocdevprivate,
 	.ndo_change_rx_flags	= bond_change_rx_flags,
 	.ndo_set_rx_mode	= bond_set_rx_mode,
 	.ndo_change_mtu		= bond_change_mtu,
-- 
2.29.2

