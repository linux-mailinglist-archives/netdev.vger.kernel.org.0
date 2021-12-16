Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9F54773D5
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 15:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237430AbhLPOAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 09:00:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:12132 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237350AbhLPOAD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 09:00:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639663203; x=1671199203;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xdKbtlL7ITOIX1JNCDs0U+JBIpXSsVmjnc4PePr4EnM=;
  b=DAABFT391XXUAWUDC+K3d5tV4YTa8eKKA46J2FleXNr4SuJr5Cz2I1sI
   yjoxF5J2+k3rvEJHwhSo6VRv7PqiDvQtW7m8MEKijv57uotGp7qJdIsvK
   szVUCLdKVkJILgLJnol9suPazoDD0dZEK4hg+rG0TDyOasvvZKjvuc6Fc
   kf0itWsKZH9pFvXUZ5lTK9BaOBQmbHhZosE8YfPP2lKcD5VMED4HTE7Rh
   K/QrsGc5HTEsKnQ1BJGNcySNa58tJoDFrZ8JFpauw+WpgSwnhY9/+BNq/
   X7HXlESHWDggSJsJpfGxq7mhXhmt0ntZDy66ExQ0ncYfYEsbUheqoATGn
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226779238"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="226779238"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 06:00:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="545988157"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga001.jf.intel.com with ESMTP; 16 Dec 2021 06:00:01 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v2 0/4] xsk: Tx improvements
Date:   Thu, 16 Dec 2021 14:59:54 +0100
Message-Id: <20211216135958.3434-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
this time we're on Tx side of AF_XDP and we touch i40e and ice drivers.
Unfortunately, similar scalability issues that were addressed for XDP
processing in ice, exist on AF_XDP side. Let's resolve them in mostly
the same way as we did on [0] and utilize the Tx batching API from xsk
buffer pool.

Magnus moves the array of Tx descriptors that is used with batching
approach to the xsk buffer pool. This means that future users of this
API will not have carry the array on their own side, they can simple
refer to pool's tx_desc array, which can be seen on patch from Magnus.
Described patch is based on i40e as it is the only user of this API.
Tx batching is still left to be tried out for ice, though.

v2:
* introduce new patch that resets @next_dd and @next_rs fields
* use batching API for AF_XDP Tx on ice side

Thanks,
Magnus & Maciej

[0]: https://lore.kernel.org/bpf/20211015162908.145341-8-anthony.l.nguyen@intel.com/

Maciej Fijalkowski (3):
  ice: xsk: avoid potential dead AF_XDP Tx processing
  ice: xsk: improve AF_XDP ZC Tx and use batching API
  ice: xsk: borrow xdp_tx_active logic from i40e

Magnus Karlsson (1):
  i40e: xsk: move tmp desc array from driver to pool

 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  11 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |   1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   5 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 255 ++++++++++++------
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  26 +-
 include/net/xdp_sock_drv.h                    |   5 +-
 include/net/xsk_buff_pool.h                   |   1 +
 net/xdp/xsk.c                                 |  13 +-
 net/xdp/xsk_buff_pool.c                       |   7 +
 net/xdp/xsk_queue.h                           |  12 +-
 13 files changed, 216 insertions(+), 129 deletions(-)

-- 
2.33.1

