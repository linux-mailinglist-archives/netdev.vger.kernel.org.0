Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA45514E5BD
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 23:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgA3W7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:51507 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgA3W7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187756"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:19 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH 00/13] devlink direct region reading
Date:   Thu, 30 Jan 2020 14:58:55 -0800
Message-Id: <20200130225913.1671982-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per the previous discussions about supporting devlink region snapshot
triggers and direct region writes, this is an RFC patch series to implement
these changes. I fully expect to need revisions to this series, and the ice
driver changes will need to go through the normal intel-wired-lan queue
process.

The final patches implement support for directly reading from a region
without a snapshot. In order to have context on how and why this is
implemented, the ice driver is modified to support devlink and expose a
region. The series can be broken down into multiple parts or stages, as
described below.

The first 4 patches modify devlink regions to support a new
devlink_region_ops structure, and then implement a new op for requesting
that the driver capture an immediate snapshot. Support for that is then
implemented in the netdevsim driver. This was previously discussed on the
list:

  https://lore.kernel.org/netdev/20200109193311.1352330-1-jacob.e.keller@intel.com/

The only major change is to convert to using an operation in the
devlink_region_ops structure instead of passing the pointer as an argument
to devlink_region_create. This makes it easier for regions to support
additional operations in the future.

Following this section is 3 patches to the ice driver implementing a
function to easily read portions of the NVM contents as flat addressable
memory. The current .get_eeprom function is updated to support reading from
the entire NVM.

There is a patch to add devlinkm_alloc as a devres based managed allocation
for the devlink_alloc call.

Following this are 4 patches to implement basic devlink support for the ice
driver. This includes a simple .get_info handler.

Finally, the last 3 patches implement a new region in the ice driver for
accessing the shadow RAM. This region will support the immediate trigger
operation as well as a new read operation that enables directly reading from
the shadow RAM without a region.

I expect that this series is not yet ready to land and am sending it
primarily as a discussion point on the changes to the devlink core code. I
expect feedback and the need to change and improve the implementation.

It's likely that the actual submissions can be broken up into smaller
series, for example the basic ice devlink support going first followed by a
separate series for the region changes.

I've also submitted iproute2 patches for implementing the ability to request
snapshots and read from the region directly.

Jacob Keller (12):
  devlink: prepare to support region operations
  devlink: add functions to take snapshot while locked
  devlink: add operation to take an immediate snapshot
  netdevsim: support taking immediate snapshot via devlink
  ice: use __le16 types for explicitly Little Endian values
  ice: create function to read a section of the NVM and Shadow RAM
  ice: enable initial devlink support for function zero
  ice: add basic handler for devlink .info_get
  ice: add board identifier info to devlink .info_get
  ice: add a devlink region to dump shadow RAM contents
  devlink: support directly reading from region memory
  ice: support direct read of the shadow ram region

Jesse Brandeburg (1):
  ice: implement full NVM read from ETHTOOL_GEEPROM

 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   7 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  61 +++
 drivers/net/ethernet/intel/ice/ice_common.h   |   5 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 427 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h  |  20 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  37 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  22 +
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 211 +++------
 drivers/net/ethernet/intel/ice/ice_nvm.h      |   7 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 drivers/net/ethernet/mellanox/mlx4/crdump.c   |  25 +-
 drivers/net/netdevsim/dev.c                   |  44 +-
 include/net/devlink.h                         |  28 +-
 include/uapi/linux/devlink.h                  |   2 +
 net/core/devlink.c                            | 246 +++++++---
 18 files changed, 918 insertions(+), 230 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.h

-- 
2.25.0.rc1

