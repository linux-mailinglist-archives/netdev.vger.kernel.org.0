Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B774E994D
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243773AbiC1OXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243778AbiC1OXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:23:30 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708B15E14D;
        Mon, 28 Mar 2022 07:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648477309; x=1680013309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+hjhWzDPppbU8Ig/L/sPDuJRf/NRdlhNwFafZ9gChwM=;
  b=GltF4583bh2CnFo0ozV84JWxcYB0aFFDjKHlP4tHg4QJ1EgsiCi6tIef
   Gl6/jG7Dr6x3N+hK+LqcgnClRAooSGMH7CiQ1IU57rXsOwXVwVzHDc/gw
   TtS63PYcySxoBVebHBc1oAgQu6SWvz2TvYtX1e1zosjrHoGkZuKlKolXX
   FPustujleWvl2xp2uivrzIvQhWFf1dqpiIaegDWs2xtz19MA+6jav8pza
   TM3KleQwgVqYJeSkJDkdpoN7arhkFnSG5SH+KMkkN/3GUJ6RBNJan1yM8
   QZehsqZl1Gya468V+IMAlcF+s4tBQhr9A+7S5waAbzqehhafoP/979D6F
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="259196105"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="259196105"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 07:21:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="649076548"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 28 Mar 2022 07:21:47 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, bjorn@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf 4/4] ice: xsk: fix indexing in ice_tx_xsk_pool()
Date:   Mon, 28 Mar 2022 16:21:23 +0200
Message-Id: <20220328142123.170157-5-maciej.fijalkowski@intel.com>
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

Ice driver tries to always create XDP rings array to be
num_possible_cpus() sized, regardless of user's queue count setting that
can be changed via ethtool -L for example.

Currently, ice_tx_xsk_pool() calculates the qid by decrementing the
ring->q_index by the count of XDP queues, but ring->q_index is set to 'i
+ vsi->alloc_txq'.

When user did ethtool -L $IFACE combined 1, alloc_txq is 1, but
vsi->num_xdp_txq is still num_possible_cpus(). Then, ice_tx_xsk_pool()
will do OOB access and in the final result ring would not get xsk_pool
pointer assigned. Then, each ice_xsk_wakeup() call will fail with error
and it will not be possible to get into NAPI and do the processing from
driver side.

Fix this by decrementing vsi->alloc_txq instead of vsi->num_xdp_txq from
ring-q_index in ice_tx_xsk_pool() so the calculation is reflected to the
setting of ring->q_index.

CC: Ciara Loftus <ciara.loftus@intel.com>
Fixes: 22bf877e528f ("ice: introduce XDP_TX fallback path")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b0b27bfcd7a2..d4f1874df7d0 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -710,7 +710,7 @@ static inline struct xsk_buff_pool *ice_tx_xsk_pool(struct ice_tx_ring *ring)
 	struct ice_vsi *vsi = ring->vsi;
 	u16 qid;
 
-	qid = ring->q_index - vsi->num_xdp_txq;
+	qid = ring->q_index - vsi->alloc_txq;
 
 	if (!ice_is_xdp_ena_vsi(vsi) || !test_bit(qid, vsi->af_xdp_zc_qps))
 		return NULL;
-- 
2.27.0

