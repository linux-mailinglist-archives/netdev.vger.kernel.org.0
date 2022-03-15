Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C949D4D9209
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbiCOBMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiCOBMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:12:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462C744744
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647306693; x=1678842693;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oQaYDuQWO/KtPX933rC+pVhDtA3pdxeISLLd7xku9X8=;
  b=Qdxxu0qknaGjwXeiu6T7x0gYgjRgqr7Hu1LeytIR6TTpRB2NxuKrp9td
   3Nw3+Y+bw40z44tjCJet6Y+jXQLKB3NyLan7pEI24Sd1oPnTVvaPnMRUH
   cbrFeOuLSpj/NS/lL/PE/4tn3eBJP2PcOgoA4vh3txnGXy/h3twID6+v9
   uFpmM/2grFvNipQYjnuKoseJ3NlffaPGmwda01gbiqoGelYkQj2j/1HQi
   z6CHTI06HgymoLk+JlTfD7ZgzaWxll53VBX0lemJR4Ai8tDe75gy/uym6
   SgdUPVMXSdqkQQQQanRu2hzlYlUYhgpiycjPixxtzaS8RP9OASoqdqTA8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256375074"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="256375074"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:11:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="540222873"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2022 18:11:32 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
Subject: [PATCH net-next v2 00/11][pull request] 100GbE Intel Wired LAN Driver Updates 2022-03-14
Date:   Mon, 14 Mar 2022 18:11:44 -0700
Message-Id: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob Keller says:

The ice_virtchnl_pf.c file has become a single place for a lot of
virtualization functionality. This includes most of the virtchnl message
handling, integration with kernel hooks like the .ndo operations, reset
logic, and more.

We are planning in the future to implement and support Scalable IOV in the
ice driver. To do this, much (but not all) of the code in ice_virtchnl_pf.c
will want to be reused.

Rather than dump all of the Scalable IOV implementation into
ice_virtchnl_pf.c it makes sense to house it in a separate file. But that
still leaves all of the Single Root IOV code littered among more generic
logic.

The long term goal is to re-organize the code such that generic re-usable
code is split into separate files. The ice_sriov.c file would end up
containing all of the Single Root IOV implementation specific details, while
ice_vf_lib.[ch] and ice_virtchnl.[ch] contain the generic pieces.

As a first step, notice that ice_sriov.c currently does not contain much of
the SR-IOV implementation. This is housed primarily in ice_virtchnl_pf.c

The code in ice_sriov.c is really generic and relates to the VF mailbox,
including mailbox overflow detection.

Rename ice_sriov.c to ice_vf_mbx.c, and then rename ice_virtchnl_pf.c to
ice_sriov.c

A later series will finish the refactor by splitting ice_sriov.c into
multiple files, moving the generic code into ice_vf_lib.c and ice_virtchnl.c

To prepare for that series, perform some basic cleanup and other refactors
that we've accumulated during this development cycle.

This series builds on top of the recent hash table refactor work.
---
v2: Trim down series size (dropped patches 12-25)

The following are changes since commit bdd6a89de44b9e07d0b106076260d2367fe0e49a:
  nfp: flower: avoid newline at the end of message in NL_SET_ERR_MSG_MOD
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (11):
  ice: rename ice_sriov.c to ice_vf_mbx.c
  ice: rename ice_virtchnl_pf.c to ice_sriov.c
  ice: remove circular header dependencies on ice.h
  ice: convert vf->vc_ops to a const pointer
  ice: remove unused definitions from ice_sriov.h
  ice: rename ICE_MAX_VF_COUNT to avoid confusion
  ice: refactor spoofchk control code in ice_sriov.c
  ice: move ice_set_vf_port_vlan near other .ndo ops
  ice: cleanup error logging for ice_ena_vfs
  ice: log an error message when eswitch fails to configure
  ice: use ice_is_vf_trusted helper function

 drivers/net/ethernet/intel/ice/Makefile       |    4 +-
 drivers/net/ethernet/intel/ice/ice.h          |    5 +-
 drivers/net/ethernet/intel/ice/ice_arfs.h     |    3 +
 drivers/net/ethernet/intel/ice/ice_base.c     |    2 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |    4 +-
 drivers/net/ethernet/intel/ice/ice_dcb.h      |    1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |    1 +
 drivers/net/ethernet/intel/ice/ice_flow.c     |    1 +
 drivers/net/ethernet/intel/ice/ice_flow.h     |    2 +
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |    1 -
 drivers/net/ethernet/intel/ice/ice_main.c     |   17 +-
 drivers/net/ethernet/intel/ice/ice_osdep.h    |   11 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |    6 +-
 drivers/net/ethernet/intel/ice/ice_repr.h     |    1 -
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 6945 ++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_sriov.h    |  430 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
 .../intel/ice/{ice_sriov.c => ice_vf_mbx.c}   |    2 +-
 .../intel/ice/{ice_sriov.h => ice_vf_mbx.h}   |    6 +-
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  |    2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 6613 ----------------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  437 --
 drivers/net/ethernet/intel/ice/ice_xsk.h      |    1 -
 23 files changed, 6983 insertions(+), 7513 deletions(-)
 copy drivers/net/ethernet/intel/ice/{ice_sriov.c => ice_vf_mbx.c} (99%)
 copy drivers/net/ethernet/intel/ice/{ice_sriov.h => ice_vf_mbx.h} (95%)
 delete mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
 delete mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h

-- 
2.31.1

