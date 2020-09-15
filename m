Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9CD26ACB4
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgIORPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 13:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgIORMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:12:50 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CE0C0611BC;
        Tue, 15 Sep 2020 10:10:58 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l9so250776wme.3;
        Tue, 15 Sep 2020 10:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KfdccU6uimlzdyty3Fs/0DDJ/XWde7Vt4Yj7cyn63Ss=;
        b=idMu67cwzqjs3I2Bcglw1cFaHy/aFoLVbf6SIwUNNTUmsW0MGFGfeDLAwj9oJ0vF4X
         uOsfek7SREPiV1Q9irW0ETLz/VhLFEqQ3MHtTnzTAILzJ56+sd47tIhvF+koS+Zt/F9u
         T42kAr2QSQWMvztwB+dKZirrywxtacSZ+Ncs1mayWs1bzgfBEHFgZHNkbRqUBKDponfV
         1ko2nI66a1BZ2wv4THdPHPptsabGAUh8jYB81bzqm1QUvlCrecmG+jr4zZRBZPoOHhk5
         qq3cNM3Gyhs9hEA1omnXjqYacBJwgWEvVVr3+kno8eUSg5QMDfpB39Na56b/zNFaPhnR
         hTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KfdccU6uimlzdyty3Fs/0DDJ/XWde7Vt4Yj7cyn63Ss=;
        b=ULJuJDFXxu3/TJUnpuW9fdr+oWtVTwWH+IvoyrJfVyZQogR+4K5Ku1pqecxXpREkSu
         je/MPo22JwJnDCjvLKnJD6J2STjUsvC/8MqxKUZaVYEyzJpmi51gO//sxLVXjsz+RT5V
         SLe0j0vu9WdCgosc9S7yLeiw/Lil55yTOrEhqSdcJULNjyXHEhryZzXo7IyseQH1TjK/
         YSDFm5Pc7J9rxsvJTTizJBjiejo9z9pBJTcy1zsiO4NjF6AGvlLLdWrEcnOmUkWwkMHq
         S6uDChkrwsSCXkBZDEHOF/Fa0nQLeJL/jjGj8hCaZaEy71CRBsIS15YSqv6Tjc4g0yL8
         rTAw==
X-Gm-Message-State: AOAM532d2Ns64hFaRjyzRg725C/jdPUaLQ1b65IF2XiaiJxIfxKaVMcv
        EKQt8dOsM4tNDTUvMaOANftF6XXpKlVdyA==
X-Google-Smtp-Source: ABdhPJzUxMwbEz0jXJIjooYqjBHn6dUnE0KMQMfGiCB8fzKPpEvJGhzOduECzYCPLP3NwTtI2OhQAA==
X-Received: by 2002:a1c:c256:: with SMTP id s83mr351508wmf.93.1600189856561;
        Tue, 15 Sep 2020 10:10:56 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id b194sm356558wmd.42.2020.09.15.10.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 10:10:55 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v3 11/14] habanalabs/gaudi: add QP error handling
Date:   Tue, 15 Sep 2020 20:10:19 +0300
Message-Id: <20200915171022.10561-12-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200915171022.10561-1-oded.gabbay@gmail.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
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

