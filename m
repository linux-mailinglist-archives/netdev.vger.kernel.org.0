Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DA949E667
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243008AbiA0Pma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:42:30 -0500
Received: from mga17.intel.com ([192.55.52.151]:43816 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243056AbiA0Pma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 10:42:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643298150; x=1674834150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VhBiY0AQNvqJyz4dJgtw1Vhd+czfgEBT2l/7YPY4AvU=;
  b=Dtdb8iy4lJeHa1wpJjoI0HrEOGjanJxnVh0/ga+AV3Kfiz4DAD1b8wXW
   +Qvym+pa0wD0Jud2rEOZnFKKNSMmXdYwfOqMpMQ6JPlvBXR7NL5mGqLyy
   lTpf4Lg84u5th9jSjl0nKEe74e/vyqZDaufpwY/XIpagWPIYbV7Zd2LAW
   NzJrkoTotLtuHVhl7IXRGWy+6bxva4sLERXJiytHlIEQ/4QJgsGVIE4Hd
   tSSbV0Lb5+/p7xxtuI7zWgaCC6ypnPtFW8/iZD2G+M6kyGaemYqFCXlB0
   EzOOCsXhgvryQ3F+HwXzSWEUBz/+JqdXjR+yeSfpol/nBShpA6h55pbyQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="227561000"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="227561000"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 07:41:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="597866305"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jan 2022 07:41:48 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RFfjOp028674;
        Thu, 27 Jan 2022 15:41:47 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 2/4] ice: switch: unobscurify bitops loop in ice_fill_adv_dummy_packet()
Date:   Thu, 27 Jan 2022 16:40:07 +0100
Message-Id: <20220127154009.623304-3-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127154009.623304-1-alexandr.lobakin@intel.com>
References: <20220127154009.623304-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A loop performing header modification according to the provided mask
in ice_fill_adv_dummy_packet() is very cryptic (and error-prone).
Replace two identical cast-deferences with a variable. Replace three
struct-member-array-accesses with a variable. Invert the condition,
reduce the indentation by one -> eliminate line wraps.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 7f7e929e73a8..b6b6e8f5d358 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5266,13 +5266,15 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		 * indicated by the mask to make sure we don't improperly write
 		 * over any significant packet data.
 		 */
-		for (j = 0; j < len / sizeof(u16); j++)
-			if (lkups[i].m_raw[j])
-				((u16 *)(pkt + offset))[j] =
-					(((u16 *)(pkt + offset))[j] &
-					 ~lkups[i].m_raw[j]) |
-					(lkups[i].h_raw[j] &
-					 lkups[i].m_raw[j]);
+		for (j = 0; j < len / sizeof(u16); j++) {
+			u16 *ptr = (u16 *)(pkt + offset);
+			u16 mask = lkups[i].m_raw[j];
+
+			if (!mask)
+				continue;
+
+			ptr[j] = (ptr[j] & ~mask) | (lkups[i].h_raw[j] & mask);
+		}
 	}
 
 	s_rule->pdata.lkup_tx_rx.hdr_len = cpu_to_le16(pkt_len);
-- 
2.34.1

