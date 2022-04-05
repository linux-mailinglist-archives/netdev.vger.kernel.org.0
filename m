Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B924F3C20
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240008AbiDEMEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380470AbiDELmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:42:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C65010C51C;
        Tue,  5 Apr 2022 04:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649156817; x=1680692817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Aolclux8i1rGH7iiut9nf4LrUExs626hnt2Qp+7Ez4=;
  b=iDO3FEUt7IsiLYwGwnNvaTiBF3GBqwR1tiSvqEEOnHqFbgmqFJ3m6Ler
   9yH2UPL+YCZBvXQkBZ9k5tBU9xLLXyx0EYuhiBn+bGmr14d61k6aj1YVf
   EM7O3Sn1PB4miAUbmCBWwz4Gk71I7vUP0mrZ/gu2xv2DTWSADfl8DrS69
   HhKBcVsUXtlcZRwBWq02+cD4o/8yNqoH4WoLTYjG5BXNELY6HRsp1skjH
   00V1paPV42FhjPUeat99tRHYf9//fQrtH+VsokB0FkIvktrNHkw7Av/4I
   02e26yGvGKfFIiBBvTMgrMctLa7lZ/BcflLB/IRUsCYNYYctPQz3jwfnB
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241307982"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241307982"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:06:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="641570837"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 04:06:55 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 06/10] ice: xsk: diversify return values from xsk_wakeup call paths
Date:   Tue,  5 Apr 2022 13:06:27 +0200
Message-Id: <20220405110631.404427-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when debugging AF_XDP workloads, one can correlate the -ENXIO
return code as the case that XSK is not in the bound state. Returning
same code from ndo_xsk_wakeup can be misleading and simply makes it
harder to follow what is going on.

Change ENXIOs in ice's ndo_xsk_wakeup() implementations to EINVALs, so
that when probing it is clear that something is wrong on the driver
side, not in the xsk_{recv,send}msg.

There is a -ENETDOWN that can happen from both kernel/driver sides
though, but I don't have a correct replacement for this on one of the
sides, so let's keep it that way.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 2439141cfa9d..272c0daf9ed3 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -929,13 +929,13 @@ ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
 		return -ENETDOWN;
 
 	if (!ice_is_xdp_ena_vsi(vsi))
-		return -ENXIO;
+		return -EINVAL;
 
 	if (queue_id >= vsi->num_txq)
-		return -ENXIO;
+		return -EINVAL;
 
 	if (!vsi->xdp_rings[queue_id]->xsk_pool)
-		return -ENXIO;
+		return -EINVAL;
 
 	ring = vsi->xdp_rings[queue_id];
 
-- 
2.33.1

