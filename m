Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBCC3768F3
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 18:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238358AbhEGQlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 12:41:03 -0400
Received: from mga04.intel.com ([192.55.52.120]:29750 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238327AbhEGQk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 12:40:57 -0400
IronPort-SDR: h68dggd2+roXHT49THq9v+NnbTdCP2Kf+fBEMf5ri/Z+7o72m2J2W0LMgY1OW8yB0ythJc+8tK
 fNYZrlkW2zCA==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="196748698"
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="196748698"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 09:39:55 -0700
IronPort-SDR: 0p1OkJ7xRyvFUR/CAmqtVHlm8yedMkIjxNyrb4LpBO6cXB8biSAjKnYkEe2HkKWSb4tK2dbMVt
 x3CZVxFAZgvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="620267976"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2021 09:39:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jaroslaw Gawin <jaroslawx.gawin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 3/5] i40e: fix the restart auto-negotiation after FEC modified
Date:   Fri,  7 May 2021 09:41:49 -0700
Message-Id: <20210507164151.2878147-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
References: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jaroslaw Gawin <jaroslawx.gawin@intel.com>

When FEC mode was changed the link didn't know it because
the link was not reset and new parameters were not negotiated.
Set a flag 'I40E_AQ_PHY_ENABLE_ATOMIC_LINK' in 'abilities'
to restart the link and make it run with the new settings.

Fixes: 1d96340196f1 ("i40e: Add support FEC configuration for Fortville 25G")
Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 040a01400b85..53416787fb7b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1409,7 +1409,8 @@ static int i40e_set_fec_cfg(struct net_device *netdev, u8 fec_cfg)
 
 		memset(&config, 0, sizeof(config));
 		config.phy_type = abilities.phy_type;
-		config.abilities = abilities.abilities;
+		config.abilities = abilities.abilities |
+				   I40E_AQ_PHY_ENABLE_ATOMIC_LINK;
 		config.phy_type_ext = abilities.phy_type_ext;
 		config.link_speed = abilities.link_speed;
 		config.eee_capability = abilities.eee_capability;
-- 
2.26.2

