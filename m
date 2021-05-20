Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A142038B5D1
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhETSQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:16:53 -0400
Received: from mga17.intel.com ([192.55.52.151]:9099 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhETSQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 14:16:52 -0400
IronPort-SDR: 2fhplkfuILLWQxTbJ4Ki2EMRCCAHveX1gzf25WU352ZWd9YDQM+zEyxD8kCsbu61iQgwptFevY
 wdoNfK0PYysQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="181579449"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="181579449"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 11:15:30 -0700
IronPort-SDR: mx5HubYFzThS6LAh3L/B6N52IAaEiJhbJBj+mjMGm2Nr0M0ViarzBEvTD4YGyBAIcYDS6fQaQk
 sNoiQUq4X3Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440670726"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 20 May 2021 11:15:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, jithu.joseph@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Subject: [PATCH net-next v2 0/9][pull request] 1GbE Intel Wired LAN Driver Updates 2021-05-20
Date:   Thu, 20 May 2021 11:17:35 -0700
Message-Id: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Andre Guedes says:

This series adds AF_XDP zero-copy feature to igc driver.

The initial patches do some code refactoring, preparing the code base to
land the AF_XDP zero-copy feature, avoiding code duplications. The last
patches of the series are the ones implementing the feature.

The last patch which indeed implements AF_XDP zero-copy support was
originally way too lengthy so, for the sake of code review, I broke it
up into two patches: one adding support for the RX functionality and the
other one adding TX support.
---
v2:
Patch 8/9 - "igc: Enable RX via AF_XDP zero-copy"
 * In XDP_PASS flow, copy metadata too into the skb.
 * When HW timestamp is added by the NIC, after copying it into
   a local variable, update xdp_buff->data_meta so that
   metadata length when XDP program is called 0.
 * In igc_xdp_enable_pool(), call xsk_pool_dma_unmap() on
   failure.

Known issues:
 When an XDP application is running in Tx-Only mode with Zero-Copy
 enabled, it is not expected to add the frames to the fill-queue. I have
 noticed the following two issues in this scenario:
 - If XDP_USE_NEED_WAKEUP flag is not set by application, igc_poll()
   will go into infinite loop because the buffer allocation resulting
   in igc_clean_rx_irq_zc() indicating that all work is not done and NAPI
   should keep polling. This does not occur if XDP_USE_NEED_WAKEUP
   flag is set.
 - Since there are no buffers allocated by userspace for the fill
   queue, there is no memory allocated for the NIC to copy the data
   to. If the packet received is destined to the hardware queue where
   XDP application is running, no packets are received even on other
   queues.
 Both these issues can be mitigated by adding a few frames to the
 fill queue. The second issue can also be mitigated by making sure no
 packets are being received on the hardware queue where Rx is running.

The following are changes since commit a49e72b3bda73d36664a084e47da9727a31b8095:
  net: qrtr: ns: Fix error return code in qrtr_ns_init()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Andre Guedes (9):
  igc: Move igc_xdp_is_enabled()
  igc: Refactor __igc_xdp_run_prog()
  igc: Refactor igc_clean_rx_ring()
  igc: Refactor XDP rxq info registration
  igc: Introduce TX/RX stats helpers
  igc: Introduce igc_unmap_tx_buffer() helper
  igc: Replace IGC_TX_FLAGS_XDP flag by an enum
  igc: Enable RX via AF_XDP zero-copy
  igc: Enable TX via AF_XDP zero-copy

 drivers/net/ethernet/intel/igc/igc.h      |  33 +-
 drivers/net/ethernet/intel/igc/igc_base.h |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c | 656 ++++++++++++++++++----
 drivers/net/ethernet/intel/igc/igc_xdp.c  | 109 +++-
 drivers/net/ethernet/intel/igc/igc_xdp.h  |   8 +-
 5 files changed, 681 insertions(+), 127 deletions(-)

-- 
2.26.2

