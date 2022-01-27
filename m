Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B2849E65A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242938AbiA0PmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:42:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:10340 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242186AbiA0PmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 10:42:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643298126; x=1674834126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QvHNkZHM+nXMWUfTV2y/6TOnJuTv1w5EQNzJgJJApNc=;
  b=GvdyPdRncpv25nhmXciBUeVbIGLQ3ZLJnpBO/5WqTKK/8XaFE+iBLs/R
   g+eGb4HFDhxMj1iU9OrHyQkyi1Gego8FRbkBzOAp1DQpXW05E1M/HB5IM
   gA+IcBnCqApXE32hbGfMlyiooIbqZvrq3Vz1fcOR+WwWlR/djou5GzY2g
   iMwYm7DYUul1F+y27YqOuMAUqasjCtyN/DR77YCDi5hWMt1DNjF1f5CM5
   jzzMt8yevmV0giXtOZgq9XE6EqEgplvo5lt3QWOLPeiYDoq/km/Q95zTa
   NBXkvXjotgYkoyZmbKsoGQJUGyJq7j8Oo4y3TLnguqSrRUzSKOvB659LZ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="333242523"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="333242523"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 07:41:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="521282146"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 27 Jan 2022 07:41:47 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RFfjOo028674;
        Thu, 27 Jan 2022 15:41:46 GMT
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
Subject: [PATCH v2 net-next 1/4] ice: switch: add and use u16[] aliases to ice_adv_lkup_elem::{h,m}_u
Date:   Thu, 27 Jan 2022 16:40:06 +0100
Message-Id: <20220127154009.623304-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127154009.623304-1-alexandr.lobakin@intel.com>
References: <20220127154009.623304-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 15 +++++++--------
 drivers/net/ethernet/intel/ice/ice_switch.h | 12 ++++++++++--
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index d98aa35c0337..7f7e929e73a8 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5267,12 +5267,12 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
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
@@ -5521,11 +5521,10 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
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
index 7b42c51a3eb0..950a66e86227 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -129,8 +129,16 @@ struct ice_update_recipe_lkup_idx_params {
 
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
2.34.1

