Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8DE6837AC
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjAaUpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjAaUpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:45:13 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD8549024;
        Tue, 31 Jan 2023 12:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675197912; x=1706733912;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jmq7RRGlshhZoJmSbplAEOtDxmbFHh5q1JoifDLUQ20=;
  b=WM7dSmFaI38l6CIfjWcpqwUV9Njd+PtV6V8B9CrpT7rnyi3SOajPPTm7
   krrUE3o3+sI5DLHDqfTk7yqZ/3bpPZlZRWX+2uNHsWQOiX+1tAu6QVhzI
   AwCYE86tR20eQNdKXXTiN796obUITilc6n/08uOVrNxr3lPGxmti5FJu9
   7syZUlvWlxpQ04VY4vNEIzAwN+2cgEdaSPQy8OetIqQl1+KGNQ+OwCXZ2
   iU8WJAwBX7syZRfz9YmK+GxEMfA8K1gnRFh3byWRNAD69vDSrpjYQ9Jqf
   mDD2zuZaF4/91EuuFdnd1Y3BoB5c10WBMEj4ElLF0gmLZXGT24miTbTya
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167066"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167066"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:45:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595218"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595218"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:09 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 00/13] ice: add XDP mbuf support
Date:   Tue, 31 Jan 2023 21:44:53 +0100
Message-Id: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,

although this work started as an effort to add multi-buffer XDP support
to ice driver, as usual it turned out that some other side stuff needed
to be addressed, so let me give you an overview.

First patch adjusts legacy-rx in a way that it will be possible to refer
to skb_shared_info being at the end of the buffer when gathering up
frame fragments within xdp_buff.

Then, patches 2-9 prepare ice driver in a way that actual multi-buffer
patches will be easier to swallow.

10 and 11 are the meat. What is worth mentioning is that this set
actually *fixes* things as patch 11 removes the logic based on
next_dd/rs and we previously stepped away from this for ice_xmit_zc().
Currently, AF_XDP ZC XDP_TX workload is off as there are two cleaning
sides that can be triggered and two of them work on different internal
logic. This set unifies that and allows us to improve the performance by
2x with a trick on the last (13) patch.

12th is a simple cleanup of no longer fields from Tx ring.

I might be wrong but I have not seen anyone reporting performance impact
among patches that add XDP multi-buffer support to a particular driver.
Numbers below were gathered via xdp_rxq_info and xdp_redirect_map on
1500 MTU:

XDP_DROP      +1%
XDP_PASS      -1,2%
XDP_TX        -0,5%
XDP_REDIRECT  -3,3%

Cherry on top, which is not directly related to mbuf support (last
patch):
XDP_TX ZC +126%

Target the we agreed on was to not degrade performance for any action by
anything that would be over 5%, so our goal was met. Basically this set
keeps the performance where it was. Redirect is slower due to more
frequent tail bumps.

Thanks!


Maciej Fijalkowski (13):
  ice: prepare legacy-rx for upcoming XDP multi-buffer support
  ice: add xdp_buff to ice_rx_ring struct
  ice: store page count inside ice_rx_buf
  ice: pull out next_to_clean bump out of ice_put_rx_buf()
  ice: inline eop check
  ice: centrallize Rx buffer recycling
  ice: use ice_max_xdp_frame_size() in ice_xdp_setup_prog()
  ice: do not call ice_finalize_xdp_rx() unnecessarily
  ice: use xdp->frame_sz instead of recalculating truesize
  ice: add support for XDP multi-buffer on Rx side
  ice: add support for XDP multi-buffer on Tx side
  ice: remove next_{dd,rs} fields from ice_tx_ring
  ice: xsk: do not convert to buff to frame for XDP_TX

 drivers/net/ethernet/intel/ice/ice_base.c     |  21 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  47 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 408 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  54 ++-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 236 ++++++----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  75 +++-
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 192 +++++----
 9 files changed, 629 insertions(+), 416 deletions(-)

-- 
2.34.1

