Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476262FA48E
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393415AbhARPYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:24:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:63478 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390548AbhARPXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 10:23:42 -0500
IronPort-SDR: izW57mRq4ByXOUaxMfphigGpJZwdk5pGOkIHuoHr5mVqkPmf0E/HezqwexTRaItM7ganAxrLkm
 UTh8APoj3j5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="165905497"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="165905497"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 07:22:56 -0800
IronPort-SDR: Wl1Ohqw2f9zjVMa9ygvPDQw5InWNl1iorcbiVyzoi9S7Sh0cHQ3bcxlrWy0n7NXxjGyQDGFnJ6
 3yWzWtndyxlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="500676300"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2021 07:22:54 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 net-next 01/11] i40e: drop redundant check when setting xdp prog
Date:   Mon, 18 Jan 2021 16:13:08 +0100
Message-Id: <20210118151318.12324-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
References: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Net core handles the case where netdev has no xdp prog attached and
current prog is NULL. Therefore, remove such check within
i40e_xdp_setup.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 521ea9df38d5..103df35c251d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12462,9 +12462,6 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
 	if (frame_size > vsi->rx_buf_len)
 		return -EINVAL;
 
-	if (!i40e_enabled_xdp_vsi(vsi) && !prog)
-		return 0;
-
 	/* When turning XDP on->off/off->on we reset and rebuild the rings. */
 	need_reset = (i40e_enabled_xdp_vsi(vsi) != !!prog);
 
-- 
2.20.1

