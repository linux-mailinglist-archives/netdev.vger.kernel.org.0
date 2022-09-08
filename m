Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A4E5B11F6
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiIHBOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIHBOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:14:24 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7022D2A4
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 18:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662599663; x=1694135663;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+BP7cnWq2QvZCeL1ZnAjpA44usfXMOqkBqXUe3F0GA8=;
  b=aO5+Pqm4txKpsxbXoDXaaSlKqXruOxrCRvhOHIS5f51giI4lAhAiOs8n
   n2en3sq7L4WrGRts8T8lIILcdEuuSq+4T4wZgirSFIbTn9eyS3Afmz4TQ
   /AOagRVLI5EgQhIxj9M+VQCcG+qADSocYxXVXJLei1Efnvmp1JSUguhPo
   sm6sBrXF6mF+3jGDz06VOJVmgKQYKvbCPj+WgqxSTOAp0ozGqVGDdQVqd
   NBFIC4SSnCJ5iwQbsPcASFIc1creJT+53G5mJY506AyiBHc36++JzX31L
   xJvMm73Dz39HcxKJAGiA/37CORSyUeEEuyE44FYoJlzJ110f/wq3beBEH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="297036360"
X-IronPort-AV: E=Sophos;i="5.93,298,1654585200"; 
   d="scan'208";a="297036360"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 18:14:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,298,1654585200"; 
   d="scan'208";a="565743216"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by orsmga003.jf.intel.com with ESMTP; 07 Sep 2022 18:14:22 -0700
Subject: [net-next PATCH v2 0/4] Extend action skbedit to RX queue mapping
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.duyck@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Wed, 07 Sep 2022 18:23:57 -0700
Message-ID: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the discussion on
https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/,
the following series extends skbedit tc action to RX queue mapping.
Currently, skbedit action in tc allows overriding of transmit queue.
Extending this ability of skedit action supports the selection of receive
queue for incoming packets. Offloading this action is added for receive
side. Enabled ice driver to offload this type of filter into the
hardware for accepting packets to the device's receive queue.

v2: Added documentation in Documentation/networking

---

Amritha Nambiar (4):
      act_skbedit: Add support for action skbedit RX queue mapping
      act_skbedit: Offload skbedit queue mapping for receive queue
      ice: Enable RX queue selection using skbedit action
      Documentation: networking: TC queue based filtering


 Documentation/networking/tc-queue-filters.rst |   24 ++
 drivers/net/ethernet/intel/ice/ice.h          |   15 +
 drivers/net/ethernet/intel/ice/ice_main.c     |    2 
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  351 ++++++++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   40 ++-
 include/net/act_api.h                         |    1 
 include/net/flow_offload.h                    |    2 
 include/net/tc_act/tc_skbedit.h               |   11 +
 net/sched/act_skbedit.c                       |   40 ++-
 net/sched/cls_api.c                           |    7 
 10 files changed, 376 insertions(+), 117 deletions(-)
 create mode 100644 Documentation/networking/tc-queue-filters.rst

--
