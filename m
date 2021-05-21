Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7672338CD1B
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238556AbhEUSVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:21:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:33075 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230242AbhEUSVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 14:21:42 -0400
IronPort-SDR: aYTz6Jiay+l1/2/ZxNLKoPPzkuvWYNKsHiUkQkq5bbOretQjDsHnfocHMSdBZmUObibrkMtD9F
 quUImj3504cg==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="262760035"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="262760035"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 11:19:57 -0700
IronPort-SDR: u52F4NyD/fmtuFTPkT4ButVGLT8vM0Onwv8UOKw8DaZ97jq1DNup8mbJT6qTLUu01qaLwuz5C3
 ZIE5GoOOZKXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="545488369"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 21 May 2021 11:19:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, dledford@redhat.com,
        jgg@mellanox.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        david.m.ertman@intel.com
Subject: [PATCH net-next v1 0/6][pull request] iwl-next Intel Wired LAN Driver Updates 2021-05-21
Date:   Fri, 21 May 2021 11:21:59 -0700
Message-Id: <20210521182205.3823642-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
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
Changes from last review (v6):
- Removed unnecessary checks in i40e_client_device_register() and
i40e_client_device_unregister()
- Simplified the i40e_client_device_register() API

The following are changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:
  Linux 5.13-rc1
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux iwl-next

Dave Ertman (4):
  iidc: Introduce iidc.h
  ice: Initialize RDMA support
  ice: Implement iidc operations
  ice: Register auxiliary device to provide RDMA

Shiraz Saleem (2):
  i40e: Prep i40e header for aux bus conversion
  i40e: Register auxiliary devices to provide RDMA

 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/intel/Kconfig            |   2 +
 drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
 drivers/net/ethernet/intel/i40e/i40e_client.c | 130 +++++--
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
 include/linux/net/intel/i40e_client.h         |  10 +
 include/linux/net/intel/iidc.h                | 100 ++++++
 24 files changed, 1132 insertions(+), 54 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 create mode 100644 include/linux/net/intel/iidc.h

-- 
2.26.2

