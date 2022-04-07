Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71DE4F854B
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243127AbiDGQyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiDGQye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:54:34 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEF21C133
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350354; x=1680886354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dPG7rEKASZKOrn/rCULjViBYadHbsrXxpKH/Rz1BF5Q=;
  b=G/F3/SUhCvROo/PkpQzRH/zbgIAQJ3RBuTBRTPsdnNdhV61EW/t19DZg
   dWI+vVrqh5Sz09DBy96Lzwnrwgq/jOmSVsbC2/Uu3Gra1d23SIYvv48XV
   SM0IlWtLmFua+1cqz33RAzikdFV3pR5TKfIvbsms00gGy9KKLkkJj/74i
   5Bfmv7+8QuAeKt9U/ghd1r9tSkqxkFB/uwV+f+SUX7+/E3ET5pa4Nnvv4
   EY10tLs6fD7JxQAZ2/BCqLC2VgaNHgwz9vMYASHLySdPHk1OLauOz41Fg
   ZuhC03XvdHB2chP+UxcHeQJVoRAxoKhQEf68iqEUx9NTPm6tJWYydGVdx
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="248908223"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="248908223"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:52:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="525003570"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 07 Apr 2022 09:52:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 2/5] ice: switch: unobscurify bitops loop in ice_fill_adv_dummy_packet()
Date:   Thu,  7 Apr 2022 09:52:44 -0700
Message-Id: <20220407165247.1817188-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220407165247.1817188-1-anthony.l.nguyen@intel.com>
References: <20220407165247.1817188-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

A loop performing header modification according to the provided mask
in ice_fill_adv_dummy_packet() is very cryptic (and error-prone).
Replace two identical cast-deferences with a variable. Replace three
struct-member-array-accesses with a variable. Invert the condition,
reduce the indentation by one -> eliminate line wraps.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 075df2474688..0936d39de70c 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5810,13 +5810,15 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
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
2.31.1

