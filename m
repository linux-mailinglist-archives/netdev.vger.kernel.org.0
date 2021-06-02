Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2647B3994DC
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhFBUyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:54:45 -0400
Received: from mga05.intel.com ([192.55.52.43]:25929 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhFBUyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 16:54:40 -0400
IronPort-SDR: rvvUXGbAfjaxg0CQi5CgF3sc3wGqPokYif53H9xbjLZ9s69zrSfsQAMk1YAjYM8WKEqUE4ypa/
 U2bAV1US/XBA==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="289522861"
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="289522861"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 13:52:55 -0700
IronPort-SDR: 2IoV9eZF3q3yFRkFdPWErTGsGvX3cEQmrW0KgyRzcgir3aWtz2/muAWYAvI8tZxdOT9+FplBtT
 eWPsGhIaJ0eg==
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="447560952"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.38.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 13:52:54 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        gustavoars@kernel.org, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v7 00/16] Add Intel Ethernet Protocol Driver for RDMA (irdma)
Date:   Wed,  2 Jun 2021 15:51:22 -0500
Message-Id: <20210602205138.889-1-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch series introduces a unified Intel Ethernet Protocol Driver
for RDMA (irdma) for the X722 iWARP device and a new E810 device which supports
iWARP and RoCEv2. The irdma module replaces the legacy i40iw module for X722
and extends the ABI already defined for i40iw. It is backward compatible with
legacy X722 rdma-core provider (libi40iw).

X722 and E810 are PCI network devices that are RDMA capable. The RDMA block of
this parent device is represented via an auxiliary device exported to 'irdma'
using the core auxiliary bus infrastructure recently added for 5.11 kernel.
The parent PCI netdev drivers 'i40e' and 'ice' register auxiliary RDMA devices
with private data/ops encapsulated that bind to auxiliary drivers registered
in irdma module.

Currently, default is RoCEv2 for E810. Runtime support for protocol switch
to iWARP will be made available via devlink in a future patch.

This rdma series is built against the shared branch iwl-next [1] which is
expected to be merged into rdma-next first for the netdev parts.

v6-->v7:
*Drop netdev patches as it is sent separately as a PR.
*Drop cover letter verbiage on development history of this series.
*Remove legacy exported symbols i40e_register_client and i40e_unregister_client in patch #15
*Fold flex array transformation fix from [2] into irdma 

v5-->v6:
*Condense aux device name from <module>.intel_rdma_<rdma protocol>.<num> to <module>.<rdma protocol>.<num>
*Fixup driver API for alloc_hw_stats to export only port stats in sysfs

v4-->v5:
*Export all IIDC core ops callbacks and make direct calls from irdma. Have irdma depend on both i40e and ice.
*Remove devlink runtime option for protocol switch. Default to RoCEv2 on E810. Run-time option to switch to IWARP
will be added via the community work discussed in [3]
*Export the ice_pf pointer in iidc_auxiliary_dev which is made available in irdma drv.probe()
and use it derive PCI function related subfields.
*Use a define to set the auxiliary dev name as opposed to kasprintf.
*Remove all future provisioning in IIDC. Remove multiple auxiliary driver support in IIDC.
*Add the auxiliary ops callbacks for core driver to use directly in iidc_auxiliary_drv object.
*Fix an auxdevice ida resource leak in ice, and update to latest ida APIs in i40e.
*Remove any left-over VF cruft in IIDC and irdma driver.
*Simplify the IIDC API to add and delete RDMA qsets. Remove iidc_res_base union usage.
*Convert all single implementation indirect .ops callbacks in irdma with direct calls
*Add rsvd only for aligmnent in irdma ABI
*clean-up on iw_memreg_type enum

v3-->v4:
* Fixup W=1 warnings in ice patches
* Fix issues uncovered by pyverbs for create user AH and multicast
* Fix descriptor set issue for fast register introduced during port to FIELD_PREP in v2 submission 

