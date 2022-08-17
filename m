Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16045974DB
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241035AbiHQRNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240908AbiHQRNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:13:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED249C1FB
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660756416; x=1692292416;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eZERtEVZye+lQ626jAk3XnC8LJhBt+8DGLs5BH34RfQ=;
  b=Fen5ilYc2wODTCj85MINW6k5XUZy0/iYiXhvUQSyW/AtLTM1QXwAUc85
   pToThDuglYKv0b5sLbbYJv28hbXTJ72B1G0g9JRMIDOgsaBeKzaDWC7ha
   FDJEukaw2j3Tb8SR89tS10Edb4StXAuNACQILXMAOD+tV2HqdazFIRUzI
   7+yahwhNndvHnBzcVMb6VgcEJWHIY5JAFOS/ik+/lL5Kfo9D2swKfqXsT
   uWgHZ+Vzw51ohU9mpnVZm60UVMezdFw/Ji3+dHFI05tDLj6Du1s65bUfn
   YHNSo09WwS5aPBr/fStv19I40mhW2hhrRaGzlaMkxfRyQEU70x8Blb2DN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="291307361"
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="291307361"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 10:13:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="558204976"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 17 Aug 2022 10:13:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2022-08-17 (ice)
Date:   Wed, 17 Aug 2022 10:13:24 -0700
Message-Id: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Grzegorz prevents modifications to VLAN 0 when setting VLAN promiscuous
as it will already be set. He also ignores -EEXIST error when attempting
to set promiscuous and ensures promiscuous mode is properly cleared from
the hardware when being removed.

Benjamin ignores additional -EEXIST errors when setting promiscuous mode
since the existing mode is the desired mode.

Sylwester fixes VFs to allow sending of tagged traffic when no VLAN filters
exist.

The following are changes since commit ed16d19c5f1d02908caf85c52a787de2eeeced2f:
  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Benjamin Mikailenko (1):
  ice: Ignore error message when setting same promiscuous mode

Grzegorz Siwik (3):
  ice: Fix double VLAN error when entering promisc mode
  ice: Ignore EEXIST when setting promisc mode
  ice: Fix clearing of promisc mode with bridge over bond

Sylwester Dziedziuch (1):
  ice: Fix VF not able to send tagged traffic with no VLAN filters

 drivers/net/ethernet/intel/ice/ice_fltr.c     |  8 +--
 drivers/net/ethernet/intel/ice/ice_lib.c      |  6 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 12 +++-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  9 ++-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 11 ++--
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 57 ++++++++++++++++---
 6 files changed, 85 insertions(+), 18 deletions(-)

-- 
2.35.1

