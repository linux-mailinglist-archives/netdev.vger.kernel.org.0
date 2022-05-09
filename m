Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6B5520126
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbiEIPfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238213AbiEIPfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:35:04 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6DED1BA8D3
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:31:09 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 0DBA53200F2;
        Mon,  9 May 2022 16:31:07 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1no5Lm-0001PF-Bu; Mon, 09 May 2022 16:31:06 +0100
Subject: [PATCH net-next v4 00/11]: Move Siena into a separate subdirectory
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 09 May 2022 16:31:06 +0100
Message-ID: <165211018297.5289.9658523545298485394.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
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

After this series further enhancements are needed to differentiate the
new kernel module from sfc.ko, and the Siena code can be removed from sfc.ko.
Thes will be posted as a small follow-up series.
The Siena module is not built by default, but can be enabled
using Kconfig option SFC_SIENA. This will create module sfc-siena.ko.

	Patches

Patches 1-3 establish the code base for the Siena driver.
Patches 4-10 ensure the allyesconfig build succeeds.
Patch 11 adds the basic Siena module.

I do not expect patch 1 through 3 to be reviewed, they are FYI only.
No checkpatch issues were resolved as part of these, but they
were fixed in the subsequent patches.

	Testing

Various build tests were done such as allyesconfig, W=1 and sparse.
The new sfc-siena.ko and sfc.ko modules were tested on a machine with both
these NICs in them, and several tests were run on both drivers.

Martin
---

v4:
- Patch 1 and 5 of v3 were applied. Removed these from this series.
- Rebase.

v3:
- Fix build errors after rebase.

v2:
- Split up patch that copies existing files.
- Only copy a subset of mcdi_pcol.h.
- Use --find-copies-harder as suggested by Benjamin Poirier.
- Merge several patches for the allyesconfig build into larger ones.

---

