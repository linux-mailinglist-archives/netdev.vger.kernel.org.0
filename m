Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEFA1DAB3C
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgETHCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:02:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:53333 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgETHC3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:02:29 -0400
IronPort-SDR: FjE0333s64FKXPHwQouHdi18qau2tNF8qlU1zP9rrshlqBdcKH26kdgoXPYYv+AGYdIX2n3XbH
 EsBtIChYjPzw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 00:02:29 -0700
IronPort-SDR: 58EadGBfcpAZ8Sg9BuUP5/dmnSL3zWFjixqR+gpeePd0MmsDpZWaFZZmGb/wpAphlmEjaKWdS2
 AXO5Q2NzB77w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,413,1583222400"; 
   d="scan'208";a="299841161"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 20 May 2020 00:02:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        galpress@amazon.com, selvin.xavier@broadcom.com,
        sriharsha.basavapatna@broadcom.com, benve@cisco.com,
        bharat@chelsio.com, xavier.huwei@huawei.com, yishaih@mellanox.com,
        leonro@mellanox.com, mkalderon@marvell.com, aditr@vmware.com,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com
Subject: [net-next v4 00/12][pull request] 100GbE Intel Wired LAN Driver Updates 2020-05-19
Date:   Wed, 20 May 2020 00:02:15 -0700
Message-Id: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains the initial implementation of the Virtual Bus,
virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the new
Virtual Bus.

The primary purpose of the Virtual bus is to put devices on it and hook the
devices up to drivers.  This will allow drivers, like the RDMA drivers, to
hook up to devices via this Virtual bus.

The associated irdma driver designed to use this new interface, is still
in RFC currently and was sent in a separate series.  The latest RFC
series follows this series, named "Intel RDMA Driver Updates 2020-05-19".  

This series currently builds against net-next tree.

Revision history:
v2: Made changes based on community feedback, like Pierre-Louis's and
    Jason's comments to update virtual bus interface.
v3: Updated the virtual bus interface based on feedback from Jason and
    Greg KH.  Also updated the initial ice driver patch to handle the
    virtual bus changes and changes requested by Jason and Greg KH.
v4: Updated the kernel documentation based on feedback from Greg KH.
    Also added PM interface updates to satisfy the sound driver
    requirements.  Added the sound driver changes that makes use of the
    virtual bus.

The following are changes since commit 2de499258659823b3c7207c5bda089c822b67d69:
  Merge branch 's390-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Dave Ertman (7):
  Implementation of Virtual Bus
  ice: Create and register virtual bus for RDMA
  ice: Complete RDMA peer registration
  ice: Support resource allocation requests
  ice: Enable event notifications
  ice: Allow reset operations
  ice: Pass through communications to VF

Ranjani Sridharan (3):
  ASoC: SOF: Introduce descriptors for SOF client
  ASoC: SOF: Create client driver for IPC test
  ASoC: SOF: ops: Add new op for client registration

Shiraz Saleem (2):
  i40e: Move client header location
  i40e: Register a virtbus device to provide RDMA

 Documentation/driver-api/index.rst            |    1 +
 Documentation/driver-api/virtual_bus.rst      |   93 ++
 MAINTAINERS                                   |    1 +
 drivers/bus/Kconfig                           |   10 +
 drivers/bus/Makefile                          |    2 +
 drivers/bus/virtual_bus.c                     |  215 +++
 drivers/infiniband/hw/i40iw/Makefile          |    1 -
 drivers/infiniband/hw/i40iw/i40iw.h           |    2 +-
 drivers/net/ethernet/intel/Kconfig            |    2 +
 drivers/net/ethernet/intel/i40e/i40e.h        |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |  133 +-
 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice.h          |   14 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   33 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  206 ++-
 drivers/net/ethernet/intel/ice/ice_common.h   |    9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   68 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    3 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 1344 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  105 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      |   50 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |    4 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  105 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |   69 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   27 +
 drivers/net/ethernet/intel/ice/ice_switch.h   |    4 +
 drivers/net/ethernet/intel/ice/ice_type.h     |    4 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   59 +-
 include/linux/mod_devicetable.h               |    8 +
 .../linux/net/intel}/i40e_client.h            |   15 +
 include/linux/net/intel/iidc.h                |  337 +++++
 include/linux/virtual_bus.h                   |   62 +
 scripts/mod/devicetable-offsets.c             |    3 +
 scripts/mod/file2alias.c                      |    7 +
 sound/soc/sof/Kconfig                         |   30 +
 sound/soc/sof/Makefile                        |    6 +-
 sound/soc/sof/core.c                          |   10 +
 sound/soc/sof/intel/Kconfig                   |    1 +
 sound/soc/sof/intel/apl.c                     |   26 +
 sound/soc/sof/intel/bdw.c                     |   25 +
 sound/soc/sof/intel/byt.c                     |   28 +
 sound/soc/sof/intel/cnl.c                     |   26 +
 sound/soc/sof/ops.h                           |   34 +
 sound/soc/sof/sof-client.c                    |   91 ++
 sound/soc/sof/sof-client.h                    |   84 ++
 sound/soc/sof/sof-ipc-test-client.c           |  325 ++++
 sound/soc/sof/sof-priv.h                      |    9 +
 48 files changed, 3630 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/driver-api/virtual_bus.rst
 create mode 100644 drivers/bus/virtual_bus.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h (94%)
 create mode 100644 include/linux/net/intel/iidc.h
 create mode 100644 include/linux/virtual_bus.h
 create mode 100644 sound/soc/sof/sof-client.c
 create mode 100644 sound/soc/sof/sof-client.h
 create mode 100644 sound/soc/sof/sof-ipc-test-client.c

-- 
2.26.2

