Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C794D2D5F1C
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390808AbgLJPIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389587AbgLJOsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 09:48:37 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1814C0613D6;
        Thu, 10 Dec 2020 06:47:56 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id e25so5595476wme.0;
        Thu, 10 Dec 2020 06:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=AxtVK2Lm2rMkZodCzAOuPbEIHub/TWyXt4Eh0g2SRxc=;
        b=gn9stn9BwKN4SFiVGlz/q8lXZmAyWT/HLaGjXAnX0aqIV8aPQY3JDgeUlBKi6qXXOs
         NWFrwc8V0ObGPjU4XF3lSkilzQfl/G4Jb3jskYEmIJ4KcK07hc5u2al8sRp3pcsKFTQg
         mV0FjlR/N+LhVc32mNxHhigAvQ7czxhqwYBi0+s41mxeCapNQ3lvE0PI1RGiQkDYxwM6
         TMigIJKh156u5lYMqcu27RKqBg9e+zjT+E6WS4Z/RDxJQon7p4BRdptIJermWt6/gMQI
         x5yshTz49Z9YWKtG04tBNsXoRtPpsEIR2KyoIVf03Fch9UmvpFQWLHsPZlSSfoonckP9
         5oHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=AxtVK2Lm2rMkZodCzAOuPbEIHub/TWyXt4Eh0g2SRxc=;
        b=NlJxxXPZJUafiVIlrlltqLO/CVlqNbh9dBRgOrZpK6Hc5m4N8GK05/ji0/aRsEsqEY
         voqCvuwXqiBXN2NIC0+rOrtqzepWRSG0bEKdNBcf6cO4L0A8stpSn001y06HPmMf/y4N
         msiOi/MfVcCC94xWOBXhouQH7/Alyg5DuKYkBbihoV6kftGckEZk74xi/r/3c74vEoU0
         wtIb2+KlxtPAlXZpyMY0GgYjMjB7Obc6zc+iUk6yLNqQUaVAVnsxC+ugLkWDgpd5l/fA
         KFnAURmw2UYaSDh9dGILwy9d9Njo8T16gcYKeAwMe5L8bTA3Zew45yT6EBpmxDtb1HEL
         3lwA==
X-Gm-Message-State: AOAM531WcFarLS9v5jmEhwhohzJoL/4nvkKUzS66f6kmgnjrXiLjCAyg
        GMzBwn8hy9o2E0E/r+fOdLg=
X-Google-Smtp-Source: ABdhPJwQexMqTKdM049mz2YKTEzbyRkII5DwpvQT2BZgpTwBskgbmlZMt5UyHfMHbS72d5gimTwWpw==
X-Received: by 2002:a1c:7c19:: with SMTP id x25mr8771592wmc.94.1607611674709;
        Thu, 10 Dec 2020 06:47:54 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:915a:a543:6cb0:cf21? (p200300ea8f065500915aa5436cb0cf21.dip0.t-ipconnect.de. [2003:ea:8f06:5500:915a:a543:6cb0:cf21])
        by smtp.googlemail.com with ESMTPSA id z17sm9200176wrh.88.2020.12.10.06.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 06:47:53 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] dma-mapping: move hint unlikely for dma_mapping_error from
 drivers to core
To:     George Cherian <gcherian@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Elie Morisse <syniurge@gmail.com>,
        Nehal Shah <nehal-bakulchandra.shah@amd.com>,
        Shyam Sundar S K <shyam-sundar.s-k@amd.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andreas Larsson <andreas@gaisler.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Michael Chan <michael.chan@broadcom.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Jon Mason <jdmason@kudzu.us>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Daniele Venzano <venza@brownhat.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kevin Brace <kevinbrace@bracecomputerlab.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, qat-linux@intel.com,
        linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, wil6210@qti.qualcomm.com,
        b43-dev@lists.infradead.org, iommu@lists.linux-foundation.org
Message-ID: <5d08af46-5897-b827-dcfb-181d869c8f71@gmail.com>
Date:   Thu, 10 Dec 2020 15:47:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zillions of drivers use the unlikely() hint when checking the result of
dma_mapping_error(). This is an inline function anyway, so we can move
the hint into the function and remove it from drivers.
From time to time discussions pop up how effective unlikely() is,
and that it should be used only if something is really very unlikely.
I think that's the case here.

Patch was created with some help from coccinelle.

@@
expression dev, dma_addr;
@@

- unlikely(dma_mapping_error(dev, dma_addr))
+ dma_mapping_error(dev, dma_addr)

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
If ok, then tbd through which tree this is supposed to go.
Patch is based on linux-next-20201210.
---
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c  |  3 +--
 drivers/crypto/hisilicon/hpre/hpre_crypto.c   |  2 +-
 .../marvell/octeontx/otx_cptvf_reqmgr.c       |  5 ++--
 drivers/crypto/mediatek/mtk-aes.c             |  2 +-
 drivers/crypto/mediatek/mtk-sha.c             |  6 ++---
 drivers/crypto/qat/qat_common/qat_algs.c      |  8 +++---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 25 +++++++++----------
 drivers/i2c/busses/i2c-amd-mp2-plat.c         |  2 +-
 drivers/infiniband/hw/hfi1/sdma.c             |  2 +-
 drivers/net/ethernet/aeroflex/greth.c         |  4 +--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  8 +++---
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  5 ++--
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  2 +-
 drivers/net/ethernet/arc/emac_main.c          |  2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  6 ++---
 drivers/net/ethernet/broadcom/bgmac.c         |  4 +--
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 10 ++++----
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  4 +--
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |  4 +--
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c    |  4 +--
 drivers/net/ethernet/faraday/ftgmac100.c      |  2 +-
 drivers/net/ethernet/faraday/ftmac100.c       |  4 +--
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 13 +++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 12 ++++-----
 drivers/net/ethernet/freescale/enetc/enetc.c  |  4 +--
 drivers/net/ethernet/freescale/gianfar.c      |  6 ++---
 drivers/net/ethernet/google/gve/gve_tx.c      |  4 +--
 drivers/net/ethernet/hisilicon/hisi_femac.c   |  2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  4 +--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 +--
 drivers/net/ethernet/lantiq_xrx200.c          |  5 ++--
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  3 +--
 drivers/net/ethernet/marvell/mvneta.c         |  9 +++----
 drivers/net/ethernet/marvell/mvneta_bm.c      |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  8 +++---
 .../marvell/octeontx2/nic/otx2_common.c       |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 10 ++++----
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 .../mellanox/mlx5/core/diag/rsc_dump.c        |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  2 +-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  6 ++---
 .../net/ethernet/neterion/vxge/vxge-config.c  |  6 ++---
 .../net/ethernet/neterion/vxge/vxge-main.c    |  6 ++---
 drivers/net/ethernet/nvidia/forcedeth.c       | 21 ++++++----------
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     |  4 +--
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  8 +++---
 drivers/net/ethernet/realtek/r8169_main.c     |  2 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  2 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |  3 +--
 drivers/net/ethernet/sfc/falcon/tx.c          |  4 +--
 drivers/net/ethernet/sfc/rx_common.c          |  3 +--
 drivers/net/ethernet/sfc/tx_common.c          |  4 +--
 drivers/net/ethernet/sfc/tx_tso.c             |  2 +-
 drivers/net/ethernet/sis/sis900.c             | 24 ++++++++----------
 drivers/net/ethernet/socionext/sni_ave.c      |  2 +-
 drivers/net/ethernet/sun/sunhme.c             |  8 +++---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  6 ++---
 drivers/net/ethernet/ti/netcp_core.c          |  4 +--
 drivers/net/ethernet/via/via-rhine.c          |  2 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  6 ++---
 drivers/net/wireless/ath/ath10k/htt_rx.c      |  2 +-
 drivers/net/wireless/ath/ath10k/pci.c         |  2 +-
 drivers/net/wireless/ath/ath10k/snoc.c        |  2 +-
 drivers/net/wireless/ath/ath11k/ce.c          |  2 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c       |  2 +-
 drivers/net/wireless/ath/ath5k/base.c         |  2 +-
 drivers/net/wireless/ath/ath9k/beacon.c       |  2 +-
 drivers/net/wireless/ath/ath9k/recv.c         | 21 +++++++---------
 drivers/net/wireless/ath/ath9k/xmit.c         |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c       | 10 ++++----
 drivers/net/wireless/ath/wil6210/txrx_edma.c  |  4 +--
 drivers/net/wireless/broadcom/b43/dma.c       |  2 +-
 drivers/net/wireless/broadcom/b43legacy/dma.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 10 ++++----
 drivers/net/wireless/intel/iwlwifi/queue/tx.c | 10 ++++----
 drivers/net/wireless/mediatek/mt76/dma.c      |  8 +++---
 .../net/wireless/ralink/rt2x00/rt2x00queue.c  |  4 +--
 include/linux/dma-mapping.h                   |  3 ++-
 kernel/dma/map_benchmark.c                    |  2 +-
 86 files changed, 207 insertions(+), 230 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index 4fe7898c8..c3d5a5290 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -60,8 +60,7 @@ static int setup_sgio_components(struct cpt_vf *cptvf, struct buf_ptr *list,
 							  list[i].vptr,
 							  list[i].size,
 							  DMA_BIDIRECTIONAL);
