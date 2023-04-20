Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9DA6EA041
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjDTXwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbjDTXwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:52:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C7A1FF1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682034770; x=1713570770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GxvzocKJo5Tc8G60apJN510oP3ATipQNVvL1NPvMqa4=;
  b=ACitXsJdsHC/Tn82QHEAAhhJ3yPILp2ogaFvol5Y8YTWXdkULPu1rk53
   N1rY1x2lo/mAwsr9KI8Wwel8e+AuwOkeZnJlTt44wHHYI6OemB5qd5Xn6
   AU3HdyrbSQrG92l+s7cOw9Ms5I0eo1qFNux0YGg0IptA11KiaQyie0DRN
   CGpAQVzofBanJF8mv6wEeDhz1DEJwU8nHY9UxHe72EuLy2GKZA7Tm2WIO
   8z/pgX7SXwN+oXfjU978wdf2j7qIJAVDt1orFMQeaAyCfvEOnkvDfMKck
   OdRB4InTyWEU+8bzaaTbSOCSHg1oeGz4HDiDTyzyWZ4kEJuG8awLYhYKO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326203134"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326203134"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 16:52:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="803527228"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="803527228"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 20 Apr 2023 16:52:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Joe Damato <jdamato@fastly.com>, anthony.l.nguyen@intel.com,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net 2/2] ixgbe: Enable setting RSS table to default values
Date:   Thu, 20 Apr 2023 16:50:00 -0700
Message-Id: <20230420235000.2971509-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420235000.2971509-1-anthony.l.nguyen@intel.com>
References: <20230420235000.2971509-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Damato <jdamato@fastly.com>

ethtool uses `ETHTOOL_GRXRINGS` to compute how many queues are supported
by RSS. The driver should return the smaller of either:
  - The maximum number of RSS queues the device supports, OR
  - The number of RX queues configured

Prior to this change, running `ethtool -X $iface default` fails if the
number of queues configured is larger than the number supported by RSS,
even though changing the queue count correctly resets the flowhash to
use all supported queues.

Other drivers (for example, i40e) will succeed but the flow hash will
reset to support the maximum number of queues supported by RSS, even if
that amount is smaller than the configured amount.

Prior to this change:

$ sudo ethtool -L eth1 combined 20
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 20 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:      0     1     2     3     4     5     6     7
   24:      8     9    10    11    12    13    14    15
   32:      0     1     2     3     4     5     6     7
...

You can see that the flowhash was correctly set to use the maximum
number of queues supported by the driver (16).

However, asking the NIC to reset to "default" fails:

$ sudo ethtool -X eth1 default
Cannot set RX flow hash configuration: Invalid argument

After this change, the flowhash can be reset to default which will use
all of the available RSS queues (16) or the configured queue count,
whichever is smaller.

Starting with eth1 which has 10 queues and a flowhash distributing to
all 10 queues:

$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 10 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9     0     1     2     3     4     5
   16:      6     7     8     9     0     1     2     3
...

Increasing the queue count to 48 resets the flowhash to distribute to 16
queues, as it did before this patch:

$ sudo ethtool -L eth1 combined 48
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 16 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:      0     1     2     3     4     5     6     7
...

Due to the other bugfix in this series, the flowhash can be set to use
queues 0-5:

$ sudo ethtool -X eth1 equal 5
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 16 RX ring(s):
    0:      0     1     2     3     4     0     1     2
    8:      3     4     0     1     2     3     4     0
   16:      1     2     3     4     0     1     2     3
...

Due to this bugfix, the flowhash can be reset to default and use 16
queues:

$ sudo ethtool -X eth1 default
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 16 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:      0     1     2     3     4     5     6     7
...

Fixes: 91cd94bfe4f0 ("ixgbe: add basic support for setting and getting nfc controls")
Signed-off-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 821dfd323fa9..0bbad4a5cc2f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2665,6 +2665,14 @@ static int ixgbe_get_rss_hash_opts(struct ixgbe_adapter *adapter,
 	return 0;
 }
 
+static int ixgbe_rss_indir_tbl_max(struct ixgbe_adapter *adapter)
+{
+	if (adapter->hw.mac.type < ixgbe_mac_X550)
+		return 16;
+	else
+		return 64;
+}
+
 static int ixgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 			   u32 *rule_locs)
 {
@@ -2673,7 +2681,8 @@ static int ixgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
-		cmd->data = adapter->num_rx_queues;
+		cmd->data = min_t(int, adapter->num_rx_queues,
+				  ixgbe_rss_indir_tbl_max(adapter));
 		ret = 0;
 		break;
 	case ETHTOOL_GRXCLSRLCNT:
@@ -3075,14 +3084,6 @@ static int ixgbe_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 	return ret;
 }
 
-static int ixgbe_rss_indir_tbl_max(struct ixgbe_adapter *adapter)
-{
-	if (adapter->hw.mac.type < ixgbe_mac_X550)
-		return 16;
-	else
-		return 64;
-}
-
 static u32 ixgbe_get_rxfh_key_size(struct net_device *netdev)
 {
 	return IXGBE_RSS_KEY_SIZE;
-- 
2.38.1

