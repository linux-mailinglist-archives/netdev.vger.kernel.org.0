Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BA41C7BE8
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgEFVFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:05:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:30092 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728821AbgEFVFL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 17:05:11 -0400
IronPort-SDR: UmUBHhlixDkws1tu+so7Z0RkXgPcWnUyrpOh0IQsZxylJMhU6qImvXOIRa7AiuzvcLMV9fDNCn
 2dPSy3/4lxqQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 14:05:10 -0700
IronPort-SDR: /eKtDeSBW16BXUfb5ufvG9/2mHfnaGP1vT39FdFQJy8cAfmcG5CYk3sIVnsN/BMwYw5BxoY5dN
 oLSTV/LwiMSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,360,1583222400"; 
   d="scan'208";a="263703794"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2020 14:05:08 -0700
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
Subject: [net-next v3 0/9][pull request] 100GbE Intel Wired LAN Driver Updates 2020-05-05
Date:   Wed,  6 May 2020 14:04:56 -0700
Message-Id: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
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
in RFC currently and was sent in a separate series.  A new RFC version
is expected later this week.

This series currently builds against net-next tree.

Revision history:
v2: Made changes based on community feedback, like Pierre-Louis's and
    Jason's comments to update virtual bus interface.
v3: Updated the virtual bus interface based on feedback from Jason and
    Greg KH.  Also updated the initial ice driver patch to handle the
    virtual bus changes and changes requested by Jason and Greg KH.

The following are changes since commit f989d546a2d5a9f001f6f8be49d98c10ab9b1897:
  erspan: Add type I version 0 support.
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

 Documentation/driver-api/virtual_bus.rst      |   88 ++
 MAINTAINERS                                   |    1 +
 drivers/bus/Kconfig                           |   10 +
 drivers/bus/Makefile                          |    2 +
 drivers/bus/virtual_bus.c                     |  255 ++++
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
 34 files changed, 2970 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/driver-api/virtual_bus.rst
 create mode 100644 drivers/bus/virtual_bus.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h (94%)
 create mode 100644 include/linux/net/intel/iidc.h
 create mode 100644 include/linux/virtual_bus.h

-- 
2.26.2

