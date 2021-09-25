Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4B24181A1
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343931AbhIYL01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244756AbhIYLZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1B0761352;
        Sat, 25 Sep 2021 11:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569058;
        bh=iRLV6v3e7JYAyZzq3uX24jBWmOHmWur2DvK8Vt/2i+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pR22exCjUS7YCkjkCvD8Rnb9sosGeBFWlArr/YA3QFWWrtyauBEi7+Tuhqd4afoJR
         eRUaq5hWn2OMw9LPTV8rZEfeRlENaJNpc2E4GJnYKmRa7zvr8b5JTcEqZmvEYOvhf/
         2YLSW8fytAdZTjkgmt/8HJ/SHvzIf7/eRAOikZt9Oa1UDm8a+EloI0pZzg2GkXLWp/
         kbdu3Un5+qwR8prVYLnTt23VXb+LJjt7pgc76zL+oyZsh181Sb/7IqLOeqFUK9InuA
         voqdYkfrjahsfJjF/DzkF/YIBNWKLGBMyC3/4eZXseBdGBO3ITOoLCyUVllM0CXPr8
         8zF7KKkx596zg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v1 21/21] net: dsa: Move devlink registration to be last devlink command
Date:   Sat, 25 Sep 2021 14:23:01 +0300
Message-Id: <66dd7979b44ac307711c382054f428f9287666a8.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This change prevents from users to access device before devlink
is fully configured.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/dsa/dsa2.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index a020339e1973..8ca6a1170c9d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -848,7 +848,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	dl_priv = devlink_priv(ds->devlink);
 	dl_priv->ds = ds;
 
-	devlink_register(ds->devlink);
 	/* Setup devlink port instances now, so that the switch
 	 * setup() can register regions etc, against the ports
 	 */
@@ -874,8 +873,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err)
 		goto teardown;
 
-	devlink_params_publish(ds->devlink);
-
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
 		ds->slave_mii_bus = mdiobus_alloc();
 		if (!ds->slave_mii_bus) {
@@ -891,7 +888,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	}
 
 	ds->setup = true;
-
+	devlink_register(ds->devlink);
 	return 0;
 
 free_slave_mii_bus:
@@ -906,7 +903,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	list_for_each_entry(dp, &ds->dst->ports, list)
 		if (dp->ds == ds)
 			dsa_port_devlink_teardown(dp);
-	devlink_unregister(ds->devlink);
 	devlink_free(ds->devlink);
 	ds->devlink = NULL;
 	return err;
@@ -919,6 +915,9 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	if (!ds->setup)
 		return;
 
+	if (ds->devlink)
+		devlink_unregister(ds->devlink);
+
 	if (ds->slave_mii_bus && ds->ops->phy_read) {
 		mdiobus_unregister(ds->slave_mii_bus);
 		mdiobus_free(ds->slave_mii_bus);
@@ -934,7 +933,6 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 		list_for_each_entry(dp, &ds->dst->ports, list)
 			if (dp->ds == ds)
 				dsa_port_devlink_teardown(dp);
-		devlink_unregister(ds->devlink);
 		devlink_free(ds->devlink);
 		ds->devlink = NULL;
 	}
-- 
2.31.1

