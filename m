Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB70F25067C
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgHXRdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:33:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:29863 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728189AbgHXRd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 13:33:26 -0400
IronPort-SDR: dUvdYVevPAaHR7UQ+VpwsPA/jjgLWvIXMR6M0wXLeKG+vWbgztljw5oYTlrG9BQ25n0efIiJhQ
 koxZxrvYhq+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="157008532"
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="157008532"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:33:20 -0700
IronPort-SDR: jbD4B3rCpyF0lR4jia2AVWwgf1GU8cWyLNCfAxbM/3SfYF6pAKCDk7n7dxantqzfDeNF5ceMnY
 UhBaE0T1M+Gw==
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="336245320"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:33:19 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net-next v5 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2020-08-24
Date:   Mon, 24 Aug 2020 10:32:51 -0700
Message-Id: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces both the Intel Ethernet Common Module and the Intel
Data Plane Function.  The patches also incorporate extended features and
functionality added in the virtchnl.h file.
 
The format of the series flow is to add the data set, then introduce
function stubs and finally introduce pieces in large cohesive subjects or
functionality.  This is to allow for more in depth understanding and
review of the bigger picture as the series is reviewed.

Currently this is common layer (iecm) is initially only being used by only
the idpf driver (PF driver for SmartNIC).  However, the plan is to
eventually switch our iavf driver along with future drivers to use this
common module.  The hope is to better enable code sharing going forward as
well as support other developers writing drivers for our hardware

v2: Addresses comments from the original series.  This includes removing
    the iecm_ctlq_err in iecm_ctlq_api.h, the private flags and duplicated
    checks, and cleaning up the clamps in iecm_ethtool.c.  We also added
    the supported_coalesce_params flags in iecm_ethtool.c.  Finally, we
    got the headers cleaned up and addressed mismatching types from calls
    to cpu_to_le to match the types (this fixes C=2 W=1 errors that were
    reported).
v3: fixed missed compile warning/error with C=2 W=1
v4: Fixed missed static in idpf_main.c on idpf_probe. Added missing local
    variable in iecm_rx_can_reuse_page. Updated location of documentation,
    refactored soft reset path to take memory allocation into account,
    refactored ethtool stats to not use VA_ARGS, *greatly* reduced use of
    iecm_status enum, aligned use of periods in debug statements, and
    refactored to reduce line indents.
v5: Cleaned up some checks the core is already doing, corrected the
    calculation for txq and rxq, Removed the FW version that had been
    missed in previous version, dma_wmb call directly replacing a
    define to it, cleaned up the memory and header files that were not
    used, and cleaning up the self defining error codes.

The following are changes since commit 7611cbb900b4b9a6fe5eca12fb12645c0576a015:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Alan Brady (1):
  idpf: Introduce idpf driver

Alice Michael (14):
  virtchnl: Extend AVF ops
  iecm: Add framework set of header files
  iecm: Add TX/RX header files
  iecm: Common module introduction and function stubs
  iecm: Add basic netdevice functionality
  iecm: Implement mailbox functionality
  iecm: Implement virtchnl commands
  iecm: Implement vector allocation
  iecm: Init and allocate vport
  iecm: Deinit vport
  iecm: Add splitq TX/RX
  iecm: Add singleq TX/RX
  iecm: Add ethtool
  iecm: Add iecm to the kernel build system

 .../device_drivers/ethernet/intel/idpf.rst    |   47 +
 .../device_drivers/ethernet/intel/iecm.rst    |   93 +
 MAINTAINERS                                   |    1 +
 drivers/net/ethernet/intel/Kconfig            |   21 +
 drivers/net/ethernet/intel/Makefile           |    2 +
 drivers/net/ethernet/intel/idpf/Makefile      |   12 +
 drivers/net/ethernet/intel/idpf/idpf_dev.h    |   17 +
 drivers/net/ethernet/intel/idpf/idpf_devids.h |   10 +
 drivers/net/ethernet/intel/idpf/idpf_main.c   |  137 +
 drivers/net/ethernet/intel/idpf/idpf_reg.c    |  152 +
 drivers/net/ethernet/intel/iecm/Makefile      |   18 +
 .../net/ethernet/intel/iecm/iecm_controlq.c   |  668 +++
 .../ethernet/intel/iecm/iecm_controlq_setup.c |  176 +
 .../net/ethernet/intel/iecm/iecm_ethtool.c    | 1048 +++++
 drivers/net/ethernet/intel/iecm/iecm_lib.c    | 1235 ++++++
 drivers/net/ethernet/intel/iecm/iecm_main.c   |   41 +
 .../ethernet/intel/iecm/iecm_singleq_txrx.c   |  892 ++++
 drivers/net/ethernet/intel/iecm/iecm_txrx.c   | 3911 +++++++++++++++++
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   | 2203 ++++++++++
 include/linux/avf/virtchnl.h                  |  592 +++
 include/linux/net/intel/iecm.h                |  399 ++
 include/linux/net/intel/iecm_alloc.h          |    7 +
 include/linux/net/intel/iecm_controlq.h       |  118 +
 include/linux/net/intel/iecm_controlq_api.h   |  192 +
 include/linux/net/intel/iecm_lan_pf_regs.h    |  120 +
 include/linux/net/intel/iecm_lan_txrx.h       |  635 +++
 include/linux/net/intel/iecm_mem.h            |   20 +
 include/linux/net/intel/iecm_txrx.h           |  582 +++
 28 files changed, 13349 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/intel/idpf.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/intel/iecm.rst
 create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_dev.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_devids.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_reg.c
 create mode 100644 drivers/net/ethernet/intel/iecm/Makefile
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_controlq.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_ethtool.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_lib.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_main.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_txrx.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
 create mode 100644 include/linux/net/intel/iecm.h
 create mode 100644 include/linux/net/intel/iecm_alloc.h
 create mode 100644 include/linux/net/intel/iecm_controlq.h
 create mode 100644 include/linux/net/intel/iecm_controlq_api.h
 create mode 100644 include/linux/net/intel/iecm_lan_pf_regs.h
 create mode 100644 include/linux/net/intel/iecm_lan_txrx.h
 create mode 100644 include/linux/net/intel/iecm_mem.h
 create mode 100644 include/linux/net/intel/iecm_txrx.h

-- 
2.26.2

