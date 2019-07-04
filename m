Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3425F12C
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 04:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfGDCM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 22:12:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:33414 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbfGDCMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 22:12:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 19:12:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,449,1557212400"; 
   d="scan'208";a="169319081"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 03 Jul 2019 19:12:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     dledford@redhat.com, jgg@mellanox.com, davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, poswald@suse.com,
        mustafa.ismail@intel.com, shiraz.saleem@intel.com,
        david.m.ertman@intel.com
Subject: [rdma 00/16] Intel RDMA Diver Updates 2019-07-03
Date:   Wed,  3 Jul 2019 19:12:42 -0700
Message-Id: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds a unified Intel Ethernet RDMA driver that
supports a new network device E810 (iWARP and RoCEv2 capable)
and the existing X722 iWARP device. The driver architecture
provides the extensibility for future generations of Intel HW
supporting RDMA.

This driver obsoletes legacy X722 driver i40iw which is marked for
deprecation and extends the ABI already defined for i40iw. It is
backward compatible with legacy X722 rdma-core provider (libi40iw).

This series was built against the rdma for-next branch.  These changes
are dependent upon changes to i40e and ice driver that are being
submitted to netdev for David Miller's net-next since the LAN drivers in
the RDMA tree are not up-to-date, patch against those drivers would
cause large conflicts with what is currently in Dave's net-next.  See
the git tree URL reference for the 3 driver patches which are required
for these changes.

RFC --> v0:
* Rehashed the design to unify RDMA driver. irdma is registered as a
  platform driver capable of supporting RDMA capable devices added to
  the virtual platform bus by their individual netdev drivers i40e/ice.
  Listening to netdev notifiers or running netdev lists are no longer
  needed for attachment. There is no load order dependencies between
  netdev drivers and irdma in the new model.

  MFD architecture was also considered, and we selected the simpler
  platform model. Supporting a MFD architecture would require an
  additional MFD core driver, individual platform netdev, RDMA function
  drivers, and stripping a large portion of the netdev drivers into
  MFD core. The sub-devices registered by MFD core for function
  drivers are indeed platform devices.  

*Use netdev_to_ibdev API to reliably get iwdev in notifiers.
 Remove VSI dev list tracking as a result.
*Fixed build make W=1 issues, sparse endianness warnings, 0-day
 32-bit compile warnings.
*Test for userspaceness with udata and remove uobject references.
*Remove abstractions for memory allocators, dev_* and pr_* prints.
*Remove redundant castings in the driver.
*Relax barriers to a dma_wmb()/dma_rmb() since we are using coherent
 mappings.
*Clang-format run on various portions of the driver.
*Remove internal verb objects tracking from driver as its already done
 in IB core.
*Report correct values for max_send_wr and max_recv_wr in irdma_query_qp()
*Check and fail the call for invalid input values on irdma_create_qp().
*ABI fixups - __aligned_u64 on all u64s. Fix travis hit and removed
 irdma_hw_attrs struct out of ABI.
*Use IRDMA_RING_MOVE_HEAD_NO_CHECK on cq_ring
*Sort call tables, Kconfig, Makefiles
*Add CQ resize feature and few fixes since RFC was published.
*Use same DRIVER_ID enum for irdma as i40iw.
*Updated ib_copy_from_udata/ib_copy_to_udata calls to do a safe copy()
*Adapt to core handling verb object allocations and other core API changes
*devlink is used to switch between RoCE and iWARP on a per function basis

The following are changes since commit 10dcc7448e9ea49488a38bca7551de1a9da06ad9:
  RDMA/hns: fix spelling mistake "attatch" -> "attach"
 and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/rdma for-next

!!! These commits are dependent upon changes to the i40e and ice driver,
    which have been submitted to netdev.  They are available at:
    git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

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

Shiraz Saleem (2):
  RDMA/irdma: Update MAINTAINERS file
  RDMA/irdma: Add Kconfig and Makefile

 MAINTAINERS                              |   10 +-
 drivers/infiniband/Kconfig               |    1 +
 drivers/infiniband/hw/Makefile           |    1 +
 drivers/infiniband/hw/i40iw/Kconfig      |    4 +-
 drivers/infiniband/hw/irdma/Kconfig      |   11 +
 drivers/infiniband/hw/irdma/Makefile     |   31 +
 drivers/infiniband/hw/irdma/cm.c         | 4514 ++++++++++++++++
 drivers/infiniband/hw/irdma/cm.h         |  415 ++
 drivers/infiniband/hw/irdma/ctrl.c       | 5958 ++++++++++++++++++++++
 drivers/infiniband/hw/irdma/defs.h       | 2126 ++++++++
 drivers/infiniband/hw/irdma/hmc.c        |  706 +++
 drivers/infiniband/hw/irdma/hmc.h        |  219 +
 drivers/infiniband/hw/irdma/hw.c         | 2563 ++++++++++
 drivers/infiniband/hw/irdma/i40iw_hw.c   |  210 +
 drivers/infiniband/hw/irdma/i40iw_hw.h   |  163 +
 drivers/infiniband/hw/irdma/i40iw_if.c   |  256 +
 drivers/infiniband/hw/irdma/icrdma_hw.c  |   75 +
 drivers/infiniband/hw/irdma/icrdma_hw.h  |   63 +
 drivers/infiniband/hw/irdma/irdma.h      |  191 +
 drivers/infiniband/hw/irdma/irdma_if.c   |  426 ++
 drivers/infiniband/hw/irdma/main.c       |  531 ++
 drivers/infiniband/hw/irdma/main.h       |  639 +++
 drivers/infiniband/hw/irdma/osdep.h      |  108 +
 drivers/infiniband/hw/irdma/pble.c       |  511 ++
 drivers/infiniband/hw/irdma/pble.h       |  136 +
 drivers/infiniband/hw/irdma/protos.h     |   96 +
 drivers/infiniband/hw/irdma/puda.c       | 1693 ++++++
 drivers/infiniband/hw/irdma/puda.h       |  187 +
 drivers/infiniband/hw/irdma/status.h     |   70 +
 drivers/infiniband/hw/irdma/trace.c      |  113 +
 drivers/infiniband/hw/irdma/trace.h      |    4 +
 drivers/infiniband/hw/irdma/trace_cm.h   |  459 ++
 drivers/infiniband/hw/irdma/type.h       | 1701 ++++++
 drivers/infiniband/hw/irdma/uda.c        |  391 ++
 drivers/infiniband/hw/irdma/uda.h        |   65 +
 drivers/infiniband/hw/irdma/uda_d.h      |  383 ++
 drivers/infiniband/hw/irdma/uk.c         | 1739 +++++++
 drivers/infiniband/hw/irdma/user.h       |  451 ++
 drivers/infiniband/hw/irdma/utils.c      | 2333 +++++++++
 drivers/infiniband/hw/irdma/verbs.c      | 4347 ++++++++++++++++
 drivers/infiniband/hw/irdma/verbs.h      |  199 +
 drivers/infiniband/hw/irdma/ws.c         |  396 ++
 drivers/infiniband/hw/irdma/ws.h         |   40 +
 include/uapi/rdma/irdma-abi.h            |  130 +
 include/uapi/rdma/rdma_user_ioctl_cmds.h |    1 +
 45 files changed, 34664 insertions(+), 2 deletions(-)
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
 create mode 100644 include/uapi/rdma/irdma-abi.h

-- 
2.21.0

