Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5043454CE2F
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352538AbiFOQOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352248AbiFOQNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:13:41 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105C436B4B;
        Wed, 15 Jun 2022 09:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655309592; x=1686845592;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DpoDWhR6InFPWT4fVcv6gitGhcQiMEpLNg6IgOWKp1U=;
  b=GOs424U54mUn+LY4gCyd2WjydDAgaOHRadGMgXChU60KUzeFyd+O7ydi
   5HZy7PWP/z+yyAbLHNdNlZqZbd4iRr11xDFxmCleR7pyNvWkGahtKA8Tm
   W/juWGqZZE+jPniPHYEwIWTo4zGDaeC2U3LkHT5VgYMS7zA+JZe+EB7U0
   FI8E9eMD8Xmt5CW3+MjyYxGjHASoHlVY5/u3zJqQCkttwxvmyIhJQWe9x
   m5aznFP72ThxsSG952NrxtJIGFLThoabw9yOATweVQzMC24s8HQ6xHwOO
   yAKUz3sVz1Z0la4sMevl2gKNfF5dhxr7qErDjkZYo5z8b98ASP57zsGCC
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280050103"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280050103"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 09:11:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="713005242"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 15 Jun 2022 09:10:59 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 00/11] AF_XDP ZC selftests
Date:   Wed, 15 Jun 2022 18:10:30 +0200
Message-Id: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
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

Patch 9 and 10 prepares xdpxceiver to address ZC drivers that clean
lazily Tx descriptors (and therefore produce XSK descs to CQ) so that
pacing algorithm works fine.

Patch 11 finally adds new TEST_MODE_ZC for testing zero copy AF_XDP
driver support.

This work already allowed us to spot and fix two bugs in AF_XDP kernel
side ([0], [1]).

v1 is here [2].
v2 is here [3].

[0]: https://lore.kernel.org/bpf/20220425153745.481322-1-maciej.fijalkowski@intel.com/
[1]: https://lore.kernel.org/bpf/20220607142200.576735-1-maciej.fijalkowski@intel.com/
[2]: https://lore.kernel.org/bpf/20220610150923.583202-1-maciej.fijalkowski@intel.com/
[3]: https://lore.kernel.org/bpf/20220614174749.901044-1-maciej.fijalkowski@intel.com/

Thank you.

Maciej Fijalkowski (11):
  ice: compress branches in ice_set_features()
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
 drivers/net/ethernet/intel/ice/ice_main.c    |  72 ++--
 tools/testing/selftests/bpf/test_xsk.sh      |  52 ++-
 tools/testing/selftests/bpf/xdpxceiver.c     | 400 +++++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h     |  10 +-
 5 files changed, 373 insertions(+), 163 deletions(-)

-- 
2.27.0

