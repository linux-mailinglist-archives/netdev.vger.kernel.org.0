Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAFD6EE64A
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 19:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbjDYRE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 13:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbjDYREZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 13:04:25 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CED159D0
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 10:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682442264; x=1713978264;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TrZwHr8CaMO8IXSYK+C68ZEt0iXeR7BDe9ITDc2OzPU=;
  b=WfiVf7R2NFc87mb+sETZ8R64Uf+jf2B/GtQj+/lU780NVwnHTkexUHmp
   FN5cpnb1GCFuLDZsIrz0c7Oia5vrq2mXMU9gVFy7TmVRqgwyNxRFjvQFe
   qH5vZxSRoNMuhg1dQZjdI/IBjbkpaPheGgVgBqE0ziRMiyqSR2tpJ6fYx
   WirCikapmxhCSAE/chrH2oj7GffIpixqgvlqiqpTGZs37BlrVHK6RhCTC
   LbN0tPrAbYOk6m7bQtvpLbOmXHWpLY0ALYfyBBJQ7mt9juec0W9SAOq7w
   yondWBtutWwSeP6Qgqse81FUtEWIiMNxZEwck0LVnjx0i9RITNNyOfglF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="326436768"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="326436768"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 10:04:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="724085189"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="724085189"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga008.jf.intel.com with ESMTP; 25 Apr 2023 10:04:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2023-04-25 (ice, iavf)
Date:   Tue, 25 Apr 2023 10:01:24 -0700
Message-Id: <20230425170127.2522312-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice and iavf drivers.

Ahmed adds setting of missed condition for statistics which caused
incorrect reporting of values for ice. For iavf, he removes a call to set
VLAN offloads during re-initialization which can cause incorrect values
to be set.

Dawid adds checks to ensure VF is ready to be reset before executing
commands that will require it to be reset on ice.

The following are changes since commit 50749f2dd6854a41830996ad302aef2ffaf011d8:
  tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Ahmed Zaki (2):
  ice: Fix stats after PF reset
  iavf: send VLAN offloading caps once after VFR

Dawid Wesierski (1):
  ice: Fix ice VF reset during iavf initialization

 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  5 -----
 drivers/net/ethernet/intel/ice/ice_lib.c      |  5 +++++
 drivers/net/ethernet/intel/ice/ice_sriov.c    |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 19 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  1 +
 6 files changed, 30 insertions(+), 9 deletions(-)

-- 
2.38.1

