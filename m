Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CF56AEFA5
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbjCGSY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjCGSYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E50F9AFC6;
        Tue,  7 Mar 2023 10:19:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9589A61539;
        Tue,  7 Mar 2023 18:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55D5C4339B;
        Tue,  7 Mar 2023 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213193;
        bh=BcUGeMLEm0LPA6u+zuE2Qt4EJaLi1EQErnMdvMFu038=;
        h=From:To:Cc:Subject:Date:From;
        b=Whku19nSoWJzSWst16iQ++EOjtE1aPFEt2JszLF1tFs63JeCm4VO4EsXwgvo6/KR3
         59Jlp8PnNNm/2y/NbTduduRcI8Ji6M2ya5sAwq2K59DL+Gau83IZj9jdT+TXroDumo
         JlNPIuMeaiggrYss3rnwhkZhB9SW9xD+867XomDVbhR//JWWjZgCjaWmMMwRCkHKeM
         VRzo+s6KaJPuaDTWFR5t9yA29CfB6xFUP6mDo2lDnMBEiV1QGXYHTYuhlv/DgzYCGi
         olyNFfyuxE1EY6VOUxsgwxmdDTvzhRZLwlO8wwmyD5AMQ+taDMuIFKJCQHrtWpYu07
         S72s7z6mrqPKw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Ariel Elior <aelior@marvell.com>,
        Chris Snook <chris.snook@gmail.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        Manish Chopra <manishc@marvell.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Mengyuan Lou <mengyuanlou@net-swift.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Rahul Verma <rahulv@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasesh Mody <rmody@marvell.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veerasenareddy Burru <vburru@marvell.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        GR-Linux-NIC-Dev@marvell.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH 00/28] PCI/AER: Remove redundant Device Control Error Reporting Enable
Date:   Tue,  7 Mar 2023 12:19:11 -0600
Message-Id: <20230307181940.868828-1-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native"),
which appeared in v6.0, the PCI core has enabled PCIe error reporting for
all devices during enumeration.

Remove driver code to do this and remove unnecessary includes of
<linux/aer.h> from several other drivers.

Intel folks, sorry that I missed removing the <linux/aer.h> includes in the
first series.


Bjorn Helgaas (28):
  alx: Drop redundant pci_enable_pcie_error_reporting()
  be2net: Drop redundant pci_enable_pcie_error_reporting()
  bnx2: Drop redundant pci_enable_pcie_error_reporting()
  bnx2x: Drop redundant pci_enable_pcie_error_reporting()
  bnxt: Drop redundant pci_enable_pcie_error_reporting()
  cxgb4: Drop redundant pci_enable_pcie_error_reporting()
  net/fungible: Drop redundant pci_enable_pcie_error_reporting()
  net: hns3: remove unnecessary aer.h include
  netxen_nic: Drop redundant pci_enable_pcie_error_reporting()
  octeon_ep: Drop redundant pci_enable_pcie_error_reporting()
  qed: Drop redundant pci_enable_pcie_error_reporting()
  net: qede: Remove unnecessary aer.h include
  qlcnic: Drop redundant pci_enable_pcie_error_reporting()
  qlcnic: Remove unnecessary aer.h include
  sfc: Drop redundant pci_enable_pcie_error_reporting()
  sfc: falcon: Drop redundant pci_enable_pcie_error_reporting()
  sfc/siena: Drop redundant pci_enable_pcie_error_reporting()
  sfc_ef100: Drop redundant pci_disable_pcie_error_reporting()
  net: ngbe: Drop redundant pci_enable_pcie_error_reporting()
  net: txgbe: Drop redundant pci_enable_pcie_error_reporting()
  e1000e: Remove unnecessary aer.h include
  fm10k: Remove unnecessary aer.h include
  i40e: Remove unnecessary aer.h include
  iavf: Remove unnecessary aer.h include
  ice: Remove unnecessary aer.h include
  igb: Remove unnecessary aer.h include
  igc: Remove unnecessary aer.h include
  ixgbe: Remove unnecessary aer.h include

 drivers/net/ethernet/atheros/alx/main.c       |  4 ----
 drivers/net/ethernet/broadcom/bnx2.c          | 21 -------------------
 drivers/net/ethernet/broadcom/bnx2.h          |  1 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  1 -
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 19 -----------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  4 ----
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  4 ----
 drivers/net/ethernet/emulex/benet/be_main.c   |  8 -------
 .../net/ethernet/fungible/funcore/fun_dev.c   |  5 -----
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  1 -
 drivers/net/ethernet/intel/e1000e/netdev.c    |  1 -
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  1 -
 drivers/net/ethernet/intel/i40e/i40e.h        |  1 -
 drivers/net/ethernet/intel/iavf/iavf.h        |  1 -
 drivers/net/ethernet/intel/ice/ice.h          |  1 -
 drivers/net/ethernet/intel/igb/igb_main.c     |  1 -
 drivers/net/ethernet/intel/igc/igc_main.c     |  1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  1 -
 .../ethernet/marvell/octeon_ep/octep_main.c   |  4 ----
 .../ethernet/qlogic/netxen/netxen_nic_main.c  | 10 +--------
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  9 --------
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  1 -
 .../ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c   |  1 -
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  4 ----
 .../net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c |  1 -
 drivers/net/ethernet/sfc/ef100.c              |  3 ---
 drivers/net/ethernet/sfc/efx.c                |  5 -----
 drivers/net/ethernet/sfc/falcon/efx.c         |  9 --------
 drivers/net/ethernet/sfc/siena/efx.c          |  5 -----
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  4 ----
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  5 -----
 31 files changed, 1 insertion(+), 136 deletions(-)

-- 
2.25.1

