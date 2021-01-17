Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245FA2F9334
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 16:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbhAQPCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 10:02:09 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45154 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729074AbhAQPBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 10:01:05 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 17 Jan 2021 17:00:15 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10HF0F7F029614;
        Sun, 17 Jan 2021 17:00:15 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V3 4/8] net/bonding: Take update_features call out of XFRM funciton
Date:   Sun, 17 Jan 2021 16:59:45 +0200
Message-Id: <20210117145949.8632-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210117145949.8632-1-tariqt@nvidia.com>
References: <20210117145949.8632-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for more cases that call netdev_update_features().

While here, move the features logic to the stage where struct bond
is already updated, and pass it as the only parameter to function
bond_set_xfrm_features().

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 drivers/net/bonding/bond_options.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index a4e4e15f574d..7f0ad97926de 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -745,17 +745,17 @@ const struct bond_option *bond_opt_get(unsigned int option)
 	return &bond_opts[option];
 }
 
-static void bond_set_xfrm_features(struct net_device *bond_dev, u64 mode)
+static bool bond_set_xfrm_features(struct bonding *bond)
 {
 	if (!IS_ENABLED(CONFIG_XFRM_OFFLOAD))
-		return;
+		return false;
 
-	if (mode == BOND_MODE_ACTIVEBACKUP)
-		bond_dev->wanted_features |= BOND_XFRM_FEATURES;
+	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
+		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
 	else
-		bond_dev->wanted_features &= ~BOND_XFRM_FEATURES;
+		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
 
-	netdev_update_features(bond_dev);
+	return true;
 }
 
 static int bond_option_mode_set(struct bonding *bond,
@@ -780,13 +780,14 @@ static int bond_option_mode_set(struct bonding *bond,
 	if (newval->value == BOND_MODE_ALB)
 		bond->params.tlb_dynamic_lb = 1;
 
-	if (bond->dev->reg_state == NETREG_REGISTERED)
-		bond_set_xfrm_features(bond->dev, newval->value);
-
 	/* don't cache arp_validate between modes */
 	bond->params.arp_validate = BOND_ARP_VALIDATE_NONE;
 	bond->params.mode = newval->value;
 
+	if (bond->dev->reg_state == NETREG_REGISTERED)
+		if (bond_set_xfrm_features(bond))
+			netdev_update_features(bond->dev);
+
 	return 0;
 }
 
-- 
2.21.0

