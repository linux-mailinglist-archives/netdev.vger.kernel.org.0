Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10EA2D7BDB
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404033AbgLKRB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:01:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:8167 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733303AbgLKRAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 12:00:38 -0500
IronPort-SDR: nwOGbi911HwOIsgxAWO4TiSSi/T0oMhzNHN65ZtxTAK4esWMpUTGHkjbsi8kvhMBrJ99BL3XB5
 BgXGcQDyuJAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9832"; a="236055108"
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="236055108"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 08:59:39 -0800
IronPort-SDR: kolrRO/+t/o240sVCQuBRLulyexz4pJ2qsPdvIkzdqDwY58Ies47JC+mHzwocFfilv+rAApcCw
 muUk7R2GHQMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="365497579"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 11 Dec 2020 08:59:38 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net-next 7/8] ice: skip NULL check against XDP prog in ZC path
Date:   Fri, 11 Dec 2020 17:49:55 +0100
Message-Id: <20201211164956.59628-8-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
References: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whole zero-copy variant of clean Rx irq is executed when xsk_pool is
attached to rx_ring and it can happen only when XDP program is present
on interface. Therefore it is safe to assume that program is always
!NULL and there is no need for checking it in ice_run_xdp_zc.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 797886524054..9aea97ca4a04 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -514,11 +514,10 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 	u32 act;
 
 	rcu_read_lock();
+	/* ZC patch is enabled only when XDP program is set,
+	 * so here it can not be NULL
+	 */
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
-	if (!xdp_prog) {
-		rcu_read_unlock();
-		return ICE_XDP_PASS;
-	}
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
-- 
2.20.1

