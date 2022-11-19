Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74116311A8
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiKSXEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiKSXEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:04:06 -0500
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A7E13D59
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 15:04:04 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:03:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899042; x=1669158242;
        bh=+2RamIkuDnXylPR5VRm6o9lU1wMBTRfv9dHoAUO5Tfg=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=K/zV5wbCWWoaMdcMPne92LyVrNwkPngmuf0CQdXKT2UVM8K9QNA7r/5N/8II+ZuKX
         g5tbGXJ9pi+WiHNbA0E7bge6XmopmzgC1f6PYVOBuMfsWdKcYA/U3cq7eV0LmkW60p
         ygwHOreetxq17F1rK5zZxIZAfJgp7pE7609iScP9GEqQMouWlXq7fXVnZlpa7sL4Fz
         uf3eplJ5Wr59nkGnUKF0YISrimMHrbr1MUUUgVUcpROam7TGX1sjywpCEFwIlyPcqu
         u2hiWV0TA6WLKHoF0orSKWGjZVt1vZUjMvFekVRL7bTWzswSK7KUQpZT56crZN2jZd
         2D1qNtG1ZKD8g==
To:     linux-kbuild@vger.kernel.org
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/18] treewide: fix object files shared between several modules
Message-ID: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up to the series[0] that adds Kbuild warning if an
object is linked into several modules (including vmlinux) in order
to prevent hidden side effects from appearing.
The original series, as well as this one, was inspired by the recent
issue[1] with the ZSTD modules on a platform which has such sets of
vmlinux cflags and module cflags so that objects built with those
two even refuse to link with each other.
The final goal is to forbid linking one object several times
entirely.

Patches 1-7 and 10-11 was runtime-tested by me. Pathes 8-9 and 12-18
are compile-time tested only (compile, link, modpost), so I
encourage the maintainers to review them carefully. At least the
last one, for cpsw, most likely has issues :D
Masahiro's patches are taken from his WIP tree[2], with the two last
finished by me.

This mostly is a monotonic work, all scores go to Masahiro and
Alexey :P

[0] https://lore.kernel.org/linux-kbuild/20221118191551.66448-1-masahiroy@k=
ernel.org
[1] https://github.com/torvalds/linux/commit/637a642f5ca5e850186bb64ac75ebb=
0f124b458d
[2] https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.=
git/log/?h=3Dtmp4

Alexander Lobakin (9):
  EDAC: i10nm, skx: fix mixed module-builtin object
  platform/x86: int3472: fix object shared between several modules
  mtd: tests: fix object shared between several modules
  crypto: octeontx2: fix objects shared between several modules
  dsa: ocelot: fix mixed module-builtin object
  net: dpaa2: fix mixed module-builtin object
  net: hns3: fix mixed module-builtin object
  net: octeontx2: fix mixed module-builtin object
  net: cpsw: fix mixed module-builtin object

