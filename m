Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E514E24D2
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346563AbiCULCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346552AbiCULCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:02:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4D512B77F;
        Mon, 21 Mar 2022 04:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647860482; x=1679396482;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HZ/6PoiG7H+z+0tPIdkEquUj6/sBoIg3k6UoDOJklXk=;
  b=EZCzPtGQUxWWzYWRMfulyjWqGHB2Sp9ZDVzE+nX8D0/FrRQFYo1ZqK2F
   hK7s+Z88JS9td0ylf4hdy2u5/31Larme+nf2uh8xOvDJXEfNOuT0mMX0L
   LTY1oIItZznT39gCOkUpZNzgAJ4LZI+ofGJETUCW4TUaRbANqSpLxOUC5
   5d4UMjsynPYTqIrnx7qoU+ObM6mXavwpFYCEgaYwEhkNvLq8xOb3uN4DP
   awD4vR0jgvJ4eUI5MCHTqcXbRKlWMm/hH12hH+fcYg5RSS1qpB91gXHzf
   wK1snQlEAhztXem20zZ6X9VhIhXBQUmjLUWtklJJ2DYuRKxATFYWsOe8g
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="343952358"
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="343952358"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 04:01:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="784957665"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 21 Mar 2022 04:01:19 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22LB1HaC031880;
        Mon, 21 Mar 2022 11:01:18 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 1/5] ice: switch: add and use u16[] aliases to ice_adv_lkup_elem::{h,m}_u
Date:   Mon, 21 Mar 2022 11:59:50 +0100
Message-Id: <20220321105954.843154-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321105954.843154-1-alexandr.lobakin@intel.com>
References: <20220321105954.843154-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ice_adv_lkup_elem fields h_u and m_u are being accessed as raw u16
arrays in several places.
To reduce cast and braces burden, add permanent array-of-u16 aliases
with the same size as the `union ice_prot_hdr` itself via anonymous
unions to the actual struct declaration, and just access them
directly.

This:
 - removes the need to cast the union to u16[] and then dereference
   it each time -> reduces the horizon for potential bugs;
 - improves -Warray-bounds coverage -- the array size is now known
   at compilation time;
 - addresses cppcheck complaints.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 15 +++++++--------
 drivers/net/ethernet/intel/ice/ice_switch.h | 12 ++++++++++--
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 25b8f6f726eb..075df2474688 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5811,12 +5811,12 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		 * over any significant packet data.
 		 */
 		for (j = 0; j < len / sizeof(u16); j++)
-			if (((u16 *)&lkups[i].m_u)[j])
+			if (lkups[i].m_raw[j])
 				((u16 *)(pkt + offset))[j] =
 					(((u16 *)(pkt + offset))[j] &
-					 ~((u16 *)&lkups[i].m_u)[j]) |
-					(((u16 *)&lkups[i].h_u)[j] &
-					 ((u16 *)&lkups[i].m_u)[j]);
+					 ~lkups[i].m_raw[j]) |
+					(lkups[i].h_raw[j] &
+					 lkups[i].m_raw[j]);
 	}
 
 	s_rule->pdata.lkup_tx_rx.hdr_len = cpu_to_le16(pkt_len);
@@ -6065,11 +6065,10 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	/* get # of words we need to match */
 	word_cnt = 0;
 	for (i = 0; i < lkups_cnt; i++) {
-		u16 j, *ptr;
+		u16 j;
 
-		ptr = (u16 *)&lkups[i].m_u;
-		for (j = 0; j < sizeof(lkups->m_u) / sizeof(u16); j++)
-			if (ptr[j] != 0)
+		for (j = 0; j < ARRAY_SIZE(lkups->m_raw); j++)
+			if (lkups[i].m_raw[j])
 				word_cnt++;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index ed3d1d03befa..ecac75e71395 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -138,8 +138,16 @@ struct ice_update_recipe_lkup_idx_params {
 
 struct ice_adv_lkup_elem {
 	enum ice_protocol_type type;
-	union ice_prot_hdr h_u;	/* Header values */
-	union ice_prot_hdr m_u;	/* Mask of header values to match */
+	union {
+		union ice_prot_hdr h_u;	/* Header values */
+		/* Used to iterate over the headers */
+		u16 h_raw[sizeof(union ice_prot_hdr) / sizeof(u16)];
+	};
+	union {
+		union ice_prot_hdr m_u;	/* Mask of header values to match */
+		/* Used to iterate over header mask */
+		u16 m_raw[sizeof(union ice_prot_hdr) / sizeof(u16)];
+	};
 };
 
 struct ice_sw_act_ctrl {
-- 
2.35.1

