Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E692F513AE3
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350433AbiD1Ra3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244981AbiD1Ra2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:30:28 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8576D39B9B
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651166833; x=1682702833;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AY63Fp9s2bVTQ7UNIpfklc7t7Jkme4QAWCT8q17gvzQ=;
  b=RSSYYbwcyuSHIZ214dt3wbzohg3RSXwJyiAVKC1vAC9HSEpuVJVyt+ma
   ZskcnFoNs/FqCUw2MJx78Q2D9Krv9XKBCtDT1Q/duJ/ZQJ3OqGYjL9+i+
   7Aeiju1yp9D3KwvXsPYv4sAjFBPEHxCBOtVOOBRu5BY8uYB9g8U0cmzTv
   yvDvLIjmCJoE7NzOTddnpOhJv/j8w0cN5cSz9jjPzmOsSrGI1RTbJFyQz
   y9OcoT0Yxsi9K16lZGGpnN8xMZZel4llXWISRkDKxAbHOd1KPMgCglNmg
   NMxexrhI6dy1x4RBedaWNKYphjoRhktrFH39UxcPC0F1W92jWdL34EHsN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329306351"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="329306351"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:27:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="581497022"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 10:27:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/11][pull request] 100GbE Intel Wired LAN Driver Updates 2022-04-28
Date:   Thu, 28 Apr 2022 10:24:19 -0700
Message-Id: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Amritha adds support for classid based queue forwarding.

Wan Jiabing converts an open coded min selection to min_t().

Maciej commonizes on a single find VSI function and removes the
duplicated implementation.

Wojciech adjusts the return value when exceeding ICE_MAX_CHAIN_WORDS to,
a more appropriate, -ENOSPC and allows for the error to be propagated.

Michal adds support for ndo_get_devlink_port().

Jake does some cleanup related to virtualization code. Mainly involving
function header comments and wording changes. NULL checks are added to
ice_get_vf_vsi() calls in order to prevent static analysis tools from
complaining that a NULL value could be dereferenced.

The following are changes since commit f3412b3879b4f7c4313b186b03940d4791345534:
  net: make sure net_rx_action() calls skb_defer_free_flush()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Amritha Nambiar (1):
  ice: Add support for classid based queue selection

Jacob Keller (6):
  ice: add newline to dev_dbg in ice_vf_fdir_dump_info
  ice: always check VF VSI pointer values
  ice: remove return value comment for ice_reset_all_vfs
  ice: fix wording in comment for ice_reset_vf
  ice: add a function comment for ice_cfg_mac_antispoof
  ice: remove period on argument description in ice_for_each_vf

Maciej Fijalkowski (1):
  ice: introduce common helper for retrieving VSI by vsi_num

Michal Swiatkowski (1):
  ice: get switch id on switchdev devices

Wan Jiabing (1):
  ice: use min_t() to make code cleaner in ice_gnss

Wojciech Drewek (1):
  ice: return ENOSPC when exceeding ICE_MAX_CHAIN_WORDS

 drivers/net/ethernet/intel/ice/ice.h          |  30 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  27 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c     |   3 +-
 drivers/net/ethernet/intel/ice/ice_idc.c      |  15 -
 drivers/net/ethernet/intel/ice/ice_main.c     |  17 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |   7 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c    |  32 ++-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   5 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 272 ++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  40 ++-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  43 ++-
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   4 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  27 +-
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |   9 +-
 14 files changed, 410 insertions(+), 121 deletions(-)

-- 
2.31.1

