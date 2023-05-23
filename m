Return-Path: <netdev+bounces-4783-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A7170E2DA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:44:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39F711C20D65
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237182108E;
	Tue, 23 May 2023 17:44:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E9A206A8
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:44:16 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01FD185
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684863849; x=1716399849;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OdJ9I9MC4W+B5nwmw9xG42byarK1oW0+aRAMqpUVU7M=;
  b=gtF+d0wo6wBaOAYCunYDQS6vyk8XAzqGZ+SbvUDKzyxwLvpa3dajJyE3
   /BsidWMPxVTPJEXoiiIuRstC9sj8YrbbMEqVjlyT3gRQjQCZolQWzFZGt
   nxw5jc2iyrqSw0L8dRREKzS05dNW7g642v77yW4UN5TdFK0xpnLv+QCC+
   lboC+4YleKZhY6tf4ZFSIzYFjeS37CQQjpOAaeoyDK3R2iGJPdTMEbTxl
   MeZVwFFCUrCBv04sUl4cdxP5gavm6KB4ZZ1qAza0k3ptiTRFp+zWXYRtT
   gX+QtgW448/P5E9bdjftCfZs5evrBkTbwN7UTzy1f9536yYOiT20eTTWh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="419023242"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="419023242"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 10:44:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="816223426"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="816223426"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 23 May 2023 10:44:03 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>,
	michal.wilczynski@intel.com,
	lukasz.czapnik@intel.com,
	przemyslaw.kitszel@intel.com,
	jiri@resnulli.us
Subject: [PATCH net-next 0/5][pull request] ice: Support 5 layer Tx scheduler topology
Date: Tue, 23 May 2023 10:40:03 -0700
Message-Id: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Michal Wilczynski says:

For performance reasons there is a need to have support for selectable
Tx scheduler topology. Currently firmware supports only the default
9-layer and 5-layer topology. This patch series enables switch from
default to 5-layer topology, if user decides to opt-in.

The following are changes since commit b2e3406a38f0f48b1dfb81e5bb73d243ff6af179:
  octeontx2-pf: Add support for page pool
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Lukasz Czapnik (1):
  ice: Add txbalancing devlink param

Michal Wilczynski (2):
  ice: Enable switching default tx scheduler topology
  ice: Document txbalancing parameter

Raj Victor (2):
  ice: Support 5 layer topology
  ice: Adjust the VSI/Aggregator layers

 Documentation/networking/devlink/ice.rst      |  17 ++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  31 +++
 drivers/net/ethernet/intel/ice/ice_common.c   |   6 +
 drivers/net/ethernet/intel/ice/ice_ddp.c      | 200 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ddp.h      |   7 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 161 +++++++++++++-
 .../net/ethernet/intel/ice/ice_fw_update.c    |   2 +-
 .../net/ethernet/intel/ice/ice_fw_update.h    |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 105 +++++++--
 drivers/net/ethernet/intel/ice/ice_nvm.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_nvm.h      |   3 +
 drivers/net/ethernet/intel/ice/ice_sched.c    |  34 +--
 drivers/net/ethernet/intel/ice/ice_sched.h    |   3 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 14 files changed, 534 insertions(+), 41 deletions(-)

-- 
2.38.1


