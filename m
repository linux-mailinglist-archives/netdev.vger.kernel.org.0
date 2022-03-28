Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F884E994B
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243770AbiC1OXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243771AbiC1OX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:23:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474535DE7E;
        Mon, 28 Mar 2022 07:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648477307; x=1680013307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OoFsVEUCXGXFdBi4oNWjVsWEHWR+etNtYQmprISNGzM=;
  b=jZLkvI1+i3mBCJG0kov0Yg999C7jQadjElgLNZOcDsve5zzyyo4/dT6v
   EG7q2raOD+UCKXNujAvOFKunF32+qmYPlm8bhoMJJjUyWOqDrzoM8l1rv
   B6Fwq28BCDAa+cgBAN/u7XKPV8GTd5dBwDSDtnWaTHHzvqJ6syH9z87ox
   HkrLYnhu40I9O+rYeLdz2StcUFsaIhyoeMwsz1MiU+i2yXAK7QjYxnJcq
   K8Kjb2fzQUo7BSIKSLh7597aXUcugWi5GxQcEm2+29YXNVtk2rzUJFpnv
   2wFCtqR3o6f+VdSMDywyJVQXXzOVbzY7Z1sdEUwAgFi9MZFtYsEAWn8JB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="259196097"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="259196097"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 07:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="649076535"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 28 Mar 2022 07:21:45 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, bjorn@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf 3/4] ice: xsk: stop Rx processing when ntc catches ntu
Date:   Mon, 28 Mar 2022 16:21:22 +0200
Message-Id: <20220328142123.170157-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220328142123.170157-1-maciej.fijalkowski@intel.com>
References: <20220328142123.170157-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can happen with big budget values and some breakage of re-filling
descriptors as we do not clear the entry that ntu is pointing at the end
of ice_alloc_rx_bufs_zc. So if ntc is at ntu then it might be the case
that status_error0 has an old, uncleared value and ntc would go over
with processing which would result in false results.

Break Rx loop when ntc == ntu to avoid broken behavior.

Fixes: 3876ff525de7 ("ice: xsk: Handle SW XDP ring wrap and bump tail more often")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 51427cb4971a..dfbcaf08520e 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -608,6 +608,9 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		 */
 		dma_rmb();
 
+		if (unlikely(rx_ring->next_to_clean == rx_ring->next_to_use))
+			break;
+
 		xdp = *ice_xdp_buf(rx_ring, rx_ring->next_to_clean);
 
 		size = le16_to_cpu(rx_desc->wb.pkt_len) &
-- 
2.27.0

