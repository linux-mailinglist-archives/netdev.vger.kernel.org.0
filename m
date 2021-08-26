Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5598C3F8D09
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 19:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243223AbhHZR31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 13:29:27 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:28732 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhHZR30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 13:29:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629998918; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=PfdLDssuVocpX0OAfjQ6bnz0pnV5VdAo1CkeOfpph+A=; b=lKkWH9IgJhH9jIOdSXfOt9VG1qDkIf6VePcpeTahSYaO25f+e1L5XKPPxh6Utsi9sRtLK5a3
 r/tJIDsrYvPg6/JoxeS1ibY+mFECmt70Y3G+38D8fujbCz5qyZ1jB/AsWAqkVattgPpgQaj+
 Y1Xkjim3UTZf0xsSfjvmVjaHYJw=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6127cf3cfc1f4cb6929d2331 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 26 Aug 2021 17:28:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BC5E3C4338F; Thu, 26 Aug 2021 17:28:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D9C01C43460;
        Thu, 26 Aug 2021 17:28:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D9C01C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     netdev@vger.kernel.org
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        regressions@lists.linux.dev, wt@penguintechs.org,
        manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org,
        loic.poulain@linaro.org, nschichan@freebox.fr
Subject: [PATCH] Revert "net: really fix the build..."
Date:   Thu, 26 Aug 2021 20:28:16 +0300
Message-Id: <20210826172816.24478-1-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit ce78ffa3ef1681065ba451cfd545da6126f5ca88.

Wren and Nicolas reported that ath11k was failing to initialise QCA6390
Wi-Fi 6 device with error:

qcom_mhi_qrtr: probe of mhi0_IPCR failed with error -22

Commit ce78ffa3ef16 ("net: really fix the build..."), introduced in
v5.14-rc5, caused this regression in qrtr. Most likely all ath11k
devices are broken, but I only tested QCA6390. Let's revert the broken
commit so that ath11k works again.

Reported-by: Wren Turkal <wt@penguintechs.org>
Reported-by: Nicolas Schichan <nschichan@freebox.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/bus/mhi/core/internal.h  |  2 +-
 drivers/bus/mhi/core/main.c      |  9 +++------
 drivers/net/mhi/net.c            |  2 +-
 drivers/net/wwan/mhi_wwan_ctrl.c |  2 +-
 include/linux/mhi.h              |  7 +------
 net/qrtr/mhi.c                   | 16 +---------------
 6 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index bc239a11aa69..5b9ea66b92dc 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -682,7 +682,7 @@ void mhi_rddm_prepare(struct mhi_controller *mhi_cntrl,
 		      struct image_info *img_info);
 void mhi_fw_load_handler(struct mhi_controller *mhi_cntrl);
 int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
-			struct mhi_chan *mhi_chan, unsigned int flags);
+			struct mhi_chan *mhi_chan);
 int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,
 		       struct mhi_chan *mhi_chan);
 void mhi_deinit_chan_ctxt(struct mhi_controller *mhi_cntrl,
diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index 84448233f64c..fc9196f11cb7 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -1430,7 +1430,7 @@ static void mhi_unprepare_channel(struct mhi_controller *mhi_cntrl,
 }
 
 int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
-			struct mhi_chan *mhi_chan, unsigned int flags)
+			struct mhi_chan *mhi_chan)
 {
 	int ret = 0;
 	struct device *dev = &mhi_chan->mhi_dev->dev;
@@ -1455,9 +1455,6 @@ int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
 	if (ret)
 		goto error_pm_state;
 
-	if (mhi_chan->dir == DMA_FROM_DEVICE)
-		mhi_chan->pre_alloc = !!(flags & MHI_CH_INBOUND_ALLOC_BUFS);
-	
 	/* Pre-allocate buffer for xfer ring */
 	if (mhi_chan->pre_alloc) {
 		int nr_el = get_nr_avail_ring_elements(mhi_cntrl,
@@ -1613,7 +1610,7 @@ void mhi_reset_chan(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan)
 }
 
 /* Move channel to start state */
-int mhi_prepare_for_transfer(struct mhi_device *mhi_dev, unsigned int flags)
+int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
 {
 	int ret, dir;
 	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
@@ -1624,7 +1621,7 @@ int mhi_prepare_for_transfer(struct mhi_device *mhi_dev, unsigned int flags)
 		if (!mhi_chan)
 			continue;
 
-		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan, flags);
+		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan);
 		if (ret)
 			goto error_open_chan;
 	}
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index 11be6bcdd551..e60e38c1f09d 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -335,7 +335,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 	u64_stats_init(&mhi_netdev->stats.tx_syncp);
 
 	/* Start MHI channels */
-	err = mhi_prepare_for_transfer(mhi_dev, 0);
+	err = mhi_prepare_for_transfer(mhi_dev);
 	if (err)
 		goto out_err;
 
diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
index d0a98f34c54d..e4d0f696687f 100644
--- a/drivers/net/wwan/mhi_wwan_ctrl.c
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -110,7 +110,7 @@ static int mhi_wwan_ctrl_start(struct wwan_port *port)
 	int ret;
 
 	/* Start mhi device's channel(s) */
-	ret = mhi_prepare_for_transfer(mhiwwan->mhi_dev, 0);
+	ret = mhi_prepare_for_transfer(mhiwwan->mhi_dev);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 5e08468854db..944aa3aa3035 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -719,13 +719,8 @@ void mhi_device_put(struct mhi_device *mhi_dev);
  *                            host and device execution environments match and
  *                            channels are in a DISABLED state.
  * @mhi_dev: Device associated with the channels
- * @flags: MHI channel flags
  */
-int mhi_prepare_for_transfer(struct mhi_device *mhi_dev,
-			     unsigned int flags);
-
-/* Automatically allocate and queue inbound buffers */
-#define MHI_CH_INBOUND_ALLOC_BUFS BIT(0)
+int mhi_prepare_for_transfer(struct mhi_device *mhi_dev);
 
 /**
  * mhi_unprepare_from_transfer - Reset UL and DL channels for data transfer.
diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 1dc955ca57d3..fa611678af05 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -15,7 +15,6 @@ struct qrtr_mhi_dev {
 	struct qrtr_endpoint ep;
 	struct mhi_device *mhi_dev;
 	struct device *dev;
-	struct completion ready;
 };
 
 /* From MHI to QRTR */
@@ -51,10 +50,6 @@ static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 	struct qrtr_mhi_dev *qdev = container_of(ep, struct qrtr_mhi_dev, ep);
 	int rc;
 
-	rc = wait_for_completion_interruptible(&qdev->ready);
-	if (rc)
-		goto free_skb;
-
 	if (skb->sk)
 		sock_hold(skb->sk);
 
@@ -84,7 +79,7 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	int rc;
 
 	/* start channels */
-	rc = mhi_prepare_for_transfer(mhi_dev, 0);
+	rc = mhi_prepare_for_transfer(mhi_dev);
 	if (rc)
 		return rc;
 
@@ -101,15 +96,6 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	if (rc)
 		return rc;
 
-	/* start channels */
-	rc = mhi_prepare_for_transfer(mhi_dev, MHI_CH_INBOUND_ALLOC_BUFS);
-	if (rc) {
-		qrtr_endpoint_unregister(&qdev->ep);
-		dev_set_drvdata(&mhi_dev->dev, NULL);
-		return rc;
-	}
-
-	complete_all(&qdev->ready);
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
 	return 0;
-- 
2.20.1

