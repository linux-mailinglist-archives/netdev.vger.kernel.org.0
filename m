Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EA220673C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387865AbgFWWkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:40:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:14604 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387453AbgFWWkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 18:40:46 -0400
IronPort-SDR: q7a9Pj7OE1r7fgLepINQUHJAXcvQcu+l4CXCntCmRWeg771U5+ts9v2Qzi3RrMnDPSXdBQQkOa
 JkIC9ULFMGGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="162327476"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="162327476"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 15:40:45 -0700
IronPort-SDR: 5fx0fzTkYpbbXXCAApyAzjUwfDxNveVw3cGQTEtKdEljJ6i8AY8DYANTnf1IXjoeAHhESEv6Xy
 QY1cbhO4r8fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="479045907"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jun 2020 15:40:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2020-06-23
Date:   Tue, 23 Jun 2020 15:40:28 -0700
Message-Id: <20200623224043.801728-1-jeffrey.t.kirsher@intel.com>
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

v2: Addresses comments from the original series.  This inncludes removing
    the iecm_ctlq_err in iecm_ctlq_api.h, the private flags and duplicated
    checks, and cleaning up the clamps in iecm_ethtool.c.  We also added
    the supported_coalesce_params flags in iecm_ethtool.c.  Finally, we
    got the headers cleaned up and addressed mismatching types from calls
    to cpu_to_le to match the types (this fixes C=2 W=1 errors that were
    reported).

The following are changes since commit 8af7b4525acf5012b2f111a8b168b8647f2c8d60:
  Merge branch 'net-atlantic-additional-A2-features'
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

 .../networking/device_drivers/intel/idpf.rst  |   47 +
 .../networking/device_drivers/intel/iecm.rst  |   93 +
 MAINTAINERS                                   |    3 +
 drivers/net/ethernet/intel/Kconfig            |   15 +
 drivers/net/ethernet/intel/Makefile           |    2 +
 drivers/net/ethernet/intel/idpf/Makefile      |   12 +
 drivers/net/ethernet/intel/idpf/idpf_dev.h    |   17 +
 drivers/net/ethernet/intel/idpf/idpf_devids.h |   10 +
 drivers/net/ethernet/intel/idpf/idpf_main.c   |  136 +
 drivers/net/ethernet/intel/idpf/idpf_reg.c    |  152 +
 drivers/net/ethernet/intel/iecm/Makefile      |   19 +
 .../net/ethernet/intel/iecm/iecm_controlq.c   |  669 +++
 .../ethernet/intel/iecm/iecm_controlq_setup.c |  177 +
 .../net/ethernet/intel/iecm/iecm_ethtool.c    | 1064 +++++
 drivers/net/ethernet/intel/iecm/iecm_lib.c    | 1093 +++++
 drivers/net/ethernet/intel/iecm/iecm_main.c   |   50 +
 drivers/net/ethernet/intel/iecm/iecm_osdep.c  |   28 +
 .../ethernet/intel/iecm/iecm_singleq_txrx.c   |  892 ++++
 drivers/net/ethernet/intel/iecm/iecm_txrx.c   | 3961 +++++++++++++++++
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   | 2262 ++++++++++
 include/linux/avf/virtchnl.h                  |  592 +++
 include/linux/net/intel/iecm.h                |  433 ++
 include/linux/net/intel/iecm_alloc.h          |   29 +
 include/linux/net/intel/iecm_controlq.h       |   95 +
 include/linux/net/intel/iecm_controlq_api.h   |  188 +
 include/linux/net/intel/iecm_lan_pf_regs.h    |  120 +
 include/linux/net/intel/iecm_lan_txrx.h       |  636 +++
 include/linux/net/intel/iecm_osdep.h          |   24 +
 include/linux/net/intel/iecm_txrx.h           |  581 +++
 include/linux/net/intel/iecm_type.h           |   47 +
 30 files changed, 13447 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/intel/idpf.rst
 create mode 100644 Documentation/networking/device_drivers/intel/iecm.rst
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
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_osdep.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_txrx.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
 create mode 100644 include/linux/net/intel/iecm.h
 create mode 100644 include/linux/net/intel/iecm_alloc.h
 create mode 100644 include/linux/net/intel/iecm_controlq.h
 create mode 100644 include/linux/net/intel/iecm_controlq_api.h
 create mode 100644 include/linux/net/intel/iecm_lan_pf_regs.h
 create mode 100644 include/linux/net/intel/iecm_lan_txrx.h
 create mode 100644 include/linux/net/intel/iecm_osdep.h
 create mode 100644 include/linux/net/intel/iecm_txrx.h
 create mode 100644 include/linux/net/intel/iecm_type.h

-- 
2.26.2

