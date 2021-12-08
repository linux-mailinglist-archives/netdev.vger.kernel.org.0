Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F4346D517
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhLHOLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:11:06 -0500
Received: from mga04.intel.com ([192.55.52.120]:20809 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231363AbhLHOLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:11:05 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="236574216"
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="236574216"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 06:07:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="479908986"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 08 Dec 2021 06:07:28 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B8E7Quc009548;
        Wed, 8 Dec 2021 14:07:26 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v4 net-next 0/9] net: intel: napi_alloc_skb() vs metadata
Date:   Wed,  8 Dec 2021 15:06:53 +0100
Message-Id: <20211208140702.642741-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an interpolation of [0] to other Intel Ethernet drivers
(and is (re)based on its code).
The main aim is to keep XDP metadata not only in case with
build_skb(), but also when we do napi_alloc_skb() + memcpy().

All Intel drivers suffers from the same here:
 - metadata gets lost on XDP_PASS in legacy-rx;
 - excessive headroom allocation on XSK Rx to skbs;
 - metadata gets lost on XSK Rx to skbs.

Those get especially actual in XDP Hints upcoming.
I couldn't have addressed the first one for all Intel drivers due to
that they don't reserve any headroom for now in legacy-rx mode even
with XDP enabled. This is hugely wrong, but requires quite a bunch
of work and a separate series. Luckily, ice doesn't suffer from
that.
igc has 1 and 3 already fixed in [0].

From v3 ([1]):
 - fix driver name and ixgbe_construct_skb() function name in the
   commit message of #9 (Jesper);
 - no functional changes.

From v2 (unreleased upstream):
 - tweaked 007 to pass bi->xdp directly and simplify code (Maciej);
 - picked Michal's Reviewed-by.

From v1 (unreleased upstream):
 - drop "fixes" of legacy-rx for i40e, igb and ixgbe since they have
   another flaw regarding headroom (see above);
 - drop igc cosmetic fixes since they landed upstream incorporated
   into Jesper's commits;
 - picked one Acked-by from Maciej.

[0] https://lore.kernel.org/netdev/163700856423.565980.10162564921347693758.stgit@firesoul
[1] https://lore.kernel.org/netdev/20211207205536.563550-1-alexandr.lobakin@intel.com

Alexander Lobakin (9):
  i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
  i40e: respect metadata on XSK Rx to skb
  ice: respect metadata in legacy-rx/ice_construct_skb()
  ice: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
  ice: respect metadata on XSK Rx to skb
  igc: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
  ixgbe: pass bi->xdp to ixgbe_construct_skb_zc() directly
  ixgbe: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
  ixgbe: respect metadata on XSK Rx to skb

 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 16 +++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx.c    | 15 ++++++++---
 drivers/net/ethernet/intel/ice/ice_xsk.c     | 16 +++++++-----
 drivers/net/ethernet/intel/igc/igc_main.c    | 13 +++++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 27 ++++++++++++--------
 5 files changed, 54 insertions(+), 33 deletions(-)

-- 
Testing hints:

Setup an XDP and AF_XDP program which will prepend metadata at the
front of the frames and return XDP_PASS, then check that metadata
is present after frames reach kernel network stack.
--
2.33.1

