Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1F26DB5B3
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjDGVJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjDGVJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:09:51 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2D01A8
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 14:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680901790; x=1712437790;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+dVv5FEnaLbXa83asWfKvI5uxkTCVXqQe1vFwtYErlc=;
  b=dsFF5RsL1PBZSOTc990Jyg+ednnUroM8knLvGz+4kvXPXgzMvGikKCqo
   c+g5rQsO/c5uGhuLIcu+sjMiZOpJdWcXlnWuAO+ayG/AGdPJFPGN3mfoU
   7KMDLMczBD47TG/VkZRdDZaqSixIz9WZG86osRmMlbv6vEHODHOCm4l27
   LzNIp0E8S5CjhGaRCkt0ThLqVDmoolW5+6u+Cw0w/Xz4MWtI3fOCEpBDm
   yXsVAaXHjUE+TG4Xb0/T7agRjmoUjEZKCNKAaC/HK8nEl8Y5iDC68wHkw
   8OMUCfA52taSNQmNWcQXX38FCFVMLMQF6kBveG1EIsFcn6r/ldizJ+fvx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="343076201"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="343076201"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 14:09:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="811511274"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="811511274"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 07 Apr 2023 14:09:49 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, ahmed.zaki@intel.com
Subject: [PATCH net v2 0/2][pull request] iavf: fix racing in VLANs
Date:   Fri,  7 Apr 2023 14:07:28 -0700
Message-Id: <20230407210730.3046149-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
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
---
v2: change state names from __IAVF_VLAN_STATE to IAVF_STATE_NAME

The following are changes since commit b9881d9a761a7e078c394ff8e30e1659d74f898f:
  Merge branch 'bonding-ns-validation-fixes'
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

