Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB126D1ED7
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 13:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjCaLQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 07:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCaLQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 07:16:06 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0499D83F1
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680261363; x=1711797363;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CAfZ1cVuv4wY0rsWo7piwDden06uFqs9+xX1wozLqPE=;
  b=bjZn8KP2w3rtVp7nUBFqoaXeA+vnZF8kLjKNekaoNk6jJX+bMJNpUv1k
   U5qOlUvYLDaKRh3a9SlbdEQLYgW2N31b1T4SMJsB0XEMg927GCYzhbyPy
   +EfutolIJt/H76ZSi1bsJGuflkFBZH85Sq6kaOGnIdJgaX6veW6uUbMlf
   6POB2xRIMlTWe9hnhk9uyZ/AhgdwPz3pVvCAfs6Ha3r8+eDIohVNNkggq
   mhpls5itnaBEG6r84FTtV3kXIKDsg1jOJdM869y+24byl/i2AgkJYPbk+
   iTlUgJyukuM3jRH97nboPvDmwgxmcGbmiNbUbc547NeAPAFKPiChfpnax
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="404145467"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="404145467"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 04:16:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="931124292"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="931124292"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga006.fm.intel.com with ESMTP; 31 Mar 2023 04:16:01 -0700
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, wojciech.drewek@intel.com,
        piotr.raczynski@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next 0/4] ice: allow matching on metadata
Date:   Fri, 31 Mar 2023 12:57:43 +0200
Message-Id: <20230331105747.89612-1-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset is intended to improve the usability of the switchdev
slow path. Without matching on a metadata values slow path works
based on VF's MAC addresses. It causes a problem when the VF wants
to use more than one MAC address (e.g. when it is in trusted mode).

Parse all metadata in the same place where protocol type fields are
parsed. Add description for the currently implemented metadata. It is
important to note that depending on DDP not all described metadata can
be available. Using not available metadata leads to error returned by
function which is looking for correct words in profiles read from DDP.

There is also one small improvement, remove of rx field in rule info
structure (patch 2). It is redundant.

Michal Swiatkowski (4):
  ice: define metadata to match in switch
  ice: remove redundant Rx field from rule info
  ice: allow matching on metadata
  ice: use src VSI instead of src MAC in slow-path

 drivers/net/ethernet/intel/ice/ice_eswitch.c  |  76 +++----
 drivers/net/ethernet/intel/ice/ice_eswitch.h  |  14 --
 .../ethernet/intel/ice/ice_protocol_type.h    | 196 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  17 --
 drivers/net/ethernet/intel/ice/ice_repr.h     |   5 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 182 +++++++---------
 drivers/net/ethernet/intel/ice/ice_switch.h   |   9 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  34 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |   3 -
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |   8 -
 .../net/ethernet/intel/ice/ice_vlan_mode.c    |   2 +-
 12 files changed, 319 insertions(+), 228 deletions(-)

-- 
2.39.2

