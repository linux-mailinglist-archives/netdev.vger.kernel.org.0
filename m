Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3A941C40A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343590AbhI2MCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245278AbhI2MCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 08:02:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96DCF61409;
        Wed, 29 Sep 2021 12:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632916851;
        bh=hZUZHfgfiTNNYSpnegZKCRZ4rkRJapfY17ImCztFpso=;
        h=From:To:Cc:Subject:Date:From;
        b=noEJzrN8+a7bB2Ia3WV/RbudWF03qf8/UhZ3QzTdnCN1X5OLGFysMqcf1SkC3DZWG
         drQm3kpAV2CfhKxC2Q0FDh+hNwzaK2MApcI1pvoLamseqt8tsBOTXDEV7SBnXlC4Aj
         Zlb0BbN6MFK4TTJN7yJZKyDQZcHKM/InshW14ECHmH8AX8+hb8+j6GapFI8b438cdX
         MFYahDhd59cBpE3tQ2NufCayJdtET2WSuwk3xi7RNb7VwmgXcWKv9521E7WZfXdlas
         5Q3F8diYv/2raIFAG7sdhp4nnl/UggE6K0ia4pimnsBGxu1jrJjSQkF/W7Ox59ka87
         aBlDM9L2fCvWw==
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
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Shay Drory <shayd@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v1 0/5] Devlink reload and missed notifications fix
Date:   Wed, 29 Sep 2021 15:00:41 +0300
Message-Id: <cover.1632916329.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * Missed removal of extra WARN_ON
 * Added "ops parameter to macro as Dan suggested.
v0: https://lore.kernel.org/all/cover.1632909221.git.leonro@nvidia.com

-------------------------------------------------------------------
Hi,

This series starts from the fixing the bug introduced by implementing
devlink delayed notifications logic, where I missed some of the
notifications functions.

The rest series provides a way to dynamically set devlink ops that is
needed for mlx5 multiport device and starts cleanup by removing
not-needed logic.

In the next series, we will delete various publish API, drop general
lock, annotate the code and rework logic around devlink->lock.

All this is possible because driver initialization is separated from the
user input now.

Thanks

Leon Romanovsky (5):
  devlink: Add missed notifications iterators
  devlink: Allow modification of devlink ops
  devlink: Allow set specific ops callbacks dynamically
  net/mlx5: Register separate reload devlink ops for multiport device
  devlink: Delete reload enable/disable interface

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   6 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |   2 +-
 .../freescale/dpaa2/dpaa2-eth-devlink.c       |   2 +-
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |   5 +-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |   5 +-
 .../net/ethernet/huawei/hinic/hinic_devlink.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   2 +-
 .../marvell/octeontx2/af/rvu_devlink.c        |   2 +-
 .../marvell/prestera/prestera_devlink.c       |   2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |   4 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  15 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   3 -
 .../mellanox/mlx5/core/sf/dev/driver.c        |   5 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  12 +-
 drivers/net/ethernet/mscc/ocelot.h            |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   2 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |   2 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.h |   2 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |   2 +-
 drivers/net/netdevsim/dev.c                   |   5 +-
 drivers/ptp/ptp_ocp.c                         |   2 +-
 drivers/staging/qlge/qlge_main.c              |   2 +-
 include/net/devlink.h                         |  15 +-
 net/core/devlink.c                            | 156 ++++++++++--------
 net/dsa/dsa2.c                                |   2 +-
 28 files changed, 131 insertions(+), 134 deletions(-)

-- 
2.31.1

