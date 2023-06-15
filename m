Return-Path: <netdev+bounces-11118-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF137731965
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B764281799
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6CA156DA;
	Thu, 15 Jun 2023 12:59:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1AA1FDA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:59:29 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9382704
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686833965; x=1718369965;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gcKU6ImbVvYc32brtTTMSGrZzt+11kXeKchcu8AjD5s=;
  b=ZfpSv7OJz0LP9J7ZJ2WVB8E2cnWMc/yznPm2/sJYzbUUNx5qUvNPzxjX
   AtxAT2etGMJ/lOkuH7/+qnDsYDg1mN2EJHhLgXABd6gZs0D/o+qTlM00j
   35pe5jtHmrh2Qqmt8WpM2j7Hix7LTQ8LSC7MfJgLyAWQnbCdhSLEhRfm4
   9itSiM21a7KA/RatiP7unmY2ld6TMHbbJ7a8gIdV5EVwQohg5hYtHiCXs
   CczrnOiLHqcqRLeq6frWE2bPLDBusFPrAhFZD8pH2If9Sx28tZPXNCaAq
   4cMZjnjXYhdqIR52AK4U7ifadM6a6XWWVw+Yv4vk7bC03/ebCGpx5UtF0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="424794810"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="424794810"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 05:59:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="825259716"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="825259716"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga002.fm.intel.com with ESMTP; 15 Jun 2023 05:59:23 -0700
From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	jacob.e.keller@intel.com,
	przemyslaw.kitszel@intel.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH iwl-next v1 0/4] change MSI-X vectors per VF
Date: Thu, 15 Jun 2023 14:38:26 +0200
Message-Id: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

This patchset is implementing sysfs API introduced here [1].

It will allow user to assign different amount of MSI-X vectors to VF.
For example when there are VMs with different number of virtual cores.

Example:
1. Turn off autoprobe
echo 0 > /sys/bus/pci/devices/0000\:18\:00.0/sriov_drivers_autoprobe
2. Create VFs
echo 4 > /sys/bus/pci/devices/0000\:18\:00.0/sriov_numvfs
3. Configure MSI-X
echo 20 > /sys/class/pci_bus/0000\:18/device/0000\:18\:01.0/sriov_vf_msix_count

[1] https://lore.kernel.org/netdev/20210314124256.70253-1-leon@kernel.org/

Michal Swiatkowski (4):
  ice: implement num_msix field per VF
  ice: add bitmap to track VF MSI-X usage
  ice: set MSI-X vector count on VF
  ice: manage VFs MSI-X using resource tracking

 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   2 +
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 257 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_sriov.h    |  13 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   4 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |   2 +-
 7 files changed, 258 insertions(+), 24 deletions(-)

-- 
2.40.1


