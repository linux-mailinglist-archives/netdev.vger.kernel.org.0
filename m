Return-Path: <netdev+bounces-3058-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB3F705523
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5591128159C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97AC01078A;
	Tue, 16 May 2023 17:39:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A99B8814
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:39:53 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE926582
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684258792; x=1715794792;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x44eX8e+SHx4Euu4FAoiXYtbdzYvVk2gTRqRPHzR5P0=;
  b=VTO32wEiUeTguxyRK6AKENdSQFwk4Xg8RbOb1J4vn6uczrQy11l1Swhj
   SZQv+YzKWg7EiR5R5fq84i1WJulv1mIJaJXbTFf9OhF4QTBrSTmdI8JJE
   KCazT8DeoaZoLvYkZDo/VOkc/BFnFKj/CCbk7gT81QhdsclSxBU0hvNXf
   uPO9F/sa3mE61OY49LUeWaNeThLh2r5XkxHs4RDwd9oTS3JBLIa14J4Hh
   u8tW1fZFM3n/m044CbS+Ccq/6Flj95/aLuVqd4NYH/zob/jhadHyfFuHA
   UkcEVXKsxI9Fv3SNCS7YRCK2L03ndm5nbsqKsBxxpuI3YsLB5W8VNtRk0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="379730735"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="379730735"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 10:39:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="704489412"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="704489412"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 16 May 2023 10:39:51 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>,
	leonro@nvidia.com
Subject: [PATCH net v2 0/3][pull request] Intel Wired LAN Driver Updates 2023-05-16
Date: Tue, 16 May 2023 10:36:07 -0700
Message-Id: <20230516173610.2706835-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

This series contains updates to ice and iavf drivers.

Ahmed adds setting of missed condition for statistics which caused
incorrect reporting of values for ice. For iavf, he removes a call to set
VLAN offloads during re-initialization which can cause incorrect values
to be set.

Dawid adds checks to ensure VF is ready to be reset before executing
commands that will require it to be reset on ice.
---
v2:
Patch 2
- Redo commit message

v1: https://lore.kernel.org/netdev/20230425170127.2522312-1-anthony.l.nguyen@intel.com/

The following are changes since commit 225c657945c4a6307741cb3cc89467eadcc26e9b:
  net: bcmgenet: Restore phy_stop() depending upon suspend/close
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Ahmed Zaki (2):
  ice: Fix stats after PF reset
  iavf: send VLAN offloading caps once after VFR

Dawid Wesierski (1):
  ice: Fix ice VF reset during iavf initialization

 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  5 -----
 drivers/net/ethernet/intel/ice/ice_lib.c      |  5 +++++
 drivers/net/ethernet/intel/ice/ice_sriov.c    |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 19 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  1 +
 6 files changed, 30 insertions(+), 9 deletions(-)

-- 
2.38.1


