Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4127B463DE9
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245519AbhK3SlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:41:07 -0500
Received: from mga14.intel.com ([192.55.52.115]:38253 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245518AbhK3SlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 13:41:06 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="236522182"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="236522182"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 10:37:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="512318065"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 30 Nov 2021 10:37:39 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AUIbcaF013253;
        Tue, 30 Nov 2021 18:37:38 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Cristian Dumitrescu <cristian.dumitrescu@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] i40e: remove dead stores on XSK hotpath
Date:   Tue, 30 Nov 2021 19:36:48 +0100
Message-Id: <20211130183649.1166842-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'if (ntu == rx_ring->count)' block in i40e_alloc_rx_buffers_zc()
was previously residing in the loop, but after introducing the
batched interface it is used only to wrap-around the NTU descriptor,
thus no more need to assign 'xdp'.

'cleaned_count' in i40e_clean_rx_irq_zc() was previously being
incremented in the loop, but after commit f12738b6ec06
("i40e: remove unnecessary cleaned_count updates") it gets
assigned only once after it, so the initialization can be dropped.

Fixes: 6aab0bb0c5cd ("i40e: Use the xsk batched rx allocation interface")
Fixes: f12738b6ec06 ("i40e: remove unnecessary cleaned_count updates")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index ea06e957393e..f08d19b8c554 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -218,7 +218,6 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 	ntu += nb_buffs;
 	if (ntu == rx_ring->count) {
 		rx_desc = I40E_RX_DESC(rx_ring, 0);
-		xdp = i40e_rx_bi(rx_ring, 0);
 		ntu = 0;
 	}
 
@@ -324,11 +323,11 @@ static void i40e_handle_xdp_result_zc(struct i40e_ring *rx_ring,
 int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
-	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
 	u16 next_to_clean = rx_ring->next_to_clean;
 	u16 count_mask = rx_ring->count - 1;
 	unsigned int xdp_res, xdp_xmit = 0;
 	bool failure = false;
+	u16 cleaned_count;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union i40e_rx_desc *rx_desc;
-- 
2.33.1

