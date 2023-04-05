Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DAF6D7679
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbjDEIKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237380AbjDEIKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:10:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C83B4EE6
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680682231; x=1712218231;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l+8w5wd3T3I/vZI33MZXnQsrnjIvslbsitaWlrcMdkU=;
  b=WakMH9joVC20jSRLVN6bMWuNEFV8soUGMDeT58q8/J9Ed/RikA3AAPB6
   sV8eyfA3cIAdtMCTD4YyUjFfG0i5xrQWvon8DrwPLESkzI3SMx4npB9uI
   AkfdpnEhEXPnjCWS1B/VDDAXVglwRXWQsIUKAlz4gne5zhTAmY0WWC+NN
   +CKGMUxzOW5exMde9kQ9PZnN9uYMNF1NbkQ8rMNIEg/Y1MWGDvFuqbHls
   Ug7mJ8OD/cMahHG1mSPoPy5omDRt0jmkGwK6EhQMN7wfi0KH6RSIDH/KT
   en1bF+Nn5VlaRyr64AGvfmHqqJdh0amVPhBKmKV26IgWrmTZFOD1vRjvc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="428681484"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="428681484"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:10:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="775961330"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="775961330"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2023 01:10:04 -0700
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, wojciech.drewek@intel.com,
        piotr.raczynski@intel.com, pmenzel@molgen.mpg.de,
        aleksander.lobakin@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v3 0/5] ice: allow matching on meta data
Date:   Wed,  5 Apr 2023 09:51:08 +0200
Message-Id: <20230405075113.455662-1-michal.swiatkowski@linux.intel.com>
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

v2 --> v3: based on Alexander Lobakin comments; link [1]
 * add patch 4 to get rid of anonymous struct initialization
 * few code style changes
 * rename ice_is_rule_info_the_same() and add const params in it
 * avoid holes in ice_adv_rule_info {}

v1 --> v2: link [2]
 * fix spell issues
 * use GENMASK to define source VSI mask

[1] https://lore.kernel.org/netdev/20230404072833.3676891-1-michal.swiatkowski@linux.intel.com/
[2] https://lore.kernel.org/netdev/20230331105747.89612-1-michal.swiatkowski@linux.intel.com/

Michal Swiatkowski (5):
  ice: define meta data to match in switch
  ice: remove redundant Rx field from rule info
  ice: allow matching on meta data
  ice: specify field names in ice_prot_ext init
  ice: use src VSI instead of src MAC in slow-path

 drivers/net/ethernet/intel/ice/ice_eswitch.c  |  84 ++-----
 drivers/net/ethernet/intel/ice/ice_eswitch.h  |  14 --
 .../ethernet/intel/ice/ice_protocol_type.h    | 197 ++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  17 --
 drivers/net/ethernet/intel/ice/ice_repr.h     |   5 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 231 ++++++++----------
 drivers/net/ethernet/intel/ice/ice_switch.h   |  13 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  34 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |   3 -
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |   8 -
 .../net/ethernet/intel/ice/ice_vlan_mode.c    |   2 +-
 12 files changed, 350 insertions(+), 259 deletions(-)

-- 
2.39.2

