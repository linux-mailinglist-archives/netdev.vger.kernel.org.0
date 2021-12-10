Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6A54706C7
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhLJRSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:18:50 -0500
Received: from mga04.intel.com ([192.55.52.120]:27809 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhLJRSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 12:18:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639156515; x=1670692515;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=k7lCyU1+N14aGKeP0fIFbQgfBl2YpUZlykaXpjtRVnY=;
  b=fj8CPnByDqhherbnFGF0CS0gWUsnUcGhy3TW7pU1lZH6TbmEz1rHObAa
   Gc3Nl8yYdZI4fCYLlPmGsmtJ9Jkj7C9iLilfWti/zhrGn4qmDNFnLfyZ7
   jGVdBaG14t5Brm/F7b1DLqE8SaQidHWNDYsEmaVt24tVN+Y4Inr21DPgM
   UmdwP1x5sDfEvuOlPj3NvXmsteQP2BZx9Be/kSRhj2o757ZR1cFxBpaPS
   ry5AK/DjILT6TaHqVWid/RuPvoenlKVYHUPbB9QbPr8c9vII8UHRcP1F/
   ttVwHy2B3qmylQIskwA3ALMIJPi3Et/sZHEaADNYQHieELgNdt7uxcyKD
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="237120408"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="237120408"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 09:14:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="516848735"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 10 Dec 2021 09:14:32 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 0/3] xsk: Tx improvements
Date:   Fri, 10 Dec 2021 18:14:22 +0100
Message-Id: <20211210171425.11475-1-maciej.fijalkowski@intel.com>
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
the same way as we did on [0].

Magnus moves the array of Tx descriptors that is used with batching
approach to the xsk buffer pool. This means that future users of this
API will not have carry the array on their own side, they can simple
refer to pool's tx_desc array, which can be seen on patch from Magnus.
Described patch is based on i40e as it is the only user of this API.
Tx batching is still left to be tried out for ice, though.

Thanks,
Magnus & Maciej

[0]: https://lore.kernel.org/bpf/20211015162908.145341-8-anthony.l.nguyen@intel.com/

Maciej Fijalkowski (2):
  ice: xsk: improve AF_XDP ZC Tx side
  ice: xsk: borrow xdp_tx_active logic from i40e

Magnus Karlsson (1):
  i40e: xsk: move tmp desc array from driver to pool

 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  11 --
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |   1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   3 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 138 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_xsk.h      |   5 +-
 include/net/xdp_sock_drv.h                    |   5 +-
 include/net/xsk_buff_pool.h                   |   1 +
 net/xdp/xsk.c                                 |  13 +-
 net/xdp/xsk_buff_pool.c                       |   7 +
 net/xdp/xsk_queue.h                           |  12 +-
 13 files changed, 106 insertions(+), 97 deletions(-)

-- 
2.33.1

