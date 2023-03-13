Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16D26B8065
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjCMSZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjCMSZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0577F02F
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731918; x=1710267918;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=18sKLdHMemKolXQFyoKNzc3XTP4ojF/6+TbWIAwdYiM=;
  b=P/KXEC5HzEIDjNP6A7s8N4vl8X/qREoRq2pmThh6AwpYFayigoF9wIWM
   +x2OMZvBR3PdK9l2XX37jlfTHHXobrzFFpJx7wP55S2kGYm85r8zC+4KH
   mGFozJQDCwAoKbV2ZQghNgO1ZAvrIey9BD+Cp5t7mC9tUwckwkOOwhPFo
   JuSGGFNVJ0J5Cvt8Hunh4aPeIVjtLvIGRmGztYnZgvEyBhL77GLxxjafG
   BCuaJqKv3l/WQVDZN2BEZ6WYw1oxNb0pSK6+wMky06hjrxFGxcNBDDS70
   FXu44tL3k7QwFDIC/u0LhltBpE7ACpEnEjVa+h/Mj6YN45wNbcfCaYcBY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772322"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772322"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:22:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767808995"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767808995"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:22:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, jacob.e.keller@intel.com
Subject: [PATCH net-next 00/14][pull request] ice: refactor mailbox overflow detection
Date:   Mon, 13 Mar 2023 11:21:09 -0700
Message-Id: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jake Keller says:

The primary motivation of this series is to cleanup and refactor the mailbox
overflow detection logic such that it will work with Scalable IOV. In
addition a few other minor cleanups are done while I was working on the
code in the area.

First, the mailbox overflow functions in ice_vf_mbx.c are refactored to
store the data per-VF as an embedded structure in struct ice_vf, rather than
stored separately as a fixed-size array which only works with Single Root
IOV. This reduces the overall memory footprint when only a handful of VFs
are used.

The overflow detection functions are also cleaned up to reduce the need for
multiple separate calls to determine when to report a VF as potentially
malicious.

Finally, the ice_is_malicious_vf function is cleaned up and moved into
ice_virtchnl.c since it is not Single Root IOV specific, and thus does not
belong in ice_sriov.c

I could probably have done this in fewer patches, but I split pieces out to
hopefully aid in reviewing the overall sequence of changes. This does cause
some additional thrash as it results in intermediate versions of the
refactor, but I think its worth it for making each step easier to
understand.

The following are changes since commit 95b744508d4d5135ae2a096ff3f0ee882bcc52b3:
  qede: remove linux/version.h and linux/compiler.h
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (14):
  ice: re-order ice_mbx_reset_snapshot function
  ice: convert ice_mbx_clear_malvf to void and use WARN
  ice: track malicious VFs in new ice_mbx_vf_info structure
  ice: move VF overflow message count into struct ice_mbx_vf_info
  ice: remove ice_mbx_deinit_snapshot
  ice: merge ice_mbx_report_malvf with ice_mbx_vf_state_handler
  ice: initialize mailbox snapshot earlier in PF init
  ice: declare ice_vc_process_vf_msg in ice_virtchnl.h
  ice: always report VF overflowing mailbox even without PF VSI
  ice: remove unnecessary &array[0] and just use array
  ice: pass mbxdata to ice_is_malicious_vf()
  ice: print message if ice_mbx_vf_state_handler returns an error
  ice: move ice_is_malicious_vf() to ice_virtchnl.c
  ice: call ice_is_malicious_vf() from ice_vc_process_vf_msg()

 drivers/net/ethernet/intel/ice/ice_main.c     |  12 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c    |  77 +-----
 drivers/net/ethernet/intel/ice/ice_sriov.h    |  15 --
 drivers/net/ethernet/intel/ice/ice_type.h     |  17 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  15 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   2 +-
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c   | 249 +++++-------------
 drivers/net/ethernet/intel/ice/ice_vf_mbx.h   |  17 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  49 +++-
 drivers/net/ethernet/intel/ice/ice_virtchnl.h |   8 +
 10 files changed, 164 insertions(+), 297 deletions(-)

-- 
2.38.1

