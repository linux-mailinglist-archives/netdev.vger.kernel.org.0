Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA63F1179AE
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfLIWtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:49:39 -0500
Received: from mga12.intel.com ([192.55.52.136]:33714 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfLIWti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:49:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 14:49:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="237912274"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 09 Dec 2019 14:49:37 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com
Subject: [net-next v3 00/20][pull request] Intel Wired LAN Driver Updates 2019-12-09
Date:   Mon,  9 Dec 2019 14:49:15 -0800
Message-Id: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains the initial implementation of the Virtual Bus,
virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the new
Virtual Bus and the new RDMA driver 'irdma' for use with 'ice' and 'i40e'.

The primary purpose of the Virtual bus is to provide a matching service
and to pass the data pointer contained in the virtbus_device to the
virtbus_driver during its probe call.  This will allow two separate
kernel objects to match up and start communication.

The last 16 patches of the series adds a unified Intel Ethernet Protocol
driver for RDMA that supports a new network device E810 (iWARP and
RoCEv2 capable) and the existing X722 iWARP device.  The driver
architecture provides the extensibility for future generations of Intel
hardware supporting RDMA.

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

The following are changes since commit 4a63ef710cc3e79ce58b46b122118e415a44b3db:
  Merge branch 'for-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue rdma

Dave Ertman (3):
  virtual-bus: Implementation of Virtual Bus
  ice: Initialize and register a virtual bus to provide RDMA
  ice: Implement peer communications

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

Shiraz Saleem (3):
  i40e: Register a virtbus device to provide RDMA
  RDMA: Add irdma Kconfig/Makefile and remove i40iw
  RDMA/irdma: Update MAINTAINERS file

 .../ABI/stable/sysfs-class-infiniband         |   18 -
 Documentation/driver-api/virtual_bus.rst      |   76 +
 MAINTAINERS                                   |    9 +-
 drivers/bus/Kconfig                           |   12 +
 drivers/bus/Makefile                          |    1 +
 drivers/bus/virtual_bus.c                     |  295 +
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
 drivers/infiniband/hw/i40iw/i40iw_main.c      | 2068 ------
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
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     | 2788 --------
 drivers/infiniband/hw/i40iw/i40iw_verbs.h     |  179 -
 drivers/infiniband/hw/i40iw/i40iw_vf.c        |   85 -
 drivers/infiniband/hw/i40iw/i40iw_vf.h        |   62 -
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c  |  756 ---
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.h  |  124 -
 drivers/infiniband/hw/irdma/Kconfig           |   11 +
 drivers/infiniband/hw/irdma/Makefile          |   28 +
 drivers/infiniband/hw/irdma/cm.c              | 4515 +++++++++++++
 drivers/infiniband/hw/irdma/cm.h              |  414 ++
 drivers/infiniband/hw/irdma/ctrl.c            | 5990 +++++++++++++++++
 drivers/infiniband/hw/irdma/defs.h            | 2129 ++++++
 drivers/infiniband/hw/irdma/hmc.c             |  705 ++
 drivers/infiniband/hw/irdma/hmc.h             |  218 +
 drivers/infiniband/hw/irdma/hw.c              | 2596 +++++++
 drivers/infiniband/hw/irdma/i40iw_hw.c        |  209 +
 drivers/infiniband/hw/irdma/i40iw_hw.h        |  162 +
 drivers/infiniband/hw/irdma/i40iw_if.c        |  222 +
 drivers/infiniband/hw/irdma/icrdma_hw.c       |   74 +
 drivers/infiniband/hw/irdma/icrdma_hw.h       |   62 +
 drivers/infiniband/hw/irdma/irdma.h           |  190 +
 drivers/infiniband/hw/irdma/irdma_if.c        |  463 ++
 drivers/infiniband/hw/irdma/main.c            |  630 ++
 drivers/infiniband/hw/irdma/main.h            |  652 ++
 drivers/infiniband/hw/irdma/osdep.h           |  106 +
 drivers/infiniband/hw/irdma/pble.c            |  510 ++
 drivers/infiniband/hw/irdma/pble.h            |  135 +
 drivers/infiniband/hw/irdma/protos.h          |   91 +
 drivers/infiniband/hw/irdma/puda.c            | 1690 +++++
 drivers/infiniband/hw/irdma/puda.h            |  186 +
 drivers/infiniband/hw/irdma/status.h          |   69 +
 drivers/infiniband/hw/irdma/trace.c           |  112 +
 drivers/infiniband/hw/irdma/trace.h           |    3 +
 drivers/infiniband/hw/irdma/trace_cm.h        |  458 ++
 drivers/infiniband/hw/irdma/type.h            | 1709 +++++
 drivers/infiniband/hw/irdma/uda.c             |  390 ++
 drivers/infiniband/hw/irdma/uda.h             |   64 +
 drivers/infiniband/hw/irdma/uda_d.h           |  382 ++
 drivers/infiniband/hw/irdma/uk.c              | 1744 +++++
 drivers/infiniband/hw/irdma/user.h            |  450 ++
 drivers/infiniband/hw/irdma/utils.c           | 2407 +++++++
 drivers/infiniband/hw/irdma/verbs.c           | 4358 ++++++++++++
 drivers/infiniband/hw/irdma/verbs.h           |  199 +
 drivers/infiniband/hw/irdma/ws.c              |  395 ++
 drivers/infiniband/hw/irdma/ws.h              |   39 +
 drivers/net/ethernet/intel/Kconfig            |    2 +
 drivers/net/ethernet/intel/i40e/i40e.h        |    3 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |  109 +-
 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice.h          |   15 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   33 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  203 +
 drivers/net/ethernet/intel/ice/ice_common.h   |    9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   65 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    3 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 1289 ++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  124 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   50 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |    3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  108 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |   69 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   27 +
 drivers/net/ethernet/intel/ice/ice_switch.h   |    4 +
 drivers/net/ethernet/intel/ice/ice_type.h     |    4 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   25 -
 include/linux/mod_devicetable.h               |    8 +
 .../linux/net/intel}/i40e_client.h            |   20 +-
 include/linux/net/intel/iidc.h                |  336 +
 include/linux/virtual_bus.h                   |   45 +
 include/uapi/rdma/i40iw-abi.h                 |  107 -
 include/uapi/rdma/ib_user_ioctl_verbs.h       |    1 +
 include/uapi/rdma/irdma-abi.h                 |  131 +
 scripts/mod/devicetable-offsets.c             |    3 +
 scripts/mod/file2alias.c                      |    8 +
 .../virtual_bus/virtual_bus_dev/Makefile      |    7 +
 .../virtual_bus_dev/virtual_bus_dev.c         |   60 +
 .../virtual_bus/virtual_bus_drv/Makefile      |    7 +
 .../virtual_bus_drv/virtual_bus_drv.c         |  115 +
 110 files changed, 37985 insertions(+), 29090 deletions(-)
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
 rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h (92%)
 create mode 100644 include/linux/net/intel/iidc.h
 create mode 100644 include/linux/virtual_bus.h
 delete mode 100644 include/uapi/rdma/i40iw-abi.h
 create mode 100644 include/uapi/rdma/irdma-abi.h
 create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_dev/Makefile
 create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_dev/virtual_bus_dev.c
 create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_drv/Makefile
 create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_drv/virtual_bus_drv.c

-- 
2.23.0

