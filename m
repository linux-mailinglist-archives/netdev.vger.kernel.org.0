Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802914794CD
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240664AbhLQTcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:32:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:11893 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236806AbhLQTcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639769537; x=1671305537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+06WBHU9Dii7ShSfMT92XaLwM4dNa8THGohMSOQH8+8=;
  b=F6820CTys8xFRNZ6Ntf6GdB471g3u7SIlLjl7yVg6gXhHD+xDIf/JAVs
   GuPTbeueI/wohmXat80B9OVNlclf6Xn1aNFvBoD1tc1mA5G9TiIy80tMq
   fZJD4BYW7oIu4f+I1jy0+eyqANBN10QrJWywXfI25eVqLkgch1B72cCEB
   zlRozu3pPxmpHiJfSENlRrFsTNHhLglIGL1XPHZSCvrmDcH6TIB6fb8mH
   0Qdmz2+BN1nCF5aebQldEIiyjxkF/KMihxfgxiRx76RjXqdwX9GcQT/SX
   ifxXrTKQdhZ0eC6f1hbSVeBrpg0tFiSA4crDMSUtDiiuU1RWtNBtUIts8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="263998128"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="263998128"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 11:32:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="754659453"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 17 Dec 2021 11:32:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 3/6] ice: remove dead store on XSK hotpath
Date:   Fri, 17 Dec 2021 11:31:11 -0800
Message-Id: <20211217193114.392106-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
References: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

The 'if (ntu == rx_ring->count)' block in ice_alloc_rx_buffers_zc()
was previously residing in the loop, but after introducing the
batched interface it is used only to wrap-around the NTU descriptor,
thus no more need to assign 'xdp'.

Fixes: db804cfc21e9 ("ice: Use the xsk batched rx allocation interface")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index c124229d98fe..27f5f64dcbd6 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -397,7 +397,6 @@ bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 	ntu += nb_buffs;
 	if (ntu == rx_ring->count) {
 		rx_desc = ICE_RX_DESC(rx_ring, 0);
-		xdp = rx_ring->xdp_buf;
 		ntu = 0;
 	}
 
-- 
2.31.1

