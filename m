Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8175846C8
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiG1T6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiG1T6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:58:38 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5131EAF8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659038318; x=1690574318;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JiD2zr0fmX+0LYltP/Dzi5jU5X6HVbI+iMtVWfFaLtY=;
  b=Dcd1fIuMoK9S08MCa5VrWOThrN9HfopO2mShwhM1TVSGUzIxghu6oSIo
   v5jr1ljBtMfOc7vPIbMQxqteuIFXCcH0VaCRuhi9jE133jN5KoQllfPX7
   VJfyNR73/B+vH1KPklIfwdZ3/l/xW+rqO+nWtlOYiq+Cw4dyyTDp9Jv9I
   jw98gEUMoD+J9zGKp/mmJ3I6QFAX51SG3K7CwdxBy3EW3FEFDzE/rloW6
   E6TnP+8rfeh4PLsntML7mJaPVMwbYQ7PKOPkrlurmuHRFufEgw2PGwuAv
   EM+OsYefW+Pzp/eQIwP9cGGJ4v+LOJdUkqe2LOKcm+eZC82Fx+yqvQFW8
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="350310067"
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="350310067"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 12:58:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="928453947"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jul 2022 12:58:37 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4][pull request] 100GbE Intel Wired LAN Driver Updates 2022-07-28
Date:   Thu, 28 Jul 2022 12:55:34 -0700
Message-Id: <20220728195538.3391360-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Michal allows for VF true promiscuous mode to be set for multiple VFs
and adds clearing of promiscuous filters when VF trust is removed.

Maciej refactors ice_set_features() to track/check changed features
instead of constantly checking against netdev features and adds support for
NETIF_F_LOOPBACK.

The following are changes since commit 623cd87006983935de6c2ad8e2d50e68f1b7d6e7:
  net: cdns,macb: use correct xlnx prefix for Xilinx
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Maciej Fijalkowski (2):
  ice: compress branches in ice_set_features()
  ice: allow toggling loopback mode via ndo_set_features callback

Michal Wilczynski (2):
  ice: Introduce enabling promiscuous mode on multiple VF's
  ice: Fix promiscuous mode not turning off

 drivers/net/ethernet/intel/ice/ice.h          |   2 -
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |   8 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  67 ++++-----
 drivers/net/ethernet/intel/ice/ice_lib.h      |  11 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  86 ++++++-----
 drivers/net/ethernet/intel/ice/ice_switch.c   | 136 +++++++++---------
 drivers/net/ethernet/intel/ice/ice_switch.h   |   8 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   4 -
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  89 +++++++++---
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   7 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  51 +++----
 12 files changed, 269 insertions(+), 202 deletions(-)

-- 
2.35.1

