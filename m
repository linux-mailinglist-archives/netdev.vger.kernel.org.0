Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E7E4D2570
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 02:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiCIBKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiCIBJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:09:38 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4B414CCB9
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 16:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646787142; x=1678323142;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n0dzLKkaR7hYKB0JOh/UwC/MQUW1jH/QEvRJ25S7Vec=;
  b=ibhVjldrEv9vlvGPd1+/gEFEuD9zn/KfSMVWNzlArbRO/jSuQzCgESjE
   pkLCwfcPrvjxmKdNcbSxmwSh1eSomDVWjNcluIUdSAiCKlOhWV2yXr6jh
   KNUgc13FHjCXEGjL7hAQhBzr5/mZsQHbm7I1s1xn/qGw35ItW0WNUsOqL
   Xa11ZHReIC4t2VXTdDvCCrcQoVDO92yUrbHh53pD7WEkMZ2ocas/0QFLH
   u+sdBTrgpJrV8qfjH6i807eWZhwyeKA5wMWqIEuS0MUpllAV5NX8A9lz0
   xTSJ6mbb6M+OWEhwnC+1jpF+mqcpi6eOz2r6Mslt+liHAT7CnJ2blzykA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341273480"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="341273480"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 15:44:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="537778697"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 08 Mar 2022 15:44:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/7][pull request] Intel Wired LAN Driver Updates 2022-03-08
Date:   Tue,  8 Mar 2022 15:45:06 -0800
Message-Id: <20220308234513.1089152-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf, i40e, and ice drivers.

Michal ensures netdev features are properly updated to reflect VLAN
changes received from PF and adds an additional flag for MSI-X
reinitialization as further differentiation of reinitialization
operations is needed for iavf.

Jake stops disabling of VFs due to failed virtchannel responses for
i40e and ice driver.

Dave moves MTU event notification to the service task to prevent issues
with RTNL lock for ice.

Christophe Jaillet corrects an allocation to GFP_ATOMIC instead of
GFP_KERNEL for ice.

Jedrzej fixes the value for link speed comparison which was preventing
the requested value from being set for ice.
---
v2: Correct recipients (add netdev), specifically for patch 2

Note: This will conflict when merging with net-next. Resolution:

diff --cc drivers/net/ethernet/intel/ice/ice.h
index dc42ff92dbad,3121f9b04f59..000000000000
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@@ -484,10 -481,9 +484,11 @@@ enum ice_pf_flags
        ICE_FLAG_LEGACY_RX,
        ICE_FLAG_VF_TRUE_PROMISC_ENA,
        ICE_FLAG_MDD_AUTO_RESET_VF,
 +      ICE_FLAG_VF_VLAN_PRUNING,
        ICE_FLAG_LINK_LENIENT_MODE_ENA,
        ICE_FLAG_PLUG_AUX_DEV,
+       ICE_FLAG_MTU_CHANGED,
 +      ICE_FLAG_GNSS,                  /* GNSS successfully initialized */
        ICE_PF_FLAGS_NBITS              /* must be last */
  };

The following are changes since commit e5417cbf7ab5df1632e68fe7d9e6331fc0e7dbd6:
  net: dsa: mt7530: fix incorrect test in mt753x_phylink_validate()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Christophe JAILLET (1):
  ice: Don't use GFP_KERNEL in atomic context

Dave Ertman (1):
  ice: Fix error with handling of bonding MTU

Jacob Keller (2):
  i40e: stop disabling VFs due to PF error responses
  ice: stop disabling VFs due to PF error responses

Jedrzej Jagielski (1):
  ice: Fix curr_link_speed advertised speed

Michal Maloszewski (2):
  iavf: Fix handling of vlan strip virtual channel messages
  iavf: Fix adopting new combined setting

 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  6 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 57 +++----------------
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  5 --
 drivers/net/ethernet/intel/iavf/iavf.h        |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 13 +++--
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 40 +++++++++++++
 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 31 +++++-----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 18 ------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  3 -
 11 files changed, 76 insertions(+), 101 deletions(-)

-- 
2.31.1

