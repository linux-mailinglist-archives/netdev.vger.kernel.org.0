Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B084CC7B3
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 22:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbiCCVP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbiCCVP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:15:26 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5136060061
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 13:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646342079; x=1677878079;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AT1juccoKnETVD0jbTzV0AyPeeUDrfnVor0RxhQAmQQ=;
  b=eYrZlCGNvvuoduGtCpsMJ2tapf6tBjyiemck8oXfn+W1gZWlRXRxZGU/
   baTWULhJ+/7yAZHqOnviP+PLGlNvxCKcLnNXOzcWDeoOX1fXgYl0bcnZ6
   MOH1hVru9ogSpznboH0b24M70h1MJyFUG3drXv9RJTqluA9E+nMvT837w
   tQvxMrXcOs4Og0a2kkBOTWkMAJAyStengpZmU59GjyE5Jq9W6BDO82aLD
   bJRQOkfLXLC8bCHn1UpkvomFvH8lhB1rsC+4aln3fs8VV4+FHQ/nu9uyG
   2WU/cWourc1jtf1jcT2NxHiHrCJ6AtwwRgc4gvpV/xGcEpxbSf3QvtTWt
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="340245696"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="340245696"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 13:14:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="640347677"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 13:14:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
Subject: [PATCH net-next 00/11][pull request] 100GbE Intel Wired LAN Driver Updates 2022-03-03
Date:   Thu,  3 Mar 2022 13:14:38 -0800
Message-Id: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob Keller says:

This series refactors the ice networking driver VF storage from a simple
static array to a hash table. It also introduces krefs and proper locking
and protection to prevent common use-after-free and concurrency issues.

There are two motivations for this work. First is to make the ice driver
more resilient by preventing a whole class of use-after-free bugs that can
occur around concurrent access to VF structures while removing VFs.

The second is to prepare the ice driver for future virtualization work to
support Scalable IOV, an alternative VF implementation compared to Single
Root IOV. The new VF implementation will allow for more dynamic VF creation
and removal, necessitating a more robust implementation for VF storage that
can't rely on the existing mechanisms to prevent concurrent access
violations.

The first few patches are cleanup and preparatory work needed to make the
conversion to the hash table safe. Following this preparatory work is a
patch to migrate the VF structures and variables to a new sub-structure for
code clarity. Next introduce new interface functions to abstract the VF
storage. Finally, the driver is actually converted to the hash table and
kref implementation.

The following are changes since commit 25bf4df4d18b4546a5821d77b5fac149a3a4961f:
  Merge branch 'ptp-ocp-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (11):
  ice: refactor unwind cleanup in eswitch mode
  ice: store VF pointer instead of VF ID
  ice: pass num_vfs to ice_set_per_vf_res()
  ice: move clear_malvf call in ice_free_vfs
  ice: move VFLR acknowledge during ice_free_vfs
  ice: remove checks in ice_vc_send_msg_to_vf
  ice: use ice_for_each_vf for iteration during removal
  ice: convert ice_for_each_vf to include VF entry iterator
  ice: factor VF variables to separate structure
  ice: introduce VF accessor functions
  ice: convert VF storage to hash table with krefs and RCU

 drivers/net/ethernet/intel/ice/ice.h          |  13 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |   4 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  | 161 ++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  20 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 203 +++--
 drivers/net/ethernet/intel/ice/ice_lib.h      |   3 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  64 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  54 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   2 +-
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  |  19 +-
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |  13 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 787 +++++++++++-------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  83 +-
 13 files changed, 872 insertions(+), 554 deletions(-)

-- 
2.31.1

