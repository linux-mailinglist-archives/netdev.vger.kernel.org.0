Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3235B54E910
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357679AbiFPSGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355597AbiFPSGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:06:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10704EA32;
        Thu, 16 Jun 2022 11:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655402792; x=1686938792;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/doCgaA4+XHWFiF5aY5ptTbuf7V2rYnBuqnLKbBy2g8=;
  b=Mdb02Zd0tEqj2PqMkDsZq3O1rVHvSEiyMzgjXel+D4mtShLP4o8zimoP
   u8IkHDm6nL4IEIrbfvuaukmLZQiTeItgO5zjA4oShiRZE+5X6TMeck4oZ
   cQxNaIqaGIhfnLVV8qHGccj/JzSBRhnO5HyYilpFiPldyoK+PP9s0fwGi
   58at0JeOeIPAHfvtGMw3cfKP4HWLDJdm8+WCqJ4x3yy8ima5xlKSIMw1U
   2s9KvNW47ZZzNW555y1CuLgQ8BPY1buVjMYqjcRoCnWuk6roHR74V0u9w
   YUfEpD4GXClN2aU0pjRkbzZJpICrX+rzV8DtRcQFnZeI+fuPqipP0SMom
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343275897"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="343275897"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 11:06:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="641664258"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jun 2022 11:06:16 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v4 bpf-next 00/10] AF_XDP ZC selftests
Date:   Thu, 16 Jun 2022 20:05:59 +0200
Message-Id: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3->v4:
* use ice_{down,up} rather than ice_{stop,open} and check retvals
  when toggling loopback mode (Jakub)
* Remove patch that was throwing away xsk->outstanding_tx (Magnus)

v2->v3:
* split loopback patch to ice_set_features() refactor part and other
  part with actual loopback toggling support (Alexandr)
* collect more acks from Magnus

v1->v2:
* collect acks from Magnus
* drop redundant 'ret' variable in patch 4 (Magnus)
* drop redundant assignments to ifobject->xdp_flags in patch 10 (Magnus)
* use NETIF_F_LOOPBACK instead of introducing priv-flag (Alexandr)

Hi!

This set makes it possible to test ice driver with test suite that
xdpxceiver provides. In order to do it, device needs to be turned on to
loopback mode, so in first patch ice_set_features() is refactored and
then in second patch NETIF_F_LOOPBACK support is added to it.
Furthermore, ethtool's loopback test is fixed for ice (patch 3 and 4).
Besides turning device into loopback mode, I was limiting queue count to
1, so that none of the steering filters are needed.

Rest of the work is related to xdpxceiver. Currently it is assumed that
underlying device supports native XDP. It is true for veth, but might
not be for other device that might be used with xdpxceiver once this
patch set land. So, patch 4 adds a logic to find out if underlying
device supports XDP so that TEST_MODE_DRV can be used for test suite.
Patch 6 restores close() on netns fd that was removed by accident.

In patch 7, default Rx pkt stream is added so physical device testing
will be able to use shared UMEM in a way that Tx will utilize first half
of buffer space and Rx second one. Then, patch 8 adds support for running
xdpxceiver on physical devices.

Patch 9 prepares xdpxceiver to address ZC drivers that clean lazily Tx
descriptors (and therefore produce XSK descs to CQ) so that pacing
algorithm works fine.

Patch 10 finally adds new TEST_MODE_ZC for testing zero copy AF_XDP
driver support.

This work already allowed us to spot and fix two bugs in AF_XDP kernel
side ([0], [1]).

v1 is here [2].
v2 is here [3].
v3 is here [4].

[0]: https://lore.kernel.org/bpf/20220425153745.481322-1-maciej.fijalkowski@intel.com/
[1]: https://lore.kernel.org/bpf/20220607142200.576735-1-maciej.fijalkowski@intel.com/
[2]: https://lore.kernel.org/bpf/20220610150923.583202-1-maciej.fijalkowski@intel.com/
[3]: https://lore.kernel.org/bpf/20220614174749.901044-1-maciej.fijalkowski@intel.com/
[4]: https://lore.kernel.org/bpf/20220615161041.902916-1-maciej.fijalkowski@intel.com/

Thank you.


Maciej Fijalkowski (10):
  ice: compress branches in ice_set_features()
  ice: allow toggling loopback mode via ndo_set_features callback
  ice: check DD bit on Rx descriptor rather than (EOP | RS)
  ice: do not setup vlan for loopback VSI
  selftests: xsk: query for native XDP support
  selftests: xsk: add missing close() on netns fd
  selftests: xsk: introduce default Rx pkt stream
  selftests: xsk: add support for executing tests on physical device
  selftests: xsk: rely on pkts_in_flight in wait_for_tx_completion()
  selftests: xsk: add support for zero copy testing

 drivers/net/ethernet/intel/ice/ice_ethtool.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c    |  81 ++--
 tools/testing/selftests/bpf/test_xsk.sh      |  52 ++-
 tools/testing/selftests/bpf/xdpxceiver.c     | 380 ++++++++++++++-----
 tools/testing/selftests/bpf/xdpxceiver.h     |   9 +-
 5 files changed, 378 insertions(+), 146 deletions(-)

-- 
2.27.0

