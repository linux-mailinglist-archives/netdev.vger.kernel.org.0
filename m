Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4992A54B7EF
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245705AbiFNRsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbiFNRsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:48:04 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55722873F;
        Tue, 14 Jun 2022 10:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655228882; x=1686764882;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gh6a4XXBv1nxa3Ro2RxR5Nzg55kDamBl4BEMb7Uz6Sw=;
  b=Rn+PnjiFbuuJvQ5lCV5Z3OG1vfjJmYNa+Y3yL28Mg5pSi+bDCC0ZDyD3
   ZHIKUENWcBhonGikeK/TuIbsad33jslvlLAF8tVj7C2/zcowYBo9gCKhB
   DTv/08ZgGQ2oXQ3Oq9l2ktSgmiNfDsOJPFzkdEGH4HPmubLAtOlgxAq5k
   OVC+6NLVFl1G39OzWvL/aQidUuMo79+joQv6+aS3ao/xqDKcSGMhDLlQ8
   56pGgS02NqlDypX5GqzU7zDqK//Sp82E1W80Kr+QDMo0K8ckLzXLNTBdv
   ay3fd/VVtX4I6WgVtoEMV/Y2KS82mhpGCBmvVe9rU6LaXVZIwfRsBKnqF
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="340356761"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="340356761"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 10:47:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="570110050"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 14 Jun 2022 10:47:51 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 00/10] AF_XDP ZC selftests
Date:   Tue, 14 Jun 2022 19:47:39 +0200
Message-Id: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1->v2:
* collect acks from Magnus
* drop redundant 'ret' variable in patch 4 (Magnus)
* drop redundant assignments to ifobject->xdp_flags in patch 10 (Magnus)
* use NETIF_F_LOOPBACK instead of introducing priv-flag (Alexandr)

Hi!

This set makes it possible to test ice driver with test suite that
xdpxceiver provides. In order to do it, device needs to be turned on to
loopback mode, so in first patch NETIF_F_LOOPBACK support is added to
ice_set_features(). Furthermore, ethtool's loopback test is fixed for
ice (patch 2 and 3). Besides turning device into loopback mode, I was
limiting queue count to 1, so that none of the steering filters are
needed.

Rest of the work is related to xdpxceiver. Currently it is assumed that
underlying device supports native XDP. It is true for veth, but might
not be for other device that might be used with xdpxceiver once this
patch set land. So, patch 4 adds a logic to find out if underlying
device supports XDP so that TEST_MODE_DRV can be used for test suite.
Patch 5 restores close() on netns fd that was removed by accident.

In patch 6, default Rx pkt stream is added so physical device testing
will be able to use shared UMEM in a way that Tx will utilize first half
of buffer space and Rx second one. Then, patch 7 adds support for running
xdpxceiver on physical devices.

Patch 8 and 9 prepares xdpxceiver to address ZC drivers that clean
lazily Tx descriptors (and therefore produce XSK descs to CQ) so that
pacing algorithm works fine.

Patch 10 finally adds new TEST_MODE_ZC for testing zero copy AF_XDP
driver support.

This work already allowed us to spot and fix two bugs in AF_XDP kernel
side ([0], [1]).

v1 is here [2].

[0]: https://lore.kernel.org/bpf/20220425153745.481322-1-maciej.fijalkowski@intel.com/
[1]: https://lore.kernel.org/bpf/20220607142200.576735-1-maciej.fijalkowski@intel.com/
[2]: https://lore.kernel.org/bpf/20220610150923.583202-1-maciej.fijalkowski@intel.com/

Thank you.

Maciej Fijalkowski (10):
  ice: allow toggling loopback mode via ndo_set_features callback
  ice: check DD bit on Rx descriptor rather than (EOP | RS)
  ice: do not setup vlan for loopback VSI
  selftests: xsk: query for native XDP support
  selftests: xsk: add missing close() on netns fd
  selftests: xsk: introduce default Rx pkt stream
  selftests: xsk: add support for executing tests on physical device
  selftests: xsk: rely on pkts_in_flight in wait_for_tx_completion()
  selftests: xsk: remove struct xsk_socket_info::outstanding_tx
  selftests: xsk: add support for zero copy testing

 drivers/net/ethernet/intel/ice/ice_ethtool.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c    |  62 +--
 tools/testing/selftests/bpf/test_xsk.sh      |  52 ++-
 tools/testing/selftests/bpf/xdpxceiver.c     | 400 +++++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h     |  10 +-
 5 files changed, 364 insertions(+), 162 deletions(-)

-- 
2.27.0

