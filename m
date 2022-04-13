Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EAE4FFA2F
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbiDMPc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbiDMPcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:32:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7139A377F9;
        Wed, 13 Apr 2022 08:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863830; x=1681399830;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FrIvXcYBo4yxCRtYQpPhYhijL2c72GoTBP/dsSAEFjM=;
  b=dp2Ul/i/m6ZXAFDV3taAQLySjTO1LBKum1gQWiUKoxZQQwvlJUVwaZcf
   bv0Vno4ZONvyLJWYil6/hBiLoThxm5SgC2EqgWILGfR99TqEBe7uqnD+2
   u6MyiV2G3LBOEwoVtVoczgsKshKChJgc87cTLs7OzCXHQ7QS9PPVCL9dT
   BPcTR6QAw0khtLejbUOqgI2wZSKlm94HPd1PYm85Lwqzp5q+cDG2+6AdK
   ORRFGq+ka04yPBPZPX78EtUh0SrRBBb+gN/TYLVZTNa+I5uhEoF6jFHTJ
   f7bnvEE87pHEfCtAVIb81YHtZcegYVRgxo81i/Ui2A3zvo0meVQ8bp2Vy
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544149"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544149"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318168"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:26 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 00/14] xsk: stop NAPI Rx processing on full XSK RQ
Date:   Wed, 13 Apr 2022 17:30:01 +0200
Message-Id: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
- add likely for internal redirect return codes in ice and ixgbe
  (Jesper)
- do not drop the buffer that head pointed to at full XSK RQ (Maxim)
- terminate Rx loop only when need_wakeup feature is enabled (Maxim)
- reword from 'stop softirq processing' to 'stop NAPI Rx processing'
- s/ENXIO/EINVAL in mlx5 and stmmac's ndo_xsk_wakeup to keep it
  consitent with Intel's drivers (Maxim)
- include Jesper's Acks

Hi!

This is a revival of Bjorn's idea [0] to break NAPI loop when XSK Rx
queue gets full which in turn makes it impossible to keep on
successfully producing descriptors to XSK Rx ring. By breaking out of
the driver side immediately we will give the user space opportunity for
consuming descriptors from XSK Rx ring and therefore provide room in the
ring so that HW Rx -> XSK Rx redirection can be done.

Maxim asked and Jesper agreed on simplifying Bjorn's original API used
for detecting the event of interest, so let's just simply check for
-ENOBUFS within Intel's ZC drivers after an attempt to redirect a buffer
to XSK Rx. No real need for redirect API extension.

One might ask why it is still relevant even after having proper busy
poll support in place - here is the justification.

For xdpsock that was:
- run for l2fwd scenario,
- app/driver processing took place on the same core in busy poll
  with 2048 budget,
- HW ring sizes Tx 256, Rx 2048,

this work improved throughput by 78% and reduced Rx queue full statistic
bump by 99%.

For testing ice, make sure that you have [1] present on your side.

This set, besides the work described above, carries also improvements
around return codes in various XSK paths and lastly a minor optimization
for xskq_cons_has_entries(), a helper that might be used when XSK Rx
batching would make it to the kernel.

Link to v1 and discussion around it is at [2].

Thanks!
MF

[0]: https://lore.kernel.org/bpf/20200904135332.60259-1-bjorn.topel@gmail.com/
[1]: https://lore.kernel.org/netdev/20220317175727.340251-1-maciej.fijalkowski@intel.com/
[2]: https://lore.kernel.org/bpf/5864171b-1e08-1b51-026e-5f09b8945076@nvidia.com/T/

Björn Töpel (1):
  xsk: improve xdp_do_redirect() error codes

Maciej Fijalkowski (13):
  xsk: diversify return codes in xsk_rcv_check()
  ice: xsk: decorate ICE_XDP_REDIR with likely()
  ixgbe: xsk: decorate IXGBE_XDP_REDIR with likely()
  ice: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
  i40e: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
  ixgbe: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
  ice: xsk: diversify return values from xsk_wakeup call paths
  i40e: xsk: diversify return values from xsk_wakeup call paths
  ixgbe: xsk: diversify return values from xsk_wakeup call paths
  mlx5: xsk: diversify return values from xsk_wakeup call paths
  stmmac: xsk: diversify return values from xsk_wakeup call paths
  ice: xsk: avoid refilling single Rx descriptors
  xsk: drop ternary operator from xskq_cons_has_entries

 .../ethernet/intel/i40e/i40e_txrx_common.h    |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 38 ++++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 53 ++++++++++++-------
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 52 ++++++++++--------
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
 net/xdp/xsk.c                                 |  4 +-
 net/xdp/xsk_queue.h                           |  4 +-
 10 files changed, 99 insertions(+), 61 deletions(-)

-- 
2.33.1