v2-->v3:
* rebase rdma for-next. Adapt to core change '1fb7f8973f51 ("RDMA: Support more than 255 rdma ports")'
* irdma Kconfig updates to conform with linux coding style.
* Fix a 0-day build issue
* Remove rdma_resource_limits selector devlink param. Follow on patch to be submitted
for it with suggestion from Parav to use devlink resource.
* Capitalize abbreviations in ice idc. e.g. 'aux' to 'AUX'

v1-->v2:
* Remove IIDC channel OPs - open, close, peer_register and peer_unregister.
  And all its associated FSM in ice PCI core driver.
* Use device_lock in ice PCI core driver while issuing IIDC ops callbacks.
* Remove peer_* verbiage from shared IIDC header and rename the structs and channel ops
  with iidc_core*/iidc_auxiliary*.
* Allocate ib_device at start and register it at the end of drv.probe() in irdma gen2 auxiliary driver.
* Use ibdev_* printing extensively throughout most of the driver
  Remove idev_to_dev, ihw_to_dev macros as no longer required in new print scheme.
* Do not bump ABI ver. to 6 in irdma. Maintain irdma ABI ver. at 5 for legacy i40iw user-provider compatibility.
* Add a boundary check in irdma_alloc_ucontext to fail binding with < 4 user-space provider version.
* Remove devlink from irdma. Add 2 new rdma-related devlink parameters added to ice PCI core driver.
* Use FIELD_PREP/FIELD_GET/GENMASK on get/set of descriptor fields versus home grown ones LS_*/RS_*.
* Bind 2 separate auxiliary drivers in irdma - one for gen1 and one for gen2 and future devices.
* Misc. driver fixes in irdma

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux iwl-next
[2] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20210525230038.GA175516@embeddedor/
[3] https://lore.kernel.org/linux-rdma/20210407224631.GI282464@nvidia.com/

Michael J. Ruhl (1):
  RDMA/irdma: Add dynamic tracing for CM

Mustafa Ismail (13):
  RDMA/irdma: Register auxiliary driver and implement private channel
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

