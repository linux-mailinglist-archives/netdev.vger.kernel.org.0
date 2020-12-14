Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78492D9AD8
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406508AbgLNPXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:23:48 -0500
Received: from mga17.intel.com ([192.55.52.151]:28673 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbgLNPXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 10:23:36 -0500
IronPort-SDR: SjFHRfuU22Z5gveVRPC7bBdjNIFZKH/T6rXFYof77ujkpPBJ4uPKlB4+0bd2qwjvHxdtX9mrgj
 B6GItFEhEnjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9834"; a="154531329"
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="154531329"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 07:22:55 -0800
IronPort-SDR: NkmcWa+ceThqdaP05/z8JXEvfS2EkFinu00PuzjCwJH8zWNTI711R/ftXO/8WlKUwWrdLNXP81
 u3+VMC1l3hpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="411285652"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 14 Dec 2020 07:22:54 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 net-next 1/8] i40e: drop redundant check when setting xdp prog
Date:   Mon, 14 Dec 2020 16:13:01 +0100
Message-Id: <20201214151308.15275-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201214151308.15275-1-maciej.fijalkowski@intel.com>
References: <20201214151308.15275-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Net core handles the case where netdev has no xdp prog attached and
current prog is NULL. Therefore, remove such check within
i40e_xdp_setup.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1337686bd099..5d494dd66d31 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12452,9 +12452,6 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
 	if (frame_size > vsi->rx_buf_len)
 		return -EINVAL;
 
-	if (!i40e_enabled_xdp_vsi(vsi) && !prog)
-		return 0;
-
 	/* When turning XDP on->off/off->on we reset and rebuild the rings. */
 	need_reset = (i40e_enabled_xdp_vsi(vsi) != !!prog);
 
-- 
2.20.1

