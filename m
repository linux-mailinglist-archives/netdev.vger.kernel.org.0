Return-Path: <netdev+bounces-7514-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2547D72083D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA8A928193D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E838B33310;
	Fri,  2 Jun 2023 17:17:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF48156CA
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:17:38 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D561A7
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685726257; x=1717262257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kq2srxQtETFn+99LUNZofGJQQphWNrHTe/KIVHRPceo=;
  b=VeuPwrUFntTAMmpNkD5crzTAL4IG3T/zQ1RgM+kV3wk5l6vlpbmwjFZp
   aIqskrBhu4cjhQlV12Zl7sA4AkFJyam2smwEIecn5vB6jMNgLdAQRisWP
   hkj21Yp+H5f+mDxU1FhK6vRTsMXDkybEwLlNcZ5D8GblgVgOIK1Ok5LFj
   XeW0j/Bbi3AZDnxZVDfLQ92jCyDuaZYL6qR6nbmZkroy0ZPHE0S8la+Ri
   s4W6sfN4Y4T9vU81Bdo3BlDae+TA7G3TvpeV6EZNdggHPSojDfuc4HN7R
   az/F+EKp+gXcpFZOodecmPtqISjXXmHp4nmYw3Xkav4H+C6Sary3NIdrS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="340549317"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="340549317"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 10:17:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="772952399"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="772952399"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 02 Jun 2023 10:17:30 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Piotr Gardocki <piotrx.gardocki@intel.com>,
	anthony.l.nguyen@intel.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net-next 1/3] iavf: add check for current MAC address in set_mac callback
Date: Fri,  2 Jun 2023 10:13:00 -0700
Message-Id: <20230602171302.745492-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Piotr Gardocki <piotrx.gardocki@intel.com>

In some cases it is possible for kernel to come with request
to change primary MAC address to the address that is actually
already set on the given interface.

If the old and new MAC addresses are equal there is no need
for going through entire routine, including AdminQ and
waitqueue.

This patch adds proper check to return fast from the function
in these cases. The same check can also be found in i40e and
ice drivers.

An example of such case is adding an interface to bonding
channel in balance-alb mode:
modprobe bonding mode=balance-alb miimon=100 max_bonds=1
ip link set bond0 up
ifenslave bond0 <eth>

Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2de4baff4c20..420aaca548a0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1088,6 +1088,12 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
+	if (ether_addr_equal(netdev->dev_addr, addr->sa_data)) {
+		netdev_dbg(netdev, "already using mac address %pM\n",
+			   addr->sa_data);
+		return 0;
+	}
+
 	ret = iavf_replace_primary_mac(adapter, addr->sa_data);
 
 	if (ret)
-- 
2.38.1


