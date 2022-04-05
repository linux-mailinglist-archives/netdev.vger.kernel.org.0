Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722C94F3C3F
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbiDEMGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380403AbiDELmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:42:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F0C10BBE3;
        Tue,  5 Apr 2022 04:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649156803; x=1680692803;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NNaVagVkmxZRREd0d3044ps0HWL2oB7S1hkDYwyMVAU=;
  b=BKPdKP7Ifvwupi4vkQfiNv4RpBq3STobS82n3+P1NKNviaZ1uaBmYHL3
   vtvL2YZ4kAjvL9B0tAho8XXDyQ8xKTOwTxr5Z/eOJO10gHjMMeprusO4A
   C1Xa01JfRLuWS0Vb5A6pNQdEAp8zCcGwwgQLdU/wNQG1/INzfOhIONrQf
   92+CBmJYKuzGCaQZaKrbv8w2ksn1tkDwsdb6Stw4ek3BGu+bp+1853fQC
   rM8NEbDhrJpbZhARs89oIQJpb58GCKTToUtRoEjkH8+834huFyMMlzuB8
   S/CvFm1loMKzgnMhqZ+MuC6QUYOj00/QfRLoGJobXm4WEBN2uHQ7bCoM7
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241307935"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241307935"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:06:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="641570791"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 04:06:40 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 00/10] xsk: stop softirq processing on full XSK Rx queue
Date:   Tue,  5 Apr 2022 13:06:21 +0200
Message-Id: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
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

This set, besides the work described above, also carries also
improvements around return codes in various XSK paths and lastly a minor
optimization for xskq_cons_has_entries(), a helper that might be used
when XSK Rx batching would make it to the kernel.

Thanks!
MF

[0]: https://lore.kernel.org/bpf/20200904135332.60259-1-bjorn.topel@gmail.com/
[1]: https://lore.kernel.org/netdev/20220317175727.340251-1-maciej.fijalkowski@intel.com/

Björn Töpel (1):
  xsk: improve xdp_do_redirect() error codes

Maciej Fijalkowski (9):
  xsk: diversify return codes in xsk_rcv_check()
  ice: xsk: terminate NAPI when XSK Rx queue gets full
  i40e: xsk: terminate NAPI when XSK Rx queue gets full
  ixgbe: xsk: terminate NAPI when XSK Rx queue gets full
  ice: xsk: diversify return values from xsk_wakeup call paths
  i40e: xsk: diversify return values from xsk_wakeup call paths
  ixgbe: xsk: diversify return values from xsk_wakeup call paths
  ice: xsk: avoid refilling single Rx descriptors
  xsk: drop ternary operator from xskq_cons_has_entries

 .../ethernet/intel/i40e/i40e_txrx_common.h    |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 27 +++++++++------
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 34 ++++++++++++-------
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 29 ++++++++++------
 net/xdp/xsk.c                                 |  4 +--
 net/xdp/xsk_queue.h                           |  4 +--
 8 files changed, 64 insertions(+), 37 deletions(-)

-- 
2.33.1

