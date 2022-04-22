Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2282450BAE4
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 16:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449031AbiDVPAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448433AbiDVPAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:00:02 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E588D5AA72
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:57:08 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 90A1F320133;
        Fri, 22 Apr 2022 15:57:06 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhuiY-00077l-9c; Fri, 22 Apr 2022 15:57:06 +0100
Subject: [PATCH linx-net 00/28]: Move Siena into a separate subdirectory
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:57:06 +0100
Message-ID: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,
        SPOOF_GMAIL_MID autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Siena NICs (SFN5000 and SFN6000 series) went EOL in November 2021.
Most of these adapters have been remove from our test labs, and testing
has been reduced to a minimum.

This patch series creates a separate kernel module for the Siena architecture,
analogous to what was done for Falcon some years ago.
This reduces our maintenance for the sfc.ko module, and allows us to
enhance the EF10 and EF100 drivers without the risk of breaking Siena NICs.

After this series Siena code can be removed from sfc.ko. That will be posted
as a separate (small) series.
The Siena module is not built by default, but can be enabled
using Kconfig option SFC_SIENA. This will create module sfc-siena.ko.

	Patches

Patch 1 disables the Siena code in the sfc.ko module.
Patches 2-4 establish the code base for the Siena driver.
Patches 5-20 ensure the allyesconfig build succeeds.
Patches 21-28 make changes specfic to the Siena module.

I do not expect patch 2 and 3 to be reviewed, they are FYI only.
No checkpatch issues were resolved as part of these 2, but they
were fixed in the subsequent patches.

	Testing

Various build tests were done such as allyesconfig, W=1 and sparse.
The new sfc-siena.ko and sfc.ko modules were tested on a machine with both
these NICs in them, and several tests were run on both drivers.
Inserting the updated sfc.ko and the new sfc-siena.ko modules at the same
time works, so no external functions exist with the same name.

Martin Habets <habetsm.xilinx@gmail.com>
---

