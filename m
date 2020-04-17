Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49681AE349
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgDQRKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:10:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:24554 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbgDQRKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:10:40 -0400
IronPort-SDR: Ci7CsQZOAwUxwg1NLy4vJreveKVTfL4apQB85astG9DEaV5GBH/nplhPzPoNJdbJaVI09DCS/z
 8Iryxq6ZeOqg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:10:39 -0700
IronPort-SDR: 64HpIrENbFmhqNu5uUMNnZq7oSbVZzRs1v966WRkYDjlLbgIOPS4jkt37sOD1m8XA6+FzVuTmy
 oCY13fTyzwfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="278442076"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 17 Apr 2020 10:10:37 -0700
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
Subject: [net-next 0/9][pull request] 100GbE Intel Wired LAN Driver Updates 2020-04-17
Date:   Fri, 17 Apr 2020 10:10:25 -0700
Message-Id: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
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

This series currently builds against net-next tree.

Revision History of RFC submissions
v1: Initial virtual bus submission 
v2: Added example virtbus_dev and virtbus_drv in tools/testing/sefltests/
    to test the virtual bus and provide an example on how to implement
v3: Added ice and i40e driver changes to implement the virtual bus, also
    added the new irdma driver which is the RDMA driver which communicates
    with the ice and i40e drivers
v4: Added other RDMA driver maintainers on the virtbus changes
  * Updated commit message and documentation, removed PM dependency, used
    static inlines where possible, cleaned up deprecated code based on
    feedback for patch 1 of the series
  * Simplified the relationship and ensure that the lifetime rules are
    controlled by the bus in patches 1 & 2 of the series


The following are changes since commit 2fcd80144b93ff90836a44f2054b4d82133d3a85:
  Merge tag 'tag-chrome-platform-fixes-for-v5.7-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/chrome-platform/linux
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

Shiraz Saleem (2):
  i40e: Move client header location
  i40e: Register a virtbus device to provide RDMA

 Documentation/driver-api/virtual_bus.rst      |   62 +
 MAINTAINERS                                   |    1 +
 drivers/bus/Kconfig                           |   10 +
 drivers/bus/Makefile                          |    2 +
 drivers/bus/virtual_bus.c                     |  270 ++++
 drivers/infiniband/hw/i40iw/Makefile          |    1 -
 drivers/infiniband/hw/i40iw/i40iw.h           |    2 +-
 drivers/net/ethernet/intel/Kconfig            |    2 +
 drivers/net/ethernet/intel/i40e/i40e.h        |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |  133 +-
 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice.h          |   15 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   33 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  206 ++-
 drivers/net/ethernet/intel/ice/ice_common.h   |    9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   68 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    3 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 1327 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  105 ++
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
 include/linux/net/intel/iidc.h                |  337 +++++
 include/linux/virtual_bus.h                   |   53 +
 scripts/mod/devicetable-offsets.c             |    3 +
 scripts/mod/file2alias.c                      |    7 +
 34 files changed, 2933 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/driver-api/virtual_bus.rst
 create mode 100644 drivers/bus/virtual_bus.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h (94%)
 create mode 100644 include/linux/net/intel/iidc.h
 create mode 100644 include/linux/virtual_bus.h

-- 
2.25.2

