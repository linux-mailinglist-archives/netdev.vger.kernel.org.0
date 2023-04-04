Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A366D6A9B
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbjDDRaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236758AbjDDRad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:30:33 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875816E86
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 10:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680629357; x=1712165357;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5XCg187Pdv56N34mrpU9ETucJ6RBZJVNpHHfqmd0ZmA=;
  b=dYOQn5m8YgHDhCra+AkepETvorw4JD1T7dfRwTUV1LGNURA+YU3jdYsk
   /7qiucZMw8SmeeFpsSMQfiWirD0JxaNLPXb2jmWgUw93Ych/PQS3sbCEh
   DPRXLE5XoRdDKDCw/31LZt8WkGLLqyoFcr3SoDcdWQ1aZqHwk4k21ZuZC
   4TfuN8WUJs8Wm7kgjJ5urIOVPsx3F7L6YkzpF5uGS1bqQ0HXFBaHjyLWt
   vyE4MRDvKVs9g9FMlxci68OqawdZArFQuvdxfiIxujbId8g+chN+Kkwq9
   R146Mq1hIfsY8/aPqt+ZvJjzVFrN3wXIFYfGLE5SvDUkMT661VPjbG5nV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="326283268"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="326283268"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:27:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="750997259"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="750997259"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 04 Apr 2023 10:27:45 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, ahmed.zaki@intel.com
Subject: [PATCH net 0/2][pull request] iavf: fix racing in VLANs
Date:   Tue,  4 Apr 2023 10:25:20 -0700
Message-Id: <20230404172523.451026-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ahmed Zaki says:

This patchset mainly fixes a racing issue in the iavf where the number of
VLANs in the vlan_filter_list might be more than the PF limit. To fix that,
we get rid of the cvlans and svlans bitmaps and keep all the required info 
in the list.

The second patch adds two new states that are needed so that we keep the 
VLAN info while the interface goes DOWN:
    -- DISABLE    (notify PF, but keep the filter in the list)
    -- INACTIVE   (dev is DOWN, filter is removed from PF)

Finally, the current code keeps each state in a separate bit field, which
is error prone. The first patch refactors that by replacing all bits with
a single enum. The changes are minimal where each bit change is replaced
with the new state value.

The following are changes since commit 218c597325f4faf7b7a6049233a30d7842b5b2dc:
  net: stmmac: fix up RX flow hash indirection table when setting channels
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Ahmed Zaki (2):
  iavf: refactor VLAN filter states
  iavf: remove active_cvlans and active_svlans bitmaps

 drivers/net/ethernet/intel/iavf/iavf.h        | 20 +++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 44 +++++-------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 68 ++++++++++---------
 3 files changed, 66 insertions(+), 66 deletions(-)

-- 
2.38.1

