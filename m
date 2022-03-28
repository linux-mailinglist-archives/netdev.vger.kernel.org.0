Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5E04E9945
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243760AbiC1OXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiC1OXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:23:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFB25DA69;
        Mon, 28 Mar 2022 07:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648477302; x=1680013302;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d+jFCb0mQcjGbf1OTTyR5SA/o5lLufGjih/d3cVC0UU=;
  b=ditBcHSc/9asNMfdos0uy/ALjYZXR/iv0Df+KWN/1qhoZUJoMTHARnPB
   265P6py0qh6WI0vugcOK3aF2jHuDZZLQ9j3dQlol2558GA+clyUjIgs8D
   vVnZPiZiWJBAsIjmpw6mGdDKj5uzGMXYE7IalLdh34Isb2mcSpIa2zuF7
   l/rz3WxulZwxbBVbFuhEf34Gf28ODTKeYw5ihTgepVmB9qlzp5kb7v06T
   syzEzW9ggSdpAkebzyjveviQBGn9gdfl81oYX/1UV5xpNPuPe28bQJ6hY
   z1bQNKQin0eQu94p81vl33Po/ucAr3mmbKytgTqrxnHainBkFFs2/Nd4p
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="259196072"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="259196072"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 07:21:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="649076506"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 28 Mar 2022 07:21:39 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, bjorn@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf 0/4] xsk: another round of fixes
Date:   Mon, 28 Mar 2022 16:21:19 +0200
Message-Id: <20220328142123.170157-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

yet another fixes for XSK from Magnus and me.

Magnus addresses the fact that xp_alloc() can return NULL, so this needs
to be handled to avoid clearing entries in the SW ring on driver side.
Then he addresses the off-by-one problem in Tx desc cleaning routine for
ice ZC driver.

From my side, I am adding protection to ZC Rx processing loop so that
cleaning of descriptors wouldn't go over already processed entries.
Then I also fix an issue with assigning XSK pool to Tx queues.

This is directed to bpf tree.

Thanks!

Maciej Fijalkowski (2):
  ice: xsk: stop Rx processing when ntc catches ntu
  ice: xsk: fix indexing in ice_tx_xsk_pool()

Magnus Karlsson (2):
  xsk: do not write NULL in SW ring at allocation failure
  ice: xsk: eliminate unnecessary loop iteration

 drivers/net/ethernet/intel/ice/ice.h     | 2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c | 5 ++++-
 net/xdp/xsk_buff_pool.c                  | 8 ++++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

-- 
2.27.0

