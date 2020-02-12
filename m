Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1CC15B08C
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 20:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgBLTO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 14:14:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:19422 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgBLTO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 14:14:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 11:14:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,433,1574150400"; 
   d="scan'208";a="237806973"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga006.jf.intel.com with ESMTP; 12 Feb 2020 11:14:25 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        galpress@amazon.com, selvin.xavier@broadcom.com,
        sriharsha.basavapatna@broadcom.com, benve@cisco.com,
        bharat@chelsio.com, xavier.huwei@huawei.com, yishaih@mellanox.com,
        leonro@mellanox.com, mkalderon@marvell.com, aditr@vmware.com
Subject: [RFC PATCH v4 00/25] Intel Wired LAN/RDMA Driver Updates 2020-02-11
Date:   Wed, 12 Feb 2020 11:13:59 -0800
Message-Id: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains the initial implementation of the Virtual Bus,
virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the new
Virtual Bus and the new RDMA driver 'irdma' for use with 'ice' and 'i40e'.

The primary purpose of the Virtual bus is to put devices on it and hook
the devices up to drivers.  This will allow drivers, like the RDMA
drivers, to hook up to devices via this Virtual bus.

The last 16 patches of the series adds a unified Intel Ethernet Protocol
driver for RDMA that supports a new network device E810 (iWARP and
RoCEv2 capable) and the existing X722 iWARP device.  The driver
architecture provides the extensibility for future generations of Intel
hardware supporting RDMA.

Patches 7-25 adds a unified Intel Ethernet Protocol driver for RDMA that
supports a new network device E810 (iWARP and RoCEv2 capable) and the
existing X722 iWARP device.  The driver architecture provides the
extensibility for future generations of Intel hardware supporting RDMA.

The 'irdma' driver replaces the legacy X722 driver i40iw and extends the
ABI already defined for i40iw.  It is backward compatible with legacy
X722 rdma-core provider (libi40iw).

This series currently builds against net-next tree AND the rdma "for-next"
branch.

v1: Initial virtual bus submission
v2: Added example virtbus_dev and virtbus_drv in
    tools/testing/sefltests/ to test the virtual bus and provide an
    example on how to implement
v3: Added ice and i40e driver changes to implement the virtual bus, also
    added the new irdma driver which is the RDMA driver which
    communicates with the ice and i40e drivers
v4: Added other RDMA driver maintainers on the virtbus changes
    * Updated commit message and documentation, removed PM dependency, used
      static inlines where possible, cleaned up deprecated code based on
      feedback for patch 1 of the series
    * Simplified the relationship and ensure that the lifetime rules are
      controlled by the bus in patches 1 & 2 of the series
    irdma driver changes:
    * Remove redundant explicit casts
    * Scrub all WQs to define correct charateristics and use system WQ for
      reset recovery work
    * Remove all non-functional NULL checks on IDC peer dev OPs
    * Change all pr_* to dev_* if struct device present. Remove dev_info logging
    * Don't use test_bit on non-atomic IIDC_* event types
    * Remove all module parameters
    * Use bool bitfields in structures instead of bool
    * Change CQP completion handling from kthread to WQ
    * Use the generic devlink parameter enable_roce instead of driver specific
      one
    * Use meaningful labels for goto unwind
    * Use new RDMA mmap API
    * Use refcount_t APIs for refcounts on driver objects
    * Add support for ibdev OP dealloc_driver
    * Adapt to use new version of virtbus
    * Remove RCU locking in CM address resolve
    * Misc. driver fixes

For ease of review and testing, the entire series is available in the
git repository below.

The following are changes since commit fdfa3a6778b194974df77b384cc71eb2e503639a:
  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue rdma

Dave Ertman (7):
  virtual-bus: Implementation of Virtual Bus
  ice: Create and register virtual bus for RDMA
  ice: Complete RDMA peer registration
  ice: Support resource allocation requests
  ice: Enable event notifications
  ice: Allow reset operations
  ice: Pass through communications to VF

