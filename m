Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7DF6910F8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 20:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBITHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 14:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjBITHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 14:07:35 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B8C5C4BB
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 11:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675969654; x=1707505654;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/FDHuUwlN974ef5053hjnCJ5IfssXKdIexxJoade5Ek=;
  b=Lulv4+uC405jleSJ7JKWAVBCDsRwGCc7rJ0s3abEzni7OgDUKjR4+RVj
   5eCkOcmHSwSBearvUpFMk3qBYcPZYIMr8QTnsidZF8qvKeGNYSK++DLlS
   pDCVbEZIFng1ZqXRinF532N/IK3LH7CoF0Q+0dNJu9YoUZsmSVChuvuUR
   FzBZulfCVzfcMQf0TUGsvsCVW/LdLYBvYvR22i78/FlzqDC1hghBX9PVU
   uzqKOPHuTSu3xocc5BN1+ZN4n6WCYYENMjAqlgh5P/OQa059g3SbcK48s
   +yTc7hzW1pdQA20W/F6YxdEhMBbpWZ56iSa18dDkkb/hsAUkSsuL/rOaR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="331512682"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="331512682"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 11:07:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="913235364"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="913235364"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 09 Feb 2023 11:07:32 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        paul.m.stillwell.jr@intel.com, jacob.e.keller@intel.com,
        jiri@nvidia.com, idosch@idosch.org
Subject: [PATCH net-next 0/5][pull request] add v2 FW logging for ice driver
Date:   Thu,  9 Feb 2023 11:06:57 -0800
Message-Id: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Stillwell says:

FW log support was added to the ice driver, but that version is no
longer supported. There is a newer version of FW logging (v2) that
adds more control knobs to get the exact data out of the FW
for debugging.

Additionally, instead of dumping the FW log output to syslog,
dump it to debugfs. The FW log data is really just binary
data that the FW log team decodes to determine what happens so the
translation from binary to some text output just slows things down
and results in potential dropped data. The structure for the debugfs
entry is: /sys/kernel/debug/ice/<pci device>/fwlog

Once enabled the FW log data is received as ARQ events that the driver
processes.

The FW logging is across all the PFs on the device, so restrict the
commands to only PF0.

The following new device parameters are added:
- fwlog_supported (read-only): does the FW support FW logging
- fwlog_enabled (read/write): is FW logging currently running
- fwlog_level (read/write): the log level enabled, valid values are
    Each level includes the messages from the previous/lower level
	0 - no logging
	1 - error logging
	2 - warning logging
	3 - normal logging
	4 - verbose logging
- fwlog_resolution (read/write): the number of log messages to included
  in a single ARQ event. The range is 1-128 (1 means push every log
  message, 128 means push only when the max AQ command buffer is full).
  The suggested value is 10.

This patch series adds the following set of devlink commands:

devlink dev param set <pci dev> name fwlog_enabled value <true/false> cmode runtime
devlink dev param set <pci dev> name fwlog_level value <0-4> cmode runtime
devlink dev param set <pci dev> name fwlog_resolution value <1-128> cmode runtime
---
Previous discussion:
https://lore.kernel.org/netdev/fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com/

The following are changes since commit 5131a053f2927158fb42880c69b5dc0d2e28ddee:
  Merge tag 'linux-can-next-for-6.3-20230208' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Paul M Stillwell Jr (5):
  ice: remove FW logging code
  ice: enable devlink to check FW logging status
  ice: add ability to query/set FW log level and resolution
  ice: disable FW logging on driver unload
  ice: use debugfs to output FW log data

 Documentation/networking/devlink/ice.rst      |  39 ++
 drivers/net/ethernet/intel/ice/Makefile       |   5 +-
 drivers/net/ethernet/intel/ice/ice.h          |  22 ++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 160 ++++----
 drivers/net/ethernet/intel/ice/ice_common.c   | 218 +----------
 drivers/net/ethernet/intel/ice/ice_common.h   |   1 -
 drivers/net/ethernet/intel/ice/ice_debugfs.c  | 116 ++++++
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 181 ++++++++-
 drivers/net/ethernet/intel/ice/ice_fwlog.c    | 367 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_fwlog.h    |  57 +++
 drivers/net/ethernet/intel/ice/ice_main.c     | 101 ++++-
 drivers/net/ethernet/intel/ice/ice_type.h     |  23 +-
 12 files changed, 973 insertions(+), 317 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_debugfs.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fwlog.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fwlog.h

-- 
2.38.1

