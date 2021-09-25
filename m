Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD13418181
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343683AbhIYLZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244902AbhIYLZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B775B6128C;
        Sat, 25 Sep 2021 11:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569031;
        bh=xa9GziJGjO+uYR+6TLvwaU0ghnPSlFl4J+UcvATj0rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sh5UCjWPwOf2FQDfkuASXPFp/fNpsJHp5uxIvwgGsrxq4+tYmgNyYTY30hIF2jbP0
         FOZ80qEQnPV2vSc/Tv9uRTO+IDefIr7Ysc8W8FcVPJN+HViEyz0m7eIWHdt93GGo7a
         HUrEErXyzrYmBaJadre4duxUrAj/tJVTh87LQS1CSQKHDIS5bxRigi/BGcuLTlSoS+
         A2HJqVcXKjt75hbAM8bIVgc2/Si6Ibd7nFYBFjBLt18A+LxshbWa+yxcfHNJVBVQJI
         xKOy57wtXFbtDXyaPBt9Cb5QkNXwWVIEDUXaffiJAl8dT224YWEEmPlxFFRh61STQw
         jkPCR4A3oV7nA==
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
Subject: [PATCH net-next v1 14/21] ionic: Move devlink registration to be last devlink command
Date:   Sat, 25 Sep 2021 14:22:54 +0300
Message-Id: <cb187a035b75dbcc27f6dd10d72f18f1101bad44.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This change prevents from users to access device before devlink is
fully configured.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 93282394d332..2267da95640b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -82,7 +82,6 @@ int ionic_devlink_register(struct ionic *ionic)
 	struct devlink_port_attrs attrs = {};
 	int err;
 
-	devlink_register(dl);
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	devlink_port_attrs_set(&ionic->dl_port, &attrs);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
@@ -93,6 +92,7 @@ int ionic_devlink_register(struct ionic *ionic)
 	}
 
 	devlink_port_type_eth_set(&ionic->dl_port, ionic->lif->netdev);
+	devlink_register(dl);
 	return 0;
 }
 
@@ -100,6 +100,6 @@ void ionic_devlink_unregister(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
 
-	devlink_port_unregister(&ionic->dl_port);
 	devlink_unregister(dl);
+	devlink_port_unregister(&ionic->dl_port);
 }
-- 
2.31.1

