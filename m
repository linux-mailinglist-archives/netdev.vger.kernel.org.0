Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB374A4E5D
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356163AbiAaScR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:32:17 -0500
Received: from mga07.intel.com ([134.134.136.100]:37997 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355691AbiAaScO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:32:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643653934; x=1675189934;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pB0ekynWdPbkeDue3+BEdEWJju2enleWv9TWAEI3sIU=;
  b=BFxEjQTk53hgcT+qCFgJTYRMk3K8ULwveuQwQGywJkxHNIjb9Bpu6riG
   Mq4R85G/ncQrBZzKhrWdgj7Yxzk4b6A2YJeprvVXyW32urdkikeXzpDEU
   KG/9F7XHiqizqN5jmjEBcJMF0ITEmmQZmv7o4Y0FSUK1jqemzN59mWZHX
   HY2nEYLC7UHQ7aQPDFI8JesuVbp6gcD7Vk56kijBYh/DkGN8W837EOhkj
   3coXAegtbJyKgC63kat3w1haTLYvqHG9UdvPRWUdioT+9z0g+/cqbRXOj
   dPs4/AbZ5bjIWLB9FsfWS3qg6FHhad+X+PWJerlOug/C4yA8vYBnILHTE
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="310833045"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="310833045"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:32:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="598920394"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2022 10:32:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        alexandr.lobakin@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bjorn@kernel.org,
        maciej.fijalkowski@intel.com, michal.swiatkowski@linux.intel.com,
        kafai@fb.com, songliubraving@fb.com, kpsingh@kernel.org,
        yhs@fb.com, andrii@kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next 0/9][pull request] 10GbE Intel Wired LAN Driver Updates 2022-01-31
Date:   Mon, 31 Jan 2022 10:31:43 -0800
Message-Id: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin says:

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

[0] https://lore.kernel.org/netdev/163700856423.565980.10162564921347693758.stgit@firesoul

The following are changes since commit b43471cc10327f098d5a72918cd59fcb91546ca3:
  Merge branch 'mana-XDP-counters'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

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
2.31.1

