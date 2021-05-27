Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C2A3934CC
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 19:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhE0RaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 13:30:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:44427 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235266AbhE0RaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 13:30:06 -0400
IronPort-SDR: zMEIxuKu3nD83aOrzeTeOld8kXRl1R9+TmCf0tqSi3vyF9WDh0iopY0UB4EU/E3OmKVm3EAoLa
 wYGn8glhQsWQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="190164929"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="190164929"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 10:27:52 -0700
IronPort-SDR: qS99XsOMNSuHyF/AHD3J+EILjfWFvFwj0B+EZFKg9cEmis6V0RAgnIVEy2AhiO/tsGUjmz34sV
 T/C+Cj6jbRhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="480682787"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2021 10:27:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, dledford@redhat.com,
        jgg@mellanox.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        david.m.ertman@intel.com
Subject: [PATCH net-next v2 0/7][pull request] iwl-next Intel Wired LAN Driver Updates 2021-05-27
Date:   Thu, 27 May 2021 10:30:07 -0700
Message-Id: <20210527173014.362216-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This pull request is targeting net-next and rdma-next branches.
These patches have been reviewed by netdev and rdma mailing lists[1].

This series adds RDMA support to the ice driver for E810 devices and
converts the i40e driver to use the auxiliary bus infrastructure
for X722 devices. The PCI netdev drivers register auxiliary RDMA devices
that will bind to auxiliary drivers registered by the new irdma module.

[1] https://lore.kernel.org/netdev/20210520143809.819-1-shiraz.saleem@intel.com/
---
v2:
- Added patch 'i40e: Replace one-element array with flexible-array
member'

Changes since linked review (v6):
- Removed unnecessary checks in i40e_client_device_register() and
i40e_client_device_unregister()
- Simplified the i40e_client_device_register() API
---
The following are changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:
  Linux 5.13-rc1
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux iwl-next

Dave Ertman (4):
  iidc: Introduce iidc.h
  ice: Initialize RDMA support
  ice: Implement iidc operations
  ice: Register auxiliary device to provide RDMA

Gustavo A. R. Silva (1):
  i40e: Replace one-element array with flexible-array member

Shiraz Saleem (2):
  i40e: Prep i40e header for aux bus conversion
  i40e: Register auxiliary devices to provide RDMA

 MAINTAINERS                                   |   1 +
 drivers/infiniband/hw/i40iw/i40iw_main.c      |   5 +-
 drivers/net/ethernet/intel/Kconfig            |   2 +
 drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
 drivers/net/ethernet/intel/i40e/i40e_client.c | 132 +++++--
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   1 +
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |  44 ++-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  33 ++
 drivers/net/ethernet/intel/ice/ice_common.c   | 217 ++++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  19 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   3 +-
 drivers/net/ethernet/intel/ice/ice_idc.c      | 339 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  14 +
 drivers/net/ethernet/intel/ice/ice_lag.c      |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  11 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 142 ++++++--
 drivers/net/ethernet/intel/ice/ice_sched.c    |  69 +++-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  27 ++
 drivers/net/ethernet/intel/ice/ice_switch.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   4 +
 include/linux/net/intel/i40e_client.h         |  12 +-
 include/linux/net/intel/iidc.h                | 100 ++++++
 25 files changed, 1136 insertions(+), 59 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 create mode 100644 include/linux/net/intel/iidc.h

-- 
2.26.2

