Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DC2418145
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244742AbhIYLYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244650AbhIYLYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CC4A6127A;
        Sat, 25 Sep 2021 11:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632568993;
        bh=0iCrJmusuY+MMUEQ//ywNHOofwBQzIGVnKfBKsYhLkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Un2ZXGs141wGHS2WheoisAp7znQPAsLcvAkFWEs/VT1FH8znj6ZuQ78vXW/UxmcNq
         DdEkagR3qqP2rfbHNVlg6STPvOVaZ0+ZfxAwDMiP0rNwXsJsLCfO7CIY/3nmp31XVw
         mcfvBqqu2/PDLgeC0sROwOWx1xKrrBzrswzkASx/156P4VKWx/jPoSaUSBLxOv+cne
         PBEte5Wz8kBJRU98ig/0GffGqKLmxAn3wYIyNB6qUMMgQN1ttlgrI02XyYZXimYavH
         eVXwwgstpU2BJ4eCFTUjvdEV6IX0VLMZ42T2n7f7/dAzBcN+b2XqdPVm20ncAAMeFq
         wP3LrJfUtJRLQ==
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
Subject: [PATCH net-next v1 02/21] bnxt_en: Register devlink instance at the end devlink configuration
Date:   Sat, 25 Sep 2021 14:22:42 +0300
Message-Id: <54d36bce5a78cdb4d51a9eaff6f2216fbbdd1004.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Move devlink_register() to be last command in devlink configuration
sequence, so no user space access will be possible till devlink instance
is fully operable. As part of this change, the devlink_params_publish
call is removed as not needed.

This change fixes forgotten devlink_params_unpublish() too.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index ed95e28d60ef..951c0c00cc95 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -745,14 +745,10 @@ static int bnxt_dl_params_register(struct bnxt *bp)
 
 	rc = devlink_params_register(bp->dl, bnxt_dl_params,
 				     ARRAY_SIZE(bnxt_dl_params));
-	if (rc) {
+	if (rc)
 		netdev_warn(bp->dev, "devlink_params_register failed. rc=%d\n",
 			    rc);
-		return rc;
-	}
-	devlink_params_publish(bp->dl);
-
-	return 0;
+	return rc;
 }
 
 static void bnxt_dl_params_unregister(struct bnxt *bp)
@@ -792,9 +788,8 @@ int bnxt_dl_register(struct bnxt *bp)
 	    bp->hwrm_spec_code > 0x10803)
 		bp->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 
-	devlink_register(dl);
 	if (!BNXT_PF(bp))
-		return 0;
+		goto out;
 
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = bp->pf.port_id;
@@ -811,6 +806,8 @@ int bnxt_dl_register(struct bnxt *bp)
 	if (rc)
 		goto err_dl_port_unreg;
 
+out:
+	devlink_register(dl);
 	return 0;
 
 err_dl_port_unreg:
@@ -824,10 +821,10 @@ void bnxt_dl_unregister(struct bnxt *bp)
 {
 	struct devlink *dl = bp->dl;
 
+	devlink_unregister(dl);
 	if (BNXT_PF(bp)) {
 		bnxt_dl_params_unregister(bp);
 		devlink_port_unregister(&bp->dl_port);
 	}
-	devlink_unregister(dl);
 	devlink_free(dl);
 }
-- 
2.31.1

