Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048D751C9F1
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384864AbiEEUKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237607AbiEEUKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:10:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA6155488
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651781219; x=1683317219;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JtgGk7ZNnxdVL0tCp/KCxOLtpR75iTF1mdqfLm+q8Zk=;
  b=CeAoh3gdfpOaYE+4AUMACkw2HnpdnJ7ESUVuIEXsxbXXARY+4P6vLeXn
   Koc0AiiMfYF4P6pu8hNOtWQxqG6S/gpuAirxDtFq/Sd/2V3nmbLxoVYgJ
   rzpLBAb4PpyBik7EG7EhfuC6bci8zT0h5T+TPeTwCjRVe+Jx+Ho8RW51E
   d8hKDmQlwmE6s5v9I+GeRwP1KSXkzX5H6lZWjM8LnxUkt2FYlPp5RU8T7
   xnxKGF4lTu/duvjc6yh7jGwymOsyolITu1i2Ec44PPhFNx4Z8nNABjbCU
   zLv2CmdZGoklGgBT5/nzH4KOgCx7Mbu1CLzMB91WAFgo1x5MVomvIoGIM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248772026"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248772026"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 13:06:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="735111693"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 05 May 2022 13:06:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 00/10][pull request] 100GbE Intel Wired LAN Driver Updates 2022-05-05
Date:   Thu,  5 May 2022 13:03:49 -0700
Message-Id: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

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
---
v2: Dropped patch 1: "ice: Add support for classid based queue selection"

The following are changes since commit 1c1ed5a48411e1686997157c21633653fbe045c6:
  net: sparx5: Add handling of host MDB entries
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

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

 drivers/net/ethernet/intel/ice/ice.h          | 15 +++++++
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 27 +++++++++++-
 drivers/net/ethernet/intel/ice/ice_gnss.c     |  3 +-
 drivers/net/ethernet/intel/ice/ice_idc.c      | 15 -------
 drivers/net/ethernet/intel/ice/ice_main.c     | 15 +++++++
 drivers/net/ethernet/intel/ice/ice_repr.c     |  7 ++-
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 32 ++++++++++++--
 drivers/net/ethernet/intel/ice/ice_switch.c   |  5 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  1 -
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 43 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  4 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 27 +++---------
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |  9 +++-
 13 files changed, 150 insertions(+), 53 deletions(-)

-- 
2.35.1

