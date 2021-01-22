Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88E530112A
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbhAVXvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:51:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:55257 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbhAVXuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:50:46 -0500
IronPort-SDR: 9GY1voYISGJHITde3DX+ZOGaPb8mjGbWdJJCunV3c/34Z4oi4PxYFN+ijspUJzDi7vJSNYTwMa
 j1Q32uaDK4Yg==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="264346844"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="264346844"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:04 -0800
IronPort-SDR: 0xg1TjhHda1OlA/EU/MiiwnGY3T2m8UDMGyTgVO3lPYEquijkQFugeXRIQuX7w1ruuKNkzms9K
 HcDkicgZvKbA==
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="574869388"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.251.4.95])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:03 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com,
        "Shiraz, Saleem" <shiraz.saleem@intel.com>
Subject: [PATCH 00/22] Add Intel Ethernet Protocol Driver for RDMA (irdma)
Date:   Fri, 22 Jan 2021 17:48:05 -0600
Message-Id: <20210122234827.1353-1-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Shiraz, Saleem" <shiraz.saleem@intel.com>

The following patch series introduces a unified Intel Ethernet Protocol Driver
for RDMA (irdma) for the X722 iWARP device and a new E810 device which supports
iWARP and RoCEv2. The irdma driver replaces the legacy i40iw driver for X722
and extends the ABI already defined for i40iw. It is backward compatible with
legacy X722 rdma-core provider (libi40iw).

X722 and E810 are PCI network devices that are RDMA capable. The RDMA block of
this parent device is represented via an auxiliary device exported to 'irdma'
using the core auxiliary bus infrastructure recently added for 5.11 kernel.
The parent PCI netdev drivers 'i40e' and 'ice' register auxiliary RDMA devices
with private data/ops encapsulated that bind to an 'irdma' auxiliary driver. 

This series is a follow on to an RFC series [1]. This series was built against
rdma for-next and currently includes the netdev patches for ease of review.
This include updates to 'ice' driver to provide RDMA support and converts 'i40e'
driver to use the auxiliary bus infrastructure .

Once the patches are closer to merging, this series will be split into a
netdev-next and rdma-next patch series targeted at their respective subsystems
with Patch #1 and Patch #5 included in both. This is the shared header file that
will allow each series to independently compile.

[1] https://lore.kernel.org/linux-rdma/20200520070415.3392210-1-jeffrey.t.kirsher@intel.com/

Dave Ertman (4):
  iidc: Introduce iidc.h
  ice: Initialize RDMA support
  ice: Implement iidc operations
  ice: Register auxiliary device to provide RDMA

Michael J. Ruhl (1):
  RDMA/irdma: Add dynamic tracing for CM