-			if (unlikely(dma_mapping_error(&pdev->dev,
-						       list[i].dma_addr))) {
+			if (dma_mapping_error(&pdev->dev, list[i].dma_addr)) {
 				dev_err(&pdev->dev, "DMA map kernel buffer failed for component: %d\n",
 					i);
 				ret = -EIO;
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index a87f99040..cf1c20f3d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -189,7 +189,7 @@ static int hpre_get_data_dma_addr(struct hpre_asym_request *hpre_req,
 		dma_dir = DMA_FROM_DEVICE;
 	}
 	*tmp = dma_map_single(dev, sg_virt(data), len, dma_dir);
-	if (unlikely(dma_mapping_error(dev, *tmp))) {
+	if (dma_mapping_error(dev, *tmp)) {
 		dev_err(dev, "dma map data err!\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
index c80baf1ad..928e01905 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
@@ -112,8 +112,7 @@ static inline int setup_sgio_components(struct pci_dev *pdev,
 							  list[i].vptr,
 							  list[i].size,
 							  DMA_BIDIRECTIONAL);
-			if (unlikely(dma_mapping_error(&pdev->dev,
-						       list[i].dma_addr))) {
+			if (dma_mapping_error(&pdev->dev, list[i].dma_addr)) {
 				dev_err(&pdev->dev, "Dma mapping failed\n");
 				ret = -EIO;
 				goto sg_cleanup;
@@ -223,7 +222,7 @@ static inline int setup_sgio_list(struct pci_dev *pdev,
 	info->dma_len = total_mem_len - info_len;
 	info->dptr_baddr = dma_map_single(&pdev->dev, (void *)info->in_buffer,
 					  info->dma_len, DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(&pdev->dev, info->dptr_baddr))) {
+	if (dma_mapping_error(&pdev->dev, info->dptr_baddr)) {
 		dev_err(&pdev->dev, "DMA Mapping failed for cpt req\n");
 		return -EIO;
 	}
diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 732306672..b842df020 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -358,7 +358,7 @@ static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 
 	ctx->ct_dma = dma_map_single(cryp->dev, info, sizeof(*info),
 				     DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(cryp->dev, ctx->ct_dma)))
+	if (dma_mapping_error(cryp->dev, ctx->ct_dma))
 		goto exit;
 
 	ctx->tfm_dma = ctx->ct_dma + sizeof(info->cmd);
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index f55aacdaf..91ff2c3fc 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -338,7 +338,7 @@ static int mtk_sha_info_update(struct mtk_cryp *cryp,
 
 	ctx->ct_dma = dma_map_single(cryp->dev, info, sizeof(*info),
 				     DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(cryp->dev, ctx->ct_dma))) {
+	if (dma_mapping_error(cryp->dev, ctx->ct_dma)) {
 		dev_err(cryp->dev, "dma %zu bytes error\n", sizeof(*info));
 		return -EINVAL;
 	}
@@ -473,7 +473,7 @@ static int mtk_sha_dma_map(struct mtk_cryp *cryp,
 {
 	ctx->dma_addr = dma_map_single(cryp->dev, ctx->buffer,
 				       SHA_BUF_SIZE, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(cryp->dev, ctx->dma_addr))) {
+	if (dma_mapping_error(cryp->dev, ctx->dma_addr)) {
 		dev_err(cryp->dev, "dma map error\n");
 		return -EINVAL;
 	}
@@ -562,7 +562,7 @@ static int mtk_sha_update_start(struct mtk_cryp *cryp,
 
 		ctx->dma_addr = dma_map_single(cryp->dev, ctx->buffer,
 					       SHA_BUF_SIZE, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(cryp->dev, ctx->dma_addr))) {
+		if (dma_mapping_error(cryp->dev, ctx->dma_addr)) {
 			dev_err(cryp->dev, "dma map bytes error\n");
 			return -EINVAL;
 		}
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index b3a68d986..ad5c2cfe8 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -669,7 +669,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		return -ENOMEM;
 
 	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, blp)))
+	if (dma_mapping_error(dev, blp))
 		goto err_in;
 
 	for_each_sg(sgl, sg, n, i) {
@@ -682,7 +682,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 						      sg->length,
 						      DMA_BIDIRECTIONAL);
 		bufl->bufers[y].len = sg->length;
-		if (unlikely(dma_mapping_error(dev, bufl->bufers[y].addr)))
+		if (dma_mapping_error(dev, bufl->bufers[y].addr))
 			goto err_in;
 		sg_nctr++;
 	}
@@ -702,7 +702,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		if (unlikely(!buflout))
 			goto err_in;
 		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, bloutp)))
+		if (dma_mapping_error(dev, bloutp))
 			goto err_out;
 		bufers = buflout->bufers;
 		for_each_sg(sglout, sg, n, i) {
@@ -714,7 +714,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			bufers[y].addr = dma_map_single(dev, sg_virt(sg),
 							sg->length,
 							DMA_BIDIRECTIONAL);
-			if (unlikely(dma_mapping_error(dev, bufers[y].addr)))
+			if (dma_mapping_error(dev, bufers[y].addr))
 				goto err_out;
 			bufers[y].len = sg->length;
 			sg_nctr++;
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 2c863d253..0ef7e5801 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -275,8 +275,7 @@ static int qat_dh_compute_value(struct kpp_request *req)
 							     sg_virt(req->src),
 							     req->src_len,
 							     DMA_TO_DEVICE);
-			if (unlikely(dma_mapping_error(dev,
-						       qat_req->in.dh.in.b)))
+			if (dma_mapping_error(dev, qat_req->in.dh.in.b))
 				return ret;
 
 		} else {
@@ -306,7 +305,7 @@ static int qat_dh_compute_value(struct kpp_request *req)
 						   req->dst_len,
 						   DMA_FROM_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, qat_req->out.dh.r)))
+		if (dma_mapping_error(dev, qat_req->out.dh.r))
 			goto unmap_src;
 
 	} else {
@@ -323,13 +322,13 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dh.in.b,
 					 sizeof(struct qat_dh_input_params),
 					 DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
+	if (dma_mapping_error(dev, qat_req->phy_in))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dh.r,
 					  sizeof(struct qat_dh_output_params),
 					  DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
+	if (dma_mapping_error(dev, qat_req->phy_out))
 		goto unmap_in_params;
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
@@ -681,7 +680,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 		qat_req->src_align = NULL;
 		qat_req->in.rsa.enc.m = dma_map_single(dev, sg_virt(req->src),
 						   req->src_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.enc.m)))
+		if (dma_mapping_error(dev, qat_req->in.rsa.enc.m))
 			return ret;
 
 	} else {
@@ -702,7 +701,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 							req->dst_len,
 							DMA_FROM_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.enc.c)))
+		if (dma_mapping_error(dev, qat_req->out.rsa.enc.c))
 			goto unmap_src;
 
 	} else {
@@ -718,13 +717,13 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.enc.m,
 					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
+	if (dma_mapping_error(dev, qat_req->phy_in))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.enc.c,
 					  sizeof(struct qat_rsa_output_params),
 					  DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
+	if (dma_mapping_error(dev, qat_req->phy_out))
 		goto unmap_in_params;
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
@@ -825,7 +824,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		qat_req->src_align = NULL;
 		qat_req->in.rsa.dec.c = dma_map_single(dev, sg_virt(req->src),
 						   req->dst_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.dec.c)))
+		if (dma_mapping_error(dev, qat_req->in.rsa.dec.c))
 			return ret;
 
 	} else {
@@ -846,7 +845,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 						    req->dst_len,
 						    DMA_FROM_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.dec.m)))
+		if (dma_mapping_error(dev, qat_req->out.rsa.dec.m))
 			goto unmap_src;
 
 	} else {
@@ -866,13 +865,13 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.dec.c,
 					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
+	if (dma_mapping_error(dev, qat_req->phy_in))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.dec.m,
 					  sizeof(struct qat_rsa_output_params),
 					  DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
+	if (dma_mapping_error(dev, qat_req->phy_out))
 		goto unmap_in_params;
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
diff --git a/drivers/i2c/busses/i2c-amd-mp2-plat.c b/drivers/i2c/busses/i2c-amd-mp2-plat.c
index 506433bc0..23a4dd1af 100644
--- a/drivers/i2c/busses/i2c-amd-mp2-plat.c
+++ b/drivers/i2c/busses/i2c-amd-mp2-plat.c
@@ -51,7 +51,7 @@ static int i2c_amd_dma_map(struct amd_i2c_common *i2c_common)
 					      i2c_common->msg->len,
 					      dma_direction);
 
-	if (unlikely(dma_mapping_error(dev_pci, i2c_common->dma_addr))) {
+	if (dma_mapping_error(dev_pci, i2c_common->dma_addr)) {
 		dev_err(&i2c_dev->pdev->dev,
 			"Error while mapping dma buffer %p\n",
 			i2c_common->dma_buf);
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index a307d4c8b..2fedcb2c5 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -3162,7 +3162,7 @@ int ext_coal_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx,
 				      tx->tlen,
 				      DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(&dd->pcidev->dev, addr))) {
+		if (dma_mapping_error(&dd->pcidev->dev, addr)) {
 			__sdma_txclean(dd, tx);
 			return -ENOSPC;
 		}
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 9c5891bbf..895bdd6ec 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -506,7 +506,7 @@ greth_start_xmit_gbit(struct sk_buff *skb, struct net_device *dev)
 	greth_write_bd(&bdp->stat, status);
 	dma_addr = dma_map_single(greth->dev, skb->data, skb_headlen(skb), DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(greth->dev, dma_addr)))
+	if (dma_mapping_error(greth->dev, dma_addr))
 		goto map_error;
 
 	greth_write_bd(&bdp->addr, dma_addr);
@@ -539,7 +539,7 @@ greth_start_xmit_gbit(struct sk_buff *skb, struct net_device *dev)
 		dma_addr = skb_frag_dma_map(greth->dev, frag, 0, skb_frag_size(frag),
 					    DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(greth->dev, dma_addr)))
+		if (dma_mapping_error(greth->dev, dma_addr))
 			goto frag_map_error;
 
 		greth_write_bd(&bdp->addr, dma_addr);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 06596fa1f..abdd531db 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -257,7 +257,7 @@ static int ena_xdp_tx_map_frame(struct ena_ring *xdp_ring,
 				     *push_hdr + *push_len,
 				     size - *push_len,
 				     DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(xdp_ring->dev, dma)))
+		if (dma_mapping_error(xdp_ring->dev, dma))
 			goto error_report_dma_error;
 
 		tx_info->map_linear_data = 1;