Masahiro Yamada (9):
  block/rnbd: fix mixed module-builtin object
  drm/bridge: imx: fix mixed module-builtin object
  drm/bridge: imx: turn imx8{qm,qxp}-ldb into single-object modules
  sound: fix mixed module-builtin object
  mfd: rsmu: fix mixed module-builtin object
  mfd: rsmu: turn rsmu-{core,i2c,spi} into single-object modules
  net: liquidio: fix mixed module-builtin object
  net: enetc: fix mixed module-builtin object
  net: emac, cpsw: fix mixed module-builtin object (davinci_cpdma)

 drivers/block/rnbd/Makefile                   |   6 +-
 drivers/block/rnbd/rnbd-common.c              |  23 -
 drivers/block/rnbd/rnbd-proto.h               |  14 +-
 drivers/crypto/marvell/octeontx2/Makefile     |  11 +-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c  |   9 +-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |   2 -
 .../marvell/octeontx2/otx2_cpt_common.h       |   2 -
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  14 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  11 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |   2 +
 .../marvell/octeontx2/otx2_cptvf_main.c       |   2 +
 drivers/edac/Kconfig                          |  11 +-
 drivers/edac/Makefile                         |   7 +-
 drivers/edac/i10nm_base.c                     |   2 +
 drivers/edac/skx_base.c                       |   2 +
 drivers/edac/skx_common.c                     |  21 +-
 drivers/edac/skx_common.h                     |   4 +-
 drivers/gpu/drm/bridge/imx/Makefile           |   4 -
 drivers/gpu/drm/bridge/imx/imx-ldb-helper.c   | 221 -----
 drivers/gpu/drm/bridge/imx/imx-ldb-helper.h   | 213 +++-
 .../imx/{imx8qm-ldb-drv.c =3D> imx8qm-ldb.c}    |   0
 .../imx/{imx8qxp-ldb-drv.c =3D> imx8qxp-ldb.c}  |   0
 drivers/mfd/Kconfig                           |   8 +-
 drivers/mfd/Makefile                          |   3 +-
 drivers/mfd/{rsmu_core.c =3D> rsmu-core.c}      |   3 +
 drivers/mfd/{rsmu_i2c.c =3D> rsmu-i2c.c}        |   0
 drivers/mfd/{rsmu_spi.c =3D> rsmu-spi.c}        |   0
 drivers/mtd/tests/Makefile                    |  17 +-
 drivers/mtd/tests/mtd_test.c                  |   9 +
 drivers/mtd/tests/nandbiterrs.c               |   2 +
 drivers/mtd/tests/oobtest.c                   |   2 +
 drivers/mtd/tests/pagetest.c                  |   2 +
 drivers/mtd/tests/readtest.c                  |   2 +
 drivers/mtd/tests/speedtest.c                 |   2 +
 drivers/mtd/tests/stresstest.c                |   2 +
 drivers/mtd/tests/subpagetest.c               |   2 +
 drivers/mtd/tests/torturetest.c               |   2 +
 drivers/net/dsa/ocelot/Kconfig                |  18 +-
 drivers/net/dsa/ocelot/Makefile               |  12 +-
 drivers/net/dsa/ocelot/felix.c                |   6 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   2 +
 drivers/net/dsa/ocelot/seville_vsc9953.c      |   2 +
 drivers/net/ethernet/cavium/Kconfig           |   5 +
 drivers/net/ethernet/cavium/liquidio/Makefile |   4 +-
 .../cavium/liquidio/cn23xx_pf_device.c        |   4 +
 .../cavium/liquidio/cn23xx_vf_device.c        |   3 +
 .../ethernet/cavium/liquidio/cn66xx_device.c  |   1 +
 .../ethernet/cavium/liquidio/cn68xx_device.c  |   1 +
 .../net/ethernet/cavium/liquidio/lio_core.c   |  16 +
 .../ethernet/cavium/liquidio/lio_ethtool.c    |   1 +
 .../ethernet/cavium/liquidio/octeon_device.c  |  24 +
 .../ethernet/cavium/liquidio/octeon_droq.c    |   4 +
 .../ethernet/cavium/liquidio/octeon_mem_ops.c |   5 +
 .../net/ethernet/cavium/liquidio/octeon_nic.c |   3 +
 .../cavium/liquidio/request_manager.c         |  14 +
 .../cavium/liquidio/response_manager.c        |   3 +
 drivers/net/ethernet/freescale/dpaa2/Kconfig  |   6 +
 drivers/net/ethernet/freescale/dpaa2/Makefile |   6 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   2 +
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  15 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   2 +
 drivers/net/ethernet/freescale/enetc/Kconfig  |   5 +
 drivers/net/ethernet/freescale/enetc/Makefile |   7 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  21 +
 .../net/ethernet/freescale/enetc/enetc_cbdr.c |   7 +
 .../ethernet/freescale/enetc/enetc_ethtool.c  |   2 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   2 +
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   2 +
 drivers/net/ethernet/hisilicon/Kconfig        |   5 +
 drivers/net/ethernet/hisilicon/hns3/Makefile  |  13 +-
 .../hns3/hns3_common/hclge_comm_cmd.c         |  27 +-
 .../hns3/hns3_common/hclge_comm_cmd.h         |   8 -
 .../hns3/hns3_common/hclge_comm_rss.c         |  17 +
 .../hns3/hns3_common/hclge_comm_tqp_stats.c   |   5 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   2 +
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |   2 +
 .../net/ethernet/marvell/octeontx2/Kconfig    |   5 +
 .../ethernet/marvell/octeontx2/nic/Makefile   |  14 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   1 -
 .../marvell/octeontx2/nic/otx2_dcbnl.c        |   8 +-
 .../marvell/octeontx2/nic/otx2_devlink.c      |   2 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   2 +
 .../ethernet/marvell/octeontx2/nic/otx2_ptp.c |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   2 +
 drivers/net/ethernet/ti/Kconfig               |  13 +
 drivers/net/ethernet/ti/Makefile              |  16 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   2 +
 drivers/net/ethernet/ti/cpsw.c                |   3 +
 drivers/net/ethernet/ti/cpsw_ale.c            |  20 +
 drivers/net/ethernet/ti/cpsw_ethtool.c        |  24 +
 drivers/net/ethernet/ti/cpsw_new.c            |   3 +
 drivers/net/ethernet/ti/cpsw_priv.c           |  36 +
 drivers/net/ethernet/ti/cpsw_sl.c             |   8 +
 drivers/net/ethernet/ti/davinci_cpdma.c       |  33 +
 drivers/net/ethernet/ti/davinci_emac.c        |   2 +
 drivers/net/ethernet/ti/netcp_core.c          |   2 +
 drivers/net/ethernet/ti/netcp_ethss.c         |   2 +
 drivers/platform/x86/intel/int3472/Makefile   |   8 +-
 drivers/platform/x86/intel/int3472/common.c   |   8 +
 drivers/platform/x86/intel/int3472/discrete.c |   2 +
 drivers/platform/x86/intel/int3472/tps68470.c |   2 +
 sound/soc/codecs/Makefile                     |   6 +-
 sound/soc/codecs/wcd-clsh-v2.c                | 903 -----------------
 sound/soc/codecs/wcd-clsh-v2.h                | 917 +++++++++++++++++-
 104 files changed, 1679 insertions(+), 1288 deletions(-)
 delete mode 100644 drivers/block/rnbd/rnbd-common.c
 delete mode 100644 drivers/gpu/drm/bridge/imx/imx-ldb-helper.c
 rename drivers/gpu/drm/bridge/imx/{imx8qm-ldb-drv.c =3D> imx8qm-ldb.c} (10=
0%)
 rename drivers/gpu/drm/bridge/imx/{imx8qxp-ldb-drv.c =3D> imx8qxp-ldb.c} (=
100%)
 rename drivers/mfd/{rsmu_core.c =3D> rsmu-core.c} (94%)
 rename drivers/mfd/{rsmu_i2c.c =3D> rsmu-i2c.c} (100%)
 rename drivers/mfd/{rsmu_spi.c =3D> rsmu-spi.c} (100%)
 delete mode 100644 sound/soc/codecs/wcd-clsh-v2.c

--
2.38.1


