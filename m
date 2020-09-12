Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD1F267B03
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 16:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgILOqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 10:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgILOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 10:42:11 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CEEC06179E;
        Sat, 12 Sep 2020 07:41:42 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t16so13352231edw.7;
        Sat, 12 Sep 2020 07:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jL0D0xcGkP8I+a05PVNQiU4I3EGWW4b574qQx3GqaHs=;
        b=PGMnpbtJJsaQ26r3fdux1cGmxbSeO2sNOqG3+KWNoN2inR4fbMiMv3cKlCD845qY5l
         G588KRv7e6PghoZ94WAsL5AsB9xNCLYxxGXeZkwVZqOUrp1YNWe+m44TkyCIZ7nvZfW1
         aeJucuZjGvBYUgrGSyoitaCb/c7/VKluLrV0MdyAcdsq+Uh3EPo/X5MAOWen2Tf08hML
         25jbiJu+JhUbF0Eq93KyJ2jVQe/uiZ8qKmNOgzGiU4Hs2SDt/AzpmzyZs7PwVM21SItz
         b0Wc1K/LFmVm/J2OIWvvyGQxIYiRxdJnPH7KfWxBDywzK8ysscL9PwLlex0OaQlBKkHt
         E/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jL0D0xcGkP8I+a05PVNQiU4I3EGWW4b574qQx3GqaHs=;
        b=tZiREPa1P836QGI9558V+Jf9OK1YZPTFpB4PaYBQsEDj/b2wbMFwVI+YFIQkoy9dfk
         e3lfUPZ2fpBkK0Y2mGYdjk2zyP6eN1BttFJpSoWRC588xt3KZenWBa8Pguq/wvsjDCtt
         DmYzCGkrj2ZYxB9NYBmOghk8v0Be4NkbfHFEG706oLoNddw6AYs5dqyYFwrNBaioX7gN
         9iD7N+JkiKWPMlgBg4i7EyC/iRiHvj5wd4P3p+jg+INNqKWIPKpFok49OERJLBukpf+2
         81XBH1sNdD6p4FXpMq034/aIVzNcA4YDA13Wm4i21O3iNykxPDLxF5SbbCmEpfq6sDmn
         pAwg==
X-Gm-Message-State: AOAM531J3wPbTknHRnWplPmthEy/F+MDP1oa5wpmQQIqXsrF0i6zzw/7
        VzMk/e1lJWMJ07MLlYSENHkUdv5sEkc=
X-Google-Smtp-Source: ABdhPJyLy7VNakk4c/4IVWSsg4iyxQklEGBXC3qcC8LBgaSJZwITOG8xbYuDNEtpJrS2o8MrcvKUzQ==
X-Received: by 2002:a05:6402:12d1:: with SMTP id k17mr8432067edx.323.1599921700202;
        Sat, 12 Sep 2020 07:41:40 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id y25sm4842938edv.15.2020.09.12.07.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 07:41:39 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v2 11/14] habanalabs/gaudi: add QP error handling
Date:   Sat, 12 Sep 2020 17:41:03 +0300
Message-Id: <20200912144106.11799-12-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200912144106.11799-1-oded.gabbay@gmail.com>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Add Queue Pair (QP) error notification to the user e.g. security violation,
too many retransmissions, invalid QP etc.

Whenever a QP caused an error, the firmware will send an event to the
driver which will push the error as an error entry to the Completion Queue
(if exists).

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
Changes in v2:
  - Fix all instances of reverse Christmas tree

 drivers/misc/habanalabs/gaudi/gaudi.c     | 13 ++++
 drivers/misc/habanalabs/gaudi/gaudiP.h    |  1 +
 drivers/misc/habanalabs/gaudi/gaudi_nic.c | 95 +++++++++++++++++++++++
 3 files changed, 109 insertions(+)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 4602e4780651..71c9e2d18032 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -6660,6 +6660,19 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 		hl_fw_unmask_irq(hdev, event_type);
 		break;
 