@@ -1004,7 +1004,7 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 	 */
 	dma = dma_map_page(rx_ring->dev, page, 0, ENA_PAGE_SIZE,
 			   DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(rx_ring->dev, dma))) {
+	if (dma_mapping_error(rx_ring->dev, dma)) {
 		ena_increase_stat(&rx_ring->rx_stats.dma_mapping_err, 1,
 				  &rx_ring->syncp);
 
@@ -2951,7 +2951,7 @@ static int ena_tx_map_skb(struct ena_ring *tx_ring,
 	if (skb_head_len > push_len) {
 		dma = dma_map_single(tx_ring->dev, skb->data + push_len,
 				     skb_head_len - push_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(tx_ring->dev, dma)))
+		if (dma_mapping_error(tx_ring->dev, dma))
 			goto error_report_dma_error;
 
 		ena_buf->paddr = dma;
@@ -2978,7 +2978,7 @@ static int ena_tx_map_skb(struct ena_ring *tx_ring,
 
 		dma = skb_frag_dma_map(tx_ring->dev, frag, delta,
 				       frag_len - delta, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(tx_ring->dev, dma)))
+		if (dma_mapping_error(tx_ring->dev, dma))
 			goto error_report_dma_error;
 
 		ena_buf->paddr = dma;
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 5f1fc6582..d2c9ea5ac 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -95,7 +95,7 @@ static int xgene_enet_refill_pagepool(struct xgene_enet_desc_ring *buf_pool,
 
 		dma_addr = dma_map_page(dev, page, 0,
 					PAGE_SIZE, DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(dev, dma_addr))) {
+		if (dma_mapping_error(dev, dma_addr)) {
 			put_page(page);
 			return -ENOMEM;
 		}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 6c049864d..e193a41ca 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -630,7 +630,7 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 				     dx_buff->len,
 				     DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(dev, dx_buff->pa))) {
+	if (dma_mapping_error(dev, dx_buff->pa)) {
 		ret = 0;
 		goto exit;
 	}
@@ -668,8 +668,7 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 						   buff_size,
 						   DMA_TO_DEVICE);
 
-			if (unlikely(dma_mapping_error(dev,
-						       frag_pa)))
+			if (dma_mapping_error(dev, frag_pa))
 				goto mapping_error;
 
 			dx = aq_ring_next_dx(ring, dx);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 24122ccda..514b1f9f5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -41,7 +41,7 @@ static int aq_get_rxpage(struct aq_rxpage *rxpage, unsigned int order,
 	daddr = dma_map_page(dev, page, 0, PAGE_SIZE << order,
 			     DMA_FROM_DEVICE);
 
-	if (unlikely(dma_mapping_error(dev, daddr)))
+	if (dma_mapping_error(dev, daddr))
 		goto free_page;
 
 	rxpage->page = page;
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index b56a9e2ae..15a02687e 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -695,7 +695,7 @@ static netdev_tx_t arc_emac_tx(struct sk_buff *skb, struct net_device *ndev)
 	addr = dma_map_single(&ndev->dev, (void *)skb->data, len,
 			      DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(&ndev->dev, addr))) {
+	if (dma_mapping_error(&ndev->dev, addr)) {
 		stats->tx_dropped++;
 		stats->tx_errors++;
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 3f65f2b37..7153e9a99 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1719,7 +1719,7 @@ static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter)
 		buffer_info->length = adapter->rx_buffer_len;
 		mapping = dma_map_single(&pdev->dev, vir_addr,
 					 buffer_info->length, DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(&pdev->dev, mapping))) {
+		if (dma_mapping_error(&pdev->dev, mapping)) {
 			dev_kfree_skb(skb);
 			buffer_info->skb = NULL;
 			buffer_info->length = 0;
@@ -2110,7 +2110,7 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 		buffer_info->dma = dma_map_single(&adapter->pdev->dev,
 						  skb->data, hdr_len,
 						  DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(&adapter->pdev->dev, buffer_info->dma)))
+		if (dma_mapping_error(&adapter->pdev->dev, buffer_info->dma))
 			goto err_dma;
 		ATL1C_SET_BUFFER_STATE(buffer_info, ATL1C_BUFFER_BUSY);
 		ATL1C_SET_PCIMAP_TYPE(buffer_info, ATL1C_PCIMAP_SINGLE,
@@ -2135,7 +2135,7 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 			dma_map_single(&adapter->pdev->dev,
 				       skb->data + mapped_len,
 				       buffer_info->length, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(&adapter->pdev->dev, buffer_info->dma)))
+		if (dma_mapping_error(&adapter->pdev->dev, buffer_info->dma))
 			goto err_dma;
 
 		ATL1C_SET_BUFFER_STATE(buffer_info, ATL1C_BUFFER_BUSY);
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 98ec1b8a7..065f26695 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -161,7 +161,7 @@ static netdev_tx_t bgmac_dma_tx_add(struct bgmac *bgmac,
 
 	slot->dma_addr = dma_map_single(dma_dev, skb->data, skb_headlen(skb),
 					DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dma_dev, slot->dma_addr)))
+	if (dma_mapping_error(dma_dev, slot->dma_addr))
 		goto err_dma_head;
 
 	flags = BGMAC_DESC_CTL0_SOF;
@@ -179,7 +179,7 @@ static netdev_tx_t bgmac_dma_tx_add(struct bgmac *bgmac,
 		slot = &ring->slots[index];
 		slot->dma_addr = skb_frag_dma_map(dma_dev, frag, 0,
 						  len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dma_dev, slot->dma_addr)))
+		if (dma_mapping_error(dma_dev, slot->dma_addr))
 			goto err_dma;
 
 		if (i == nr_frags - 1)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 1a6ec1a12..d48459fb7 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -453,7 +453,7 @@ static void bnx2x_tpa_start(struct bnx2x_fastpath *fp, u16 queue,
 	 *  when TPA_STOP arrives.
 	 */
 
-	if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
+	if (dma_mapping_error(&bp->pdev->dev, mapping)) {
 		/* Move the BD from the consumer to the producer */
 		bnx2x_reuse_rx_data(fp, cons, prod);
 		tpa_info->tpa_state = BNX2X_TPA_ERROR;
@@ -562,7 +562,7 @@ static int bnx2x_alloc_rx_sge(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 
 	mapping = dma_map_page(&bp->pdev->dev, pool->page,
 			       pool->offset, SGE_PAGE_SIZE, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
+	if (dma_mapping_error(&bp->pdev->dev, mapping)) {
 		BNX2X_ERR("Can't map sge\n");
 		return -ENOMEM;
 	}
@@ -839,7 +839,7 @@ static int bnx2x_alloc_rx_data(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 	mapping = dma_map_single(&bp->pdev->dev, data + NET_SKB_PAD,
 				 fp->rx_buf_size,
 				 DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
+	if (dma_mapping_error(&bp->pdev->dev, mapping)) {
 		bnx2x_frag_free(fp, data);
 		BNX2X_ERR("Can't map rx data\n");
 		return -ENOMEM;
@@ -3830,7 +3830,7 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Map skb linear data for DMA */
 	mapping = dma_map_single(&bp->pdev->dev, skb->data,
 				 skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
+	if (dma_mapping_error(&bp->pdev->dev, mapping)) {
 		DP(NETIF_MSG_TX_QUEUED,
 		   "SKB mapping failed - silently dropping this SKB\n");
 		dev_kfree_skb_any(skb);
@@ -4076,7 +4076,7 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		mapping = skb_frag_dma_map(&bp->pdev->dev, frag, 0,
 					   skb_frag_size(frag), DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
+		if (dma_mapping_error(&bp->pdev->dev, mapping)) {
 			unsigned int pkts_compl = 0, bytes_compl = 0;
 
 			DP(NETIF_MSG_TX_QUEUED,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 32245bbe8..3d5660d8e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -2558,7 +2558,7 @@ static int bnx2x_run_loopback(struct bnx2x *bp, int loopback_mode)
 		packet[i] = (unsigned char) (i & 0xff);
 	mapping = dma_map_single(&bp->pdev->dev, skb->data,
 				 skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
+	if (dma_mapping_error(&bp->pdev->dev, mapping)) {
 		rc = -ENOMEM;
 		dev_kfree_skb(skb);
 		DP(BNX2X_MSG_ETHTOOL, "Unable to map SKB\n");
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4edd6f8e0..d63338a22 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -482,7 +482,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(&pdev->dev, mapping))) {
+	if (dma_mapping_error(&pdev->dev, mapping)) {
 		dev_kfree_skb_any(skb);
 		tx_buf->skb = NULL;
 		return NETDEV_TX_OK;
@@ -545,7 +545,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		mapping = skb_frag_dma_map(&pdev->dev, frag, 0, len,
 					   DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(&pdev->dev, mapping)))
+		if (dma_mapping_error(&pdev->dev, mapping))
 			goto tx_dma_error;
 
 		tx_buf = &txr->tx_buf_ring[prod];
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 196652a11..6964f7a9c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -567,7 +567,7 @@ static unsigned int refill_fl(struct adapter *adap, struct sge_fl *q, int n,
 		mapping = dma_map_page(adap->pdev_dev, pg, 0,
 				       PAGE_SIZE << s->fl_pg_order,
 				       PCI_DMA_FROMDEVICE);
-		if (unlikely(dma_mapping_error(adap->pdev_dev, mapping))) {
+		if (dma_mapping_error(adap->pdev_dev, mapping)) {
 			__free_pages(pg, s->fl_pg_order);
 			q->mapping_err++;
 			goto out;   /* do not try small pages for this error */
@@ -597,7 +597,7 @@ static unsigned int refill_fl(struct adapter *adap, struct sge_fl *q, int n,
 
 		mapping = dma_map_page(adap->pdev_dev, pg, 0, PAGE_SIZE,
 				       PCI_DMA_FROMDEVICE);
-		if (unlikely(dma_mapping_error(adap->pdev_dev, mapping))) {
+		if (dma_mapping_error(adap->pdev_dev, mapping)) {
 			put_page(pg);
 			q->mapping_err++;
 			goto out;
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 95657da0a..f79bdd1b5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -645,7 +645,7 @@ static unsigned int refill_fl(struct adapter *adapter, struct sge_fl *fl,
 		dma_addr = dma_map_page(adapter->pdev_dev, page, 0,
 					PAGE_SIZE << s->fl_pg_order,
 					PCI_DMA_FROMDEVICE);
-		if (unlikely(dma_mapping_error(adapter->pdev_dev, dma_addr))) {
+		if (dma_mapping_error(adapter->pdev_dev, dma_addr)) {
 			/*
 			 * We've run out of DMA mapping space.  Free up the
 			 * buffer and return with what we've managed to put
@@ -683,7 +683,7 @@ static unsigned int refill_fl(struct adapter *adapter, struct sge_fl *fl,
 
 		dma_addr = dma_map_page(adapter->pdev_dev, page, 0, PAGE_SIZE,
 				       PCI_DMA_FROMDEVICE);
-		if (unlikely(dma_mapping_error(adapter->pdev_dev, dma_addr))) {
+		if (dma_mapping_error(adapter->pdev_dev, dma_addr)) {
 			put_page(page);
 			break;
 		}
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 88bfe2107..4e7815c3c 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -398,7 +398,7 @@ static int ftgmac100_alloc_rx_buf(struct ftgmac100 *priv, unsigned int entry,
 	} else {
 		map = dma_map_single(priv->dev, skb->data, RX_BUF_SIZE,
 				     DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(priv->dev, map))) {
+		if (dma_mapping_error(priv->dev, map)) {
 			if (net_ratelimit())
 				netdev_err(netdev, "failed to map rx page\n");
 			dev_kfree_skb_any(skb);
diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 473b337b2..10398a5fc 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -670,7 +670,7 @@ static int ftmac100_alloc_rx_page(struct ftmac100 *priv,
 	}
 
 	map = dma_map_page(priv->dev, page, 0, RX_BUF_SIZE, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(priv->dev, map))) {
+	if (dma_mapping_error(priv->dev, map)) {
 		if (net_ratelimit())
 			netdev_err(netdev, "failed to map rx page\n");
 		__free_page(page);
@@ -1015,7 +1015,7 @@ ftmac100_hard_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	}
 
 	map = dma_map_single(priv->dev, skb->data, skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(priv->dev, map))) {
+	if (dma_mapping_error(priv->dev, map)) {
 		/* drop packet */
 		if (net_ratelimit())
 			netdev_err(netdev, "map socket buffer failed\n");
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 4360ce4d3..f261becd5 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1548,8 +1548,7 @@ static int dpaa_bp_add_8_bufs(const struct dpaa_bp *dpaa_bp)
 
 		addr = dma_map_page(dpaa_bp->priv->rx_dma_dev, p, 0,
 				    DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(dpaa_bp->priv->rx_dma_dev,
-					       addr))) {
+		if (dma_mapping_error(dpaa_bp->priv->rx_dma_dev, addr)) {
 			netdev_err(net_dev, "DMA map failed\n");
 			goto release_previous_buffs;
 		}
@@ -1949,7 +1948,7 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 	/* Map the entire buffer size that may be seen by FMan, but no more */
 	addr = dma_map_single(priv->tx_dma_dev, buff_start,
 			      priv->tx_headroom + skb->len, dma_dir);
-	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+	if (dma_mapping_error(priv->tx_dma_dev, addr)) {
 		if (net_ratelimit())
 			netif_err(priv, tx_err, net_dev, "dma_map_single() failed\n");
 		return -EINVAL;
@@ -2004,7 +2003,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	sgt[0].offset = 0;
 	addr = dma_map_single(priv->tx_dma_dev, skb->data,
 			      skb_headlen(skb), dma_dir);
-	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+	if (dma_mapping_error(priv->tx_dma_dev, addr)) {
 		netdev_err(priv->net_dev, "DMA mapping failed\n");
 		err = -EINVAL;
 		goto sg0_map_failed;
@@ -2018,7 +2017,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 		WARN_ON(!skb_frag_page(frag));
 		addr = skb_frag_dma_map(priv->tx_dma_dev, frag, 0,
 					frag_len, dma_dir);
-		if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+		if (dma_mapping_error(priv->tx_dma_dev, addr)) {
 			netdev_err(priv->net_dev, "DMA mapping failed\n");
 			err = -EINVAL;
 			goto sg_map_failed;
@@ -2044,7 +2043,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 
 	addr = dma_map_page(priv->tx_dma_dev, p, 0,
 			    priv->tx_headroom + DPAA_SGT_SIZE, dma_dir);
-	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+	if (dma_mapping_error(priv->tx_dma_dev, addr)) {
 		netdev_err(priv->net_dev, "DMA mapping failed\n");
 		err = -EINVAL;
 		goto sgt_map_failed;
@@ -2488,7 +2487,7 @@ static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
 	addr = dma_map_single(priv->tx_dma_dev, buff_start,
 			      xdpf->headroom + xdpf->len,
 			      DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+	if (dma_mapping_error(priv->tx_dma_dev, addr)) {
 		err = -EINVAL;
 		goto out_error;
 	}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 91cff93db..0065f32b9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -806,7 +806,7 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 
 	/* Separately map the SGT buffer */
 	addr = dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(dev, addr))) {
+	if (dma_mapping_error(dev, addr)) {
 		err = -ENOMEM;
 		goto dma_map_single_failed;
 	}
@@ -863,7 +863,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
 
 	addr = dma_map_single(dev, skb->data, skb->len, DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(dev, addr))) {
+	if (dma_mapping_error(dev, addr)) {
 		err = -ENOMEM;
 		goto data_map_failed;
 	}
@@ -882,7 +882,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 
 	/* Separately map the SGT buffer */
 	sgt_addr = dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(dev, sgt_addr))) {
+	if (dma_mapping_error(dev, sgt_addr)) {
 		err = -ENOMEM;
 		goto sgt_map_failed;
 	}
@@ -939,7 +939,7 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
 	addr = dma_map_single(dev, buffer_start,
 			      skb_tail_pointer(skb) - buffer_start,
 			      DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(dev, addr)))
+	if (dma_mapping_error(dev, addr))
 		return -ENOMEM;
 
 	dpaa2_fd_set_addr(fd, addr);
@@ -1333,7 +1333,7 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 
 		addr = dma_map_page(dev, page, 0, priv->rx_buf_size,
 				    DMA_BIDIRECTIONAL);
-		if (unlikely(dma_mapping_error(dev, addr)))
+		if (dma_mapping_error(dev, addr))
 			goto err_map;
 
 		buf_array[i] = addr;
@@ -2317,7 +2317,7 @@ static int dpaa2_eth_xdp_create_fd(struct net_device *net_dev,
 	addr = dma_map_single(dev, buffer_start,
 			      swa->xdp.dma_size,
 			      DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(dev, addr)))
+	if (dma_mapping_error(dev, addr))
 		return -ENOMEM;
 
 	dpaa2_fd_set_addr(fd, addr);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c78d12229..ac9d74fb9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -93,7 +93,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 	prefetchw(txbd);
 
 	dma = dma_map_single(tx_ring->dev, skb->data, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(tx_ring->dev, dma)))
+	if (dma_mapping_error(tx_ring->dev, dma))
 		goto dma_err;
 
 	temp_bd.addr = cpu_to_le64(dma);
@@ -443,7 +443,7 @@ static bool enetc_new_page(struct enetc_bdr *rx_ring,
 		return false;
 
 	addr = dma_map_page(rx_ring->dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(rx_ring->dev, addr))) {
+	if (dma_mapping_error(rx_ring->dev, addr)) {
 		__free_page(page);
 
 		return false;
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index d391a45ce..5ff80bfb9 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -1247,7 +1247,7 @@ static bool gfar_new_page(struct gfar_priv_rx_q *rxq, struct gfar_rx_buff *rxb)
 		return false;
 
 	addr = dma_map_page(rxq->dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(rxq->dev, addr))) {
+	if (dma_mapping_error(rxq->dev, addr)) {
 		__free_page(page);
 
 		return false;
@@ -1900,7 +1900,7 @@ static netdev_tx_t gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	bufaddr = dma_map_single(priv->dev, skb->data, skb_headlen(skb),
 				 DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(priv->dev, bufaddr)))
+	if (dma_mapping_error(priv->dev, bufaddr))
 		goto dma_map_err;
 
 	txbdp_start->bufPtr = cpu_to_be32(bufaddr);
@@ -1935,7 +1935,7 @@ static netdev_tx_t gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			bufaddr = skb_frag_dma_map(priv->dev, frag, 0,
 						   size, DMA_TO_DEVICE);
-			if (unlikely(dma_mapping_error(priv->dev, bufaddr)))
+			if (dma_mapping_error(priv->dev, bufaddr))
 				goto dma_map_err;
 
 			/* set the TxBD length and buffer pointer */
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 6938f3a93..8b5f9d7a4 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -524,7 +524,7 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
 	info->skb =  skb;
 
 	addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(tx->dev, addr))) {
+	if (dma_mapping_error(tx->dev, addr)) {
 		tx->dma_mapping_error++;
 		goto drop;
 	}
@@ -558,7 +558,7 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
 		seg_desc = &tx->desc[idx];
 		len = skb_frag_size(frag);
 		addr = skb_frag_dma_map(tx->dev, frag, 0, len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(tx->dev, addr))) {
+		if (dma_mapping_error(tx->dev, addr)) {
 			tx->dma_mapping_error++;
 			goto unmap_drop;
 		}
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 57c3bc4f7..d636b1c5a 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -525,7 +525,7 @@ static netdev_tx_t hisi_femac_net_xmit(struct sk_buff *skb,
 
 	addr = dma_map_single(priv->dev, skb->data,
 			      skb->len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(priv->dev, addr))) {
+	if (dma_mapping_error(priv->dev, addr)) {
 		dev_kfree_skb_any(skb);
 		dev->stats.tx_dropped++;
 		return NETDEV_TX_OK;
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 8b2bf8503..45b60ba49 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -712,7 +712,7 @@ static int hix5hd2_fill_sg_desc(struct hix5hd2_priv *priv,
 	desc->total_len = cpu_to_le32(skb->len);
 	addr = dma_map_single(priv->dev, skb->data, skb_headlen(skb),
 			      DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(priv->dev, addr)))
+	if (dma_mapping_error(priv->dev, addr))
 		return -EINVAL;
 	desc->linear_addr = cpu_to_le32(addr);
 	desc->linear_len = cpu_to_le32(skb_headlen(skb));
@@ -766,7 +766,7 @@ static netdev_tx_t hix5hd2_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	} else {
 		addr = dma_map_single(priv->dev, skb->data, skb->len,
 				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(priv->dev, addr))) {
+		if (dma_mapping_error(priv->dev, addr)) {
 			dev_kfree_skb_any(skb);
 			dev->stats.tx_dropped++;
 			return NETDEV_TX_OK;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4c2fb8688..ff9e8600f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1188,7 +1188,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		dma = skb_frag_dma_map(dev, frag, 0, size, DMA_TO_DEVICE);
 	}
 
-	if (unlikely(dma_mapping_error(dev, dma))) {
+	if (dma_mapping_error(dev, dma)) {
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.sw_err_cnt++;
 		u64_stats_update_end(&ring->syncp);
@@ -2462,7 +2462,7 @@ static int hns3_map_buffer(struct hns3_enet_ring *ring, struct hns3_desc_cb *cb)
 	cb->dma = dma_map_page(ring_to_dev(ring), cb->priv, 0,
 			       cb->length, ring_to_dma_dir(ring));
 
-	if (unlikely(dma_mapping_error(ring_to_dev(ring), cb->dma)))
+	if (dma_mapping_error(ring_to_dev(ring), cb->dma))
 		return -EIO;
 
 	return 0;
diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 51ed8a54d..1b5112c71 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -166,8 +166,7 @@ static int xrx200_alloc_skb(struct xrx200_chan *ch)
 	ch->dma.desc_base[ch->dma.desc].addr = dma_map_single(ch->priv->dev,
 			ch->skb[ch->dma.desc]->data, XRX200_DMA_DATA_LEN,
 			DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(ch->priv->dev,
-				       ch->dma.desc_base[ch->dma.desc].addr))) {
+	if (dma_mapping_error(ch->priv->dev, ch->dma.desc_base[ch->dma.desc].addr)) {
 		dev_kfree_skb_any(ch->skb[ch->dma.desc]);
 		ret = -ENOMEM;
 		goto skip;
@@ -308,7 +307,7 @@ static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
 	ch->skb[ch->dma.desc] = skb;
 
 	mapping = dma_map_single(priv->dev, skb->data, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(priv->dev, mapping)))
+	if (dma_mapping_error(priv->dev, mapping))
 		goto err_drop;
 
 	/* dma needs to start on a 16 byte aligned address */
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 90e6111ce..ee218d71f 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -750,8 +750,7 @@ txq_put_data_tso(struct net_device *dev, struct tx_queue *txq,
 		txq->tx_desc_mapping[tx_index] = DESC_DMA_MAP_SINGLE;
 		desc->buf_ptr = dma_map_single(dev->dev.parent, data,
 			length, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev->dev.parent,
-					       desc->buf_ptr))) {
+		if (dma_mapping_error(dev->dev.parent, desc->buf_ptr)) {
 			WARN(1, "dma_map_single failed!\n");
 			return -ENOMEM;
 		}
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 563ceac30..cb0ed101a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2636,8 +2636,7 @@ mvneta_tso_put_data(struct net_device *dev, struct mvneta_tx_queue *txq,
 	tx_desc->data_size = size;
 	tx_desc->buf_phys_addr = dma_map_single(dev->dev.parent, data,
 						size, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev->dev.parent,
-		     tx_desc->buf_phys_addr))) {
+	if (dma_mapping_error(dev->dev.parent, tx_desc->buf_phys_addr)) {
 		mvneta_txq_desc_put(txq);
 		return -ENOMEM;
 	}
@@ -2747,8 +2746,7 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 			dma_map_single(pp->dev->dev.parent, addr,
 				       tx_desc->data_size, DMA_TO_DEVICE);
 
-		if (dma_mapping_error(pp->dev->dev.parent,
-				      tx_desc->buf_phys_addr)) {
+		if (dma_mapping_error(pp->dev->dev.parent, tx_desc->buf_phys_addr)) {
 			mvneta_txq_desc_put(txq);
 			goto error;
 		}
@@ -2816,8 +2814,7 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 	tx_desc->buf_phys_addr = dma_map_single(dev->dev.parent, skb->data,
 						tx_desc->data_size,
 						DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev->dev.parent,
-				       tx_desc->buf_phys_addr))) {
+	if (dma_mapping_error(dev->dev.parent, tx_desc->buf_phys_addr)) {
 		mvneta_txq_desc_put(txq);
 		frags = 0;
 		goto out;
diff --git a/drivers/net/ethernet/marvell/mvneta_bm.c b/drivers/net/ethernet/marvell/mvneta_bm.c
index 46c942ef2..6b2776605 100644
--- a/drivers/net/ethernet/marvell/mvneta_bm.c
+++ b/drivers/net/ethernet/marvell/mvneta_bm.c
@@ -104,7 +104,7 @@ int mvneta_bm_construct(struct hwbm_pool *hwbm_pool, void *buf)
 	*(u32 *)buf = (u32)buf;
 	phys_addr = dma_map_single(&priv->pdev->dev, buf, bm_pool->buf_size,
 				   DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(&priv->pdev->dev, phys_addr)))
+	if (dma_mapping_error(&priv->pdev->dev, phys_addr))
 		return -ENOMEM;
 
 	mvneta_bm_pool_put_bp(priv, bm_pool, phys_addr);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index afdd22827..1cab75cfd 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -720,7 +720,7 @@ static void *mvpp2_buf_alloc(struct mvpp2_port *port,
 		dma_addr = dma_map_single(port->dev->dev.parent, data,
 					  MVPP2_RX_BUF_SIZE(bm_pool->pkt_size),
 					  DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(port->dev->dev.parent, dma_addr))) {
+		if (dma_mapping_error(port->dev->dev.parent, dma_addr)) {
 			mvpp2_frag_free(bm_pool, NULL, data);
 			return NULL;
 		}
@@ -3324,7 +3324,7 @@ mvpp2_xdp_submit_frame(struct mvpp2_port *port, u16 txq_id,
 		dma_addr = dma_map_single(port->dev->dev.parent, xdpf->data,
 					  xdpf->len, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(port->dev->dev.parent, dma_addr))) {
+		if (dma_mapping_error(port->dev->dev.parent, dma_addr)) {
 			mvpp2_txq_desc_put(txq);
 			ret = MVPP2_XDP_DROPPED;
 			goto out;
@@ -3864,7 +3864,7 @@ static inline int mvpp2_tso_put_data(struct sk_buff *skb,
 
 	buf_dma_addr = dma_map_single(dev->dev.parent, tso->data, sz,
 				      DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev->dev.parent, buf_dma_addr))) {
+	if (dma_mapping_error(dev->dev.parent, buf_dma_addr)) {
 		mvpp2_txq_desc_put(txq);
 		return -ENOMEM;
 	}
@@ -3983,7 +3983,7 @@ static netdev_tx_t mvpp2_tx(struct sk_buff *skb, struct net_device *dev)
 
 	buf_dma_addr = dma_map_single(dev->dev.parent, skb->data,
 				      skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev->dev.parent, buf_dma_addr))) {
+	if (dma_mapping_error(dev->dev.parent, buf_dma_addr)) {
 		mvpp2_txq_desc_put(txq);
 		frags = 0;
 		goto out;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 73fb94dd5..87f9a1f75 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -484,7 +484,7 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
 
 	iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
 				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
-	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
+	if (dma_mapping_error(pfvf->dev, iova)) {
 		page_frag_free(buf);
 		return -ENOMEM;
 	}
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6d2d60675..971be3bd8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -808,7 +808,7 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 	dma_addr = dma_map_single(eth->dev,
 				  eth->scratch_head, cnt * MTK_QDMA_PAGE_SIZE,
 				  DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(eth->dev, dma_addr)))
+	if (dma_mapping_error(eth->dev, dma_addr))
 		return -ENOMEM;
 
 	phy_ring_tail = eth->phy_scratch_ring +
@@ -956,7 +956,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 
 	mapped_addr = dma_map_single(eth->dev, skb->data,
 				     skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(eth->dev, mapped_addr)))
+	if (dma_mapping_error(eth->dev, mapped_addr))
 		return -ENOMEM;
 
 	WRITE_ONCE(itxd->txd1, mapped_addr);
@@ -998,7 +998,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 			mapped_addr = skb_frag_dma_map(eth->dev, frag, offset,
 						       frag_map_size,
 						       DMA_TO_DEVICE);
-			if (unlikely(dma_mapping_error(eth->dev, mapped_addr)))
+			if (dma_mapping_error(eth->dev, mapped_addr))
 				goto err_dma;
 
 			if (i == nr_frags - 1 &&
@@ -1292,7 +1292,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 					  eth->ip_align,
 					  ring->buf_size,
 					  DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(eth->dev, dma_addr))) {
+		if (dma_mapping_error(eth->dev, dma_addr)) {
 			skb_free_frag(new_data);
 			netdev->stats.rx_dropped++;
 			goto release_desc;
@@ -1695,7 +1695,7 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 				ring->data[i] + NET_SKB_PAD + eth->ip_align,
 				ring->buf_size,
 				DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(eth->dev, dma_addr)))
+		if (dma_mapping_error(eth->dev, dma_addr))
 			return -ENOMEM;
 		ring->dma[i].rxd1 = (unsigned int)dma_addr;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 7954c1daf..39f8b5f99 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -61,7 +61,7 @@ static int mlx4_alloc_page(struct mlx4_en_priv *priv,
 	if (unlikely(!page))
 		return -ENOMEM;
 	dma = dma_map_page(priv->ddev, page, 0, PAGE_SIZE, priv->dma_dir);
-	if (unlikely(dma_mapping_error(priv->ddev, dma))) {
+	if (dma_mapping_error(priv->ddev, dma)) {
 		__free_page(page);
 		return -ENOMEM;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index ed4fb79b4..e8e8e6742 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -85,7 +85,7 @@ static int mlx5_rsc_dump_trigger(struct mlx5_core_dev *dev, struct mlx5_rsc_dump
 	int err;
 
 	dma = dma_map_page(ddev, page, 0, cmd->mem_size, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(ddev, dma)))
+	if (dma_mapping_error(ddev, dma))
 		return -ENOMEM;
 
 	in_seq_num = MLX5_GET(resource_dump, cmd->cmd, seq_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 2e3e78b0f..8d948df89 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -529,7 +529,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		xdptxd.dma_addr = dma_map_single(sq->pdev, xdptxd.data,
 						 xdptxd.len, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(sq->pdev, xdptxd.dma_addr))) {
+		if (dma_mapping_error(sq->pdev, xdptxd.dma_addr)) {
 			xdp_return_frame_rx_napi(xdpf);
 			drops++;
 			continue;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 6a1d82503..478d2e663 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -256,7 +256,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 	pdev = mlx5_core_dma_dev(sq->channel->priv->mdev);
 	buf->dma_addr = dma_map_single(pdev, &buf->progress,
 				       PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(pdev, buf->dma_addr))) {
+	if (dma_mapping_error(pdev, buf->dma_addr)) {
 		err = -ENOMEM;
 		goto err_free;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index d16def68e..31dedccf2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -324,7 +324,7 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn, bool fir
 	fsz = skb_frag_size(frag);
 	dma_addr = skb_frag_dma_map(sq->pdev, frag, 0, fsz,
 				    DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sq->pdev, dma_addr)))
+	if (dma_mapping_error(sq->pdev, dma_addr))
 		return -ENOMEM;
 
 	dseg->addr       = cpu_to_be64(dma_addr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7f5851c61..e18ba719a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -277,7 +277,7 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
 
 	dma_info->addr = dma_map_page(rq->pdev, dma_info->page, 0,
 				      PAGE_SIZE, rq->buff.map_dir);
-	if (unlikely(dma_mapping_error(rq->pdev, dma_info->addr))) {
+	if (dma_mapping_error(rq->pdev, dma_info->addr)) {
 		page_pool_recycle_direct(rq->page_pool, dma_info->page);
 		dma_info->page = NULL;
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index e47e2a005..46edc4fac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -282,7 +282,7 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	if (headlen) {
 		dma_addr = dma_map_single(sq->pdev, skb_data, headlen,
 					  DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(sq->pdev, dma_addr)))
+		if (dma_mapping_error(sq->pdev, dma_addr))
 			goto dma_unmap_wqe_err;
 
 		dseg->addr       = cpu_to_be64(dma_addr);
@@ -300,7 +300,7 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 		dma_addr = skb_frag_dma_map(sq->pdev, frag, 0, fsz,
 					    DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(sq->pdev, dma_addr)))
+		if (dma_mapping_error(sq->pdev, dma_addr))
 			goto dma_unmap_wqe_err;
 
 		dseg->addr       = cpu_to_be64(dma_addr);
@@ -642,7 +642,7 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	txd.len = skb->len;
 
 	txd.dma_addr = dma_map_single(sq->pdev, txd.data, txd.len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sq->pdev, txd.dma_addr)))
+	if (dma_mapping_error(sq->pdev, txd.dma_addr))
 		goto err_unmap;
 	mlx5e_dma_push(sq, txd.dma_addr, txd.len, MLX5E_DMA_MAP_SINGLE);
 
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index da48dd857..289ad74a8 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -1184,7 +1184,7 @@ __vxge_hw_blockpool_create(struct __vxge_hw_device *hldev,
 		dma_addr = dma_map_single(&hldev->pdev->dev, memblock,
 					  VXGE_HW_BLOCK_SIZE,
 					  DMA_BIDIRECTIONAL);
-		if (unlikely(dma_mapping_error(&hldev->pdev->dev, dma_addr))) {
+		if (dma_mapping_error(&hldev->pdev->dev, dma_addr)) {
 			vxge_os_dma_free(hldev->pdev, memblock, &acc_handle);
 			__vxge_hw_blockpool_destroy(blockpool);
 			status = VXGE_HW_ERR_OUT_OF_MEMORY;
@@ -2270,7 +2270,7 @@ static void vxge_hw_blockpool_block_add(struct __vxge_hw_device *devh,
 	dma_addr = dma_map_single(&devh->pdev->dev, block_addr, length,
 				  DMA_BIDIRECTIONAL);
 
-	if (unlikely(dma_mapping_error(&devh->pdev->dev, dma_addr))) {
+	if (dma_mapping_error(&devh->pdev->dev, dma_addr)) {
 		vxge_os_dma_free(devh->pdev, block_addr, &acc_handle);
 		blockpool->req_out--;
 		goto exit;
@@ -2358,7 +2358,7 @@ static void *__vxge_hw_blockpool_malloc(struct __vxge_hw_device *devh, u32 size,
 		dma_object->addr = dma_map_single(&devh->pdev->dev, memblock,
 						  size, DMA_BIDIRECTIONAL);
 
-		if (unlikely(dma_mapping_error(&devh->pdev->dev, dma_object->addr))) {
+		if (dma_mapping_error(&devh->pdev->dev, dma_object->addr)) {
 			vxge_os_dma_free(devh->pdev, memblock,
 				&dma_object->acc_handle);
 			memblock = NULL;
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 87892bd99..af324429f 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -244,7 +244,7 @@ static int vxge_rx_map(void *dtrh, struct vxge_ring *ring)
 	dma_addr = dma_map_single(&ring->pdev->dev, rx_priv->skb_data,
 				  rx_priv->data_size, DMA_FROM_DEVICE);
 
-	if (unlikely(dma_mapping_error(&ring->pdev->dev, dma_addr))) {
+	if (dma_mapping_error(&ring->pdev->dev, dma_addr)) {
 		ring->stats.pci_map_fail++;
 		return -EIO;
 	}
@@ -901,7 +901,7 @@ vxge_xmit(struct sk_buff *skb, struct net_device *dev)
 	dma_pointer = dma_map_single(&fifo->pdev->dev, skb->data,
 				     first_frg_len, DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(&fifo->pdev->dev, dma_pointer))) {
+	if (dma_mapping_error(&fifo->pdev->dev, dma_pointer)) {
 		vxge_hw_fifo_txdl_free(fifo_hw, dtr);
 		fifo->stats.pci_map_fail++;
 		goto _exit0;
@@ -931,7 +931,7 @@ vxge_xmit(struct sk_buff *skb, struct net_device *dev)
 						    0, skb_frag_size(frag),
 						    DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(&fifo->pdev->dev, dma_pointer)))
+		if (dma_mapping_error(&fifo->pdev->dev, dma_pointer))
 			goto _exit2;
 		vxge_debug_tx(VXGE_TRACE,
 			"%s: %s:%d frag = %d dma_pointer = 0x%llx",
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 8724d6a9e..be2cf2e02 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1836,8 +1836,7 @@ static int nv_alloc_rx(struct net_device *dev)
 							     skb->data,
 							     skb_tailroom(skb),
 							     DMA_FROM_DEVICE);
-			if (unlikely(dma_mapping_error(&np->pci_dev->dev,
-						       np->put_rx_ctx->dma))) {
+			if (dma_mapping_error(&np->pci_dev->dev, np->put_rx_ctx->dma)) {
 				kfree_skb(skb);
 				goto packet_dropped;
 			}
@@ -1877,8 +1876,7 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
 							     skb->data,
 							     skb_tailroom(skb),
 							     DMA_FROM_DEVICE);
-			if (unlikely(dma_mapping_error(&np->pci_dev->dev,
-						       np->put_rx_ctx->dma))) {
+			if (dma_mapping_error(&np->pci_dev->dev, np->put_rx_ctx->dma)) {
 				kfree_skb(skb);
 				goto packet_dropped;
 			}
@@ -2253,8 +2251,7 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		np->put_tx_ctx->dma = dma_map_single(&np->pci_dev->dev,
 						     skb->data + offset, bcnt,
 						     DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(&np->pci_dev->dev,
-					       np->put_tx_ctx->dma))) {
+		if (dma_mapping_error(&np->pci_dev->dev, np->put_tx_ctx->dma)) {
 			/* on DMA mapping error - drop the packet */
 			dev_kfree_skb_any(skb);
 			u64_stats_update_begin(&np->swstats_tx_syncp);
@@ -2295,8 +2292,7 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 							frag, offset,
 							bcnt,
 							DMA_TO_DEVICE);
-			if (unlikely(dma_mapping_error(&np->pci_dev->dev,
-						       np->put_tx_ctx->dma))) {
+			if (dma_mapping_error(&np->pci_dev->dev, np->put_tx_ctx->dma)) {
 
 				/* Unwind the mapped fragments */
 				do {
@@ -2430,8 +2426,7 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 		np->put_tx_ctx->dma = dma_map_single(&np->pci_dev->dev,
 						     skb->data + offset, bcnt,
 						     DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(&np->pci_dev->dev,
-					       np->put_tx_ctx->dma))) {
+		if (dma_mapping_error(&np->pci_dev->dev, np->put_tx_ctx->dma)) {
 			/* on DMA mapping error - drop the packet */
 			dev_kfree_skb_any(skb);
 			u64_stats_update_begin(&np->swstats_tx_syncp);
@@ -2473,8 +2468,7 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 							bcnt,
 							DMA_TO_DEVICE);
 
-			if (unlikely(dma_mapping_error(&np->pci_dev->dev,
-						       np->put_tx_ctx->dma))) {
+			if (dma_mapping_error(&np->pci_dev->dev, np->put_tx_ctx->dma)) {
 
 				/* Unwind the mapped fragments */
 				do {
@@ -5178,8 +5172,7 @@ static int nv_loopback_test(struct net_device *dev)
 	test_dma_addr = dma_map_single(&np->pci_dev->dev, tx_skb->data,
 				       skb_tailroom(tx_skb),
 				       DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(&np->pci_dev->dev,
-				       test_dma_addr))) {
+	if (dma_mapping_error(&np->pci_dev->dev, test_dma_addr)) {
 		dev_kfree_skb_any(tx_skb);
 		goto out;
 	}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 9156c9825..37ce436ea 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -281,7 +281,7 @@ static int ionic_rx_page_alloc(struct ionic_queue *q,
 
 	page_info->dma_addr = dma_map_page(dev, page_info->page, 0, PAGE_SIZE,
 					   DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(dev, page_info->dma_addr))) {
+	if (dma_mapping_error(dev, page_info->dma_addr)) {
 		put_page(page_info->page);
 		page_info->dma_addr = 0;
 		page_info->page = NULL;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 49783f365..16d01fe29 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -2629,7 +2629,7 @@ static int qed_ll2_start_xmit(struct qed_dev *cdev, struct sk_buff *skb,
 
 	mapping = dma_map_single(&cdev->pdev->dev, skb->data,
 				 skb->len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(&cdev->pdev->dev, mapping))) {
+	if (dma_mapping_error(&cdev->pdev->dev, mapping)) {
 		DP_NOTICE(cdev, "SKB mapping failed\n");
 		return -EINVAL;
 	}
@@ -2672,7 +2672,7 @@ static int qed_ll2_start_xmit(struct qed_dev *cdev, struct sk_buff *skb,
 		mapping = skb_frag_dma_map(&cdev->pdev->dev, frag, 0,
 					   skb_frag_size(frag), DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(&cdev->pdev->dev, mapping))) {
+		if (dma_mapping_error(&cdev->pdev->dev, mapping)) {
 			DP_NOTICE(cdev,
 				  "Unable to map frag - dropping packet\n");
 			rc = -ENOMEM;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index bedbb85a1..b25692bbb 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -1482,7 +1482,7 @@ static int qede_selftest_transmit_traffic(struct qede_dev *edev,
 	/* Map skb linear data for DMA and set in the first BD */
 	mapping = dma_map_single(&edev->pdev->dev, skb->data,
 				 skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(&edev->pdev->dev, mapping))) {
+	if (dma_mapping_error(&edev->pdev->dev, mapping)) {
 		DP_NOTICE(edev, "SKB mapping failed\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index a2494bf85..907e3b5ca 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -48,7 +48,7 @@ int qede_alloc_rx_buffer(struct qede_rx_queue *rxq, bool allow_lazy)
 	 */
 	mapping = dma_map_page(rxq->dev, data, 0,
 			       PAGE_SIZE, rxq->data_direction);
-	if (unlikely(dma_mapping_error(rxq->dev, mapping))) {
+	if (dma_mapping_error(rxq->dev, mapping)) {
 		__free_page(data);
 		return -ENOMEM;
 	}
@@ -247,7 +247,7 @@ static int map_frag_to_bd(struct qede_tx_queue *txq,
 	/* Map skb non-linear frag data for DMA */
 	mapping = skb_frag_dma_map(txq->dev, frag, 0,
 				   skb_frag_size(frag), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(txq->dev, mapping)))
+	if (dma_mapping_error(txq->dev, mapping))
 		return -ENOMEM;
 
 	/* Setup the data pointer of the frag data */
@@ -364,7 +364,7 @@ int qede_xdp_transmit(struct net_device *dev, int n_frames,
 
 		mapping = dma_map_single(dmadev, xdpf->data, xdpf->len,
 					 DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dmadev, mapping))) {
+		if (dma_mapping_error(dmadev, mapping)) {
 			xdp_return_frame_rx_napi(xdpf);
 			drops++;
 
@@ -1542,7 +1542,7 @@ netdev_tx_t qede_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Map skb linear data for DMA and set in the first BD */
 	mapping = dma_map_single(txq->dev, skb->data,
 				 skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(txq->dev, mapping))) {
+	if (dma_mapping_error(txq->dev, mapping)) {
 		DP_NOTICE(edev, "SKB mapping failed\n");
 		qede_free_failed_tx_pkt(txq, first_bd, 0, false);
 		qede_update_tx_producer(txq);
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 46d8510b2..16612108c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3830,7 +3830,7 @@ static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
 		return NULL;
 
 	mapping = dma_map_page(d, data, 0, R8169_RX_BUF_SIZE, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(d, mapping))) {
+	if (dma_mapping_error(d, mapping)) {
 		netdev_err(tp->dev, "Failed to map RX DMA!\n");
 		__free_pages(data, get_order(R8169_RX_BUF_SIZE));
 		return NULL;
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index dd0bc7f0a..b1a6022a2 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1875,7 +1875,7 @@ static int rocker_tx_desc_frag_map_put(const struct rocker_port *rocker_port,
 	struct rocker_tlv *frag;
 
 	dma_handle = dma_map_single(&pdev->dev, buf, buf_len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(&pdev->dev, dma_handle))) {
+	if (dma_mapping_error(&pdev->dev, dma_handle)) {
 		if (net_ratelimit())
 			netdev_err(rocker_port->dev, "failed to dma map tx frag\n");
 		return -EIO;
diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
index 966f13e74..68b62402c 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -170,8 +170,7 @@ static int ef4_init_rx_buffers(struct ef4_rx_queue *rx_queue, bool atomic)
 				dma_map_page(&efx->pci_dev->dev, page, 0,
 					     PAGE_SIZE << efx->rx_buffer_order,
 					     DMA_FROM_DEVICE);
-			if (unlikely(dma_mapping_error(&efx->pci_dev->dev,
-						       dma_addr))) {
+			if (dma_mapping_error(&efx->pci_dev->dev, dma_addr)) {
 				__free_pages(page, efx->rx_buffer_order);
 				return -EIO;
 			}
diff --git a/drivers/net/ethernet/sfc/falcon/tx.c b/drivers/net/ethernet/sfc/falcon/tx.c
index f7306e93a..486ae15a7 100644
--- a/drivers/net/ethernet/sfc/falcon/tx.c
+++ b/drivers/net/ethernet/sfc/falcon/tx.c
@@ -222,7 +222,7 @@ static int ef4_tx_map_data(struct ef4_tx_queue *tx_queue, struct sk_buff *skb)
 	unmap_len = len;
 	unmap_addr = dma_addr;
 
-	if (unlikely(dma_mapping_error(dma_dev, dma_addr)))
+	if (dma_mapping_error(dma_dev, dma_addr))
 		return -EIO;
 
 	/* Add descriptors for each fragment. */
@@ -257,7 +257,7 @@ static int ef4_tx_map_data(struct ef4_tx_queue *tx_queue, struct sk_buff *skb)
 		unmap_len = len;
 		unmap_addr = dma_addr;
 
-		if (unlikely(dma_mapping_error(dma_dev, dma_addr)))
+		if (dma_mapping_error(dma_dev, dma_addr))
 			return -EIO;
 	} while (1);
 }
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 68fc7d317..4e3b72178 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -393,8 +393,7 @@ static int efx_init_rx_buffers(struct efx_rx_queue *rx_queue, bool atomic)
 				dma_map_page(&efx->pci_dev->dev, page, 0,
 					     PAGE_SIZE << efx->rx_buffer_order,
 					     DMA_FROM_DEVICE);
-			if (unlikely(dma_mapping_error(&efx->pci_dev->dev,
-						       dma_addr))) {
+			if (dma_mapping_error(&efx->pci_dev->dev, dma_addr)) {
 				__free_pages(page, efx->rx_buffer_order);
 				return -EIO;
 			}
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index d530cde2b..6b1bd889f 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -346,7 +346,7 @@ int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 	unmap_len = len;
 	unmap_addr = dma_addr;
 
-	if (unlikely(dma_mapping_error(dma_dev, dma_addr)))
+	if (dma_mapping_error(dma_dev, dma_addr))
 		return -EIO;
 
 	if (segment_count) {
@@ -395,7 +395,7 @@ int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 		unmap_len = len;
 		unmap_addr = dma_addr;
 
-		if (unlikely(dma_mapping_error(dma_dev, dma_addr)))
+		if (dma_mapping_error(dma_dev, dma_addr))
 			return -EIO;
 	} while (1);
 }
diff --git a/drivers/net/ethernet/sfc/tx_tso.c b/drivers/net/ethernet/sfc/tx_tso.c
index 898e5c61d..a7febf03a 100644
--- a/drivers/net/ethernet/sfc/tx_tso.c
+++ b/drivers/net/ethernet/sfc/tx_tso.c
@@ -202,7 +202,7 @@ static int tso_start(struct tso_state *st, struct efx_nic *efx,
 	st->dma_addr = dma_addr + header_len;
 	st->unmap_len = 0;
 
-	return unlikely(dma_mapping_error(dma_dev, dma_addr)) ? -ENOMEM : 0;
+	return dma_mapping_error(dma_dev, dma_addr) ? -ENOMEM : 0;
 }
 
 static int tso_get_fragment(struct tso_state *st, struct efx_nic *efx,
diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 620c26f71..457af6764 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -1193,8 +1193,7 @@ sis900_init_rx_ring(struct net_device *net_dev)
 							     skb->data,
 							     RX_BUF_SIZE,
 							     DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(&sis_priv->pci_dev->dev,
-					       sis_priv->rx_ring[i].bufptr))) {
+		if (dma_mapping_error(&sis_priv->pci_dev->dev, sis_priv->rx_ring[i].bufptr)) {
 			dev_kfree_skb(skb);
 			sis_priv->rx_skbuff[i] = NULL;
 			break;
@@ -1619,13 +1618,12 @@ sis900_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 	sis_priv->tx_ring[entry].bufptr = dma_map_single(&sis_priv->pci_dev->dev,
 							 skb->data, skb->len,
 							 DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(&sis_priv->pci_dev->dev,
-				       sis_priv->tx_ring[entry].bufptr))) {
-			dev_kfree_skb_any(skb);
-			sis_priv->tx_skbuff[entry] = NULL;
-			net_dev->stats.tx_dropped++;
-			spin_unlock_irqrestore(&sis_priv->lock, flags);
-			return NETDEV_TX_OK;
+	if (dma_mapping_error(&sis_priv->pci_dev->dev, sis_priv->tx_ring[entry].bufptr)) {
+		dev_kfree_skb_any(skb);
+		sis_priv->tx_skbuff[entry] = NULL;
+		net_dev->stats.tx_dropped++;
+		spin_unlock_irqrestore(&sis_priv->lock, flags);
+		return NETDEV_TX_OK;
 	}
 	sis_priv->tx_ring[entry].cmdsts = (OWN | INTR | skb->len);
 	sw32(cr, TxENA | sr32(cr));
@@ -1834,8 +1832,8 @@ static int sis900_rx(struct net_device *net_dev)
 				dma_map_single(&sis_priv->pci_dev->dev,
 					       skb->data, RX_BUF_SIZE,
 					       DMA_FROM_DEVICE);
-			if (unlikely(dma_mapping_error(&sis_priv->pci_dev->dev,
-						       sis_priv->rx_ring[entry].bufptr))) {
+			if (dma_mapping_error(&sis_priv->pci_dev->dev,
+					      sis_priv->rx_ring[entry].bufptr)) {
 				dev_kfree_skb_irq(skb);
 				sis_priv->rx_skbuff[entry] = NULL;
 				break;
@@ -1869,8 +1867,8 @@ static int sis900_rx(struct net_device *net_dev)
 				dma_map_single(&sis_priv->pci_dev->dev,
 					       skb->data, RX_BUF_SIZE,
 					       DMA_FROM_DEVICE);
-			if (unlikely(dma_mapping_error(&sis_priv->pci_dev->dev,
-						       sis_priv->rx_ring[entry].bufptr))) {
+			if (dma_mapping_error(&sis_priv->pci_dev->dev,
+					      sis_priv->rx_ring[entry].bufptr)) {
 				dev_kfree_skb_irq(skb);
 				sis_priv->rx_skbuff[entry] = NULL;
 				break;
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 501b9c7ab..afa9d23d6 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -553,7 +553,7 @@ static int ave_dma_map(struct net_device *ndev, struct ave_desc *desc,
 	dma_addr_t map_addr;
 
 	map_addr = dma_map_single(ndev->dev.parent, ptr, len, dir);
-	if (unlikely(dma_mapping_error(ndev->dev.parent, map_addr)))
+	if (dma_mapping_error(ndev->dev.parent, map_addr))
 		return -ENOMEM;
 
 	desc->skbs_dma = map_addr;
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 54b53dbdb..22b5a967b 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2038,7 +2038,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 			mapping = dma_map_single(hp->dma_dev, new_skb->data,
 						 RX_BUF_ALLOC_SIZE,
 						 DMA_FROM_DEVICE);
-			if (unlikely(dma_mapping_error(hp->dma_dev, mapping))) {
+			if (dma_mapping_error(hp->dma_dev, mapping)) {
 				dev_kfree_skb_any(new_skb);
 				drops++;
 				goto drop_it;
@@ -2318,7 +2318,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 
 		len = skb->len;
 		mapping = dma_map_single(hp->dma_dev, skb->data, len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(hp->dma_dev, mapping)))
+		if (dma_mapping_error(hp->dma_dev, mapping))
 			goto out_dma_error;
 		tx_flags |= (TXFLAG_SOP | TXFLAG_EOP);
 		hme_write_txd(hp, &hp->happy_block->happy_meal_txd[entry],
@@ -2335,7 +2335,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 		first_len = skb_headlen(skb);
 		first_mapping = dma_map_single(hp->dma_dev, skb->data, first_len,
 					       DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(hp->dma_dev, first_mapping)))
+		if (dma_mapping_error(hp->dma_dev, first_mapping))
 			goto out_dma_error;
 		entry = NEXT_TX(entry);
 
@@ -2346,7 +2346,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 			len = skb_frag_size(this_frag);
 			mapping = skb_frag_dma_map(hp->dma_dev, this_frag,
 						   0, len, DMA_TO_DEVICE);
-			if (unlikely(dma_mapping_error(hp->dma_dev, mapping))) {
+			if (dma_mapping_error(hp->dma_dev, mapping)) {
 				unmap_partial_tx_skb(hp, first_mapping, first_len,
 						     first_entry, entry);
 				goto out_dma_error;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 766e8866b..f2bf609bd 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -367,7 +367,7 @@ static int am65_cpsw_nuss_rx_push(struct am65_cpsw_common *common,
 	desc_dma = k3_cppi_desc_pool_virt2dma(rx_chn->desc_pool, desc_rx);
 
 	buf_dma = dma_map_single(dev, skb->data, pkt_len, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(dev, buf_dma))) {
+	if (dma_mapping_error(dev, buf_dma)) {
 		k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
 		dev_err(dev, "Failed to map rx skb buffer\n");
 		return -EINVAL;
@@ -1121,7 +1121,7 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 	/* Map the linear buffer */
 	buf_dma = dma_map_single(dev, skb->data, pkt_len,
 				 DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, buf_dma))) {
+	if (dma_mapping_error(dev, buf_dma)) {
 		dev_err(dev, "Failed to map tx skb buffer\n");
 		ndev->stats.tx_errors++;
 		goto err_free_skb;
@@ -1177,7 +1177,7 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 
 		buf_dma = skb_frag_dma_map(dev, frag, 0, frag_size,
 					   DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, buf_dma))) {
+		if (dma_mapping_error(dev, buf_dma)) {
 			dev_err(dev, "Failed to map tx skb page\n");
 			k3_cppi_desc_pool_free(tx_chn->desc_pool, next_desc);
 			ndev->stats.tx_errors++;
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index d7a144b4a..ce5c19689 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -883,7 +883,7 @@ static int netcp_allocate_rx_buf(struct netcp_intf *netcp, int fdq)
 		}
 		dma = dma_map_single(netcp->dev, bufptr, buf_len,
 				     DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(netcp->dev, dma)))
+		if (dma_mapping_error(netcp->dev, dma))
 			goto fail;
 
 		/* warning!!!! We are saving the virtual ptr in the sw_data
@@ -1090,7 +1090,7 @@ netcp_tx_map_skb(struct sk_buff *skb, struct netcp_intf *netcp)
 
 	/* Map the linear buffer */
 	dma_addr = dma_map_single(dev, skb->data, pkt_len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, dma_addr))) {
+	if (dma_mapping_error(dev, dma_addr)) {
 		dev_err(netcp->ndev_dev, "Failed to map skb buffer\n");
 		return NULL;
 	}
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 73ca597eb..52318530a 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1212,7 +1212,7 @@ static inline int rhine_skb_dma_init(struct net_device *dev,
 		return -ENOMEM;
 
 	sd->dma = dma_map_single(hwdev, sd->skb->data, size, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(hwdev, sd->dma))) {
+	if (dma_mapping_error(hwdev, sd->dma)) {
 		netif_err(rp, drv, dev, "Rx DMA mapping failure\n");
 		dev_kfree_skb_any(sd->skb);
 		return -EIO;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 6fea980ac..f914b30d5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -763,7 +763,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	phys = dma_map_single(ndev->dev.parent, skb->data,
 			      skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+	if (dma_mapping_error(ndev->dev.parent, phys)) {
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
@@ -781,7 +781,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 				      skb_frag_address(frag),
 				      skb_frag_size(frag),
 				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+		if (dma_mapping_error(ndev->dev.parent, phys)) {
 			if (net_ratelimit())
 				netdev_err(ndev, "TX DMA mapping error\n");
 			ndev->stats.tx_dropped++;
@@ -874,7 +874,7 @@ static void axienet_recv(struct net_device *ndev)
 		phys = dma_map_single(ndev->dev.parent, new_skb->data,
 				      lp->max_frm_size,
 				      DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+		if (dma_mapping_error(ndev->dev.parent, phys)) {
 			if (net_ratelimit())
 				netdev_err(ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9c4e6cf21..98c4f9c29 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -170,7 +170,7 @@ static int __ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
 				       skb->len + skb_tailroom(skb),
 				       DMA_FROM_DEVICE);
 
-		if (unlikely(dma_mapping_error(htt->ar->dev, paddr))) {
+		if (dma_mapping_error(htt->ar->dev, paddr)) {
 			dev_kfree_skb_any(skb);
 			ret = -ENOMEM;
 			goto fail;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8ab262931..063df651f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -779,7 +779,7 @@ static int __ath10k_pci_rx_post_buf(struct ath10k_pci_pipe *pipe)
 	paddr = dma_map_single(ar->dev, skb->data,
 			       skb->len + skb_tailroom(skb),
 			       DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(ar->dev, paddr))) {
+	if (dma_mapping_error(ar->dev, paddr)) {
 		ath10k_warn(ar, "failed to dma map pci rx buf\n");
 		dev_kfree_skb_any(skb);
 		return -EIO;
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index fd41f2545..e2121b5dd 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -505,7 +505,7 @@ static int __ath10k_snoc_rx_post_buf(struct ath10k_snoc_pipe *pipe)
 	paddr = dma_map_single(ar->dev, skb->data,
 			       skb->len + skb_tailroom(skb),
 			       DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(ar->dev, paddr))) {
+	if (dma_mapping_error(ar->dev, paddr)) {
 		ath10k_warn(ar, "failed to dma map snoc rx buf\n");
 		dev_kfree_skb_any(skb);
 		return -EIO;
diff --git a/drivers/net/wireless/ath/ath11k/ce.c b/drivers/net/wireless/ath/ath11k/ce.c
index 9d730f8ac..4a4c946cb 100644
--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -279,7 +279,7 @@ static int ath11k_ce_rx_post_pipe(struct ath11k_ce_pipe *pipe)
 		paddr = dma_map_single(ab->dev, skb->data,
 				       skb->len + skb_tailroom(skb),
 				       DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(ab->dev, paddr))) {
+		if (dma_mapping_error(ab->dev, paddr)) {
 			ath11k_warn(ab, "failed to dma map ce rx buf\n");
 			dev_kfree_skb_any(skb);
 			ret = -EIO;
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 5de619d5c..38388a6da 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2716,7 +2716,7 @@ static struct sk_buff *ath11k_dp_rx_alloc_mon_status_buf(struct ath11k_base *ab,
 	paddr = dma_map_single(ab->dev, skb->data,
 			       skb->len + skb_tailroom(skb),
 			       DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(ab->dev, paddr)))
+	if (dma_mapping_error(ab->dev, paddr))
 		goto fail_free_skb;
 
 	spin_lock_bh(&rx_ring->idr_lock);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4c6e57f99..7f8a0b632 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -617,7 +617,7 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_hw *ah, dma_addr_t *skb_addr)
 				   skb->data, common->rx_bufsize,
 				   DMA_FROM_DEVICE);
 
-	if (unlikely(dma_mapping_error(ah->dev, *skb_addr))) {
+	if (dma_mapping_error(ah->dev, *skb_addr)) {
 		ATH5K_ERR(ah, "%s: DMA mapping failed\n", __func__);
 		dev_kfree_skb(skb);
 		return NULL;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 71e2ada86..431b26931 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -154,7 +154,7 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 
 	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
 					 skb->len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
+	if (dma_mapping_error(sc->dev, bf->bf_buf_addr)) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 		bf->bf_buf_addr = 0;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0c0624a3b..0cbb82558 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -232,15 +232,13 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
 		bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
 						 common->rx_bufsize,
 						 DMA_BIDIRECTIONAL);
-		if (unlikely(dma_mapping_error(sc->dev,
-						bf->bf_buf_addr))) {
-				dev_kfree_skb_any(skb);
-				bf->bf_mpdu = NULL;
-				bf->bf_buf_addr = 0;
-				ath_err(common,
-					"dma_mapping_error() on RX init\n");
-				error = -ENOMEM;
-				goto rx_init_fail;
+		if (dma_mapping_error(sc->dev, bf->bf_buf_addr)) {
+			dev_kfree_skb_any(skb);
+			bf->bf_mpdu = NULL;
+			bf->bf_buf_addr = 0;
+			ath_err(common, "dma_mapping_error() on RX init\n");
+			error = -ENOMEM;
+			goto rx_init_fail;
 		}
 
 		list_add_tail(&bf->list, &sc->rx.rxbuf);
@@ -309,8 +307,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 		bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
 						 common->rx_bufsize,
 						 DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(sc->dev,
-					       bf->bf_buf_addr))) {
+		if (dma_mapping_error(sc->dev, bf->bf_buf_addr)) {
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
 			bf->bf_buf_addr = 0;
@@ -1134,7 +1131,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		/* We will now give hardware our shiny new allocated skb */
 		new_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
 					      common->rx_bufsize, dma_type);
-		if (unlikely(dma_mapping_error(sc->dev, new_buf_addr))) {
+		if (dma_mapping_error(sc->dev, new_buf_addr)) {
 			dev_kfree_skb_any(requeue_skb);
 			goto requeue_drop_frag;
 		}
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e60d4737f..0988e7c3a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2182,7 +2182,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 
 	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
 					 skb->len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
+	if (dma_mapping_error(sc->dev, bf->bf_buf_addr)) {
 		bf->bf_mpdu = NULL;
 		bf->bf_buf_addr = 0;
 		ath_err(ath9k_hw_common(sc->sc_ah),
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index cc830c795..49b64a558 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -276,7 +276,7 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct wil_ring *vring,
 	skb->ip_summed = CHECKSUM_NONE;
 
 	pa = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(dev, pa))) {
+	if (dma_mapping_error(dev, pa)) {
 		kfree_skb(skb);
 		return -ENOMEM;
 	}
@@ -1820,7 +1820,7 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct wil6210_vif *vif,
 	_hdr_desc = &vring->va[i].tx.legacy;
 
 	pa = dma_map_single(dev, skb->data, hdrlen, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, pa))) {
+	if (dma_mapping_error(dev, pa)) {
 		wil_err(wil, "TSO: Skb head DMA map error\n");
 		goto err_exit;
 	}
@@ -1878,7 +1878,7 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct wil6210_vif *vif,
 				headlen -= lenmss;
 			}
 
-			if (unlikely(dma_mapping_error(dev, pa))) {
+			if (dma_mapping_error(dev, pa)) {
 				wil_err(wil, "TSO: DMA map page error\n");
 				goto mem_error;
 			}
@@ -2064,7 +2064,7 @@ static int __wil_tx_ring(struct wil6210_priv *wil, struct wil6210_vif *vif,
 	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_OFFSET, 16, 1,
 			  skb->data, skb_headlen(skb), false);
 
-	if (unlikely(dma_mapping_error(dev, pa)))
+	if (dma_mapping_error(dev, pa))
 		return -EINVAL;
 	ring->ctx[i].mapped_as = wil_mapped_as_single;
 	/* 1-st segment */
@@ -2098,7 +2098,7 @@ static int __wil_tx_ring(struct wil6210_priv *wil, struct wil6210_vif *vif,
 		_d = &ring->va[i].tx.legacy;
 		pa = skb_frag_dma_map(dev, frag, 0, skb_frag_size(frag),
 				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, pa))) {
+		if (dma_mapping_error(dev, pa)) {
 			wil_err(wil, "Tx[%2d] failed to map fragment\n",
 				ring_index);
 			goto dma_error;
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 8ca2ce51c..a3cf34548 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -182,7 +182,7 @@ static int wil_ring_alloc_skb_edma(struct wil6210_priv *wil,
 	skb->ip_summed = CHECKSUM_NONE;
 
 	pa = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(dev, pa))) {
+	if (dma_mapping_error(dev, pa)) {
 		kfree_skb(skb);
 		return -ENOMEM;
 	}
@@ -1370,7 +1370,7 @@ static int wil_tx_tso_gen_desc(struct wil6210_priv *wil, void *buff_addr,
 		pa = skb_frag_dma_map(dev, frag, 0, len, DMA_TO_DEVICE);
 		ring->ctx[i].mapped_as = wil_mapped_as_page;
 	}
-	if (unlikely(dma_mapping_error(dev, pa))) {
+	if (dma_mapping_error(dev, pa)) {
 		wil_err(wil, "TSO: Skb DMA map error\n");
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless/broadcom/b43/dma.c
index 9a7c62bd5..d48f9f142 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -539,7 +539,7 @@ static bool b43_dma_mapping_error(struct b43_dmaring *ring,
 				  dma_addr_t addr,
 				  size_t buffersize, bool dma_to_device)
 {
-	if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
+	if (dma_mapping_error(ring->dev->dev->dma_dev, addr))
 		return true;
 
 	switch (ring->type) {
diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/wireless/broadcom/b43legacy/dma.c
index 7e2f70c42..30f56090d 100644
--- a/drivers/net/wireless/broadcom/b43legacy/dma.c
+++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
@@ -413,7 +413,7 @@ static bool b43legacy_dma_mapping_error(struct b43legacy_dmaring *ring,
 					 size_t buffersize,
 					 bool dma_to_device)
 {
-	if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
+	if (dma_mapping_error(ring->dev->dev->dma_dev, addr))
 		return true;
 
 	switch (ring->type) {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 966be5689..bfc704955 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1657,7 +1657,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 		dma_addr_t tb_phys = dma_map_single(trans->dev,
 						    skb->data + hdr_len,
 						    head_tb_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+		if (dma_mapping_error(trans->dev, tb_phys))
 			return -EINVAL;
 		trace_iwlwifi_dev_tx_tb(trans->dev, skb, skb->data + hdr_len,
 					tb_phys, head_tb_len);
@@ -1676,7 +1676,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 		tb_phys = skb_frag_dma_map(trans->dev, frag, 0,
 					   skb_frag_size(frag), DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+		if (dma_mapping_error(trans->dev, tb_phys))
 			return -EINVAL;
 		trace_iwlwifi_dev_tx_tb(trans->dev, skb, skb_frag_address(frag),
 					tb_phys, skb_frag_size(frag));
@@ -1828,7 +1828,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 		hdr_tb_len = hdr_page->pos - start_hdr;
 		hdr_tb_phys = dma_map_single(trans->dev, start_hdr,
 					     hdr_tb_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, hdr_tb_phys))) {
+		if (dma_mapping_error(trans->dev, hdr_tb_phys)) {
 			dev_kfree_skb(csum_skb);
 			return -EINVAL;
 		}
@@ -1853,7 +1853,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 
 			tb_phys = dma_map_single(trans->dev, tso.data,
 						 size, DMA_TO_DEVICE);
-			if (unlikely(dma_mapping_error(trans->dev, tb_phys))) {
+			if (dma_mapping_error(trans->dev, tb_phys)) {
 				dev_kfree_skb(csum_skb);
 				return -EINVAL;
 			}
@@ -2039,7 +2039,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	/* map the data for TB1 */
 	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_FIRST_TB_SIZE;
 	tb1_phys = dma_map_single(trans->dev, tb1_addr, tb1_len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(trans->dev, tb1_phys)))
+	if (dma_mapping_error(trans->dev, tb1_phys))
 		goto out_err;
 	iwl_pcie_txq_build_tfd(trans, txq, tb1_phys, tb1_len, false);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index af0b27a68..18eff5c33 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -282,7 +282,7 @@ static int iwl_txq_gen2_set_tb_with_wa(struct iwl_trans *trans,
 	struct page *page;
 	int ret;
 
-	if (unlikely(dma_mapping_error(trans->dev, phys)))
+	if (dma_mapping_error(trans->dev, phys))
 		return -ENOMEM;
 
 	if (likely(!iwl_txq_crosses_4g_boundary(phys, len))) {
@@ -322,7 +322,7 @@ static int iwl_txq_gen2_set_tb_with_wa(struct iwl_trans *trans,
 
 	phys = dma_map_single(trans->dev, page_address(page), len,
 			      DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(trans->dev, phys)))
+	if (dma_mapping_error(trans->dev, phys))
 		return -ENOMEM;
 	ret = iwl_txq_gen2_set_tb(trans, tfd, phys, len);
 	if (ret < 0) {
@@ -477,7 +477,7 @@ static int iwl_txq_gen2_build_amsdu(struct iwl_trans *trans,
 		tb_len = hdr_page->pos - start_hdr;
 		tb_phys = dma_map_single(trans->dev, start_hdr,
 					 tb_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, tb_phys))) {
+		if (dma_mapping_error(trans->dev, tb_phys)) {
 			dev_kfree_skb(csum_skb);
 			goto out_err;
 		}
@@ -563,7 +563,7 @@ iwl_tfh_tfd *iwl_txq_gen2_build_tx_amsdu(struct iwl_trans *trans,
 	/* map the data for TB1 */
 	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_FIRST_TB_SIZE;
 	tb_phys = dma_map_single(trans->dev, tb1_addr, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+	if (dma_mapping_error(trans->dev, tb_phys))
 		goto out_err;
 	/*
 	 * No need for _with_wa(), we ensure (via alignment) that the data
@@ -658,7 +658,7 @@ iwl_tfh_tfd *iwl_txq_gen2_build_tx(struct iwl_trans *trans,
 	/* map the data for TB1 */
 	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_FIRST_TB_SIZE;
 	tb_phys = dma_map_single(trans->dev, tb1_addr, tb1_len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+	if (dma_mapping_error(trans->dev, tb_phys))
 		goto out_err;
 	/*
 	 * No need for _with_wa(), we ensure (via alignment) that the data
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 73eeb00d5..12aeca142 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -317,7 +317,7 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, struct mt76_queue *q,
 
 	addr = dma_map_single(dev->dev, skb->data, skb->len,
 			      DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev->dev, addr)))
+	if (dma_mapping_error(dev->dev, addr))
 		goto error;
 
 	buf.addr = addr;
@@ -365,7 +365,7 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 
 	len = skb_headlen(skb);
 	addr = dma_map_single(dev->dev, skb->data, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev->dev, addr)))
+	if (dma_mapping_error(dev->dev, addr))
 		goto free;
 
 	tx_info.buf[n].addr = t->dma_addr;
@@ -379,7 +379,7 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 
 		addr = dma_map_single(dev->dev, iter->data, iter->len,
 				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev->dev, addr)))
+		if (dma_mapping_error(dev->dev, addr))
 			goto unmap;
 
 		tx_info.buf[n].addr = addr;
@@ -441,7 +441,7 @@ mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)
 			break;
 
 		addr = dma_map_single(dev->dev, buf, len, DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(dev->dev, addr))) {
+		if (dma_mapping_error(dev->dev, addr)) {
 			skb_free_frag(buf);
 			break;
 		}
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index d4d389e8f..24a139dea 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -78,7 +78,7 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry, gfp_t gfp)
 
 		skb_dma = dma_map_single(rt2x00dev->dev, skb->data, skb->len,
 					 DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(rt2x00dev->dev, skb_dma))) {
+		if (dma_mapping_error(rt2x00dev->dev, skb_dma)) {
 			dev_kfree_skb_any(skb);
 			return NULL;
 		}
@@ -98,7 +98,7 @@ int rt2x00queue_map_txskb(struct queue_entry *entry)
 	skbdesc->skb_dma =
 	    dma_map_single(dev, entry->skb->data, entry->skb->len, DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(dev, skbdesc->skb_dma)))
+	if (dma_mapping_error(dev, skbdesc->skb_dma))
 		return -ENOMEM;
 
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2e49996a8..c15194ea3 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -95,8 +95,9 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	debug_dma_mapping_error(dev, dma_addr);
 
-	if (dma_addr == DMA_MAPPING_ERROR)
+	if (unlikely(dma_addr == DMA_MAPPING_ERROR))
 		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/kernel/dma/map_benchmark.c b/kernel/dma/map_benchmark.c
index b1496e744..901420a5d 100644
--- a/kernel/dma/map_benchmark.c
+++ b/kernel/dma/map_benchmark.c
@@ -78,7 +78,7 @@ static int map_benchmark_thread(void *data)
 
 		map_stime = ktime_get();
 		dma_addr = dma_map_single(map->dev, buf, PAGE_SIZE, map->dir);
-		if (unlikely(dma_mapping_error(map->dev, dma_addr))) {
+		if (dma_mapping_error(map->dev, dma_addr)) {
 			pr_err("dma_map_single failed on %s\n",
 				dev_name(map->dev));
 			ret = -ENOMEM;
-- 
2.29.2

