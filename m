Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6C01E5884
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgE1HZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:25:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:14695 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgE1HZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:43 -0400
IronPort-SDR: 2O2Rp7GHp3R/BpoKU9O/klzCSrQnud7/aHyKOPcDgC6UpXnbR5Nn1gxM3xfhH810ykgEXNh7g3
 ghpp7cNcbfpg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:42 -0700
IronPort-SDR: ZJ0VYW9lFOS//Ia69CUu79B1M97RoKTml7GLGhhNrXG/gzEzKBdVw7VXBPyMGXRUM+jjQMGm+T
 c9AOXqbqgozg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831122"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:42 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ice: Add more Rx errors to netdev's rx_error counter
Date:   Thu, 28 May 2020 00:25:30 -0700
Message-Id: <20200528072538.1621790-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we are only including illegal_bytes and rx_crc_errors in the
PF netdev's rx_error counter. There are many more causes of Rx errors
that the device supports and reports via Ethtool. Accumulate all Rx
errors in the PF netdev's rx_error counter.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c2da3e1a2e17..93a42ff7496b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4295,7 +4295,13 @@ void ice_update_vsi_stats(struct ice_vsi *vsi)
 	if (vsi->type == ICE_VSI_PF) {
 		cur_ns->rx_crc_errors = pf->stats.crc_errors;
 		cur_ns->rx_errors = pf->stats.crc_errors +
-				    pf->stats.illegal_bytes;
+				    pf->stats.illegal_bytes +
+				    pf->stats.rx_len_errors +
+				    pf->stats.rx_undersize +
+				    pf->hw_csum_rx_error +
+				    pf->stats.rx_jabber +
+				    pf->stats.rx_fragments +
+				    pf->stats.rx_oversize;
 		cur_ns->rx_length_errors = pf->stats.rx_len_errors;
 		/* record drops from the port level */
 		cur_ns->rx_missed_errors = pf->stats.eth.rx_discards;
-- 
2.26.2

