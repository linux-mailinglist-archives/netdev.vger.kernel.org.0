Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902BB418165
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245389AbhIYLZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244871AbhIYLZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17AC6610F7;
        Sat, 25 Sep 2021 11:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569014;
        bh=l4ubO1iNO/eKHGDuYjGRafB4EwpXo5nxoxsjU5XAGKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssn8r6T5ipfBUV1Bjq6AnhfL44IZyOMHmXeWU6/9hH1lTVCmQSiosocc/kJUbkg7Y
         2ibqp53ysp4VfOvt0pQcVBcLBGi1uwBdc2dShLgM8OithU5F704lKTB7QVpgQDEKjC
         xmoGjPqQuCIbs+A8gi2Xn5lorLDn3A7B3youjreW56czvxw13U73pZkmuVqZ04sCkz
         ypZ5JISMkGCifzna5/Lo6ceMPQIjL0Wz/NZvKz7rozYwHq/LYCRWlYsOvw9BeKhkIu
         yaZ08tgzL9k1IR8iSCJU4gK9wHDjHmylgObF4TNSoK+AUmkpzkf0/PSGQeyQ4+p2pj
         19gPtbN90X9aw==
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
Subject: [PATCH net-next v1 06/21] ice: Open devlink when device is ready
Date:   Sat, 25 Sep 2021 14:22:46 +0300
Message-Id: <23884bb7be2cc08ae00c551a6bb7d200a75b5117.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Move devlink_registration routine to be the last command, when the
device is fully initialized.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index aacc0b345bbe..627adf8fb89d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4258,8 +4258,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	pf->msg_enable = netif_msg_init(debug, ICE_DFLT_NETIF_M);
 
-	ice_devlink_register(pf);
-
 #ifndef CONFIG_DYNAMIC_DEBUG
 	if (debug < -1)
 		hw->debug_mask = debug;
@@ -4493,6 +4491,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		dev_warn(dev, "RDMA is not supported on this device\n");
 	}
 
+	ice_devlink_register(pf);
 	return 0;
 
 err_init_aux_unroll:
@@ -4516,7 +4515,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	ice_devlink_destroy_regions(pf);
 	ice_deinit_hw(hw);
 err_exit_unroll:
-	ice_devlink_unregister(pf);
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 	return err;
@@ -4593,6 +4591,7 @@ static void ice_remove(struct pci_dev *pdev)
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 	int i;
 
+	ice_devlink_unregister(pf);
 	for (i = 0; i < ICE_MAX_RESET_WAIT; i++) {
 		if (!ice_is_reset_in_progress(pf->state))
 			break;
@@ -4629,7 +4628,6 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_deinit_pf(pf);
 	ice_devlink_destroy_regions(pf);
 	ice_deinit_hw(&pf->hw);
-	ice_devlink_unregister(pf);
 
 	/* Issue a PFR as part of the prescribed driver unload flow.  Do not
 	 * do it via ice_schedule_reset() since there is no need to rebuild
-- 
2.31.1

