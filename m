Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D950E468B6
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfFNUQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:16:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:59942 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfFNUP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:15:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 13:15:56 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2019 13:15:56 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 10/12] i40e: remove duplicate stat calculation for tx_errors
Date:   Fri, 14 Jun 2019 13:16:08 -0700
Message-Id: <20190614201610.13566-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
References: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The tx_errors statistic was being calculated twice in
i40e_update_eth_stats.

This appears to be as of commit 201db2898f2c ("i40e: add missing VSI
statistics", 2014-03-25).

Remove the extra i40e_stat_update32 call for GLV_TEPC.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1d78db15c65a..7c43ec533385 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -636,9 +636,6 @@ void i40e_update_eth_stats(struct i40e_vsi *vsi)
 	i40e_stat_update32(hw, I40E_GLV_RUPP(stat_idx),
 			   vsi->stat_offsets_loaded,
 			   &oes->rx_unknown_protocol, &es->rx_unknown_protocol);
-	i40e_stat_update32(hw, I40E_GLV_TEPC(stat_idx),
-			   vsi->stat_offsets_loaded,
-			   &oes->tx_errors, &es->tx_errors);
 
 	i40e_stat_update48(hw, I40E_GLV_GORCH(stat_idx),
 			   I40E_GLV_GORCL(stat_idx),
-- 
2.21.0

