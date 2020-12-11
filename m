Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C072D7BD6
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392378AbgLKRAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:00:54 -0500
Received: from mga06.intel.com ([134.134.136.31]:8167 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732702AbgLKRAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 12:00:07 -0500
IronPort-SDR: HsHFV064V2Ggu3cybjluETuT911QAEXivDWIPuO/2WZN8in6kMTpNBqQAdZ0CRMwzZ7Ftev2Xn
 a8NTKdz6e2/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9832"; a="236055073"
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="236055073"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 08:59:26 -0800
IronPort-SDR: 7nBS6JJqVrob3WIiFPaiLnRZdc8+5Qy7fveTGzAyl1FDDckP3ywkFPaJ4mVU/wA+JHcosHvKwc
 BgYQOh7mBOtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="365497503"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 11 Dec 2020 08:59:24 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net-next 1/8] i40e: drop redundant check when setting xdp prog
Date:   Fri, 11 Dec 2020 17:49:49 +0100
Message-Id: <20201211164956.59628-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
References: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
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

