Return-Path: <netdev+bounces-10759-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB2C730268
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 665B528141C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31CB6C2C3;
	Wed, 14 Jun 2023 14:53:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279E5DDCD
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:53:23 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4A6212C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686754396; x=1718290396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m+4uwLRuZN9fn+hK45LCaKkaZvlTk7MrI9TFDI/rJdM=;
  b=M0PBMVONyXNG7MIJoT9sv/MH9VOKIBLeti/A61sDs/N8WuLD5N8GjNRR
   MK/6shImFzDza6IJtpGlpzyKD55fpEf8sbjIsT0ln7xxhwxqHFGwZokhF
   YLiUFEMxO+4w3blOdrh+MNHPiMRWItWnhIix2JO6pw44VBQolSwNQ0zqM
   vf8W4/OxXwElxaGB6RozzYn0ikvtps2qoGBnx9b2IV4fg+6XacsyR5ycS
   UQN51S/4w082D+jVmxXM+spysfKQqzMbM5mQK17N0yelG0/5raD3qebs9
   DVs44hibRmWF0lzogBv0Yk8qpoENS1/iQ7clgrOr6kRWIZXm7xQ+p0G3L
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387040571"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="387040571"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 07:53:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="782114883"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="782114883"
Received: from pgardocx-mobl1.igk.intel.com ([10.237.95.41])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 07:53:13 -0700
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
Subject: [PATCH net-next v3 2/3] i40e: remove unnecessary check for old MAC == new MAC
Date: Wed, 14 Jun 2023 16:53:01 +0200
Message-Id: <20230614145302.902301-3-piotrx.gardocki@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230614145302.902301-1-piotrx.gardocki@intel.com>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The check has been moved to core. The ndo_set_mac_address callback
is not being called with new MAC address equal to the old one anymore.

Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b847bd105b16..29ad1797adce 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1788,12 +1788,6 @@ static int i40e_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	if (ether_addr_equal(netdev->dev_addr, addr->sa_data)) {
-		netdev_info(netdev, "already using mac address %pM\n",
-			    addr->sa_data);
-		return 0;
-	}
-
 	if (test_bit(__I40E_DOWN, pf->state) ||
 	    test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state))
 		return -EADDRNOTAVAIL;
-- 
2.34.1


