Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF64D2B8461
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgKRTIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:08:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:46633 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgKRTIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:08:02 -0500
IronPort-SDR: OzWISj+vrubAwoC0rkx3PnXsY1+wZPw6nxWUJ3C14xrz1WQTQ76dMRTB7vhpya+Q8aEB0pu0P+
 dnZxQdxYCn5w==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="255880096"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="255880096"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 11:08:01 -0800
IronPort-SDR: TQ10F2iwPjczB4f7qkVpWqxHaS/sKBimHtdk0mQX+JFNy6SqutMiFPd+5FcfBwbEFbWp2jUvmK
 RSAfahkt6jEg==
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="341410214"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 11:08:01 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>, Jakub Kicinksi <kuba@kernel.org>
Subject: [net-next v4 0/2] devlink: move common flash_update calls to core
Date:   Wed, 18 Nov 2020 11:06:34 -0800
Message-Id: <20201118190636.1235045-1-jacob.e.keller@intel.com>
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

Changes since v3
* picked up acked-by and reviewed-by comments
* fixed the ionic driver to leave the print statement in place

For the original patch that moved request_firmware, see [1]. For the v2 see
[2]. For further discussion of the issues with devlink flash status see [3].
For v3 see [4].

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
[4] https://lore.kernel.org/netdev/20201117200820.854115-1-jacob.e.keller@intel.com/

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
 .../net/ethernet/pensando/ionic/ionic_fw.c    | 14 ++------
 drivers/net/netdevsim/dev.c                   |  2 --
 include/net/devlink.h                         |  9 +++--
 net/core/devlink.c                            | 36 ++++++++++++++-----
 17 files changed, 68 insertions(+), 113 deletions(-)


base-commit: ed30aef3c864f99111e16d4ea5cf29488d99a278
-- 
2.29.0

