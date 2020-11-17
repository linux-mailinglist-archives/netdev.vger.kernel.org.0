Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C352B6FB5
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbgKQUJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:09:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:5081 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgKQUJt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 15:09:49 -0500
IronPort-SDR: aBx364a80JgNddyRIuoNbXIvjxpivtZl7IWiA+2TOq1soRhv3+x+xNT8EX/iYne5N1VP556fzm
 4Fjfd8WSCNoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9808"; a="171171602"
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="171171602"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 12:09:46 -0800
IronPort-SDR: qxj0CHBS2rLstbhPRPY3uzqgmAc98H/vvKIJXNDNdtm3ioblKNTAwf14ekZdzBI0Xl7Flqkn/r
 9vv021TCaaDA==
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="368003523"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 12:09:45 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>, Jakub Kicinksi <kuba@kernel.org>
Subject: [net-next v3 0/2] devlink: move common flash_update calls to core
Date:   Tue, 17 Nov 2020 12:08:18 -0800
Message-Id: <20201117200820.854115-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series moves a couple common pieces done by all drivers of the
->flash_update interface into devlink.c flash update handler. Specifically,
the core code will now request_firmware and
devlink_flash_update_(begin|end)_notify.

This cleanup is intended to simplify driver implementations so that they
have less work to do and are less capable of doing the "wrong" thing.

For request_firmware, this simplification is done as it is not expected that
drivers would do anything else. It also standardizes all drivers so that
they use the same interface (request_firmware, as opposed to
request_firmware_direct), and allows reporting the netlink extended ack with
the file name attribute.

For status notification, this change prevents drivers from sending a status
message without properly sending the status end notification. The current
userspace implementation of devlink relies on this end notification to
properly close the flash update channel. Without this, the flash update
process may hang indefinitely. By moving the begin and end calls into the
core code, it is no longer possible for a driver author to get this wrong.

For the original patch that moved request_firmware, see [1]. For the v2 see
[2]. For further discussion of the issues with devlink flash status see [3].

Cc: Jiri Pirko <jiri@nvidia.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Shannon Nelson <snelson@pensando.io>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Boris Pismenny <borisp@nvidia.com>
Cc: Bin Luo <luobin9@huawei.com>
Cc: Jakub Kicinksi <kuba@kernel.org>

[1] https://lore.kernel.org/netdev/20201113000142.3563690-1-jacob.e.keller@intel.com/
[2] https://lore.kernel.org/netdev/20201113224559.3910864-1-jacob.e.keller@intel.com/
[3] https://lore.kernel.org/netdev/6352e9d3-02af-721e-3a54-ef99a666be29@intel.com/


Jacob Keller (2):
  devlink: move request_firmware out of driver
  devlink: move flash end and begin to core devlink

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  4 +--
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 33 +++++++++++------
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  4 +--
 .../net/ethernet/huawei/hinic/hinic_devlink.c | 12 +------
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 17 +--------
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 11 +-----
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   |  3 --
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 11 +-----
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  2 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 17 ++-------
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  2 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |  2 +-
 .../ethernet/pensando/ionic/ionic_devlink.h   |  2 +-
 .../net/ethernet/pensando/ionic/ionic_fw.c    | 14 +-------
 drivers/net/netdevsim/dev.c                   |  2 --
 include/net/devlink.h                         |  9 +++--
 net/core/devlink.c                            | 36 ++++++++++++++-----
 17 files changed, 67 insertions(+), 114 deletions(-)


base-commit: 83c317d7b36bb3858cf1cb86d2635ec3f3bd6ea3
-- 
2.29.0

