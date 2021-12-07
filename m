Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3518146C504
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 21:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhLGU7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 15:59:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:30780 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhLGU7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 15:59:47 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="224942856"
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="224942856"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 12:56:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="563798551"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 07 Dec 2021 12:56:11 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B7Ku9kd018910;
        Tue, 7 Dec 2021 20:56:09 GMT
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
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v3 net-next 0/9] net: intel: napi_alloc_skb() vs metadata
Date:   Tue,  7 Dec 2021 21:55:27 +0100
Message-Id: <20211207205536.563550-1-alexandr.lobakin@intel.com>
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

Alexander Lobakin (9):
  i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
  i40e: respect metadata on XSK Rx to skb
  ice: respect metadata in legacy-rx/ice_construct_skb()
  ice: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
  ice: respect metadata on XSK Rx to skb
  igc: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
  ixgbe: pass bi->xdp to ixgbe_construct_skb_zc() directly
  ixgbe: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
  i40e: respect metadata on XSK Rx to skb

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

