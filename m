Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CBC2273DB
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgGUAii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:38:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:46872 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbgGUAih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 20:38:37 -0400
IronPort-SDR: ZBea49lzy9yWpCzIEg5S2R5n+jn78ESezQfY0jzyUz8qU7NbknQ7i9/9XRBQV1ucq8aQWNZJf3
 1kKxMZEemWpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="214699698"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="214699698"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 17:38:36 -0700
IronPort-SDR: +oNqSZVaz14R2w+Dz+awFx14DPHhqjruyBMjcKu8kNu7VSPuRJmiz6Vhf5izaRlEuscVuYYNzm
 Hu5w8tadhexQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="310040211"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jul 2020 17:38:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net-next v4 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2020-07-20
Date:   Mon, 20 Jul 2020 17:37:55 -0700
Message-Id: <20200721003810.2770559-1-anthony.l.nguyen@intel.com>
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

The following are changes since commit 120c7dd52213d86ca65a76127b9a69b1cae132d0:
  Merge branch 'Fully-describe-the-waveform-for-PTP-periodic-output'
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
 drivers/net/ethernet/intel/iecm/Makefile      |   19 +
 .../net/ethernet/intel/iecm/iecm_controlq.c   |  670 +++
 .../ethernet/intel/iecm/iecm_controlq_setup.c |  177 +
 .../net/ethernet/intel/iecm/iecm_ethtool.c    | 1050 +++++
 drivers/net/ethernet/intel/iecm/iecm_lib.c    | 1191 +++++
 drivers/net/ethernet/intel/iecm/iecm_main.c   |   41 +
 drivers/net/ethernet/intel/iecm/iecm_osdep.c  |   28 +
 .../ethernet/intel/iecm/iecm_singleq_txrx.c   |  892 ++++
 drivers/net/ethernet/intel/iecm/iecm_txrx.c   | 3911 +++++++++++++++++
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   | 2228 ++++++++++
 include/linux/avf/virtchnl.h                  |  592 +++
 include/linux/net/intel/iecm.h                |  430 ++
 include/linux/net/intel/iecm_alloc.h          |   29 +
 include/linux/net/intel/iecm_controlq.h       |   95 +
 include/linux/net/intel/iecm_controlq_api.h   |  188 +
 include/linux/net/intel/iecm_lan_pf_regs.h    |  120 +
 include/linux/net/intel/iecm_lan_txrx.h       |  636 +++
 include/linux/net/intel/iecm_osdep.h          |   24 +
 include/linux/net/intel/iecm_txrx.h           |  582 +++
 include/linux/net/intel/iecm_type.h           |   47 +
 30 files changed, 13442 insertions(+)
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