+	case GAUDI_EVENT_NIC0_QP0:
+	case GAUDI_EVENT_NIC0_QP1:
+	case GAUDI_EVENT_NIC1_QP0:
+	case GAUDI_EVENT_NIC1_QP1:
+	case GAUDI_EVENT_NIC2_QP0:
+	case GAUDI_EVENT_NIC2_QP1:
+	case GAUDI_EVENT_NIC3_QP0:
+	case GAUDI_EVENT_NIC3_QP1:
+	case GAUDI_EVENT_NIC4_QP0:
+	case GAUDI_EVENT_NIC4_QP1:
+		gaudi_nic_handle_qp_err(hdev, event_type);
+		break;
+
 	case GAUDI_EVENT_PSOC_GPIO_U16_0:
 		cause = le64_to_cpu(eq_entry->data[0]) & 0xFF;
 		dev_err(hdev->dev,
diff --git a/drivers/misc/habanalabs/gaudi/gaudiP.h b/drivers/misc/habanalabs/gaudi/gaudiP.h
index 3158d5d68c1d..7d7439da88bc 100644
--- a/drivers/misc/habanalabs/gaudi/gaudiP.h
+++ b/drivers/misc/habanalabs/gaudi/gaudiP.h
@@ -576,5 +576,6 @@ netdev_tx_t gaudi_nic_handle_tx_pkt(struct gaudi_nic_device *gaudi_nic,
 					struct sk_buff *skb);
 int gaudi_nic_sw_init(struct hl_device *hdev);
 void gaudi_nic_sw_fini(struct hl_device *hdev);
+void gaudi_nic_handle_qp_err(struct hl_device *hdev, u16 event_type);
 
 #endif /* GAUDIP_H_ */
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index 37f25247f751..49e94e9c786a 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -3988,3 +3988,98 @@ int gaudi_nic_cq_mmap(struct hl_device *hdev, struct vm_area_struct *vma)
 
 	return rc;
 }
+
+static char *get_syndrome_text(u32 syndrome)
+{
+	char *str;
+
+	switch (syndrome) {
+	case 0x05:
+		str = "Rx got invalid QP";
+		break;
+	case 0x06:
+		str = "Rx transport service mismatch";
+		break;
+	case 0x09:
+		str = "Rx Rkey check failed";
+		break;
+	case 0x40:
+		str = "timer retry exceeded";
+		break;
+	case 0x41:
+		str = "NACK retry exceeded";
+		break;
+	case 0x42:
+		str = "doorbell on invalid QP";
+		break;
+	case 0x43:
+		str = "doorbell security check failed";
+		break;
+	case 0x44:
+		str = "Tx got invalid QP";
+		break;
+	case 0x45:
+		str = "responder got ACK/NACK on invalid QP";
+		break;
+	case 0x46:
+		str = "responder try to send ACK/NACK on invalid QP";
+		break;
+	default:
+		str = "unknown syndrome";
+		break;
+	}
+
+	return str;
+}
+
+void gaudi_nic_handle_qp_err(struct hl_device *hdev, u16 event_type)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	struct qp_err *qp_err_arr;
+	struct hl_nic_cqe cqe_sw;
+	u32 pi, ci;
+
+	gaudi_nic = &gaudi->nic_devices[event_type - GAUDI_EVENT_NIC0_QP0];
+	qp_err_arr = gaudi_nic->qp_err_mem_cpu;
+
+	mutex_lock(&gaudi->nic_qp_err_lock);
+
+	if (!gaudi->nic_cq_enable)
+		dev_err_ratelimited(hdev->dev,
+			"received NIC %d QP error event %d but no CQ to push it\n",
+			gaudi_nic->port, event_type);
+
+	pi = NIC_RREG32(mmNIC0_QPC0_ERR_FIFO_PRODUCER_INDEX);
+	ci = gaudi_nic->qp_err_ci;
+
+	cqe_sw.is_err = true;
+	cqe_sw.port = gaudi_nic->port;
+
+	while (ci < pi) {
+		cqe_sw.type = QP_ERR_IS_REQ(qp_err_arr[ci]) ?
+				HL_NIC_CQE_TYPE_REQ : HL_NIC_CQE_TYPE_RES;
+		cqe_sw.qp_number = QP_ERR_QP_NUM(qp_err_arr[ci]);
+		cqe_sw.qp_err.syndrome = QP_ERR_ERR_NUM(qp_err_arr[ci]);
+
+		ci = (ci + 1) & (QP_ERR_BUF_LEN - 1);
+
+		dev_err_ratelimited(hdev->dev,
+			"NIC QP error port: %d, type: %d, qpn: %d, syndrome: %s (0x%x)\n",
+			cqe_sw.port, cqe_sw.type, cqe_sw.qp_number,
+			get_syndrome_text(cqe_sw.qp_err.syndrome),
+			cqe_sw.qp_err.syndrome);
+
+		if (gaudi->nic_cq_enable)
+			copy_cqe_to_main_queue(hdev, &cqe_sw);
+	}
+
+	gaudi_nic->qp_err_ci = ci;
+	NIC_WREG32(mmNIC0_QPC0_ERR_FIFO_CONSUMER_INDEX, ci);
+
+	/* signal the completion queue that there are available CQEs */
+	if (gaudi->nic_cq_enable)
+		complete(&gaudi->nic_cq_comp);
+
+	mutex_unlock(&gaudi->nic_qp_err_lock);
+}
-- 
2.17.1

