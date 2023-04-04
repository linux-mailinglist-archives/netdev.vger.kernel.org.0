Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECAA6D59E9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbjDDHrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjDDHrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:47:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757D1E4B
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 00:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680594438; x=1712130438;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q8frmjS9JbaV+Gzo3nPdtGBmDzHBXz957rD4hn+IAOg=;
  b=bZv3FK5r4fsnjyOj6RwIRqC4ProKjdlhxfEdmvNyKOcaaEJzskFJDmoq
   f9rv0IqgZD3Ta3jdOnA2S+LvtDj3IO2B72YekEpv127Cg+NR9yt//t1v3
   BwrELGyYOBUt/sKDDWZfMIHCFSXRtC/fiC5juCgNdOnaO25zoT3qGWnJN
   1z40jyqmj47UdJ4Lr+P6AqAohIKw0PIrA/9UbDMKCnaCUyRvXa7/BP4/q
   ARDwJqvlINTsFlG4vp1Lb3ofpZse+ITpozN1SLBjKTOXW/Z+JVV0eDqIx
   5KJYdytbfAh1wXlHVUhdUO2axPoVhbjrO7o7y5cfA3o+QOu+2sDlGSppu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="404877586"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="404877586"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 00:47:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="797421805"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="797421805"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga002.fm.intel.com with ESMTP; 04 Apr 2023 00:47:16 -0700
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, wojciech.drewek@intel.com,
        piotr.raczynski@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v2 0/4] ice: allow matching on meta data
Date:   Tue,  4 Apr 2023 09:28:29 +0200
Message-Id: <20230404072833.3676891-1-michal.swiatkowski@linux.intel.com>
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

v1 --> v2:
 * fix spell issues
 * use GENMASK to define source VSI mask

Michal Swiatkowski (4):
  ice: define meta data to match in switch
  ice: remove redundant Rx field from rule info
  ice: allow matching on meta data
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

