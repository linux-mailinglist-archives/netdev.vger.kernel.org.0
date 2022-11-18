Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3F6630006
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiKRWZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiKRWYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:24:48 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492B23E090
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668810287; x=1700346287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pFZ8WDEtCUwGNNJdmqW8Isf0dOPyO2vHOlqfZVk6I7Y=;
  b=fENf+7nxE+IdWS9IOlFi9zTMWVVQ6TyRJy/ElgmRHXwjrkgM+qgwmsgr
   wdkG0Xu45683Y3gfNB5pN7h1uLwgOxrDjNw26pXgeanv19BbqzBENuldU
   ZCaNkrP2yMCA+yWLoMHup4kl1jwignz//DkhQIgKfEVGSvPqgic2HMCZ2
   dWX/gsTjG6vR/qRp0He9YKxCHM+POL6XCJr2AxGgEwsmkvlrOi5OoZ+R2
   URvpYVsrum2XufIQNH0i1L0TGF6DGmlC6W7vHMDptR6r6Tc1aZfi4C0qj
   YQ+ztJr5aaRTm1ZmHlFSPGtmsylKtmcOdE3IBYO3n8J4THcIEni67PMt+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="375394913"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="375394913"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 14:24:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="634580312"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="634580312"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 18 Nov 2022 14:24:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/4] iavf: remove INITIAL_MAC_SET to allow gARP to work properly
Date:   Fri, 18 Nov 2022 14:24:38 -0800
Message-Id: <20221118222439.1565245-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221118222439.1565245-1-anthony.l.nguyen@intel.com>
References: <20221118222439.1565245-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

IAVF_FLAG_INITIAL_MAC_SET prevents waiting on iavf_is_mac_set_handled()
the first time the MAC is set. This breaks gratuitous ARP because the
MAC address has not been updated yet when the gARP packet is sent out.

Current behaviour:
$ echo 1 > /sys/class/net/ens4f0/device/sriov_numvfs
iavf 0000:88:02.0: MAC address: ee:04:19:14:ec:ea
$ ip addr add 192.168.1.1/24 dev ens4f0v0
$ ip link set dev ens4f0v0 up
$ echo 1 > /proc/sys/net/ipv4/conf/ens4f0v0/arp_notify
$ ip link set ens4f0v0 addr 00:11:22:33:44:55
07:23:41.676611 ee:04:19:14:ec:ea > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 42: Request who-has 192.168.1.1 tell 192.168.1.1, length 28

With IAVF_FLAG_INITIAL_MAC_SET removed:
$ echo 1 > /sys/class/net/ens4f0/device/sriov_numvfs
iavf 0000:88:02.0: MAC address: 3e:8a:16:a2:37:6d
$ ip addr add 192.168.1.1/24 dev ens4f0v0
$ ip link set dev ens4f0v0 up
$ echo 1 > /proc/sys/net/ipv4/conf/ens4f0v0/arp_notify
$ ip link set ens4f0v0 addr 00:11:22:33:44:55
07:28:01.836608 00:11:22:33:44:55 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 42: Request who-has 192.168.1.1 tell 192.168.1.1, length 28

Fixes: 35a2443d0910 ("iavf: Add waiting for response from PF in set mac")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      | 1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 3f6187c16424..0d1bab4ac1b0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -298,7 +298,6 @@ struct iavf_adapter {
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
 #define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
 #define IAVF_FLAG_REINIT_MSIX_NEEDED		BIT(20)
-#define IAVF_FLAG_INITIAL_MAC_SET		BIT(23)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
 	/* flags for admin queue service task */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index b66f8fa1d83b..801f5b7b8119 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1087,12 +1087,6 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
 	if (ret)
 		return ret;
 
-	/* If this is an initial set MAC during VF spawn do not wait */
-	if (adapter->flags & IAVF_FLAG_INITIAL_MAC_SET) {
-		adapter->flags &= ~IAVF_FLAG_INITIAL_MAC_SET;
-		return 0;
-	}
-
 	ret = wait_event_interruptible_timeout(adapter->vc_waitqueue,
 					       iavf_is_mac_set_handled(netdev, addr->sa_data),
 					       msecs_to_jiffies(2500));
@@ -2605,8 +2599,6 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 		ether_addr_copy(netdev->perm_addr, adapter->hw.mac.addr);
 	}
 
-	adapter->flags |= IAVF_FLAG_INITIAL_MAC_SET;
-
 	adapter->tx_desc_count = IAVF_DEFAULT_TXD;
 	adapter->rx_desc_count = IAVF_DEFAULT_RXD;
 	err = iavf_init_interrupt_scheme(adapter);
-- 
2.35.1

