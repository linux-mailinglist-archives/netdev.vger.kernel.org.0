Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E979A51DE6F
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444244AbiEFRsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385161AbiEFRsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:48:13 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D42A53717
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651859069; x=1683395069;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XoaL2RCgU+5mbzH1nMGLXmb8I8OS43RmiIy8DSc5X7w=;
  b=UsGQByjD5QsVHDMdj1vGHEnZsUJ5iDn4bYt4uMa1J0LryCWoOTfBiSeY
   ZwsocXXCh5mRdHy2tBm2ZD9BOmTseN9/9bf4FrxYmrWLq/PRLs1vU4ROA
   ybbbyuFO9F4A1205zIG7SzJHqfBFVTCPgzQMslbuD+LW7F6Eq/2Ma01Ry
   MMmNcbPiKeiUkMBawZrY26hqSJfOzDQmYSr30JwAj0tsaRV1Jdmq8P8/K
   kOwbq+J8GwLV/wh5hevqrQtUzkfC9jLWW8R9cOjytSJYfg7l33QEOKZRU
   VcAFpraSTQTkerjk/7zPw8tJ8Bt00QjEaQ2kraRNrDF73LBeDUdm7b5+U
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="331523429"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="331523429"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 10:44:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="891929166"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 06 May 2022 10:44:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com
Subject: [PATCH net v2 0/3][pull request] Intel Wired LAN Driver Updates 2022-05-06
Date:   Fri,  6 May 2022 10:41:26 -0700
Message-Id: <20220506174129.4976-1-anthony.l.nguyen@intel.com>
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

Ivan Vecera fixes a race with aux plug/unplug by delaying setting adev
until initialization is complete and adding locking.

Anatolii ensures VF queues are completely disabled before attempting to
reconfigure them.

Michal ensures stale Tx timestamps are cleared from hardware.
---
v2: Dropped patch 4 "ice: fix crash when writing timestamp on RX rings"
as issues were found.

The following are changes since commit c88d3908516d301972420160f5f15f936ba3ec3a:
  Merge branch 'ocelot-vcap-fixes'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Anatolii Gerasymenko (1):
  ice: clear stale Tx queue settings before configuring

Ivan Vecera (1):
  ice: Fix race during aux device (un)plugging

Michal Michalik (1):
  ice: fix PTP stale Tx timestamps cleanup

 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 25 ++++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 +
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 10 ++-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 68 ++++++++++++++-----
 5 files changed, 78 insertions(+), 28 deletions(-)

-- 
2.35.1

