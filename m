Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCC76349D9
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbiKVWK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbiKVWKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:10:55 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB8D2035C
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669155054; x=1700691054;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bi+CDtIi0sojbZXmE4Glz/923OBzpSpMyOZ6sslmzKE=;
  b=R47wVNM4fwh1UMOdzz6iIMcYF8QRRp1SXGD4ADzzn+RMRABsdc8vZNXp
   JEretqAsUoPMUqHCC7oJmUEbJGg95nVyLulCQVJBkEmFmyiKCaP1VSeqe
   IhGrsDixy0GRb5iV8W2z9I9gmrqYqe4WUs2GixWXHJu7551b7njAM61z+
   Wd+1hFzalbhaCK4Vke2N3g/E8IQK0qIyVwangceYE27P0OTqkNEkag0ht
   HnmnXRNr3optUItuFBcHfIoAQ9cA/E1FaJThWCq/Nk1JOaKsDOcGmoxD6
   FG7hue9zKLSvaZUZuJqdSXsWiVp7+oEE3+c2Xa3RGf/JHu8LLWfC95RPf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="378182922"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="378182922"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 14:10:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="705126990"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="705126990"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 22 Nov 2022 14:10:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/7][pull request] Intel Wired LAN Driver Updates 2022-11-22 (ice)
Date:   Tue, 22 Nov 2022 14:10:40 -0800
Message-Id: <20221122221047.3095231-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
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

This series contains updates to ice driver only.

Karol adjusts check of PTP hardware to wait longer but check more often.
He also removes waiting for PTP lock when getting time values.

Brett removes use of driver defined link speed; instead using the values
from ethtool.h, utilizing static tables for indexing.

Ben adds tracking of stats in order to accumulate reported statistics that
were previously reset by hardware.

Marcin fixes issues setting RXDID when queues are asymmetric.

Anatolii re-introduces use of define over magic number; ICE_RLAN_BASE_S.
---
v2:
Patch 5
 - Convert some allocations to non-managed
 - Remove combined error checking; add error checks for each call
 - Remove excess NULL checks
 - Remove unnecessary NULL sets and newlines

The following are changes since commit 339e79dfb087075cbc27d3a902457574c4dac182:
  Merge branch 'cleanup-ocelot_stats-exposure'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anatolii Gerasymenko (1):
  ice: Use ICE_RLAN_BASE_S instead of magic number

Benjamin Mikailenko (2):
  ice: Accumulate HW and Netdev statistics over reset
  ice: Accumulate ring statistics over reset

Brett Creeley (1):
  ice: Remove and replace ice speed defines with ethtool.h versions

Karol Kolacinski (2):
  ice: Check for PTP HW lock more frequently
  ice: Remove gettime HW semaphore

Marcin Szycik (1):
  ice: Fix configuring VIRTCHNL_OP_CONFIG_VSI_QUEUES with unbalanced
    queues

 drivers/net/ethernet/intel/ice/ice.h          |   7 +
 drivers/net/ethernet/intel/ice/ice_base.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  41 ++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   3 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  12 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  12 -
 drivers/net/ethernet/intel/ice/ice_lib.c      | 272 +++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  96 +++++--
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  31 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  12 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  10 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  40 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  18 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c   |  92 ++----
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  37 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  25 +-
 18 files changed, 485 insertions(+), 228 deletions(-)

-- 
2.35.1

