Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81306575CD8
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 09:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiGOH56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 03:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiGOH56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 03:57:58 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEF27D7B8
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 00:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657871877; x=1689407877;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8y338NQSmDBmmLrRO0DzkQ5IfgLAxLj3qXlNTQZXH2M=;
  b=m5HqmX91G1uXk+2vJKPbzYNamq9TOJtA9XwKS0y5F03gytc3vI/3CdYp
   7kko64HAL8c4hWvY0+6sOgvx9g22Ftr9QSB/0MbVPIomm6n+BRzHl9C0J
   2lO/2xYZOJ+NggQRHlf9ajuIOEv36zc09cKLo80u/gQQSkxOZnD5bhFOb
   6elw7AXNwfldan1kf2sM3rOkqwAAr48tEKh8W7Lpz63Nq/86gXFXHDGYb
   Np2hD76bdhcJ00EPk45P9csXsT8Blid6fWQKEWB1YkXZ172JUsnsY2HD1
   Gza7HK+6+7AkfRHZ3AwsREUoGcL+IwJhktlClGz1OgwHIopQjVHHKJyzm
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="266141660"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="266141660"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 00:57:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="654236718"
Received: from junxiaochang.bj.intel.com ([10.238.135.52])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 00:57:35 -0700
From:   Junxiao Chang <junxiao.chang@intel.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com, Joao.Pinto@synopsys.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, cedric@bytespeed.nl,
        f.fainelli@gmail.com
Subject: [PATCH net] net: stmmac: fix dma queue left shift overflow issue
Date:   Fri, 15 Jul 2022 15:47:01 +0800
Message-Id: <20220715074701.194776-1-junxiao.chang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When queue number is > 4, left shift overflows due to 32 bits
integer variable. Mask calculation is wrong for MTL_RXQ_DMA_MAP1.

If CONFIG_UBSAN is enabled, kernel dumps below warning:
[   10.363842] ==================================================================
[   10.363882] UBSAN: shift-out-of-bounds in /build/linux-intel-iotg-5.15-8e6Tf4/
linux-intel-iotg-5.15-5.15.0/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:224:12
[   10.363929] shift exponent 40 is too large for 32-bit type 'unsigned int'
[   10.363953] CPU: 1 PID: 599 Comm: NetworkManager Not tainted 5.15.0-1003-intel-iotg
[   10.363956] Hardware name: ADLINK Technology Inc. LEC-EL/LEC-EL, BIOS 0.15.11 12/22/2021
[   10.363958] Call Trace:
[   10.363960]  <TASK>
[   10.363963]  dump_stack_lvl+0x4a/0x5f
[   10.363971]  dump_stack+0x10/0x12
[   10.363974]  ubsan_epilogue+0x9/0x45
[   10.363976]  __ubsan_handle_shift_out_of_bounds.cold+0x61/0x10e
[   10.363979]  ? wake_up_klogd+0x4a/0x50
[   10.363983]  ? vprintk_emit+0x8f/0x240
[   10.363986]  dwmac4_map_mtl_dma.cold+0x42/0x91 [stmmac]
[   10.364001]  stmmac_mtl_configuration+0x1ce/0x7a0 [stmmac]
[   10.364009]  ? dwmac410_dma_init_channel+0x70/0x70 [stmmac]
[   10.364020]  stmmac_hw_setup.cold+0xf/0xb14 [stmmac]
[   10.364030]  ? page_pool_alloc_pages+0x4d/0x70
[   10.364034]  ? stmmac_clear_tx_descriptors+0x6e/0xe0 [stmmac]
[   10.364042]  stmmac_open+0x39e/0x920 [stmmac]
[   10.364050]  __dev_open+0xf0/0x1a0
[   10.364054]  __dev_change_flags+0x188/0x1f0
[   10.364057]  dev_change_flags+0x26/0x60
[   10.364059]  do_setlink+0x908/0xc40
[   10.364062]  ? do_setlink+0xb10/0xc40
[   10.364064]  ? __nla_validate_parse+0x4c/0x1a0
[   10.364068]  __rtnl_newlink+0x597/0xa10
[   10.364072]  ? __nla_reserve+0x41/0x50
[   10.364074]  ? __kmalloc_node_track_caller+0x1d0/0x4d0
[   10.364079]  ? pskb_expand_head+0x75/0x310
[   10.364082]  ? nla_reserve_64bit+0x21/0x40
[   10.364086]  ? skb_free_head+0x65/0x80
[   10.364089]  ? security_sock_rcv_skb+0x2c/0x50
[   10.364094]  ? __cond_resched+0x19/0x30
[   10.364097]  ? kmem_cache_alloc_trace+0x15a/0x420
[   10.364100]  rtnl_newlink+0x49/0x70

This change fixes MTL_RXQ_DMA_MAP1 mask issue and channel/queue
mapping warning.

Fixes: d43042f4da3e ("net: stmmac: mapping mtl rx to dma channel")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216195
Reported-by: Cedric Wassenaar <cedric@bytespeed.nl>
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index fd41db65fe1df..af33390411346 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -219,6 +219,9 @@ static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
 	if (queue == 0 || queue == 4) {
 		value &= ~MTL_RXQ_DMA_Q04MDMACH_MASK;
 		value |= MTL_RXQ_DMA_Q04MDMACH(chan);
+	} else if (queue > 4) {
+		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue - 4);
+		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue - 4);
 	} else {
 		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue);
 		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue);
-- 
2.25.1

