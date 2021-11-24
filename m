Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EAF45CAF6
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242931AbhKXR2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:28:50 -0500
Received: from mga07.intel.com ([134.134.136.100]:35662 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242925AbhKXR2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="298734824"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="298734824"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 09:18:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="597738899"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 24 Nov 2021 09:18:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 07/12] iavf: Enable setting RSS hash key
Date:   Wed, 24 Nov 2021 09:16:47 -0800
Message-Id: <20211124171652.831184-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver support for changing the RSS hash key exists, however, checks
have caused it to be reported as unsupported. Remove the check and
allow the hash key to be specified.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index d327f576136f..ddb3f9f1c58e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1885,7 +1885,7 @@ static int iavf_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
  * @key: hash key
  * @hfunc: hash function to use
  *
- * Returns -EINVAL if the table specifies an inavlid queue id, otherwise
+ * Returns -EINVAL if the table specifies an invalid queue id, otherwise
  * returns 0 after programming the table.
  **/
 static int iavf_set_rxfh(struct net_device *netdev, const u32 *indir,
@@ -1894,19 +1894,21 @@ static int iavf_set_rxfh(struct net_device *netdev, const u32 *indir,
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	u16 i;
 
-	/* We do not allow change in unsupported parameters */
-	if (key ||
-	    (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP))
+	/* Only support toeplitz hash function */
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
 		return -EOPNOTSUPP;
-	if (!indir)
+
+	if (!key && !indir)
 		return 0;
 
 	if (key)
 		memcpy(adapter->rss_key, key, adapter->rss_key_size);
 
-	/* Each 32 bits pointed by 'indir' is stored with a lut entry */
-	for (i = 0; i < adapter->rss_lut_size; i++)
-		adapter->rss_lut[i] = (u8)(indir[i]);
+	if (indir) {
+		/* Each 32 bits pointed by 'indir' is stored with a lut entry */
+		for (i = 0; i < adapter->rss_lut_size; i++)
+			adapter->rss_lut[i] = (u8)(indir[i]);
+	}
 
 	return iavf_config_rss(adapter);
 }
-- 
2.31.1

