Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63AF6DB131
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjDGRLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjDGRLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:11:03 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36FBA5D5
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 10:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680887459; x=1712423459;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+IXhH56OTcDrSCGEz9GXnnpL4E0FkATToH9bEY3nt1Q=;
  b=fU2Q57uRJJfmF8ql7t1YfXX/sJA304QlBqrcrfBaXr+oFysS5p/MgH/c
   /T1nQ5FqMCIp0UPbUU8N+OHsYppoAjL2AWQure1km31qi4q31zs5bpyFt
   WFHD277Gd4rZn9oBPGQRTxscTyxqye6Oj2RbzB+ov9B97gWgPiDbSaBPz
   p/CA8hdaqdAFFraTKidTraYsAvxN1Ce5r7QD6+uUwebtwk5NTPAuvRYX9
   sTcYsXsy1UVJNQeAp2qKFsoWob5U74GSKeo/0yR+gqT3vgSg3z0pLrp6o
   uuGPZEihGXPen/xa60nwhqR7akD7dNcZLbYnzyz0cSuWA1gi0wWFlAulR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="344805694"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="344805694"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 10:10:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="687569913"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="687569913"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga002.jf.intel.com with ESMTP; 07 Apr 2023 10:10:57 -0700
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, wojciech.drewek@intel.com,
        piotr.raczynski@intel.com, pmenzel@molgen.mpg.de,
        aleksander.lobakin@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v4 0/5] ice: allow matching on meta data
Date:   Fri,  7 Apr 2023 18:52:14 +0200
Message-Id: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

v3 --> v4: also based on Alexander comments; link [3]
 * hole in ice_adv_rule_info {}, but logically segregate
 * fix cosmetic tabs vs space etc.

v2 --> v3: based on Alexander Lobakin comments; link [2]
 * add patch 4 to get rid of anonymous struct initialization
 * few code style changes
 * rename ice_is_rule_info_the_same() and add const params in it
 * avoid holes in ice_adv_rule_info {}

v1 --> v2: link [1]
 * fix spell issues
 * use GENMASK to define source VSI mask

[1] https://lore.kernel.org/netdev/20230331105747.89612-1-michal.swiatkowski@linux.intel.com/
[2] https://lore.kernel.org/netdev/20230404072833.3676891-1-michal.swiatkowski@linux.intel.com/
[3] https://lore.kernel.org/netdev/20230405075113.455662-1-michal.swiatkowski@linux.intel.com/ 
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
2.39.2

