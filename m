Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C0C4E24E0
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346610AbiCULDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346592AbiCULDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:03:13 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603A514FFCF;
        Mon, 21 Mar 2022 04:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647860505; x=1679396505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gw06FbtHD6oupzt/DZZYNvSPrC9S4YxANi+MQO/HMuU=;
  b=VafVnYUzlkYPbv15Z1W85fJ5XTHXRS/SNcr0GKSG8Bc/2F/6l157mNtu
   cuM5FIghvk3KemKTDzi7T+EVeR+qzCuACqfiuxfr6wLP6a70nHDTSr6Gi
   zryrsllh45oaaSfLi6X+RWMiLNDag6L3pjMJte/Tix5DIsqWbntzVsWPI
   5fy/Iyhn4OaONUm4NuSIihdiqpRmI3G2iYBrd+4QKHEvp+ai44ryYs5o7
   hwZLro8x7CWUMNnh0mMuhrGbtFX6vMKdUU7NMvZHf9XoQkxJ1a9Coqdo9
   pAil15FjPkaquUDCZ6kLizFyfM+u5qtoOvv0XI+gWHgIDUfZifrW/KwVS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="257242543"
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="257242543"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 04:01:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="582829300"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 21 Mar 2022 04:01:20 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22LB1HaD031880;
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
Subject: [PATCH v4 net-next 2/5] ice: switch: unobscurify bitops loop in ice_fill_adv_dummy_packet()
Date:   Mon, 21 Mar 2022 11:59:51 +0100
Message-Id: <20220321105954.843154-3-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321105954.843154-1-alexandr.lobakin@intel.com>
References: <20220321105954.843154-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A loop performing header modification according to the provided mask
in ice_fill_adv_dummy_packet() is very cryptic (and error-prone).
Replace two identical cast-deferences with a variable. Replace three
struct-member-array-accesses with a variable. Invert the condition,
reduce the indentation by one -> eliminate line wraps.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
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
2.35.1

