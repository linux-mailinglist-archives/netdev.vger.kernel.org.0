Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A133C92F4
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 23:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhGNVVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 17:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235424AbhGNVVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 17:21:30 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A38FC061760
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 14:18:38 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 69531806B5;
        Thu, 15 Jul 2021 09:18:33 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1626297513;
        bh=HAKkGGSo4mHleotY94r+xy5ikYReAid1ZfboDKXL6ag=;
        h=From:To:Cc:Subject:Date;
        b=VRUKs+zQfHSo2zKXlk20QZ0fODn3TZ9XMp1MNNCPDtRXOieiBcF+YvnQ5OZXX6gNo
         rWe6JXYXSx4KjC76jR4hsvSITjBFp4nZTs35qA3yskW3nAw60ZKZprrupwemJNQ9KZ
         L1xRdXOXW51o8AfgKGTleOrJNGacRRz/2kI3oAefXxJ6D+G3muZZXvMC8NmDqtWfMY
         z7Xb/zuLpSE8gzJl5J0DiS9Utxz+MNPZtVOoej3RW6xx8b1/qMm32o822gxPqlYrzs
         kIlIj1N467YfYVEw1tPZWt/CH+1RYyufIj2apfABAW+H2qzWOfzMBYOsaxtZ+ANo5O
         pXHpatXEd8DJQ==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60ef54a90000>; Thu, 15 Jul 2021 09:18:33 +1200
Received: from richardl-dl.ws.atlnz.lc (richardl-dl.ws.atlnz.lc [10.33.23.13])
        by pat.atlnz.lc (Postfix) with ESMTP id 362B213EE8E;
        Thu, 15 Jul 2021 09:18:33 +1200 (NZST)
Received: by richardl-dl.ws.atlnz.lc (Postfix, from userid 1481)
        id 3076A320AF9; Thu, 15 Jul 2021 09:18:33 +1200 (NZST)
From:   richard.laing@alliedtelesis.co.nz
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        loic.poulain@linaro.org,
        Richard Laing <richard.laing@alliedtelesis.co.nz>
Subject: [PATCH] bus: mhi: pci-generic: configurable network interface MRU
Date:   Thu, 15 Jul 2021 09:18:05 +1200
Message-Id: <20210714211805.22350-1-richard.laing@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Sr3uF8G0 c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=e_q4qTt1xDgA:10 a=LZI0ioW4W1tqXtV-B4gA:9 a=9oN4MwAJvyJ6ewmm:21 a=6_l_vBfCNWmAWfyy:21
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Laing <richard.laing@alliedtelesis.co.nz>

The MRU value used by the MHI MBIM network interface affects
the throughput performance of the interface. Different modem
models use different default MRU sizes based on their bandwidth
capabilities. Large values generally result in higher throughput
for larger packet sizes.

In addition if the MRU used by the MHI device is larger than that
specified in the MHI net device the data is fragmented and needs
to be re-assembled which generates a (single) warning message about
the fragmented packets. Setting the MRU on both ends avoids the
extra processing to re-assemble the packets.

This patch allows the documented MRU for a modem to be automatically
set as the MHI net device MRU avoiding fragmentation and improving
throughput performance.

Signed-off-by: Richard Laing <richard.laing@alliedtelesis.co.nz>
---
 drivers/bus/mhi/pci_generic.c | 6 +++++-
 drivers/net/mhi/net.c         | 1 +
 drivers/net/mhi/proto_mbim.c  | 4 +++-
 include/linux/mhi.h           | 2 ++
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.=
c
index b3357a8a2fdb..ae7a201dad95 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -32,6 +32,7 @@
  * @edl: emergency download mode firmware path (if any)
  * @bar_num: PCI base address register to use for MHI MMIO register spac=
e
  * @dma_data_width: DMA transfer word size (32 or 64 bits)
+ * @mru_default: default MRU size for MBIM network packets
  */
 struct mhi_pci_dev_info {
 	const struct mhi_controller_config *config;
@@ -40,6 +41,7 @@ struct mhi_pci_dev_info {
 	const char *edl;
 	unsigned int bar_num;
 	unsigned int dma_data_width;
+	unsigned int mru_default;
 };
=20
 #define MHI_CHANNEL_CONFIG_UL(ch_num, ch_name, el_count, ev_ring) \
@@ -251,7 +253,8 @@ static const struct mhi_pci_dev_info mhi_qcom_sdx55_i=
nfo =3D {
 	.edl =3D "qcom/sdx55m/edl.mbn",
 	.config =3D &modem_qcom_v1_mhiv_config,
 	.bar_num =3D MHI_PCI_DEFAULT_BAR_NUM,
-	.dma_data_width =3D 32
+	.dma_data_width =3D 32,
+	.mru_default =3D 32768
 };
=20
 static const struct mhi_pci_dev_info mhi_qcom_sdx24_info =3D {
@@ -643,6 +646,7 @@ static int mhi_pci_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
 	mhi_cntrl->wake_get =3D mhi_pci_wake_get_nop;
 	mhi_cntrl->wake_put =3D mhi_pci_wake_put_nop;
 	mhi_cntrl->wake_toggle =3D mhi_pci_wake_toggle_nop;
+	mhi_cntrl->mru =3D info->mru_default;
=20
 	err =3D mhi_pci_claim(mhi_cntrl, info->bar_num, DMA_BIT_MASK(info->dma_=
data_width));
 	if (err)
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index e60e38c1f09d..a5a2aa19bb91 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -329,6 +329,7 @@ static int mhi_net_newlink(void *ctxt, struct net_dev=
ice *ndev, u32 if_id,
 	mhi_netdev->mdev =3D mhi_dev;
 	mhi_netdev->skbagg_head =3D NULL;
 	mhi_netdev->proto =3D info->proto;
+	mhi_netdev->mru =3D mhi_dev->mhi_cntrl->mru;
=20
 	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
 	u64_stats_init(&mhi_netdev->stats.rx_syncp);
diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
index bf1ad863237d..f1cc7f35bb85 100644
--- a/drivers/net/mhi/proto_mbim.c
+++ b/drivers/net/mhi/proto_mbim.c
@@ -292,7 +292,9 @@ static int mbim_init(struct mhi_net_dev *mhi_netdev)
=20
 	ndev->needed_headroom =3D sizeof(struct mbim_tx_hdr);
 	ndev->mtu =3D MHI_MBIM_DEFAULT_MTU;
-	mhi_netdev->mru =3D MHI_MBIM_DEFAULT_MRU;
+
+	if (!mhi_netdev->mru)
+		mhi_netdev->mru =3D MHI_MBIM_DEFAULT_MRU;
=20
 	return 0;
 }
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 944aa3aa3035..beb918328eef 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -356,6 +356,7 @@ struct mhi_controller_config {
  * @fbc_download: MHI host needs to do complete image transfer (optional=
)
  * @wake_set: Device wakeup set flag
  * @irq_flags: irq flags passed to request_irq (optional)
+ * @mru: the default MRU for the MHI device
  *
  * Fields marked as (required) need to be populated by the controller dr=
iver
  * before calling mhi_register_controller(). For the fields marked as (o=
ptional)
@@ -448,6 +449,7 @@ struct mhi_controller {
 	bool fbc_download;
 	bool wake_set;
 	unsigned long irq_flags;
+	u32 mru;
 };
=20
 /**
--=20
2.32.0

