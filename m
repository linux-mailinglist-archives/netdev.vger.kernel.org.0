Return-Path: <netdev+bounces-3958-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E97709D34
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 428FD281D62
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA5A125B8;
	Fri, 19 May 2023 17:04:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE9B125B5
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:04:42 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9141A8
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684515867; x=1716051867;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mUeuU0PPbggA9NHZUdnhU00A/v/mdngPk+o2nkJTv9s=;
  b=MZMaiZ99itWKnLkocPOnlvpwtKKhjxuJ4qlJ4z1Ueqa9C2+qCT/NW5ah
   bYRP1CRehx7x5Z9KB3OQOTWoqDfnGIJ01B1MR2yFsrzZ1wO4hY28MCme2
   dzS6sd+Kw+VgnzE7DURRE5T1a+yiTOpRC5D74gvQ+xOAbhoj58indmr4W
   JizZFOknrlH3/1Apl5ccFDcQo0LZ5ypDR/2Zb6oAu6RCd2+Bx5K23Fy5U
   Ah1EnegomBtONb+X7uxtFo+F9p+tBUQn1dfZjR2TswCA4ZMSHsLaE/qkY
   sm2/sZ6ilyM4lKPYBvPb2QPXocl8iA/z1t4PBAH3en3Mlz6+PjdgxcKiF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="337017653"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="337017653"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:04:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="846950274"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="846950274"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2023 10:04:13 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>,
	michal.swiatkowski@linux.intel.com,
	piotr.raczynski@intel.com,
	simon.horman@corigine.com,
	leonro@nvidia.com
Subject: [PATCH net-next 0/5][pull request] ice: allow matching on meta data
Date: Fri, 19 May 2023 10:00:13 -0700
Message-Id: <20230519170018.2820322-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Michal Swiatkowski says:

This patchset is intended to improve the usability of the switchdev
slow path. Without matching on a meta data values slow path works
based on VF's MAC addresses. It causes a problem when the VF wants
to use more than one MAC address (e.g. when it is in trusted mode).

Parse all meta data in the same place where protocol type fields are
parsed. Add description for the currently implemented meta data. It is
important to note that depending on DDP not all described meta data can
be available. Using not available meta data leads to error returned by
function which is looking for correct words in profiles read from DDP.

There is also one small improvement, remove of rx field in rule info
structure (patch 2). It is redundant.

The following are changes since commit 20d5e0ef252a151ea6585cfccf32def81a624666:
  net: arc: Make arc_emac_remove() return void
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Michal Swiatkowski (5):
  ice: define meta data to match in switch
  ice: remove redundant Rx field from rule info
  ice: specify field names in ice_prot_ext init
  ice: allow matching on meta data
  ice: use src VSI instead of src MAC in slow-path

 drivers/net/ethernet/intel/ice/ice_eswitch.c  |  84 ++-----
 drivers/net/ethernet/intel/ice/ice_eswitch.h  |  14 --
 .../ethernet/intel/ice/ice_protocol_type.h    | 197 ++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  17 --
 drivers/net/ethernet/intel/ice/ice_repr.h     |   5 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 232 ++++++++----------
 drivers/net/ethernet/intel/ice/ice_switch.h   |  13 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  34 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |   3 -
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |   8 -
 .../net/ethernet/intel/ice/ice_vlan_mode.c    |   2 +-
 12 files changed, 351 insertions(+), 259 deletions(-)

-- 
2.38.1


