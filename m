Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C663D0EED
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 14:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhGUL7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 07:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235330AbhGUL7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 07:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B34496120C;
        Wed, 21 Jul 2021 12:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626871189;
        bh=k+dVNJh5z43KdObG8GTDGe49OrDPmvX8GDjb/agtr2M=;
        h=From:To:Cc:Subject:Date:From;
        b=JG0D/McuaXACyq1qjGXq+xJ+Ejywo0LeSvNeSckTJEUnua5hkhC2r5xS7L912dtc6
         NPWWv9jvlGDU1tvkZRWsjXqVIipvNe6EQAzTTrwZpcm40gPpyefA/Znxng0Yulnpdv
         Nt2CKHGRxEgJQ0ovqRgL/wzmZMtYQXP74YmJ0upmObFhJoQfAlsN9vHZfvuBirfCNj
         jdDvCmBlmQr5Kz0K942tfHN6hiUkpq1ArouhkpAce1au6ev9kTjrmkg9Mz+akLRLlq
         zgd9WORikcOJOvauU/R7DGehHY3ayJfXt7R4o/GsdF2fCKRT38K0xqr4uoFjB6JG6j
         4oI6/sE1gYwPg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     Leon Romanovsky <leonro@nvidia.com>, drivers@pensando.io,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] ionic: cleanly release devlink instance
Date:   Wed, 21 Jul 2021 15:39:44 +0300
Message-Id: <956213a5c415c30e7e9f9c20bb50bc5b50ba4d18.1626870761.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The failure to register devlink will leave the system with dangled
devlink resource, which is not cleaned if devlink_port_register() fails.

In order to remove access to ".registered" field of struct devlink_port,
require both devlink_register and devlink_port_register to success and
check it through device pointer.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Future series will remove .registered field from the devlink.
---
 .../net/ethernet/pensando/ionic/ionic_devlink.c    | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index b41301a5b0df..cd520e4c5522 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -91,20 +91,20 @@ int ionic_devlink_register(struct ionic *ionic)
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	devlink_port_attrs_set(&ionic->dl_port, &attrs);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
-	if (err)
+	if (err) {
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
-	else
-		devlink_port_type_eth_set(&ionic->dl_port,
-					  ionic->lif->netdev);
+		devlink_unregister(dl);
+		return err;
+	}
 
-	return err;
+	devlink_port_type_eth_set(&ionic->dl_port, ionic->lif->netdev);
+	return 0;
 }
 
 void ionic_devlink_unregister(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
 
-	if (ionic->dl_port.registered)
-		devlink_port_unregister(&ionic->dl_port);
+	devlink_port_unregister(&ionic->dl_port);
 	devlink_unregister(dl);
 }
-- 
2.31.1

