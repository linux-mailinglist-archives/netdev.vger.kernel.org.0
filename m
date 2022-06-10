Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDED546914
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbiFJPJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiFJPJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:09:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408C7128151;
        Fri, 10 Jun 2022 08:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654873783; x=1686409783;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1sjojXLKRkOQYqRODIfczVGIGb1NA9KdQeLyE8+D+4k=;
  b=gVr69klBfLkwhp//vAmc/uL6mA8oWzhFSsdhT2rwOskXeMdjcWNnhyYf
   y1bL2r7gI1roW/KxR9cd6cq0PoOEknc0YE9psUBYANoxm2dv+FTm21RsT
   kaix6fjdmn5ctOch1I/K7uVv4vk0e8uOKekXa+1VTiDVmCQIHxPevxk+J
   lFnj0vUim16Eb2nX0uJ0NBGc/Fo3mFd1mnGg53NZL9riCBmXvH7jem541
   dqNsW96+Hqgfw9ZbEe2F0Jk1vMZnQyVEAyJ3tE5BORMbFNr7yOfwgjOd8
   7RlXlzGfdxANdfIBwPRgocxgmwro3SmAl9mPmKXrswIyrHnSjd4mWH4MF
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="278788413"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="278788413"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 08:09:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638176162"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 10 Jun 2022 08:09:40 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 00/10] AF_XDP ZC selftests
Date:   Fri, 10 Jun 2022 17:09:13 +0200
Message-Id: <20220610150923.583202-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set makes it possible to test ice driver with test suite that
xdpxceiver provides. In order to do it, device needs to be turned on to
loopback mode, so in first patch knob is introduced that allows user to
toggle loopback mode. Furthermore, ethtool's loopback test is fixed for
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

[0]: https://lore.kernel.org/bpf/20220425153745.481322-1-maciej.fijalkowski@intel.com/
[1]: https://lore.kernel.org/bpf/20220607142200.576735-1-maciej.fijalkowski@intel.com/

Thank you.


Maciej Fijalkowski (10):
  ice: introduce priv-flag for toggling loopback mode
  ice: check DD bit on Rx descriptor rather than (EOP | RS)
  ice: do not setup vlan for loopback VSI
  selftests: xsk: query for native XDP support
  selftests: xsk: add missing close() on netns fd
  selftests: xsk: introduce default Rx pkt stream
  selftests: xsk: add support for executing tests on physical device
  selftests: xsk: rely on pkts_in_flight in wait_for_tx_completion()
  selftests: xsk: remove struct xsk_socket_info::outstanding_tx
  selftests: xsk: add support for zero copy testing

 drivers/net/ethernet/intel/ice/ice.h         |   1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  19 +-
 drivers/net/ethernet/intel/ice/ice_main.c    |   8 +-
 tools/testing/selftests/bpf/test_xsk.sh      |  52 ++-
 tools/testing/selftests/bpf/xdpxceiver.c     | 404 +++++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h     |  10 +-
 6 files changed, 352 insertions(+), 142 deletions(-)

-- 
2.27.0

