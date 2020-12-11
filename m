Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786E62D7CA9
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394616AbgLKRSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395092AbgLKRRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:17:24 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564BBC0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 09:16:43 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id i24so10100880edj.8
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 09:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FtRlX1vNS2B2cE3wGDul6BGlypI/t7Tg4uZcVGOGRGE=;
        b=pDQMMbn62siH04wILxKsrmrNYd6wF2M7ExHVhzWnaC4rDALX12pMHTDK/8NbPkweWB
         ySccOClUHV9NFzN2cdELaScS17CUr/mdKpBEhK08NndTmQiVgL89icffdn/UuZzUwX0S
         JOdlavhwQeuQLio6RP4SkMeBq1nKmsrk0UpM/MnOG31OvJyFbdjegIRKKeog1h6JALVJ
         a/jz4sSMIqMQuJE5KO7iExpo5Jqj4cgpitwC9FGp5xlJGH0ngLNNtQgWb/wTRDr9O0Xf
         m1PC74iqipYUZuLDjVqHREwQGSPZlIi8yoBx9Vk+0cqXDzv9f5ZXaOPigt7fqoNGmGhZ
         nFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FtRlX1vNS2B2cE3wGDul6BGlypI/t7Tg4uZcVGOGRGE=;
        b=YCAktfAnO3XZVX5QBD/9yJGSjTdzzGiesDu1K5Jlaem9qyEUnmsAkN7uyFhWO1+gE2
         5hsAo8CbHLjur/hnu3ZSxLkJEj1WptJG3uMy2QUn82rsv889zyHBkB2XD4lOtBbbar39
         aV46ssQVs/ksat/cjDXrZ29bB4w7G00+oS5JvONKZ27SchKH/pwsgzur8SJqe2/6kUpn
         gPye0u9EpuVzKBmsabBoCZsEV/W3e3QntOubdwIddoKzC1EUGOrgU5T8E0MmV0ZjK+S3
         mxwr2BXLND6iEcbhJppTsQMIu2BgiNWExWQCT7ev8KZBOMuecr6hMVLPJNLAGDHsY+Ft
         6OaQ==
X-Gm-Message-State: AOAM530Je4fbv+mHfkP9490EwYcZruCw9Q/IsfaWw38YPorqupaWxQFX
        WvKus/0scb/L9XiwAQ4vhtynPcdX0Cg=
X-Google-Smtp-Source: ABdhPJzxyBOFQFO/2NQqS5Op31zoz6ZpdR6VwLH5n8KsyZpSGioY5Yrmx/zBT75KxXA1OsCfQ3UPrA==
X-Received: by 2002:a05:6402:21c7:: with SMTP id bi7mr13325171edb.54.1607707001961;
        Fri, 11 Dec 2020 09:16:41 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id qp16sm7361414ejb.74.2020.12.11.09.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 09:16:41 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     jon@solid-run.com, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH net] dpaa2-eth: fix the size of the mapped SGT buffer
Date:   Fri, 11 Dec 2020 19:16:07 +0200
Message-Id: <20201211171607.108034-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch fixes an error condition triggered when the code path which
transmits a S/G frame descriptor when the skb's headroom is not enough
for DPAA2's needs.

We are greated with a splat like the one below when a SGT structure is
recycled and that is because even though a dma_unmap is performed on the
Tx confirmation path, the unmap is not done with the proper size.

[  714.464927] WARNING: CPU: 13 PID: 0 at drivers/iommu/io-pgtable-arm.c:281 __arm_lpae_map+0x2d4/0x30c
(...)
[  714.465343] Call trace:
[  714.465348]  __arm_lpae_map+0x2d4/0x30c
[  714.465353]  __arm_lpae_map+0x114/0x30c
[  714.465357]  __arm_lpae_map+0x114/0x30c
[  714.465362]  __arm_lpae_map+0x114/0x30c
[  714.465366]  arm_lpae_map+0xf4/0x180
[  714.465373]  arm_smmu_map+0x4c/0xc0
[  714.465379]  __iommu_map+0x100/0x2bc
[  714.465385]  iommu_map_atomic+0x20/0x30
[  714.465391]  __iommu_dma_map+0xb0/0x110
[  714.465397]  iommu_dma_map_page+0xb8/0x120
[  714.465404]  dma_map_page_attrs+0x1a8/0x210
[  714.465413]  __dpaa2_eth_tx+0x384/0xbd0 [fsl_dpaa2_eth]
[  714.465421]  dpaa2_eth_tx+0x84/0x134 [fsl_dpaa2_eth]
[  714.465427]  dev_hard_start_xmit+0x10c/0x2b0
[  714.465433]  sch_direct_xmit+0x1a0/0x550
(...)

The dpaa2-eth driver uses an area of software annotations to transmit
necessary information from the Tx path to the Tx confirmation one. This
SWA structure has a different layout for each kind of frame that we are
dealing with: linear, S/G or XDP.

The commit referenced was incorrectly setting up the 'sgt_size' field
for the S/G type of SWA even though we are dealing with a linear skb
here.

Fixes: d70446ee1f40 ("dpaa2-eth: send a scatter-gather FD instead of realloc-ing")
Reported-by: Daniel Thompson <daniel.thompson@linaro.org>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index cf9400a9886d..d880ab2a7d96 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -878,7 +878,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 	swa = (struct dpaa2_eth_swa *)sgt_buf;
 	swa->type = DPAA2_ETH_SWA_SINGLE;
 	swa->single.skb = skb;
-	swa->sg.sgt_size = sgt_buf_size;
+	swa->single.sgt_size = sgt_buf_size;
 
 	/* Separately map the SGT buffer */
 	sgt_addr = dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIRECTIONAL);
-- 
2.28.0

