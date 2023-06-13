Return-Path: <netdev+bounces-10372-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F8B72E2CF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:25:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 085C41C20C74
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3A234D6F;
	Tue, 13 Jun 2023 12:24:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCA33C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:24:39 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0663210EC
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686659078; x=1718195078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aiy2x7WzA9Zv0AUyWsyvj/l73+iJBj7g8yRezUPEHv4=;
  b=hWBaGFMmw4M/9dS7lFpRskhzH/xu3zkmbJQb3TevotJfZz0ZdCSaALpW
   ftZwMd7D4MkuBbD7DNwYXIo3lRO21MECvtTiqOOjT1Etca56RP4rPITJ+
   mdrHX21swhZu3P8QhKBnc67TLQD1Es1Yv1C2pdN8vJJpF5uy+yrvyeCdp
   W5zzQpUs1uAyaIOB9oihExdmtzQKtmXv0jWjgSnUqo44ZQuhvo51wyDHg
   CrdjR97IjcxQua9QUntIsmPAtNamSQ5PloMTYoC8/g9lyaKQKHmch3RL7
   vJ+S8uVesJSE8Euaz5zXRPO7asdX5Dvgy48unsIn9SY5Hzu+AdR1EBpHg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="337951234"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="337951234"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 05:24:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="835872008"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="835872008"
Received: from pgardocx-mobl1.igk.intel.com ([10.237.95.41])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 05:24:34 -0700
From: Piotr Gardocki <piotrx.gardocki@intel.com>
To: netdev@vger.kernel.org
Cc: piotrx.gardocki@intel.com,
	intel-wired-lan@lists.osuosl.org,
	przemyslaw.kitszel@intel.com,
	michal.swiatkowski@linux.intel.com,
	pmenzel@molgen.mpg.de,
	kuba@kernel.org,
	maciej.fijalkowski@intel.com,
	anthony.l.nguyen@intel.com,
	simon.horman@corigine.com,
	aleksander.lobakin@intel.com
Subject: [PATCH net-next v2 3/3] ice: remove unnecessary check for old MAC == new MAC
Date: Tue, 13 Jun 2023 14:24:20 +0200
Message-Id: <20230613122420.855486-4-piotrx.gardocki@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230613122420.855486-1-piotrx.gardocki@intel.com>
References: <20230613122420.855486-1-piotrx.gardocki@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The check has been moved to core. The ndo_set_mac_address callback
is not being called with new MAC address equal to the old one anymore.

Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index caafb12d9cc7..f0ba896a3f46 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5624,11 +5624,6 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 	if (!is_valid_ether_addr(mac))
 		return -EADDRNOTAVAIL;
 
-	if (ether_addr_equal(netdev->dev_addr, mac)) {
-		netdev_dbg(netdev, "already using mac %pM\n", mac);
-		return 0;
-	}
-
 	if (test_bit(ICE_DOWN, pf->state) ||
 	    ice_is_reset_in_progress(pf->state)) {
 		netdev_err(netdev, "can't set mac %pM. device not ready\n",
-- 
2.34.1


