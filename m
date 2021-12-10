Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C64B47034C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhLJPDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 10:03:24 -0500
Received: from mga04.intel.com ([192.55.52.120]:14344 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231735AbhLJPDX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 10:03:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639148389; x=1670684389;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Sc4UZZcBuoyPA5U2BemIlY7ATRRho8rNRsU713opSdc=;
  b=C+hW4pIxBUixq2eUvJQiUZv7ErJGNJBiFcxQ9OOrz5AueGw9M9OJzOT4
   wT7/eLIZ1oSKjRaHjvrMcqjS2mjpGVYvkyBhpk2nNS5ybLigdV1k+R12i
   O35Mc6y2Y4r7FFUw3uHtrdSZw7IzQdEHztGwDCn0YPuwcTr4XmHJ4ZF8e
   IeJrOaBvx7ZbzcUI4KFkSfSxwPKESmEBJJkIzryaORyJO+roDUis/tcDT
   TeKOfdy+cmy2mLJmj7OG+2DixMxmHuW/MNmXdc16Cez1k6+chL6BweEzA
   +7pJj6pC6nkk+N0oSl+QK+cZb2e4LBJNODM7sIIezjqGbFB4NFJlx8fDO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="237093248"
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="237093248"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 06:59:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="680763681"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 10 Dec 2021 06:59:46 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, elza.mathew@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 0/5] ice: xsk: Rx processing fixes
Date:   Fri, 10 Dec 2021 15:59:36 +0100
Message-Id: <20211210145941.5865-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,
it seems that previous [0] Rx fix was not enough and there are still
issues with AF_XDP Rx ZC support in ice driver. Elza reported that for
multiple XSK sockets configured on a single netdev, some of them were
becoming dead after a while. We have spotted more things that needed to
be addressed this time. More of information can be found in particular
commit messages.

Thanks,
Maciej

[0]: https://lore.kernel.org/bpf/20211129231746.2767739-1-anthony.l.nguyen@intel.com/

Maciej Fijalkowski (5):
  ice: xsk: return xsk buffers back to pool when cleaning the ring
  ice: xsk: allocate separate memory for XDP SW ring
  ice: xsk: do not clear status_error0 for ntu + nb_buffs descriptor
  ice: xsk: allow empty Rx descriptors on XSK ZC data path
  ice: xsk: fix cleaned_count setting

 drivers/net/ethernet/intel/ice/ice_base.c | 19 +++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 19 ++++---
 drivers/net/ethernet/intel/ice/ice_txrx.h |  1 -
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 62 +++++++++++------------
 4 files changed, 62 insertions(+), 39 deletions(-)

-- 
2.33.1

