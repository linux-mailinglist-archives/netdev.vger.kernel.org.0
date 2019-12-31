Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE612DC22
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfLaW1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:27:52 -0500
Received: from mga05.intel.com ([192.55.52.43]:29321 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbfLaW1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:27:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 14:27:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="209403578"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga007.jf.intel.com with ESMTP; 31 Dec 2019 14:27:51 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/11][pull request] 1GbE Intel Wired LAN Driver Updates 2019-12-31
Date:   Tue, 31 Dec 2019 14:27:39 -0800
Message-Id: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e, igb and igc only.

Robert Beckett provide an igb change to assist in keeping packets from
being dropped due to receive descriptor ring being full when receive
flow control is enabled.  Create a separate function to setup SRRCTL to
ease in reuse and ensure that setting of the drop enable bit only if
receive flow control is not enabled.

Sasha adds support for scatter gather support in igc.  Improve the
direct memory address mapping flow by optimizing/simplifying and more
clear.  Update igc to use pci_release_mem_regions() instead of
pci_release_selected_regions().  Clean up function header comments to
align with the actual code.  Adds support for 64 bit DMA access, to help
handle socket buffer fragments in high memory.  Adds legacy power
management support in igc by implementing suspend, resume, 
runtime_suspend/resume, and runtime_idle callbacks.  Clean up references
to Serdes interface in igc since that interface is not supported for
i225 devices.

Alex replaces the pr_info calls with netdev_info in all cases related to
netdev link state, as suggested by Joe Perches.

The following are changes since commit 9e860947d8d7a1504476ac49abfce90a4ce600f3:
  net/ncsi: Fix gma flag setting after response
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Alexander Duyck (1):
  e1000e: Use netdev_info instead of pr_info for link messages

Robert Beckett (1):
  igb: dont drop packets if rx flow control is enabled

Sasha Neftin (9):
  igc: Add scatter gather support
  igc: Improve the DMA mapping flow
  igc: Prefer to use the pci_release_mem_regions method
  igc: Remove excess parameter description from igc_is_non_eop
  igc: Fix the parameter description for igc_alloc_rx_buffers
  igc: Fix parameter descriptions for a several functions
  igc: Add 64 bit DMA access support
  igc: Add legacy power management support
  igc: Remove serdes comments from a description of methods

 drivers/net/ethernet/intel/e1000e/netdev.c   |  17 +-
 drivers/net/ethernet/intel/igb/igb.h         |   1 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c |   8 +
 drivers/net/ethernet/intel/igb/igb_main.c    |  47 +++-
 drivers/net/ethernet/intel/igc/igc.h         |   2 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  31 +++
 drivers/net/ethernet/intel/igc/igc_main.c    | 253 +++++++++++++++++--
 drivers/net/ethernet/intel/igc/igc_regs.h    |   9 +
 8 files changed, 322 insertions(+), 46 deletions(-)

-- 
2.24.1

