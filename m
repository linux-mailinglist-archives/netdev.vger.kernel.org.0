Return-Path: <netdev+bounces-9347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F5072892A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41CA5281788
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342462D26B;
	Thu,  8 Jun 2023 20:05:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2101717740;
	Thu,  8 Jun 2023 20:05:58 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C877270B;
	Thu,  8 Jun 2023 13:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686254757; x=1717790757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+KCiaCinoS1ukgSFpmB7Jhh5XDvQB2xIiZwCaCxjqSQ=;
  b=Yj01cCrhxb5Y7cYFrXRTFUXhHH0225sRLO7vjt2JGJYiigUl9Bvoo5w1
   RUAgvYIiQDhQAqxhpLe0VEWu++BoBSWTZiXwNLqVp27+W3C3jeqFGtQkZ
   miNcYMWvbiyn4A3YnPqbh7EsZi9cTy2WMmCUzDC2rksME314LhF1jwykZ
   q1OIKFlkf7Rsy1zluQ4SlCkzHQvdq6vAWV4BdWr7EqRfvV9th5/UQRQj4
   Yp7PNn883erNCdUEWD1C5AE+10ddwWeoHdv/x0mIa4P7EqYdEPOhaPXPM
   /SYFNgnHVF2YFXizjzokkp2I5z0cJptUBTVeWICPpXheaiHU1H7BKRPkQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385770923"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385770923"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 13:05:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="687486363"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="687486363"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 08 Jun 2023 13:05:35 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Kamil Maziarz <kamil.maziarz@intel.com>,
	anthony.l.nguyen@intel.com,
	maciej.fijalkowski@intel.com,
	magnus.karlsson@intel.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net 2/2] ice: Fix XDP memory leak when NIC is brought up and down
Date: Thu,  8 Jun 2023 13:00:51 -0700
Message-Id: <20230608200051.451752-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230608200051.451752-1-anthony.l.nguyen@intel.com>
References: <20230608200051.451752-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Kamil Maziarz <kamil.maziarz@intel.com>

Fix the buffer leak that occurs while switching
the port up and down with traffic and XDP by
checking for an active XDP program and freeing all empty TX buffers.

Fixes: efc2214b6047 ("ice: Add support for XDP")
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a1f7c8edc22f..03513d4871ab 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -7056,6 +7056,10 @@ int ice_down(struct ice_vsi *vsi)
 	ice_for_each_txq(vsi, i)
 		ice_clean_tx_ring(vsi->tx_rings[i]);
 
+	if (ice_is_xdp_ena_vsi(vsi))
+		ice_for_each_xdp_txq(vsi, i)
+			ice_clean_tx_ring(vsi->xdp_rings[i]);
+
 	ice_for_each_rxq(vsi, i)
 		ice_clean_rx_ring(vsi->rx_rings[i]);
 
-- 
2.38.1


