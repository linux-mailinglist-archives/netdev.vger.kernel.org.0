Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D4E4FFA45
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbiDMPd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236549AbiDMPd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:33:26 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3BE37AB0;
        Wed, 13 Apr 2022 08:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863860; x=1681399860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W0ivcRo/CNJCiHsXXiZIy0nwpm+Mc6B1Iwk6iOajJno=;
  b=BBjEnQ50sRuDbeD1+YRY6b8+h8LCR0t5PyXTaeSIMrLfUGqz3dbPUBSn
   JkFY3aKv/102/bRuXLyvydYeHdCWuutwf+ByjcQexyFWtNcogeATxBo2z
   AkrHfoNwW2FH+yFSgrKZmrxca9Rcx4XPMr5QmRIH6CwVgdiAdJcrkd/qT
   kQEjaEmaOId35jZHzDY9oEdfCb3SxFidmGIgk+r+BISpFPq/nTXFDxCk4
   jtEXqn3xjZq5pm2IfGUtMWtJl/ttqk3tKphRv4G0s48oOvqiNjqljA4tw
   Enp6xweA13RbkcxoV1wiD/fAaojznDSZ12SNNm75QYxPQs2LuTwIv0P1L
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544320"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544320"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318405"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:57 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 11/14] mlx5: xsk: diversify return values from xsk_wakeup call paths
Date:   Wed, 13 Apr 2022 17:30:12 +0200
Message-Id: <20220413153015.453864-12-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when debugging AF_XDP workloads, one can correlate the -ENXIO
return code as the case that XSK is not in the bound state. Returning
same code from ndo_xsk_wakeup can be misleading and simply makes it
harder to follow what is going on.

Change ENXIO in mlx5's ndo_xsk_wakeup() implementation to EINVAL, so
that when probing it is clear that something is wrong on the driver
side, not the xsk_{recv,send}msg.

There is a -ENETDOWN that can happen from both kernel/driver sides
though, but I don't have a correct replacement for this on one of the
sides, so let's keep it that way.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 3ec0c17db010..4902ef74fedf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -23,7 +23,7 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 	c = priv->channels.c[ix];
 
 	if (unlikely(!test_bit(MLX5E_CHANNEL_STATE_XSK, c->state)))
-		return -ENXIO;
+		return -EINVAL;
 
 	if (!napi_if_scheduled_mark_missed(&c->napi)) {
 		/* To avoid WQE overrun, don't post a NOP if async_icosq is not
-- 
2.33.1

