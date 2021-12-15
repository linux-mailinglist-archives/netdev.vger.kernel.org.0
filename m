Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39730476129
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344073AbhLOSzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:55:14 -0500
Received: from mga14.intel.com ([192.55.52.115]:57351 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344059AbhLOSyz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639594495; x=1671130495;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CJ3QIN8qtqTy11dgMk5dEO3fIxZecRujzDJBBE6MpGI=;
  b=i5W6+v12z4OXqpCq7hBAs7fR2Bqo26P+bUOu/iqyxj1DNwQGgcgY50j3
   uXAmZyxJiswbcueRtMWWPL4SH0D6BEHJ0YIGTcYkNCBW4axX2CFhhpBhj
   t8VMVtLc96wvFhnggDGpsFMXlUUxOXF1cw0fK3KU9t5Cf4/8rCsl+HFHJ
   siuzHUGgiG0JzzVTIJcE9GSuEacKnWBfCQA7ujsCjvWgii9BhNKrVbS0k
   mh1PGbQ2wF2xe0q0JipkCCE/rbs+5ZSsa5eED/Y12wudrTmiAvd83+87p
   xlz4A1Ziwv39Tl+1a5EyJTXyzCacKOvOAUUbWXk4JLW4zDInc83IsILz/
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="239533292"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="239533292"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 10:54:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465729927"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 10:54:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/9][pull request] 100GbE Intel Wired LAN Driver Updates 2021-12-15
Date:   Wed, 15 Dec 2021 10:53:46 -0800
Message-Id: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jake makes changes to flash update. This includes the following:

 * a new shadow-ram region similar to NVM region but for the device shadow
   RAM contents. This is distinct from NVM region because shadow RAM is
   built up during device init and may be different from the raw NVM flash
   data.
 * refactoring of the ice_flash_pldm_image to become the main flash update
   entry point. This is simpler than having both an
   ice_devlink_flash_update and an ice_flash_pldm_image. It will make
   additions like dry-run easier in the future.
 * reducing time to read Option ROM version information.
 * adding support for firmware activation via devlink reload, when
   possible.

The major new work is the reload support, which allows activating firmware
immediately without a reboot when possible. Reload support only supports
firmware activation.

Jesse improves transmit code: utilizing newer netif_tx* API, adding some
prefetch calls, correcting expected conditions when calling ice_vsi_down(),
and utilizing __netdev_tx_sent_queue() call.

The following are changes since commit 3bc14ea0d12a57a968038f8e86e9bc2c1668ad9a:
  ethtool: always write dev in ethnl_parse_header_dev_get
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (5):
  ice: devlink: add shadow-ram region to snapshot Shadow RAM
  ice: move and rename ice_check_for_pending_update
  ice: move ice_devlink_flash_update and merge with ice_flash_pldm_image
  ice: reduce time to read Option ROM CIVD data
  ice: support immediate firmware activation via devlink reload

Jesse Brandeburg (4):
  ice: update to newer kernel API
  ice: use prefetch methods
  ice: tighter control over VSI_DOWN state
  ice: use modern kernel API for kick

 Documentation/networking/devlink/ice.rst      |  24 +-
 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   7 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  12 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 202 +++++++++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   6 +-
 .../net/ethernet/intel/ice/ice_fw_update.c    | 335 +++++++++++++-----
 .../net/ethernet/intel/ice/ice_fw_update.h    |   9 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  15 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |  67 +++-
 drivers/net/ethernet/intel/ice/ice_nvm.h      |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  40 ++-
 drivers/net/ethernet/intel/ice/ice_type.h     |   4 +
 13 files changed, 558 insertions(+), 167 deletions(-)

-- 
2.31.1