Mustafa Ismail (13):
  RDMA/irdma: Register an auxiliary driver and implement private channel
    OPs
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
  i40e: Prep i40e header for aux bus conversion
  i40e: Register auxiliary devices to provide RDMA
  RDMA/irdma: Add irdma Kconfig/Makefile and remove i40iw
  RDMA/irdma: Update MAINTAINERS file

 Documentation/ABI/stable/sysfs-class-infiniband  |   20 -
 MAINTAINERS                                      |   17 +-
 drivers/infiniband/Kconfig                       |    2 +-
 drivers/infiniband/hw/Makefile                   |    2 +-
 drivers/infiniband/hw/i40iw/Kconfig              |    9 -
 drivers/infiniband/hw/i40iw/Makefile             |    9 -
 drivers/infiniband/hw/i40iw/i40iw.h              |  611 ---
 drivers/infiniband/hw/i40iw/i40iw_cm.c           | 4419 ----------------
 drivers/infiniband/hw/i40iw/i40iw_cm.h           |  462 --
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c         | 5243 -------------------
 drivers/infiniband/hw/i40iw/i40iw_d.h            | 1746 -------
 drivers/infiniband/hw/i40iw/i40iw_hmc.c          |  821 ---
 drivers/infiniband/hw/i40iw/i40iw_hmc.h          |  241 -
 drivers/infiniband/hw/i40iw/i40iw_hw.c           |  851 ---
 drivers/infiniband/hw/i40iw/i40iw_main.c         | 2066 --------
 drivers/infiniband/hw/i40iw/i40iw_osdep.h        |  217 -
 drivers/infiniband/hw/i40iw/i40iw_p.h            |  129 -
 drivers/infiniband/hw/i40iw/i40iw_pble.c         |  613 ---
 drivers/infiniband/hw/i40iw/i40iw_pble.h         |  131 -
 drivers/infiniband/hw/i40iw/i40iw_puda.c         | 1496 ------
 drivers/infiniband/hw/i40iw/i40iw_puda.h         |  188 -
 drivers/infiniband/hw/i40iw/i40iw_register.h     | 1030 ----
 drivers/infiniband/hw/i40iw/i40iw_status.h       |  101 -
 drivers/infiniband/hw/i40iw/i40iw_type.h         | 1358 -----
 drivers/infiniband/hw/i40iw/i40iw_uk.c           | 1200 -----
 drivers/infiniband/hw/i40iw/i40iw_user.h         |  422 --
 drivers/infiniband/hw/i40iw/i40iw_utils.c        | 1518 ------
 drivers/infiniband/hw/i40iw/i40iw_verbs.c        | 2652 ----------
 drivers/infiniband/hw/i40iw/i40iw_verbs.h        |  179 -
 drivers/infiniband/hw/i40iw/i40iw_vf.c           |   85 -
 drivers/infiniband/hw/i40iw/i40iw_vf.h           |   62 -
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c     |  759 ---
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.h     |  124 -
 drivers/infiniband/hw/irdma/Kconfig              |   11 +
 drivers/infiniband/hw/irdma/Makefile             |   28 +
 drivers/infiniband/hw/irdma/cm.c                 | 4463 ++++++++++++++++
 drivers/infiniband/hw/irdma/cm.h                 |  429 ++
 drivers/infiniband/hw/irdma/ctrl.c               | 6103 ++++++++++++++++++++++
 drivers/infiniband/hw/irdma/defs.h               | 2210 ++++++++
 drivers/infiniband/hw/irdma/hmc.c                |  734 +++
 drivers/infiniband/hw/irdma/hmc.h                |  184 +
 drivers/infiniband/hw/irdma/hw.c                 | 2773 ++++++++++
 drivers/infiniband/hw/irdma/i40iw_hw.c           |  221 +
 drivers/infiniband/hw/irdma/i40iw_hw.h           |  162 +
 drivers/infiniband/hw/irdma/i40iw_if.c           |  226 +
 drivers/infiniband/hw/irdma/icrdma_hw.c          |   82 +
 drivers/infiniband/hw/irdma/icrdma_hw.h          |   67 +
 drivers/infiniband/hw/irdma/irdma.h              |  203 +
 drivers/infiniband/hw/irdma/irdma_if.c           |  422 ++
 drivers/infiniband/hw/irdma/main.c               |  364 ++
 drivers/infiniband/hw/irdma/main.h               |  613 +++
 drivers/infiniband/hw/irdma/osdep.h              |   99 +
 drivers/infiniband/hw/irdma/pble.c               |  525 ++
 drivers/infiniband/hw/irdma/pble.h               |  136 +
 drivers/infiniband/hw/irdma/protos.h             |  118 +
 drivers/infiniband/hw/irdma/puda.c               | 1743 ++++++
 drivers/infiniband/hw/irdma/puda.h               |  194 +
 drivers/infiniband/hw/irdma/status.h             |   70 +
 drivers/infiniband/hw/irdma/trace.c              |  112 +
 drivers/infiniband/hw/irdma/trace.h              |    3 +
 drivers/infiniband/hw/irdma/trace_cm.h           |  458 ++
 drivers/infiniband/hw/irdma/type.h               | 1726 ++++++
 drivers/infiniband/hw/irdma/uda.c                |  391 ++
 drivers/infiniband/hw/irdma/uda.h                |   63 +
 drivers/infiniband/hw/irdma/uda_d.h              |  382 ++
 drivers/infiniband/hw/irdma/uk.c                 | 1729 ++++++
 drivers/infiniband/hw/irdma/user.h               |  462 ++
 drivers/infiniband/hw/irdma/utils.c              | 2680 ++++++++++
 drivers/infiniband/hw/irdma/verbs.c              | 4617 ++++++++++++++++
 drivers/infiniband/hw/irdma/verbs.h              |  218 +
 drivers/infiniband/hw/irdma/ws.c                 |  404 ++
 drivers/infiniband/hw/irdma/ws.h                 |   41 +
 drivers/net/ethernet/intel/Kconfig               |    2 +
 drivers/net/ethernet/intel/i40e/i40e.h           |    2 +
 drivers/net/ethernet/intel/i40e/i40e_client.c    |  154 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c      |    1 +
 drivers/net/ethernet/intel/ice/Makefile          |    1 +
 drivers/net/ethernet/intel/ice/ice.h             |   17 +
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h  |   33 +
 drivers/net/ethernet/intel/ice/ice_common.c      |  217 +-
 drivers/net/ethernet/intel/ice/ice_common.h      |    9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c     |   64 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h     |    3 +
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h  |    3 +-
 drivers/net/ethernet/intel/ice/ice_idc.c         | 1430 +++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h     |  104 +
 drivers/net/ethernet/intel/ice/ice_lib.c         |   27 +
 drivers/net/ethernet/intel/ice/ice_lib.h         |    2 +-
 drivers/net/ethernet/intel/ice/ice_main.c        |  124 +-
 drivers/net/ethernet/intel/ice/ice_sched.c       |   69 +-
 drivers/net/ethernet/intel/ice/ice_switch.c      |   27 +
 drivers/net/ethernet/intel/ice/ice_switch.h      |    4 +
 drivers/net/ethernet/intel/ice/ice_type.h        |    4 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |   34 +
 include/linux/net/intel/i40e_client.h            |   14 +
 include/linux/net/intel/iidc.h                   |  342 ++
 include/uapi/rdma/i40iw-abi.h                    |  107 -
 include/uapi/rdma/ib_user_ioctl_verbs.h          |    1 +
 include/uapi/rdma/irdma-abi.h                    |  140 +
 99 files changed, 38262 insertions(+), 28922 deletions(-)
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
 create mode 100644 include/linux/net/intel/iidc.h
 delete mode 100644 include/uapi/rdma/i40iw-abi.h
 create mode 100644 include/uapi/rdma/irdma-abi.h

-- 
1.8.3.1

