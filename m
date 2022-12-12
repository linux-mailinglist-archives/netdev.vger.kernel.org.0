Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B02649DFA
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbiLLLfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiLLLfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:35:05 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E3AA1B6
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670844767; x=1702380767;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/6El1mI6P4k3y3GAALHEjsvAifPyosOsYKYtmDbkPHk=;
  b=PfyzFHGC4PbfznjnDT2sSuMJ424kBGu9hqtpmqKqUdHNiK2auhuBWUzJ
   2AdapbBGMok7QWSmozizGJGYWXuA/Gj0LC0PfivobNnT8yBf2LtjBcfKS
   Lb80EXAlju0RiPWqeI7vo4tQTQ8pKkTW7UK2SuBwiN7LLR5Ksq3undv56
   Ioir/7Krmg3q8B0MyTAUS+U8DxxTuIbgEUBSJDMi8PFRWvdoUFwvPO96M
   saYsrN7FGofjTBvBfp4sYf46lwR9JIhhF/Ujcnwmwmeg2o7orbt3+D/kr
   p2xfjAsTK5+egnkNodOq68gIImvEH0NSRemyiJgkpDOsdJUc/6g3qEOBA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="317861402"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="317861402"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 03:32:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="893459654"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="893459654"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga006.fm.intel.com with ESMTP; 12 Dec 2022 03:32:43 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     alexandr.lobakin@intel.com, sridhar.samudrala@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com,
        benjamin.mikailenko@intel.com, paul.m.stillwell.jr@intel.com,
        netdev@vger.kernel.org, kuba@kernel.org, leon@kernel.org,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v1 00/10] implement devlink reload in ice
Date:   Mon, 12 Dec 2022 12:16:35 +0100
Message-Id: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is a part of changes done in patchset [0]. Resource management is
kind of controversial part, so I split it into two patchsets.

It is the first one, covering refactor and implement reload API call.
The refactor will unblock some of the patches needed by SIOV or
subfunction.

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

Previously the code was reviewed here [0].

[0] https://lore.kernel.org/netdev/Y3ckRWtAtZU1BdXm@unreal/T/#m3bb8feba0a62f9b4cd54cd94917b7e2143fc2ecd

Jacob Keller (1):
  ice: stop hard coding the ICE_VSI_CTRL location

Michal Swiatkowski (9):
  ice: move RDMA init to ice_idc.c
  ice: alloc id for RDMA using xa_array
  ice: cleanup in VSI config/deconfig code
  ice: split ice_vsi_setup into smaller functions
  ice: split probe into smaller functions
  ice: sync netdev filters after clearing VSI
  ice: move VSI delete outside deconfig
  ice: update VSI instead of init in some case
  ice: implement devlink reinit action

 drivers/net/ethernet/intel/ice/ice.h         |    6 +-
 drivers/net/ethernet/intel/ice/ice_common.c  |   11 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c |  103 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |    2 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c    |    5 +
 drivers/net/ethernet/intel/ice/ice_idc.c     |   53 +-
 drivers/net/ethernet/intel/ice/ice_lib.c     |  997 ++++++++--------
 drivers/net/ethernet/intel/ice/ice_lib.h     |    8 +-
 drivers/net/ethernet/intel/ice/ice_main.c    | 1075 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c  |    2 +-
 10 files changed, 1236 insertions(+), 1026 deletions(-)

-- 
2.36.1

