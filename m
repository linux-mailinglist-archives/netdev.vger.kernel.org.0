Return-Path: <netdev+bounces-12133-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C16D7736607
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0829A1C20AED
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983DB882E;
	Tue, 20 Jun 2023 08:25:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CA646A5
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:25:04 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB06DD
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687249502; x=1718785502;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iAVElBJATHHVS8jixdg/1VEQURYFyFA0PaU7QYlOOmg=;
  b=mejPJxdPKLNdFSfQI/3rOCF5TcjASyZjKfzm3Meirjdi6gcblEn9x9FR
   CyHrXHhMZme6TaGEcp1jZiO5B2exjOtqKOfP+8AhVN1VafzA2WczRYvfb
   9I93aJZGTmJiube2cVYlh8cNnp+yDfUTtZPvSKu6wzQABt9hghxy83i40
   IBRia/Vq6XloNORrJgk3aGo53ZIzzf4Wk7DM5DKwOd3Bp04jBuL0rl+GA
   7SNcpLwJ9lkC6l8CkpoqQ2ccahSNlW1eGqZXqd+0cAk0EuhQeQW2gF5lI
   K7D7T84dPHNiH0lboDTzAZpfxyDyucVgGDTzYHzccH+S+4N5V4gle2/by
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="357287946"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="357287946"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 01:25:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="691346033"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="691346033"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 20 Jun 2023 01:25:00 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	anthony.l.nguyen@intel.com,
	magnus.karlsson@intel.com,
	michal.swiatkowski@intel.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH iwl-net] ice: add missing napi deletion
Date: Tue, 20 Jun 2023 10:24:54 +0200
Message-Id: <20230620082454.377001-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Error path from ice_probe() is missing ice_napi_del() calls, add it to
ice_deinit_eth() as ice_init_eth() was the one to add napi instances. It
is also a good habit to delete napis when removing driver and this also
addresses that. FWIW ice_napi_del() had no callsites.

Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index cd562856f23a..f6b041490154 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4485,6 +4485,7 @@ static void ice_deinit_eth(struct ice_pf *pf)
 	if (!vsi)
 		return;
 
+	ice_napi_del(vsi);
 	ice_vsi_close(vsi);
 	ice_unregister_netdev(vsi);
 	ice_devlink_destroy_pf_port(pf);
-- 
2.34.1


