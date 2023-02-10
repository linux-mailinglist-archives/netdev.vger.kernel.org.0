Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5E269241C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbjBJRLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbjBJRLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:11:03 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8CC61D13;
        Fri, 10 Feb 2023 09:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676049058; x=1707585058;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aVIjMHiVDs6yNHx91RH8isvaygb3dRwiPav4Cea93Cw=;
  b=MJp9vhNt1JXr0khA3V0WuP2BwHaRY4i6cExcJaANARrVJjdMBj6uJgxS
   DoqRICvHATlJMZQXnh3S8sXuVc/QlZ4xxQ4znpQOeXXXjs8+lv0QxD+S/
   pisXYxYSSGSSn7FRmwYc/B6GrGqnxyusmlU+m2NKlqvCF3b2mGbjTSPvO
   rNWByyNElWN8cV1b4LD3BmZ7ZywAZrfmGAJxnMkPOeE9wmVtAKx+fiW8B
   OydNNTMYJwy2TO72v0SQma5+JBsjdzbZXnpd0DwL1d78VP6VLqOvWF15r
   AxCZrTxVjPSf1+b0Tk1crA3CjDxqrtyZDqcL2TPAadqZrqy1hwM0vzdAu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="395076666"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="395076666"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:07:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="668107534"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="668107534"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga002.jf.intel.com with ESMTP; 10 Feb 2023 09:07:23 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 0ADB43C624;
        Fri, 10 Feb 2023 17:07:21 +0000 (GMT)
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 0/6] ice: post-mbuf fixes
Date:   Fri, 10 Feb 2023 18:06:12 +0100
Message-Id: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.39.1
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

The set grew from the poor performance of %BPF_F_TEST_XDP_LIVE_FRAMES
when the ice-backed device is a sender. Initially there were around
3.3 Mpps / thread, while I have 5.5 on skb-based pktgen...

After fixing 0005 (0004 is a prereq for it) first (strange thing nobody
noticed that earlier), I started catching random OOMs. This is how 0002
(and partially 0001) appeared.
0003 is a suggestion from Maciej to not waste time on refactoring dead
lines. 0006 is a "cherry on top" to get away with the final 6.7 Mpps.
4.5 of 6 are fixes, but only the first three are tagged, since it then
starts being tricky. I may backport them manually later on.

TL;DR for the series is that shortcuts are good, but only as long as
they don't make the driver miss important things. %XDP_TX is purely
driver-local, however .ndo_xdp_xmit() is not, and sometimes assumptions
can be unsafe there.

With that series and also one core code patch[0], "live frames" and
xdp-trafficgen are now safe'n'fast on ice (probably more to come).

[0] https://lore.kernel.org/all/20230209172827.874728-1-alexandr.lobakin@intel.com
---
Goes to directly to bpf-next as touches the recently added/changed code.

Alexander Lobakin (6):
  ice: fix ice_tx_ring::xdp_tx_active underflow
  ice: fix XDP Tx ring overrun
  ice: remove two impossible branches on XDP Tx cleaning
  ice: robustify cleaning/completing XDP Tx buffers
  ice: fix freeing XDP frames backed by Page Pool
  ice: micro-optimize .ndo_xdp_xmit() path

 drivers/net/ethernet/intel/ice/ice_txrx.c     | 67 +++++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 37 ++++++--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 88 ++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 12 +--
 5 files changed, 136 insertions(+), 72 deletions(-)

-- 
2.39.1