Shiraz Saleem (2):
  RDMA/irdma: Add irdma Kconfig/Makefile and remove i40iw
  RDMA/irdma: Update MAINTAINERS file

 Documentation/ABI/stable/sysfs-class-infiniband |   20 -
 MAINTAINERS                                     |   16 +-
 drivers/infiniband/Kconfig                      |    2 +-
 drivers/infiniband/hw/Makefile                  |    2 +-
 drivers/infiniband/hw/i40iw/Kconfig             |    9 -
 drivers/infiniband/hw/i40iw/Makefile            |    9 -
 drivers/infiniband/hw/i40iw/i40iw.h             |  602 ---
 drivers/infiniband/hw/i40iw/i40iw_cm.c          | 4419 ------------------
 drivers/infiniband/hw/i40iw/i40iw_cm.h          |  462 --
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c        | 5243 ---------------------
 drivers/infiniband/hw/i40iw/i40iw_d.h           | 1746 -------
 drivers/infiniband/hw/i40iw/i40iw_hmc.c         |  821 ----
 drivers/infiniband/hw/i40iw/i40iw_hmc.h         |  241 -
 drivers/infiniband/hw/i40iw/i40iw_hw.c          |  851 ----
 drivers/infiniband/hw/i40iw/i40iw_main.c        | 2064 ---------
 drivers/infiniband/hw/i40iw/i40iw_osdep.h       |  195 -
 drivers/infiniband/hw/i40iw/i40iw_p.h           |  129 -
 drivers/infiniband/hw/i40iw/i40iw_pble.c        |  611 ---
 drivers/infiniband/hw/i40iw/i40iw_pble.h        |  131 -
 drivers/infiniband/hw/i40iw/i40iw_puda.c        | 1496 ------
 drivers/infiniband/hw/i40iw/i40iw_puda.h        |  188 -
 drivers/infiniband/hw/i40iw/i40iw_register.h    | 1030 -----
 drivers/infiniband/hw/i40iw/i40iw_status.h      |  101 -
 drivers/infiniband/hw/i40iw/i40iw_type.h        | 1358 ------
 drivers/infiniband/hw/i40iw/i40iw_uk.c          | 1200 -----
 drivers/infiniband/hw/i40iw/i40iw_user.h        |  422 --
 drivers/infiniband/hw/i40iw/i40iw_utils.c       | 1518 ------
 drivers/infiniband/hw/i40iw/i40iw_verbs.c       | 2652 -----------
 drivers/infiniband/hw/i40iw/i40iw_verbs.h       |  179 -
 drivers/infiniband/hw/i40iw/i40iw_vf.c          |   85 -
 drivers/infiniband/hw/i40iw/i40iw_vf.h          |   62 -
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c    |  759 ---
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.h    |  124 -
 drivers/infiniband/hw/irdma/Kconfig             |   12 +
 drivers/infiniband/hw/irdma/Makefile            |   27 +
 drivers/infiniband/hw/irdma/cm.c                | 4421 ++++++++++++++++++
 drivers/infiniband/hw/irdma/cm.h                |  417 ++
 drivers/infiniband/hw/irdma/ctrl.c              | 5657 +++++++++++++++++++++++
 drivers/infiniband/hw/irdma/defs.h              | 1155 +++++
 drivers/infiniband/hw/irdma/hmc.c               |  710 +++
 drivers/infiniband/hw/irdma/hmc.h               |  180 +
 drivers/infiniband/hw/irdma/hw.c                | 2725 +++++++++++
 drivers/infiniband/hw/irdma/i40iw_hw.c          |  216 +
 drivers/infiniband/hw/irdma/i40iw_hw.h          |  160 +
 drivers/infiniband/hw/irdma/i40iw_if.c          |  216 +
 drivers/infiniband/hw/irdma/icrdma_hw.c         |  149 +
 drivers/infiniband/hw/irdma/icrdma_hw.h         |   71 +
 drivers/infiniband/hw/irdma/irdma.h             |  153 +
 drivers/infiniband/hw/irdma/main.c              |  358 ++
 drivers/infiniband/hw/irdma/main.h              |  555 +++
 drivers/infiniband/hw/irdma/osdep.h             |   86 +
 drivers/infiniband/hw/irdma/pble.c              |  521 +++
 drivers/infiniband/hw/irdma/pble.h              |  136 +
 drivers/infiniband/hw/irdma/protos.h            |  116 +
 drivers/infiniband/hw/irdma/puda.c              | 1745 +++++++
 drivers/infiniband/hw/irdma/puda.h              |  194 +
 drivers/infiniband/hw/irdma/status.h            |   71 +
 drivers/infiniband/hw/irdma/trace.c             |  112 +
 drivers/infiniband/hw/irdma/trace.h             |    3 +
 drivers/infiniband/hw/irdma/trace_cm.h          |  458 ++
 drivers/infiniband/hw/irdma/type.h              | 1541 ++++++
 drivers/infiniband/hw/irdma/uda.c               |  271 ++
 drivers/infiniband/hw/irdma/uda.h               |   89 +
 drivers/infiniband/hw/irdma/uda_d.h             |  128 +
 drivers/infiniband/hw/irdma/uk.c                | 1684 +++++++
 drivers/infiniband/hw/irdma/user.h              |  437 ++
 drivers/infiniband/hw/irdma/utils.c             | 2541 ++++++++++
 drivers/infiniband/hw/irdma/verbs.c             | 4527 ++++++++++++++++++
 drivers/infiniband/hw/irdma/verbs.h             |  225 +
 drivers/infiniband/hw/irdma/ws.c                |  406 ++
 drivers/infiniband/hw/irdma/ws.h                |   41 +
 drivers/net/ethernet/intel/i40e/i40e_client.c   |  149 -
 include/linux/net/intel/i40e_client.h           |    3 -
 include/uapi/rdma/i40iw-abi.h                   |  107 -
 include/uapi/rdma/ib_user_ioctl_verbs.h         |    1 +
 include/uapi/rdma/irdma-abi.h                   |  111 +
 76 files changed, 32636 insertions(+), 28996 deletions(-)
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
 delete mode 100644 include/uapi/rdma/i40iw-abi.h
 create mode 100644 include/uapi/rdma/irdma-abi.h

-- 
1.8.3.1

