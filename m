Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7A1418138
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244551AbhIYLYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236171AbhIYLYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:24:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10A496103B;
        Sat, 25 Sep 2021 11:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632568986;
        bh=9vQ7Jy6vxv+17KL8sYGHu0D+tMeIG2i6YIeiCDwml2M=;
        h=From:To:Cc:Subject:Date:From;
        b=hpCTP/IfVfGHBzOHP5/ERVih7Np+6S1CF2jaWxQBoSaPpWxvmWDrfmi7KtqGbIaVj
         4OMP9F328p7IEKsQzcAUW5dQQZYTXDjoQuwu64EE7m2nYqbjppu/uR38XLj8XZIz7k
         tRfvIx0CnP2L6dSIHqOzY5bRfwrLvqQDlcJnq1VfFHVYWyTvhdVEHmtM8lyZU08CB5
         pGGeo0dbRn2QmrPwLTpyFDlqv0X0xbge20cSdYgMMwH28HeTweZHf7K4m97G8m+PMS
         HvoMMFLiqX8Bo6SQ1BDgqdXOzuUK17iTJZMKO1OupxzLl6OnuXkShCsq0tTaFU/EGp
         tBeh0G+D96Qhw==
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
Subject: [PATCH net-next v1 00/21] Move devlink_register to be last devlink command
Date:   Sat, 25 Sep 2021 14:22:40 +0300
Message-Id: <cover.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This is second version of patch series
https://lore.kernel.org/netdev/cover.1628599239.git.leonro@nvidia.com/

The main change is addition of delayed notification logic that will
allowed us to delete devlink_params_publish API (future series will
remove it completely) and conversion of all drivers to have devlink_register
being last commend.

The series itself is pretty straightforward, except liquidio driver
which performs initializations in various workqueues without proper
locks. That driver doesn't hole device_lock and it is clearly broken
for any parallel driver core flows (modprobe + devlink + PCI reset will
100% crash it).

In order to annotate devlink_register() will lockdep of holding
device_lock, I added workaround in this driver.

Thanks

----------------------
From previous cover letter:
Hi Dave and Jakub,

This series prepares code to remove devlink_reload_enable/_disable API
and in order to do, we move all devlink_register() calls to be right
before devlink_reload_enable().

The best place for such a call should be right before exiting from
the probe().

This is done because devlink_register() opens devlink netlink to the
users and gives them a venue to issue commands before initialization
is finished.

1. Some drivers were aware of such "functionality" and tried to protect
themselves with extra locks, state machines and devlink_reload_enable().
Let's assume that it worked for them, but I'm personally skeptical about
it.

2. Some drivers copied that pattern, but without locks and state
machines. That protected them from reload flows, but not from any _set_
routines.

3. And all other drivers simply didn't understand the implications of early
devlink_register() and can be seen as "broken".

Thanks

Leon Romanovsky (21):
  devlink: Notify users when objects are accessible
  bnxt_en: Register devlink instance at the end devlink configuration
  liquidio: Overcome missing device lock protection in init/remove flows
  dpaa2-eth: Register devlink instance at the end of probe
  net: hinic: Open device for the user access when it is ready
  ice: Open devlink when device is ready
  octeontx2: Move devlink registration to be last devlink command
  net/prestera: Split devlink and traps registrations to separate
    routines
  net/mlx4: Move devlink_register to be the last initialization command
  net/mlx5: Accept devlink user input after driver initialization
    complete
  mlxsw: core: Register devlink instance last
  net: mscc: ocelot: delay devlink registration to the end
  nfp: Move delink_register to be last command
  ionic: Move devlink registration to be last devlink command
  qed: Move devlink registration to be last devlink command
  net: ethernet: ti: Move devlink registration to be last devlink
    command
  netdevsim: Move devlink registration to be last devlink command
  net: wwan: iosm: Move devlink_register to be last devlink command
  ptp: ocp: Move devlink registration to be last devlink command
  staging: qlge: Move devlink registration to be last devlink command
  net: dsa: Move devlink registration to be last devlink command

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  15 +--
 .../net/ethernet/cavium/liquidio/lio_main.c   |  19 ++--
 .../freescale/dpaa2/dpaa2-eth-devlink.c       |  14 ++-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   9 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |   5 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |   7 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   6 +-
 .../marvell/octeontx2/af/rvu_devlink.c        |  10 +-
 .../marvell/octeontx2/nic/otx2_devlink.c      |  15 +--
 .../marvell/prestera/prestera_devlink.c       |  29 +----
 .../marvell/prestera/prestera_devlink.h       |   4 +-
 .../ethernet/marvell/prestera/prestera_main.c |   8 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |   8 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   9 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   2 +
 .../mellanox/mlx5/core/sf/dev/driver.c        |   2 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  19 +---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |   5 +-
 .../ethernet/netronome/nfp/devlink_param.c    |   9 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |   5 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |   7 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  15 +--
 drivers/net/ethernet/ti/cpsw_new.c            |   7 +-
 drivers/net/netdevsim/dev.c                   |   8 +-
 drivers/net/wwan/iosm/iosm_ipc_devlink.c      |   7 +-
 drivers/ptp/ptp_ocp.c                         |   6 +-
 drivers/staging/qlge/qlge_main.c              |   8 +-
 net/core/devlink.c                            | 107 +++++++++++++++---
 net/dsa/dsa2.c                                |  10 +-
 30 files changed, 202 insertions(+), 177 deletions(-)

-- 
2.31.1

