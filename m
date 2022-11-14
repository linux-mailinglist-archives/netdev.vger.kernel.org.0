Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190AB6280E1
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237934AbiKNNML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237924AbiKNNMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:12:08 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EEA2B1B6
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668431522; x=1699967522;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=u1XEetprpcT9DVPX1AZNlJyceve4yFTp+k+XYN2n7A8=;
  b=etOX3bn5VYhLauhK3Anlkc15wXDg3528y/9qT4nIcEoskpT5Gq+RlVdc
   34MYEZr/Xcz1DE5bdI0PrlB5Nq6UInvCOzY5N3Obh6wpUGmblO+17BSMI
   Zd5lyzjXPaNfeT/2jqlPZOgkBy5xXff6QdGmo5E6oVjrQuMG+fBTe2uR/
   /5/fZWedOU0+NMk3I57rto1MQCISIO5oQiweN6SM5t4wI8Mfl3jdTVonY
   owWpWYQB/NRZDxwmxnzYTo7M9S7TK51G9lnzQx0V0/MM30DsnLTXIru3e
   ufQyvzLwUEZaCafJ8W8AqhIsEK4aixR2hOApiAaPnb/sKqBoj7CJe6j6y
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="291679834"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="291679834"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 05:11:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616305813"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="616305813"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2022 05:11:45 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next 00/13] resource management using devlink reload
Date:   Mon, 14 Nov 2022 13:57:42 +0100
Message-Id: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the default value for number of PF vectors is number of CPUs.
Because of that there are cases when all vectors are used for PF
and user can't create more VFs. It is hard to set default number of
CPUs right for all different use cases. Instead allow user to choose
how many vectors should be used for various features. After implementing
subdevices this mechanism will be also used to set number of vectors
for subfunctions.

The idea is to set vectors for eth or VFs using devlink resource API.
New value of vectors will be used after devlink reinit. Example
commands:
$ sudo devlink resource set pci/0000:31:00.0 path msix/msix_eth size 16
$ sudo devlink dev reload pci/0000:31:00.0
After reload driver will work with 16 vectors used for eth instead of
num_cpus.

The default number of queues is implicitly derived from interrupt
vectors and can be later changed by ethtool.
To decrease queues used on eth user can decrease vectors on eth.
The result will be the same. Still user can change number of queues
using ethtool:
$ sudo ethtool -L enp24s0f0 tx 72 rx 72
but maximum queues amount is equal to amount of vectors.

Most of this patchset is about implementing driver reload mechanism.
Part of code from probe and rebuild is used to not duplicate code.
To allow this reuse probe and rebuild path are split into smaller
functions.

Patch "ice: split ice_vsi_setup into smaller functions" changes
boolean variable in function call to integer and adds define
for it. Instead of having the function called with true/false now it
can be called with readable defines ICE_VSI_FLAG_INIT or
ICE_VSI_FLAG_NO_INIT. It was suggested by Jacob Keller and probably this
mechanism will be implemented across ice driver in follow up patchset.

Patch 1 - 10	-> cleanup code to reuse most of the already
                   implemented function in reload path
Patch 11	-> implement devlink reload API
Patch 12        -> prepare interrupts reservation, make irdma see
                   changeable vectors count
Patch 13        -> changing number of vectors


Jacob Keller (1):
  ice: stop hard coding the ICE_VSI_CTRL location

Michal Kubiak (1):
  devlink, ice: add MSIX vectors as devlink resource

Michal Swiatkowski (11):
  ice: move RDMA init to ice_idc.c
  ice: alloc id for RDMA using xa_array
  ice: cleanup in VSI config/deconfig code
  ice: split ice_vsi_setup into smaller functions
  ice: split probe into smaller functions
  ice: sync netdev filters after clearing VSI
  ice: move VSI delete outside deconfig
  ice: update VSI instead of init in some case
  ice: implement devlink reinit action
  ice: introduce eswitch capable flag
  ice, irdma: prepare reservation of MSI-X to reload

 .../networking/devlink/devlink-resource.rst   |   10 +
 drivers/infiniband/hw/irdma/main.c            |    2 +-
 drivers/net/ethernet/intel/ice/ice.h          |   23 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   11 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  263 +++-
 drivers/net/ethernet/intel/ice/ice_devlink.h  |    2 +
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |    6 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |    6 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c     |    5 +
 drivers/net/ethernet/intel/ice/ice_idc.c      |   57 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  789 +++++-----
 drivers/net/ethernet/intel/ice/ice_lib.h      |    8 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 1354 ++++++++++-------
 drivers/net/ethernet/intel/ice/ice_sriov.c    |    3 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |    2 +-
 include/net/devlink.h                         |   14 +
 16 files changed, 1517 insertions(+), 1038 deletions(-)

-- 
2.36.1

