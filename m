Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724F9607160
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 09:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJUHrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 03:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJUHrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 03:47:36 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505CA247E1F
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 00:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666338455; x=1697874455;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kU1Id6G7a8/JzQoOyE/W4Dvo+eXevjaDf2HkULyhCMk=;
  b=VUvqwSDJFjnj03mnvKgWt/oquZ1SEEmdWS7mIzKvVqVxw4/CenCCubBO
   ml4ndRefnl9RgYA3zFNo8XBpUjpvqhDqsC1zP2qwt9QmH1284rBz9I02z
   0K84Zih/36vvC9sfbF5jV3K0taeL7TNi4LGGOoqYg12ce7Dp6NqC76dG2
   h+uzud3rOy8jBq7QdqsfmoBcqQNpNR4REBPTkvjmosz6LP5pA0qWHadC4
   VRbdWZOzRgX19rm5/R/8ekNFqS5tsnltekVlBJBBM76FL3gA0ud7xSnd8
   MZkLgxRpXXRKkGAAuzi0Awno7SFMNpo2tgNCRAlieahyWdM78fAodcXq7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="294338976"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="294338976"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 00:47:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="661459992"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="661459992"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by orsmga008.jf.intel.com with ESMTP; 21 Oct 2022 00:47:34 -0700
Subject: [net-next PATCH v3 0/3] Extend action skbedit to RX queue mapping
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.duyck@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Fri, 21 Oct 2022 00:58:34 -0700
Message-ID: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the discussion on
https://lore.kernel.org/netdev/166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com/ ,
the following series extends skbedit tc action to RX queue mapping.
Currently, skbedit action in tc allows overriding of transmit queue.
Extending this ability of skedit action supports the selection of
receive queue for incoming packets. On the receive side, this action
is supported only in hardware, so the skip_sw flag is enforced.

Enabled ice driver to offload this type of filter into the hardware
for accepting packets to the device's receive queue.

v3: Enforced skip_sw so that the action skbedit RX queue mapping is
    hardware only

---

Amritha Nambiar (3):
      act_skbedit: skbedit queue mapping for receive queue
      ice: Enable RX queue selection using skbedit action
      Documentation: networking: TC queue based filtering


 Documentation/networking/index.rst            |    1 
 Documentation/networking/tc-queue-filters.rst |   37 +++
 drivers/net/ethernet/intel/ice/ice.h          |   15 +
 drivers/net/ethernet/intel/ice/ice_main.c     |    2 
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  351 ++++++++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   40 ++-
 include/net/act_api.h                         |    1 
 include/net/flow_offload.h                    |    2 
 include/net/tc_act/tc_skbedit.h               |   29 ++
 net/sched/act_skbedit.c                       |   14 +
 net/sched/cls_api.c                           |    7 
 11 files changed, 388 insertions(+), 111 deletions(-)
 create mode 100644 Documentation/networking/tc-queue-filters.rst

--