Martin Habets (28):
      sfc: Disable Siena support
      sfc: Move Siena specific files
      sfc: Copy shared files needed for Siena
      sfc: Remove build references to missing functionality
      sfc/siena: Rename functions in efx_common.h to avoid conflicts with sfc
      sfc/siena: Rename functions in efx.h to avoid conflicts with sfc
      sfc/siena: Rename functions in efx_channels.h to avoid conflicts with sfc
      sfc/siena: Update nic.h to avoid conflicts with sfc
      sfc/siena: Remove unused functions in tx.h to avoid conflicts with sfc
      sfc/siena: Rename functions in rx_common.h to avoid conflicts with sfc
      sfc/siena: Rename functions in tx_common.h to avoid conflicts with sfc
      sfc/siena: Rename functions in selftest.h to avoid conflicts with sfc
      sfc/siena: Rename functions in ethtool_common.h to avoid conflicts with sfc
      sfc/siena: Rename functions in ptp.h to avoid conflicts with sfc
      sfc/siena: Rename functions in mcdi.h to avoid conflicts with sfc
      sfc/siena: Rename functions in mcdi_port.h to avoid conflicts with sfc
      sfc/siena: Rename functions in mcdi_port_common.h to avoid conflicts with sfc
      sfc/siena: Rename loopback_mode in net_driver.h to avoid a conflict with sfc
      sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
      sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
      sfc: Add a basic Siena module
      siena: Make the (un)load message more specific
      siena: Make MTD support specific for Siena
      siena: Make SRIOV support specific for Siena
      siena: Make HWMON support specific for Siena
      sfc/siena: Make MCDI logging support specific for Siena
      sfc/siena: Make PTP and reset support specific for Siena
      sfc/siena: Reinstate SRIOV init/fini function calls


 drivers/net/ethernet/sfc/Kconfig                  |   15 
 drivers/net/ethernet/sfc/Makefile                 |    5 
 drivers/net/ethernet/sfc/efx.c                    |   17 
 drivers/net/ethernet/sfc/farch.c                  | 2988 ---
 drivers/net/ethernet/sfc/nic.h                    |    4 
 drivers/net/ethernet/sfc/siena.c                  | 1109 -
 drivers/net/ethernet/sfc/siena/Kconfig            |   45 
 drivers/net/ethernet/sfc/siena/Makefile           |   11 
 drivers/net/ethernet/sfc/siena/bitfield.h         |  614 +
 drivers/net/ethernet/sfc/siena/efx.c              | 1325 +
 drivers/net/ethernet/sfc/siena/efx.h              |  218 
 drivers/net/ethernet/sfc/siena/efx_channels.c     | 1360 +
 drivers/net/ethernet/sfc/siena/efx_channels.h     |   45 
 drivers/net/ethernet/sfc/siena/efx_common.c       | 1408 +
 drivers/net/ethernet/sfc/siena/efx_common.h       |  118 
 drivers/net/ethernet/sfc/siena/enum.h             |  176 
 drivers/net/ethernet/sfc/siena/ethtool.c          |  282 
 drivers/net/ethernet/sfc/siena/ethtool_common.c   | 1340 +
 drivers/net/ethernet/sfc/siena/ethtool_common.h   |   60 
 drivers/net/ethernet/sfc/siena/farch.c            | 2990 +++
 drivers/net/ethernet/sfc/siena/farch_regs.h       | 2929 +++
 drivers/net/ethernet/sfc/siena/filter.h           |  309 
 drivers/net/ethernet/sfc/siena/io.h               |  310 
 drivers/net/ethernet/sfc/siena/mcdi.c             | 2260 ++
 drivers/net/ethernet/sfc/siena/mcdi.h             |  386 
 drivers/net/ethernet/sfc/siena/mcdi_mon.c         |  531 +
 drivers/net/ethernet/sfc/siena/mcdi_pcol.h        |21968 +++++++++++++++++++++
 drivers/net/ethernet/sfc/siena/mcdi_port.c        |  110 
 drivers/net/ethernet/sfc/siena/mcdi_port.h        |   17 
 drivers/net/ethernet/sfc/siena/mcdi_port_common.c | 1282 +
 drivers/net/ethernet/sfc/siena/mcdi_port_common.h |   58 
 drivers/net/ethernet/sfc/siena/mtd.c              |  124 
 drivers/net/ethernet/sfc/siena/net_driver.h       | 1715 ++
 drivers/net/ethernet/sfc/siena/nic.c              |  530 +
 drivers/net/ethernet/sfc/siena/nic.h              |  206 
 drivers/net/ethernet/sfc/siena/nic_common.h       |  251 
 drivers/net/ethernet/sfc/siena/ptp.c              | 2201 ++
 drivers/net/ethernet/sfc/siena/ptp.h              |   45 
 drivers/net/ethernet/sfc/siena/rx.c               |  400 
 drivers/net/ethernet/sfc/siena/rx_common.c        | 1091 +
 drivers/net/ethernet/sfc/siena/rx_common.h        |  110 
 drivers/net/ethernet/sfc/siena/selftest.c         |  807 +
 drivers/net/ethernet/sfc/siena/selftest.h         |   52 
 drivers/net/ethernet/sfc/siena/siena.c            | 1113 +
 drivers/net/ethernet/sfc/siena/siena_sriov.c      | 1687 ++
 drivers/net/ethernet/sfc/siena/siena_sriov.h      |   79 
 drivers/net/ethernet/sfc/siena/sriov.h            |   83 
 drivers/net/ethernet/sfc/siena/tx.c               |  395 
 drivers/net/ethernet/sfc/siena/tx.h               |   40 
 drivers/net/ethernet/sfc/siena/tx_common.c        |  448 
 drivers/net/ethernet/sfc/siena/tx_common.h        |   39 
 drivers/net/ethernet/sfc/siena/vfdi.h             |  252 
 drivers/net/ethernet/sfc/siena/workarounds.h      |   28 
 drivers/net/ethernet/sfc/siena_sriov.c            | 1686 --
 drivers/net/ethernet/sfc/siena_sriov.h            |   76 
 55 files changed, 51859 insertions(+), 5889 deletions(-)
 delete mode 100644 drivers/net/ethernet/sfc/farch.c
 delete mode 100644 drivers/net/ethernet/sfc/siena.c
 create mode 100644 drivers/net/ethernet/sfc/siena/Kconfig
 create mode 100644 drivers/net/ethernet/sfc/siena/Makefile
 create mode 100644 drivers/net/ethernet/sfc/siena/bitfield.h
 create mode 100644 drivers/net/ethernet/sfc/siena/efx.c
 create mode 100644 drivers/net/ethernet/sfc/siena/efx.h
 create mode 100644 drivers/net/ethernet/sfc/siena/efx_channels.c
 create mode 100644 drivers/net/ethernet/sfc/siena/efx_channels.h
 create mode 100644 drivers/net/ethernet/sfc/siena/efx_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/efx_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/enum.h
 create mode 100644 drivers/net/ethernet/sfc/siena/ethtool.c
 create mode 100644 drivers/net/ethernet/sfc/siena/ethtool_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/ethtool_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/farch.c
 create mode 100644 drivers/net/ethernet/sfc/siena/farch_regs.h
 create mode 100644 drivers/net/ethernet/sfc/siena/filter.h
 create mode 100644 drivers/net/ethernet/sfc/siena/io.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi.c
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_mon.c
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_pcol.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_port.c
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_port.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_port_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_port_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mtd.c
 create mode 100644 drivers/net/ethernet/sfc/siena/net_driver.h
 create mode 100644 drivers/net/ethernet/sfc/siena/nic.c
 create mode 100644 drivers/net/ethernet/sfc/siena/nic.h
 create mode 100644 drivers/net/ethernet/sfc/siena/nic_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/ptp.c
 create mode 100644 drivers/net/ethernet/sfc/siena/ptp.h
 create mode 100644 drivers/net/ethernet/sfc/siena/rx.c
 create mode 100644 drivers/net/ethernet/sfc/siena/rx_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/rx_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/selftest.c
 create mode 100644 drivers/net/ethernet/sfc/siena/selftest.h
 create mode 100644 drivers/net/ethernet/sfc/siena/siena.c
 create mode 100644 drivers/net/ethernet/sfc/siena/siena_sriov.c
 create mode 100644 drivers/net/ethernet/sfc/siena/siena_sriov.h
 create mode 100644 drivers/net/ethernet/sfc/siena/sriov.h
 create mode 100644 drivers/net/ethernet/sfc/siena/tx.c
 create mode 100644 drivers/net/ethernet/sfc/siena/tx.h
 create mode 100644 drivers/net/ethernet/sfc/siena/tx_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/tx_common.h
 create mode 100644 drivers/net/ethernet/sfc/siena/vfdi.h
 create mode 100644 drivers/net/ethernet/sfc/siena/workarounds.h
 delete mode 100644 drivers/net/ethernet/sfc/siena_sriov.c
 delete mode 100644 drivers/net/ethernet/sfc/siena_sriov.h

--
Martin Habets <habetsm.xilinx@gmail.com>
