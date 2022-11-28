Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E99F63B35C
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiK1UhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiK1UhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:37:01 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6408E2C64A
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669667819; x=1701203819;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VuVHwNODoW53SJ69KdX6+lmDXQ8KG2NYUAarD808Mc8=;
  b=dTa/m7gw+JcQCLQZiZqa+M2yaK82m0fkr+5R7ODNnKc8gCqT1ldOXU2f
   ULhzNrz+P+DJFJS1HTSCoPI52HfC5hRpT92894PZYecoTI0BVhiEhJpar
   vVmwslvuOy5DDRriuQVXJtXhlfJIKlK92X7OVlFQXRk+u3p7ipeUqz3jZ
   LgaYUk3ZIt+xIgwai8fkr4HJev1t5mEBfB2T/BPDakVpQxzwl2JsNX3Kk
   FRgqTugPJ9k7Cr+z7fruNK/+u3zlj00QcZXt+0iTlS1t1iIy3VlTrx+mY
   0Iq6RJQJoVl6EdvujhEZdx9g7TN0Ls5vJGcOJ+3/OCW0JqdznFYpewcTC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379205372"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379205372"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732286339"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="732286339"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:58 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 0/9] support direct read from region
Date:   Mon, 28 Nov 2022 12:36:38 -0800
Message-Id: <20221128203647.1198669-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v2:
* Picked up ack/review tags
* Added DEVLINK_ATTR_REGION_DIRECT so userspace must be explicit
* Fixed the capitalization of netlink error messages

Changes since v1:
* Re-ordered patches at the beginning slightly, pulling min_t change and
  reporting of extended error messages to the start of the series.
* use NL_SET_ERR_MSG_ATTR for reporting invalid attributes
* Use kmalloc instead of kzalloc
* Cleanup spacing around data_size
* Fix the __always_unused positioning
* Update documentation for direct reads to clearly explain they are not
  atomic for larger reads.
* Add a patch to fix missing documentation for ice.rst
* Mention the direct read support in ice.rst documentation

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



Jacob Keller (9):
  devlink: use min_t to calculate data_size
  devlink: report extended error message in region_read_dumpit()
  devlink: find snapshot in devlink_nl_cmd_region_read_dumpit
  devlink: remove unnecessary parameter from chunk_fill function
  devlink: refactor region_read_snapshot_fill to use a callback function
  devlink: support directly reading from region memory
  ice: use same function to snapshot both NVM and Shadow RAM
  ice: document 'shadow-ram' devlink region
  ice: implement direct read for NVM and Shadow RAM regions

 .../networking/devlink/devlink-region.rst     |  13 ++
 Documentation/networking/devlink/ice.rst      |  13 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 112 ++++++++------
 include/net/devlink.h                         |  16 ++
 include/uapi/linux/devlink.h                  |   2 +
 net/core/devlink.c                            | 139 ++++++++++++++----
 6 files changed, 215 insertions(+), 80 deletions(-)


base-commit: c672e37279896f570cfa44926d57497e8d16033b
-- 
2.38.1.420.g319605f8f00e

