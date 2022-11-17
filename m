Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF69E62E7C6
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbiKQWI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241210AbiKQWIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:08:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE79656D76
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668722893; x=1700258893;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1bCl+6ehL1vCwRa82jupCfnWFQYXFtLYyl1Fy6cnEiI=;
  b=HJoHwwK5I35u+kvs0GEBbsL4wgYgI35JrwGTm3mYyZQvI8OoW5W2mNwi
   pLikQJA18wbi2e7MTkX4NFF1l+gOtghyHKzZCO6YA3h1ZbHCnLWf6iSIu
   HOYE7weJxDMWAOZBzuc43hXF0yVG5zdC+E8oJaa44q3iCPIjiQEzF+wy2
   AExwq7/SkSUqgnVe2KUVpSoJOnfIzkNI/10GcTNJslpWyKRYlEi7RFxeB
   U9pCnwLjZVWpRzumFKUELJ5JdP8Z/QcQ9FOa/iYrNOjUG7ziXc1f6nQ4w
   Ma7XAPQZP+ZFEe/QaN57BurCtH+bY5CBKHq4aRn5dOV/zdMLQcMp3AHM4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="313001214"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="313001214"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="672975615"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="672975615"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:12 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/8] devlink: support direct read from region
Date:   Thu, 17 Nov 2022 14:07:55 -0800
Message-Id: <20221117220803.2773887-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A long time ago when initially implementing devlink regions in ice I
proposed the ability to allow reading from a region without taking a
snapshot [1]. I eventually dropped this work from the original series due to
size. Then I eventually lost track of submitting this follow up.

This can be useful when interacting with some region that has some
definitive "contents" from which snapshots are made. For example the ice
driver has regions representing the contents of the device flash.

If userspace wants to read the contents today, it must first take a snapshot
and then read from that snapshot. This makes sense if you want to read a
large portion of data or you want to be sure reads are consistently from the
same recording of the flash.

However if user space only wants to read a small chunk, it must first
generate a snapshot of the entire contents, perform a read from the
snapshot, and then delete the snapshot after reading.

For such a use case, a direct read from the region makes more sense. This
can be achieved by allowing the devlink region read command to work without
a snapshot. Instead the portion to be read can be forwarded directly to the
driver via a new .read callback.

This avoids the need to read the entire region contents into memory first
and avoids the software overhead of creating a snapshot and then deleting
it.

This series implements such behavior and hooks up the ice NVM and shadow RAM
regions to allow it.

[1] https://lore.kernel.org/netdev/20200130225913.1671982-1-jacob.e.keller@intel.com/

Cc: Jiri Pirko <jiri@nvidia.com>
Cc: Jakub Kicinski <kuba@kernel.org>

Jacob Keller (8):
  devlink: find snapshot in devlink_nl_cmd_region_read_dumpit
  devlink: use min_t to calculate data_size
  devlink: report extended error message in region_read_dumpit
  devlink: remove unnecessary parameter from chunk_fill function
  devlink: refactor region_read_snapshot_fill to use a callback function
  devlink: support directly reading from region memory
  ice: use same function to snapshot both NVM and Shadow RAM
  ice: implement direct read for NVM and Shadow RAM regions

 .../networking/devlink/devlink-region.rst     |   8 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 112 +++++++++-------
 include/net/devlink.h                         |  16 +++
 net/core/devlink.c                            | 121 +++++++++++++-----
 4 files changed, 180 insertions(+), 77 deletions(-)


base-commit: b4b221bd79a1c698d9653e3ae2c3cb61cdc9aee7
-- 
2.38.1.420.g319605f8f00e

