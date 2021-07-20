Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C323CFD9F
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239640AbhGTOwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240121AbhGTO2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2407F61242;
        Tue, 20 Jul 2021 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792421;
        bh=FBU3mvl8B6oQHJIQ3dAba22U8Nn4CQoEYZ8YPr3rE4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nAnPKf4D4GagaB0YPToMdtpbgV3khWraUnYRq3LdU767eqem3voAgNUTfFncXLvB/
         tTWZp2iqu2kmm1muz/eU8VRBjzDZesjEiDxqjefp3BmuagL/4Bajj7dh3JmiD8MBWn
         LnEIic4Cf8VLuGc9SBHG2xjJPjJx1X3VZYtwFmRh9L8Hs3RKBZPrIGvLo6aIdoE4YN
         EWvEfw9lLD8+bXaJI1z7XyXXR9LZGhpYEcuxKR4xe1jOkNeDZ0vwC8fdSeR9eGZoz5
         EGO+aRw9XU/6J6ERKb/tx0tnVL9UaypGS5HNB74eTp2q/UNoFaWGmwOWKazLugMdZj
         eyAg7NCBxzjvw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 08/31] bonding: use siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:15 +0200
Message-Id: <20210720144638.2859828-9-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/bonding/bond_main.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index d22d78303311..94f8d6a9adfb 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3998,7 +3998,6 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 		}
 
 		return 0;
-	case BOND_INFO_QUERY_OLD:
 	case SIOCBONDINFOQUERY:
 		u_binfo = (struct ifbond __user *)ifr->ifr_data;
 
@@ -4010,7 +4009,6 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 			return -EFAULT;
 
 		return 0;
-	case BOND_SLAVE_INFO_QUERY_OLD:
 	case SIOCBONDSLAVEINFOQUERY:
 		u_sinfo = (struct ifslave __user *)ifr->ifr_data;
 
@@ -4040,19 +4038,15 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
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
@@ -4065,6 +4059,29 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
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
@@ -4954,6 +4971,7 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_select_queue	= bond_select_queue,
 	.ndo_get_stats64	= bond_get_stats,
 	.ndo_do_ioctl		= bond_do_ioctl,
+	.ndo_siocdevprivate	= bond_siocdevprivate,
 	.ndo_change_rx_flags	= bond_change_rx_flags,
 	.ndo_set_rx_mode	= bond_set_rx_mode,
 	.ndo_change_mtu		= bond_change_mtu,
-- 
2.29.2

