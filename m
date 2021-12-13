Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3F747307D
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhLMPb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:31:29 -0500
Received: from mga04.intel.com ([192.55.52.120]:4850 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235627AbhLMPb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 10:31:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639409487; x=1670945487;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H7g9iSSe4v6lpuPhngwIAXIU8l1m2PxzKJzB5Ufiyh8=;
  b=VXuLZpo/zEduiSECpR/jbZKSbR8IQH5kLb7OnuKL86M+IN72ddMOX01l
   2l6ihAnGSBbtYF5N2eeRbyratyXgO2gncHZTkFZsIP7COzXVi21jKxC+x
   rgfKraYl50QMR5Xb/cgclAwVQ0uKz+2kkuOEvHqlFGYR0TR6OyIRRVmsb
   gA3fAxMB8ySn42WrpkiLmEF/X8RHC7UOovo+FdQ7kg0KRkNp+/xg8XMsK
   Ds17zSJAb0fxd2ENDaemUXczbiHcEMBN46EM0rppUMnlnjFEFhoXE77Pp
   VH15hiKWYJLt/Mp8oProJwJc1WN80M7invhRcvms3l2EBcz8IHdAum48d
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="237490463"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="237490463"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:31:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="613864707"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 13 Dec 2021 07:31:19 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, elza.mathew@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-net 0/6] ice: xsk: Rx processing fixes
Date:   Mon, 13 Dec 2021 16:31:05 +0100
Message-Id: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
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

v2 has a diff around only patch 2:
- use array_size() in memsets (Alexandr)
- remove unnecessary ternary operator from ice_alloc_rx_buf{, _zc}()
  (Alexandr)
- respect RCT in ice_construct_skb_zc() (Alexandr)
- fix kdoc issue (Anthony)

It also carries Alexandr's patch that was sent previously which was
overlapping with this set.

Thanks,
Maciej

[0]: https://lore.kernel.org/bpf/20211129231746.2767739-1-anthony.l.nguyen@intel.com/

Alexander Lobakin (1):
  ice: remove dead store on XSK hotpath

Maciej Fijalkowski (5):
  ice: xsk: return xsk buffers back to pool when cleaning the ring
  ice: xsk: allocate separate memory for XDP SW ring
  ice: xsk: do not clear status_error0 for ntu + nb_buffs descriptor
  ice: xsk: allow empty Rx descriptors on XSK ZC data path
  ice: xsk: fix cleaned_count setting

 drivers/net/ethernet/intel/ice/ice_base.c | 17 ++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 19 ++++---
 drivers/net/ethernet/intel/ice/ice_txrx.h |  1 -
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 66 +++++++++++------------
 4 files changed, 62 insertions(+), 41 deletions(-)

-- 
2.33.1

