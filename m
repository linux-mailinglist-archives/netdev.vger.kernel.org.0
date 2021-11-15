Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C449451BC6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347574AbhKPAGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:06:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:18451 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353546AbhKPAEv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 19:04:51 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220768896"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="220768896"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 16:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="506163131"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 15 Nov 2021 16:00:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 07/10] iavf: validate pointers
Date:   Mon, 15 Nov 2021 15:59:31 -0800
Message-Id: <20211115235934.880882-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

In some cases, the ethtool get_rxfh handler may be called with a null
key or indir parameter. So check these pointers, or you will have a very
bad day.

Fixes: 43a3d9ba34c9 ("i40evf: Allow PF driver to configure RSS")
Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 136c801f5584..25ee0606e625 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1859,14 +1859,13 @@ static int iavf_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_TOP;
-	if (!indir)
-		return 0;
-
-	memcpy(key, adapter->rss_key, adapter->rss_key_size);
+	if (key)
+		memcpy(key, adapter->rss_key, adapter->rss_key_size);
 
-	/* Each 32 bits pointed by 'indir' is stored with a lut entry */
-	for (i = 0; i < adapter->rss_lut_size; i++)
-		indir[i] = (u32)adapter->rss_lut[i];
+	if (indir)
+		/* Each 32 bits pointed by 'indir' is stored with a lut entry */
+		for (i = 0; i < adapter->rss_lut_size; i++)
+			indir[i] = (u32)adapter->rss_lut[i];
 
 	return 0;
 }
-- 
2.31.1

