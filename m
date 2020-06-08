Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9EC1F2FA4
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbgFIAwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbgFHXKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D61208A9;
        Mon,  8 Jun 2020 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657808;
        bh=3fRy+M5MKsobW1DMkCE6aT8AuhzEA6KfX/ybdilXmPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELe17dI3Nfkg8sQQkaYKaDaxivhq3puSVAAy0Y2i1BQCqu8aXfj/wmVl/LOCrsMr3
         LZIvjZj/zBxY+QJMOHxBctnUYJOJdAPIy3/GtR/zFPUE8atDgi9UvRzo5kYItfdqHG
         j+AE9h6U3L/cwks5AnW0J9bFkJB4hJZTNQXSccoE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 184/274] ath10k: Skip handling del_server during driver exit
Date:   Mon,  8 Jun 2020 19:04:37 -0400
Message-Id: <20200608230607.3361041-184-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit 7c6d67b136ceb0aebc7a3153b300e925ed915daf ]

The qmi infrastructure sends the client a del_server
event when the client releases its qmi handle. This
is not the msg indicating the actual qmi server exiting.
In such cases the del_server msg should not be processed,
since the wifi firmware does not reset its qmi state.

Hence skip the processing of del_server event when the
driver is unloading.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1588663061-12138-1-git-send-email-pillair@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 13 ++++++++++++-
 drivers/net/wireless/ath/ath10k/qmi.h |  6 ++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 85dce43c5439..7abdef8d6b9b 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -961,7 +961,16 @@ static void ath10k_qmi_del_server(struct qmi_handle *qmi_hdl,
 		container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
 
 	qmi->fw_ready = false;
-	ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_SERVER_EXIT, NULL);
+
+	/*
+	 * The del_server event is to be processed only if coming from
+	 * the qmi server. The qmi infrastructure sends del_server, when
+	 * any client releases the qmi handle. In this case do not process
+	 * this del_server event.
+	 */
+	if (qmi->state == ATH10K_QMI_STATE_INIT_DONE)
+		ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_SERVER_EXIT,
+					     NULL);
 }
 
 static struct qmi_ops ath10k_qmi_ops = {
@@ -1091,6 +1100,7 @@ int ath10k_qmi_init(struct ath10k *ar, u32 msa_size)
 	if (ret)
 		goto err_qmi_lookup;
 
+	qmi->state = ATH10K_QMI_STATE_INIT_DONE;
 	return 0;
 
 err_qmi_lookup:
@@ -1109,6 +1119,7 @@ int ath10k_qmi_deinit(struct ath10k *ar)
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	struct ath10k_qmi *qmi = ar_snoc->qmi;
 
+	qmi->state = ATH10K_QMI_STATE_DEINIT;
 	qmi_handle_release(&qmi->qmi_hdl);
 	cancel_work_sync(&qmi->event_work);
 	destroy_workqueue(qmi->event_wq);
diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
index dc257375f161..b59720524224 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.h
+++ b/drivers/net/wireless/ath/ath10k/qmi.h
@@ -83,6 +83,11 @@ struct ath10k_qmi_driver_event {
 	void *data;
 };
 
+enum ath10k_qmi_state {
+	ATH10K_QMI_STATE_INIT_DONE,
+	ATH10K_QMI_STATE_DEINIT,
+};
+
 struct ath10k_qmi {
 	struct ath10k *ar;
 	struct qmi_handle qmi_hdl;
@@ -105,6 +110,7 @@ struct ath10k_qmi {
 	char fw_build_timestamp[MAX_TIMESTAMP_LEN + 1];
 	struct ath10k_qmi_cal_data cal_data[MAX_NUM_CAL_V01];
 	bool msa_fixed_perm;
+	enum ath10k_qmi_state state;
 };
 
 int ath10k_qmi_wlan_enable(struct ath10k *ar,
-- 
2.25.1