Martin Habets (11):
      sfc: Move Siena specific files
      sfc: Copy shared files needed for Siena (part 1)
      sfc: Copy shared files needed for Siena (part 2)
      sfc/siena: Remove build references to missing functionality
      sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
      sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
      sfc/siena: Rename peripheral functions to avoid conflicts with sfc
      sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
      sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
      sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
      sfc: Add a basic Siena module


 drivers/net/ethernet/sfc/Kconfig                  |    1 
 drivers/net/ethernet/sfc/Makefile                 |    1 
 drivers/net/ethernet/sfc/siena/Kconfig            |   12 
 drivers/net/ethernet/sfc/siena/Makefile           |   11 
 drivers/net/ethernet/sfc/siena/bitfield.h         |    0 
 drivers/net/ethernet/sfc/siena/efx.c              | 1309 ++++++++++++
 drivers/net/ethernet/sfc/siena/efx.h              |  218 ++
 drivers/net/ethernet/sfc/siena/efx_channels.c     | 1376 +++++++++++++
 drivers/net/ethernet/sfc/siena/efx_channels.h     |   45 
 drivers/net/ethernet/sfc/siena/efx_common.c       | 1408 +++++++++++++
 drivers/net/ethernet/sfc/siena/efx_common.h       |  118 +
 drivers/net/ethernet/sfc/siena/enum.h             |  176 ++
 drivers/net/ethernet/sfc/siena/ethtool.c          |  282 +++
 drivers/net/ethernet/sfc/siena/ethtool_common.c   | 1340 ++++++++++++
 drivers/net/ethernet/sfc/siena/ethtool_common.h   |   60 +
 drivers/net/ethernet/sfc/siena/farch.c            |   58 -
 drivers/net/ethernet/sfc/siena/farch_regs.h       |    0 
 drivers/net/ethernet/sfc/siena/filter.h           |    0 
 drivers/net/ethernet/sfc/siena/io.h               |    0 
 drivers/net/ethernet/sfc/siena/mcdi.c             | 2259 +++++++++++++++++++++
 drivers/net/ethernet/sfc/siena/mcdi.h             |  386 ++++
 drivers/net/ethernet/sfc/siena/mcdi_mon.c         |  531 +++++
 drivers/net/ethernet/sfc/siena/mcdi_port.c        |  110 +
 drivers/net/ethernet/sfc/siena/mcdi_port.h        |   17 
 drivers/net/ethernet/sfc/siena/mcdi_port_common.c | 1282 ++++++++++++
 drivers/net/ethernet/sfc/siena/mcdi_port_common.h |   58 +
 drivers/net/ethernet/sfc/siena/mtd.c              |  124 +
 drivers/net/ethernet/sfc/siena/net_driver.h       | 1715 ++++++++++++++++
 drivers/net/ethernet/sfc/siena/nic.c              |  530 +++++
 drivers/net/ethernet/sfc/siena/nic.h              |  206 ++
 drivers/net/ethernet/sfc/siena/nic_common.h       |  251 ++
 drivers/net/ethernet/sfc/siena/ptp.c              | 2200 ++++++++++++++++++++
 drivers/net/ethernet/sfc/siena/ptp.h              |   45 
 drivers/net/ethernet/sfc/siena/rx.c               |  400 ++++
 drivers/net/ethernet/sfc/siena/rx_common.c        | 1094 ++++++++++
 drivers/net/ethernet/sfc/siena/rx_common.h        |  110 +
 drivers/net/ethernet/sfc/siena/selftest.c         |  807 ++++++++
 drivers/net/ethernet/sfc/siena/selftest.h         |   52 
 drivers/net/ethernet/sfc/siena/siena.c            |  158 +
 drivers/net/ethernet/sfc/siena/siena_sriov.c      |   35 
 drivers/net/ethernet/sfc/siena/siena_sriov.h      |    0 
 drivers/net/ethernet/sfc/siena/sriov.h            |   83 +
 drivers/net/ethernet/sfc/siena/tx.c               |  399 ++++
 drivers/net/ethernet/sfc/siena/tx.h               |   40 
 drivers/net/ethernet/sfc/siena/tx_common.c        |  448 ++++
 drivers/net/ethernet/sfc/siena/tx_common.h        |   39 
 drivers/net/ethernet/sfc/siena/vfdi.h             |    0 
 drivers/net/ethernet/sfc/siena/workarounds.h      |   28 
 48 files changed, 19700 insertions(+), 122 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/siena/Kconfig
 create mode 100644 drivers/net/ethernet/sfc/siena/Makefile
 copy drivers/net/ethernet/sfc/{bitfield.h => siena/bitfield.h} (100%)
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
 rename drivers/net/ethernet/sfc/{farch.c => siena/farch.c} (98%)
 copy drivers/net/ethernet/sfc/{farch_regs.h => siena/farch_regs.h} (100%)
 copy drivers/net/ethernet/sfc/{filter.h => siena/filter.h} (100%)
 copy drivers/net/ethernet/sfc/{io.h => siena/io.h} (100%)
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi.c
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi.h
 create mode 100644 drivers/net/ethernet/sfc/siena/mcdi_mon.c
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
 rename drivers/net/ethernet/sfc/{siena.c => siena/siena.c} (89%)
 rename drivers/net/ethernet/sfc/{siena_sriov.c => siena/siena_sriov.c} (98%)
 rename drivers/net/ethernet/sfc/{siena_sriov.h => siena/siena_sriov.h} (100%)
 create mode 100644 drivers/net/ethernet/sfc/siena/sriov.h
 create mode 100644 drivers/net/ethernet/sfc/siena/tx.c
 create mode 100644 drivers/net/ethernet/sfc/siena/tx.h
 create mode 100644 drivers/net/ethernet/sfc/siena/tx_common.c
 create mode 100644 drivers/net/ethernet/sfc/siena/tx_common.h
 copy drivers/net/ethernet/sfc/{vfdi.h => siena/vfdi.h} (100%)
 create mode 100644 drivers/net/ethernet/sfc/siena/workarounds.h

--
Martin Habets <habetsm.xilinx@gmail.com>

