Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE0D418152
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245124AbhIYLZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244574AbhIYLY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:24:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 853346128B;
        Sat, 25 Sep 2021 11:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569003;
        bh=02xRTwet1c5l8qRgcXs4VCpKQJvqfYPSwFUrWIoc2cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBdkOeQZAzQfx/m/yxFbsJIGBvkhRpE2hSfkJbHrHeRhC5LOGgZSfk4qdoFd5jXLC
         4cajFeDHROqHcKL6Uxo3t/x66TBMHadOtMGgbKbHUJLVc+EoKzRywI13DAUuwL4Nmy
         XdaiN+sF1pwhdlQ+uSs0w4bITD8GdZlM7wYUfcvrz8HaBW66RC6ITexIAdOoJUX2tS
         NdMaGkjmUePmj+YdIJxYmXTz6HRjqnWB052FPKJjeF22nVurS6AbIJA54sOsNoQIvo
         MozNtLmeX9dcJkGV28/X2nazhnG4nqa89dbG8o8cBxCkZF4jyGYcMvQtjkCR91Gadf
         06/PrR1PnbLsA==
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
Subject: [PATCH net-next v1 03/21] liquidio: Overcome missing device lock protection in init/remove flows
Date:   Sat, 25 Sep 2021 14:22:43 +0300
Message-Id: <4e78bd8c6f45eef8093547a37c4d00ef0d1fef56.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The liquidio driver is broken by design. It initialize PCI devices
in separate delayed works. It causes to the situation where device lock
is dropped during initialize and remove sequences.

That lock is part of driver/core and needed to protect from races during
init, destroy and bus invocations.

In addition to lack of locking protection, it has incorrect order of
destroy flows and very questionable synchronization scheme based on
atomic_t.

This change doesn't fix that driver but makes sure that rest of the
netdev subsystem doesn't suffer from such basic protection by adding
device_lock over devlink_*() APIs and by moving devlink_register()
to be last command in setup_nic_devices().

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index a34b3bb2dd4f..dafc79bd34f4 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1279,6 +1279,14 @@ static int liquidio_stop_nic_module(struct octeon_device *oct)
 	struct lio *lio;
 
 	dev_dbg(&oct->pci_dev->dev, "Stopping network interfaces\n");
+	device_lock(&oct->pci_dev->dev);
+	if (oct->devlink) {
+		devlink_unregister(oct->devlink);
+		devlink_free(oct->devlink);
+		oct->devlink = NULL;
+	}
+	device_unlock(&oct->pci_dev->dev);
+
 	if (!oct->ifcount) {
 		dev_err(&oct->pci_dev->dev, "Init for Octeon was not completed\n");
 		return 1;
@@ -1300,12 +1308,6 @@ static int liquidio_stop_nic_module(struct octeon_device *oct)
 	for (i = 0; i < oct->ifcount; i++)
 		liquidio_destroy_nic_device(oct, i);
 
-	if (oct->devlink) {
-		devlink_unregister(oct->devlink);
-		devlink_free(oct->devlink);
-		oct->devlink = NULL;
-	}
-
 	dev_dbg(&oct->pci_dev->dev, "Network interfaces stopped\n");
 	return 0;
 }
@@ -3749,10 +3751,12 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		}
 	}
 
+	device_lock(&octeon_dev->pci_dev->dev);
 	devlink = devlink_alloc(&liquidio_devlink_ops,
 				sizeof(struct lio_devlink_priv),
 				&octeon_dev->pci_dev->dev);
 	if (!devlink) {
+		device_unlock(&octeon_dev->pci_dev->dev);
 		dev_err(&octeon_dev->pci_dev->dev, "devlink alloc failed\n");
 		goto setup_nic_dev_free;
 	}
@@ -3760,9 +3764,10 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 	lio_devlink = devlink_priv(devlink);
 	lio_devlink->oct = octeon_dev;
 
-	devlink_register(devlink);
 	octeon_dev->devlink = devlink;
 	octeon_dev->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
+	devlink_register(devlink);
+	device_unlock(&octeon_dev->pci_dev->dev);
 
 	return 0;
 
-- 
2.31.1