Michael J. Ruhl (1):
  RDMA/irdma: Add dynamic tracing for CM

Mustafa Ismail (13):
  RDMA/irdma: Add driver framework definitions
  RDMA/irdma: Implement device initialization definitions
  RDMA/irdma: Implement HW Admin Queue OPs
  RDMA/irdma: Add HMC backing store setup functions
  RDMA/irdma: Add privileged UDA queue implementation
  RDMA/irdma: Add QoS definitions
  RDMA/irdma: Add connection manager
  RDMA/irdma: Add PBLE resource manager
  RDMA/irdma: Implement device supported verb APIs
  RDMA/irdma: Add RoCEv2 UD OP support
  RDMA/irdma: Add user/kernel shared libraries
  RDMA/irdma: Add miscellaneous utility definitions
  RDMA/irdma: Add ABI definitions

Shiraz Saleem (4):
  i40e: Move client header location
  i40e: Register a virtbus device to provide RDMA
  RDMA: Add irdma Kconfig/Makefile and remove i40iw
  RDMA/irdma: Update MAINTAINERS file

 .../ABI/stable/sysfs-class-infiniband         |   18 -
 Documentation/driver-api/virtual_bus.rst      |   59 +
 MAINTAINERS                                   |    9 +-
 drivers/bus/Kconfig                           |   11 +
 drivers/bus/Makefile                          |    1 +
 drivers/bus/virtual_bus.c                     |  267 +
 drivers/infiniband/Kconfig                    |    2 +-
 drivers/infiniband/hw/Makefile                |    2 +-
 drivers/infiniband/hw/i40iw/Kconfig           |    9 -
 drivers/infiniband/hw/i40iw/Makefile          |   10 -
 drivers/infiniband/hw/i40iw/i40iw.h           |  602 --
 drivers/infiniband/hw/i40iw/i40iw_cm.c        | 4422 ------------
 drivers/infiniband/hw/i40iw/i40iw_cm.h        |  462 --
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c      | 5198 --------------
 drivers/infiniband/hw/i40iw/i40iw_d.h         | 1737 -----
 drivers/infiniband/hw/i40iw/i40iw_hmc.c       |  821 ---
 drivers/infiniband/hw/i40iw/i40iw_hmc.h       |  241 -
 drivers/infiniband/hw/i40iw/i40iw_hw.c        |  852 ---
 drivers/infiniband/hw/i40iw/i40iw_main.c      | 2070 ------
 drivers/infiniband/hw/i40iw/i40iw_osdep.h     |  217 -
 drivers/infiniband/hw/i40iw/i40iw_p.h         |  128 -
 drivers/infiniband/hw/i40iw/i40iw_pble.c      |  612 --
 drivers/infiniband/hw/i40iw/i40iw_pble.h      |  131 -
 drivers/infiniband/hw/i40iw/i40iw_puda.c      | 1493 ----
 drivers/infiniband/hw/i40iw/i40iw_puda.h      |  188 -
 drivers/infiniband/hw/i40iw/i40iw_register.h  | 1030 ---
 drivers/infiniband/hw/i40iw/i40iw_status.h    |  101 -
 drivers/infiniband/hw/i40iw/i40iw_type.h      | 1363 ----
 drivers/infiniband/hw/i40iw/i40iw_uk.c        | 1232 ----
 drivers/infiniband/hw/i40iw/i40iw_user.h      |  430 --
 drivers/infiniband/hw/i40iw/i40iw_utils.c     | 1557 -----
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     | 2789 --------
 drivers/infiniband/hw/i40iw/i40iw_verbs.h     |  179 -
 drivers/infiniband/hw/i40iw/i40iw_vf.c        |   85 -
 drivers/infiniband/hw/i40iw/i40iw_vf.h        |   62 -
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c  |  756 ---
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.h  |  124 -
 drivers/infiniband/hw/irdma/Kconfig           |   11 +
 drivers/infiniband/hw/irdma/Makefile          |   28 +
 drivers/infiniband/hw/irdma/cm.c              | 4499 +++++++++++++
 drivers/infiniband/hw/irdma/cm.h              |  413 ++
 drivers/infiniband/hw/irdma/ctrl.c            | 5985 +++++++++++++++++
 drivers/infiniband/hw/irdma/defs.h            | 2132 ++++++
 drivers/infiniband/hw/irdma/hmc.c             |  705 ++
 drivers/infiniband/hw/irdma/hmc.h             |  217 +
 drivers/infiniband/hw/irdma/hw.c              | 2597 +++++++
 drivers/infiniband/hw/irdma/i40iw_hw.c        |  211 +
 drivers/infiniband/hw/irdma/i40iw_hw.h        |  162 +
 drivers/infiniband/hw/irdma/i40iw_if.c        |  228 +
 drivers/infiniband/hw/irdma/icrdma_hw.c       |   76 +
 drivers/infiniband/hw/irdma/icrdma_hw.h       |   62 +
 drivers/infiniband/hw/irdma/irdma.h           |  190 +
 drivers/infiniband/hw/irdma/irdma_if.c        |  424 ++
 drivers/infiniband/hw/irdma/main.c            |  572 ++
 drivers/infiniband/hw/irdma/main.h            |  595 ++
 drivers/infiniband/hw/irdma/osdep.h           |  105 +
 drivers/infiniband/hw/irdma/pble.c            |  510 ++
 drivers/infiniband/hw/irdma/pble.h            |  135 +
 drivers/infiniband/hw/irdma/protos.h          |   93 +
 drivers/infiniband/hw/irdma/puda.c            | 1690 +++++
 drivers/infiniband/hw/irdma/puda.h            |  186 +
 drivers/infiniband/hw/irdma/status.h          |   69 +
 drivers/infiniband/hw/irdma/trace.c           |  112 +
 drivers/infiniband/hw/irdma/trace.h           |    3 +
 drivers/infiniband/hw/irdma/trace_cm.h        |  458 ++
 drivers/infiniband/hw/irdma/type.h            | 1714 +++++
 drivers/infiniband/hw/irdma/uda.c             |  390 ++
 drivers/infiniband/hw/irdma/uda.h             |   64 +
 drivers/infiniband/hw/irdma/uda_d.h           |  382 ++
 drivers/infiniband/hw/irdma/uk.c              | 1744 +++++
 drivers/infiniband/hw/irdma/user.h            |  448 ++
 drivers/infiniband/hw/irdma/utils.c           | 2425 +++++++
 drivers/infiniband/hw/irdma/verbs.c           | 4582 +++++++++++++
 drivers/infiniband/hw/irdma/verbs.h           |  213 +
 drivers/infiniband/hw/irdma/ws.c              |  395 ++
 drivers/infiniband/hw/irdma/ws.h              |   39 +
 drivers/net/ethernet/intel/Kconfig            |    2 +
 drivers/net/ethernet/intel/i40e/i40e.h        |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |  139 +-
 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice.h          |   15 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   33 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  203 +
 drivers/net/ethernet/intel/ice/ice_common.h   |    9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   65 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    3 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 1349 ++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  105 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   50 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |    4 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  104 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |   69 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   27 +
 drivers/net/ethernet/intel/ice/ice_switch.h   |    4 +
 drivers/net/ethernet/intel/ice/ice_type.h     |    4 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   59 +-
 include/linux/mod_devicetable.h               |    8 +
 .../linux/net/intel}/i40e_client.h            |   15 +
 include/linux/net/intel/iidc.h                |  337 +
 include/linux/virtual_bus.h                   |   57 +
 include/uapi/rdma/i40iw-abi.h                 |  107 -
 include/uapi/rdma/ib_user_ioctl_verbs.h       |    1 +
 include/uapi/rdma/irdma-abi.h                 |  140 +
 scripts/mod/devicetable-offsets.c             |    3 +
 scripts/mod/file2alias.c                      |    8 +
 106 files changed, 37965 insertions(+), 29093 deletions(-)
 create mode 100644 Documentation/driver-api/virtual_bus.rst
 create mode 100644 drivers/bus/virtual_bus.c
 delete mode 100644 drivers/infiniband/hw/i40iw/Kconfig
 delete mode 100644 drivers/infiniband/hw/i40iw/Makefile
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_cm.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_cm.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_ctrl.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_d.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_hmc.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_hmc.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_hw.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_main.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_osdep.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_p.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_pble.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_pble.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_puda.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_puda.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_register.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_status.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_type.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_uk.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_user.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_utils.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_verbs.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_verbs.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_vf.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_vf.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_virtchnl.h
 create mode 100644 drivers/infiniband/hw/irdma/Kconfig
 create mode 100644 drivers/infiniband/hw/irdma/Makefile
 create mode 100644 drivers/infiniband/hw/irdma/cm.c
 create mode 100644 drivers/infiniband/hw/irdma/cm.h
 create mode 100644 drivers/infiniband/hw/irdma/ctrl.c
 create mode 100644 drivers/infiniband/hw/irdma/defs.h
 create mode 100644 drivers/infiniband/hw/irdma/hmc.c
 create mode 100644 drivers/infiniband/hw/irdma/hmc.h
 create mode 100644 drivers/infiniband/hw/irdma/hw.c
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_hw.c
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_hw.h
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
 create mode 100644 drivers/infiniband/hw/irdma/icrdma_hw.c
 create mode 100644 drivers/infiniband/hw/irdma/icrdma_hw.h
 create mode 100644 drivers/infiniband/hw/irdma/irdma.h
 create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
 create mode 100644 drivers/infiniband/hw/irdma/main.c
 create mode 100644 drivers/infiniband/hw/irdma/main.h
 create mode 100644 drivers/infiniband/hw/irdma/osdep.h
 create mode 100644 drivers/infiniband/hw/irdma/pble.c
 create mode 100644 drivers/infiniband/hw/irdma/pble.h
 create mode 100644 drivers/infiniband/hw/irdma/protos.h
 create mode 100644 drivers/infiniband/hw/irdma/puda.c
 create mode 100644 drivers/infiniband/hw/irdma/puda.h
 create mode 100644 drivers/infiniband/hw/irdma/status.h
 create mode 100644 drivers/infiniband/hw/irdma/trace.c
 create mode 100644 drivers/infiniband/hw/irdma/trace.h
 create mode 100644 drivers/infiniband/hw/irdma/trace_cm.h
 create mode 100644 drivers/infiniband/hw/irdma/type.h
 create mode 100644 drivers/infiniband/hw/irdma/uda.c
 create mode 100644 drivers/infiniband/hw/irdma/uda.h
 create mode 100644 drivers/infiniband/hw/irdma/uda_d.h
 create mode 100644 drivers/infiniband/hw/irdma/uk.c
 create mode 100644 drivers/infiniband/hw/irdma/user.h
 create mode 100644 drivers/infiniband/hw/irdma/utils.c
 create mode 100644 drivers/infiniband/hw/irdma/verbs.c
 create mode 100644 drivers/infiniband/hw/irdma/verbs.h
 create mode 100644 drivers/infiniband/hw/irdma/ws.c
 create mode 100644 drivers/infiniband/hw/irdma/ws.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h (94%)
 create mode 100644 include/linux/net/intel/iidc.h
 create mode 100644 include/linux/virtual_bus.h
 delete mode 100644 include/uapi/rdma/i40iw-abi.h
 create mode 100644 include/uapi/rdma/irdma-abi.h

-- 
2.24.1

