Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6AEB30739
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfEaDyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:54:35 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40802 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfEaDyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:54:16 -0400
Received: by mail-io1-f67.google.com with SMTP id n5so7017606ioc.7
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P/pdOsY/niyZRmGETxNerH6dJjcttG53YSsCa7ifoY0=;
        b=LdLXbxUxV/IrXn4d1i/vGdienEoZXb6BsYFxIL5VpNAARTTGVluKaA6MGSJ4HEGwmK
         aLKqU/vlN6B8wanswPX59AUkIA92XKC976uKcxKb4QFoe/+yYvne3gQycN9GvcP/iJ25
         sL4jj4nfvf4SAtWPqfJzmLRVzV5nP+XX4qCSQj4fArc1fgXTTmFkW9mTIh2bICl8TjtI
         E+RjoaGd7oPTbfy22IAVGy6/ZVePyFgXwYIqVsf7aixl3ziURXrNxVoWHH+9D/5TUczZ
         +yOfQK7CAChVB5l34hJ9D4ZauMfJ9nfyrP1kk6zBxq/Bl8RiouWy+cWfS8ooBeS2Jbc+
         Ouhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P/pdOsY/niyZRmGETxNerH6dJjcttG53YSsCa7ifoY0=;
        b=i2sWnKwJjhDGtFSap7X9mRoOssA/8Xq5CfSb3N5YHleKjpoW7PLzztCilwFL293H2B
         BCqrNMvI4evbbO/oVnIyZp3K+BP/ybPU9hvb51LITz2/MgSMyi53Pqj15kgIYeCS1Coj
         oRfDxVAYJyiWXTETZLYzAJKq9YnnVNgtRUDtFZuIReDQ+c5fXO/x1i4JkyAe18AVrEMl
         AStgo5q9Jfa4pQxEuSiTQSi8kTqF1XL+C1Lch0B923Y7ekn99hIgZofm95Zc3k8yy2GY
         KOni7yG8jdU6IGwIbi2v3snGX6ZopvuydElJZwkhUjCdkRbKkxWKhNeM/9uNavc7Msa0
         4JkA==
X-Gm-Message-State: APjAAAXdtUFT62BtVJPyXxFvf84adKXnuAXX97SU92UoslrrxtksPSwy
        6kWy6pzBmJURzIn/iiucUkYo6w==
X-Google-Smtp-Source: APXvYqyw1bxBazDS9xdd5Yr6U/DRZA7zOSrNfezkhmrAo1aPM/nKFMpw7mOYi1fYX4ZuYxbTSsmRgA==
X-Received: by 2002:a5d:8712:: with SMTP id u18mr4719446iom.18.1559274853194;
        Thu, 30 May 2019 20:54:13 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id q15sm1626947ioi.15.2019.05.30.20.54.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 20:54:12 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 13/17] soc: qcom: ipa: AP/modem communications
Date:   Thu, 30 May 2019 22:53:44 -0500
Message-Id: <20190531035348.7194-14-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531035348.7194-1-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements two forms of out-of-band communication between
the AP and modem.

  - QMI is a mechanism that allows clients running on the AP
    interact with services running on the modem (and vice-versa).
    The AP IPA driver uses QMI to communicate with the corresponding
    IPA driver resident on the modem, to agree on parameters used
    with the IPA hardware and to ensure both sides are ready before
    entering operational mode.

  - SMP2P is a more primitive mechanism available for the modem and
    AP to communicate with each other.  It provides a means for either
    the AP or modem to interrupt the other, and furthermore, to provide
    32 bits worth of information.  The IPA driver uses SMP2P to tell
    the modem what the state of the IPA clock was in the event of a
    crash.  This allows the modem to safely access the IPA hardware
    (or avoid doing so) when a crash occurs, for example, to access
    information within the IPA hardware.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_qmi.c     | 402 +++++++++++++++++++++++
 drivers/net/ipa/ipa_qmi.h     |  35 ++
 drivers/net/ipa/ipa_qmi_msg.c | 583 ++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_qmi_msg.h | 238 ++++++++++++++
 drivers/net/ipa/ipa_smp2p.c   | 304 ++++++++++++++++++
 drivers/net/ipa/ipa_smp2p.h   |  47 +++
 6 files changed, 1609 insertions(+)
 create mode 100644 drivers/net/ipa/ipa_qmi.c
 create mode 100644 drivers/net/ipa/ipa_qmi.h
 create mode 100644 drivers/net/ipa/ipa_qmi_msg.c
 create mode 100644 drivers/net/ipa/ipa_qmi_msg.h
 create mode 100644 drivers/net/ipa/ipa_smp2p.c
 create mode 100644 drivers/net/ipa/ipa_smp2p.h

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
new file mode 100644
index 000000000000..e94437508f6c
--- /dev/null
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -0,0 +1,402 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/qrtr.h>
+#include <linux/soc/qcom/qmi.h>
+
+#include "ipa.h"
+#include "ipa_endpoint.h"
+#include "ipa_mem.h"
+#include "ipa_qmi_msg.h"
+
+#define QMI_INIT_DRIVER_TIMEOUT	60000	/* A minute in milliseconds */
+
+/**
+ * DOC: AP/Modem QMI Handshake
+ *
+ * The AP and modem perform a "handshake" at initialization time to ensure
+ * each side knows the other side is ready.  Two QMI handles (endpoints) are
+ * used for this; one provides service on the modem for AP requests, and the
+ * other is on the AP to service modem requests (and to supply an indication
+ * from the AP).
+ *
+ * The QMI service on the modem expects to receive an INIT_DRIVER request from
+ * the AP, which contains parameters used by the modem during initialization.
+ * The AP sends this request using the client handle as soon as it is knows
+ * the modem side service is available.  The modem responds to this request
+ * immediately.
+ *
+ * When the modem learns the AP service is available, it is able to
+ * communicate its status to the AP.  The modem uses this to tell
+ * the AP when it is ready to receive an indication, sending an
+ * INDICATION_REGISTER request to the handle served by the AP.  This
+ * is independent of the modem's initialization of its driver.
+ *
+ * When the modem has completed the driver initialization requested by the
+ * AP, it sends a DRIVER_INIT_COMPLETE request to the AP.   This request
+ * could arrive at the AP either before or after the INDICATION_REGISTER
+ * request.
+ *
+ * The final step in the handshake occurs after the AP has received both
+ * requests from the modem.  The AP completes the handshake by sending an
+ * INIT_COMPLETE_IND indication message to the modem.
+ */
+
+#define IPA_HOST_SERVICE_SVC_ID		0x31
+#define IPA_HOST_SVC_VERS		1
+#define IPA_HOST_SERVICE_INS_ID		1
+
+#define IPA_MODEM_SERVICE_SVC_ID	0x31
+#define IPA_MODEM_SERVICE_INS_ID	2
+#define IPA_MODEM_SVC_VERS		1
+
+/* Send an INIT_COMPLETE_IND indication message to the modem */
+static int ipa_send_master_driver_init_complete_ind(struct qmi_handle *qmi,
+						    struct sockaddr_qrtr *sq)
+{
+	struct ipa_init_complete_ind ind = { };
+
+	ind.status.result = QMI_RESULT_SUCCESS_V01;
+	ind.status.error = QMI_ERR_NONE_V01;
+
+	return qmi_send_indication(qmi, sq, IPA_QMI_INIT_COMPLETE_IND,
+				   IPA_QMI_INIT_COMPLETE_IND_SZ,
+				   ipa_init_complete_ind_ei, &ind);
+}
+
+/* This function is called to determine whether to complete the handshake by
+ * sending an INIT_COMPLETE_IND indication message to the modem.  The
+ * "init_driver" parameter is false when we've received an INDICATION_REGISTER
+ * request message from the modem, or true when we've received the response
+ * from the INIT_DRIVER request message we send.  If this function decides the
+ * message should be sent, it calls ipa_send_master_driver_init_complete_ind()
+ * to send it.
+ */
+static void ipa_handshake_complete(struct qmi_handle *qmi,
+				   struct sockaddr_qrtr *sq, bool init_driver)
+{
+	struct ipa *ipa;
+	bool send_it;
+	int ret;
+
+	if (init_driver) {
+		ipa = container_of(qmi, struct ipa, qmi.client_handle);
+		ipa->qmi.init_driver_response_received = true;
+		send_it = !!ipa->qmi.indication_register_received;
+	} else {
+		ipa = container_of(qmi, struct ipa, qmi.server_handle);
+		ipa->qmi.indication_register_received = 1;
+		send_it = !!ipa->qmi.init_driver_response_received;
+	}
+	if (!send_it)
+		return;
+
+	ret = ipa_send_master_driver_init_complete_ind(qmi, sq);
+	WARN(ret, "error %d sending init complete indication\n", ret);
+}
+
+/* Callback function to handle an INDICATION_REGISTER request message from the
+ * modem.  This informs the AP that the modem is now ready to receive the
+ * INIT_COMPLETE_IND indication message.
+ */
+static void ipa_indication_register_fn(struct qmi_handle *qmi,
+				       struct sockaddr_qrtr *sq,
+				       struct qmi_txn *txn,
+				       const void *decoded)
+{
+	struct ipa_indication_register_rsp rsp = { };
+	int ret;
+
+	rsp.rsp.result = QMI_RESULT_SUCCESS_V01;
+	rsp.rsp.error = QMI_ERR_NONE_V01;
+
+	ret = qmi_send_response(qmi, sq, txn, IPA_QMI_INDICATION_REGISTER,
+				IPA_QMI_INDICATION_REGISTER_RSP_SZ,
+				ipa_indication_register_rsp_ei, &rsp);
+	if (!WARN(ret, "error %d sending response\n", ret))
+		ipa_handshake_complete(qmi, sq, false);
+}
+
+/* Callback function to handle a DRIVER_INIT_COMPLETE request message from the
+ * modem.  This informs the AP that the modem has completed the initializion
+ * of its driver.
+ */
+static void ipa_driver_init_complete_fn(struct qmi_handle *qmi,
+					struct sockaddr_qrtr *sq,
+					struct qmi_txn *txn,
+					const void *decoded)
+{
+	struct ipa_driver_init_complete_rsp rsp = { };
+	int ret;
+
+	rsp.rsp.result = QMI_RESULT_SUCCESS_V01;
+	rsp.rsp.error = QMI_ERR_NONE_V01;
+
+	ret = qmi_send_response(qmi, sq, txn, IPA_QMI_DRIVER_INIT_COMPLETE,
+				IPA_QMI_DRIVER_INIT_COMPLETE_RSP_SZ,
+				ipa_driver_init_complete_rsp_ei, &rsp);
+
+	WARN(ret, "error %d sending response\n", ret);
+}
+
+/* The server handles two request message types sent by the modem. */
+static struct qmi_msg_handler ipa_server_msg_handlers[] = {
+	{
+		.type		= QMI_REQUEST,
+		.msg_id		= IPA_QMI_INDICATION_REGISTER,
+		.ei		= ipa_indication_register_req_ei,
+		.decoded_size	= IPA_QMI_INDICATION_REGISTER_REQ_SZ,
+		.fn		= ipa_indication_register_fn,
+	},
+	{
+		.type		= QMI_REQUEST,
+		.msg_id		= IPA_QMI_DRIVER_INIT_COMPLETE,
+		.ei		= ipa_driver_init_complete_req_ei,
+		.decoded_size	= IPA_QMI_DRIVER_INIT_COMPLETE_REQ_SZ,
+		.fn		= ipa_driver_init_complete_fn,
+	},
+};
+
+/* Callback function to handle an IPA_QMI_INIT_DRIVER response message from
+ * the modem.  This only acknowledges that the modem received the request.
+ * The modem will eventually report that it has completed its modem
+ * initialization by sending a IPA_QMI_DRIVER_INIT_COMPLETE request.
+ */
+static void ipa_init_driver_rsp_fn(struct qmi_handle *qmi,
+				   struct sockaddr_qrtr *sq,
+				   struct qmi_txn *txn,
+				   const void *decoded)
+{
+	txn->result = 0;	/* IPA_QMI_INIT_DRIVER request was successful */
+	complete(&txn->completion);
+
+	ipa_handshake_complete(qmi, sq, true);
+}
+
+/* The client handles one response message type sent by the modem. */
+static struct qmi_msg_handler ipa_client_msg_handlers[] = {
+	{
+		.type		= QMI_RESPONSE,
+		.msg_id		= IPA_QMI_INIT_DRIVER,
+		.ei		= ipa_init_modem_driver_rsp_ei,
+		.decoded_size	= IPA_QMI_INIT_DRIVER_RSP_SZ,
+		.fn		= ipa_init_driver_rsp_fn,
+	},
+};
+
+/* Return a pointer to an init modem driver request structure, which contains
+ * configuration parameters for the modem.  The modem may be started multiple
+ * times, but generally these parameters don't change so we can reuse the
+ * request structure once it's initialized.  The only exception is the
+ * skip_uc_load field, which will be set only after the microcontroller has
+ * reported it has completed its initialization.
+ */
+static const struct ipa_init_modem_driver_req *
+init_modem_driver_req(struct ipa_qmi *ipa_qmi)
+{
+	struct ipa *ipa = container_of(ipa_qmi, struct ipa, qmi);
+	static struct ipa_init_modem_driver_req req;
+
+	/* This is not the first boot if the microcontroller is loaded */
+	req.skip_uc_load = ipa->uc_loaded;
+	req.skip_uc_load_valid = true;
+
+	/* We only have to initialize most of it once */
+	if (req.platform_type_valid)
+		return &req;
+
+	req.platform_type_valid = true;
+	req.platform_type = IPA_QMI_PLATFORM_TYPE_MSM_ANDROID;
+
+	req.hdr_tbl_info_valid = IPA_SMEM_MODEM_HDR_SIZE ? 1 : 0;
+	req.hdr_tbl_info.start = ipa_qmi->base + IPA_SMEM_MODEM_HDR_OFFSET;
+	req.hdr_tbl_info.end = req.hdr_tbl_info.start +
+					IPA_SMEM_MODEM_HDR_SIZE - 1;
+
+	req.v4_route_tbl_info_valid = true;
+	req.v4_route_tbl_info.start =
+			ipa_qmi->base + IPA_SMEM_V4_RT_NHASH_OFFSET;
+	req.v4_route_tbl_info.count = IPA_SMEM_MODEM_RT_COUNT;
+
+	req.v6_route_tbl_info_valid = true;
+	req.v6_route_tbl_info.start =
+			ipa_qmi->base + IPA_SMEM_V6_RT_NHASH_OFFSET;
+	req.v6_route_tbl_info.count = IPA_SMEM_MODEM_RT_COUNT;
+
+	req.v4_filter_tbl_start_valid = true;
+	req.v4_filter_tbl_start = ipa_qmi->base + IPA_SMEM_V4_FLT_NHASH_OFFSET;
+
+	req.v6_filter_tbl_start_valid = true;
+	req.v6_filter_tbl_start = ipa_qmi->base + IPA_SMEM_V6_FLT_NHASH_OFFSET;
+
+	req.modem_mem_info_valid = IPA_SMEM_MODEM_SIZE ? 1 : 0;
+	req.modem_mem_info.start = ipa_qmi->base + IPA_SMEM_MODEM_OFFSET;
+	req.modem_mem_info.size = IPA_SMEM_MODEM_SIZE;
+
+	req.ctrl_comm_dest_end_pt_valid = true;
+	req.ctrl_comm_dest_end_pt = IPA_ENDPOINT_AP_MODEM_RX;
+
+	req.hdr_proc_ctx_tbl_info_valid =
+			IPA_SMEM_MODEM_HDR_PROC_CTX_SIZE ? 1 : 0;
+	req.hdr_proc_ctx_tbl_info.start =
+			ipa_qmi->base + IPA_SMEM_MODEM_HDR_PROC_CTX_OFFSET;
+	req.hdr_proc_ctx_tbl_info.end = req.hdr_proc_ctx_tbl_info.start +
+			IPA_SMEM_MODEM_HDR_PROC_CTX_SIZE - 1;
+
+	req.v4_hash_route_tbl_info_valid = true;
+	req.v4_hash_route_tbl_info.start =
+			ipa_qmi->base + IPA_SMEM_V4_RT_HASH_OFFSET;
+	req.v4_hash_route_tbl_info.count = IPA_SMEM_MODEM_RT_COUNT;
+
+	req.v6_hash_route_tbl_info_valid = true;
+	req.v6_hash_route_tbl_info.start =
+			ipa_qmi->base + IPA_SMEM_V6_RT_HASH_OFFSET;
+	req.v6_hash_route_tbl_info.count = IPA_SMEM_MODEM_RT_COUNT;
+
+	req.v4_hash_filter_tbl_start_valid = true;
+	req.v4_hash_filter_tbl_start =
+			ipa_qmi->base + IPA_SMEM_V4_FLT_HASH_OFFSET;
+
+	req.v6_hash_filter_tbl_start_valid = true;
+	req.v6_hash_filter_tbl_start =
+			ipa_qmi->base + IPA_SMEM_V6_FLT_HASH_OFFSET;
+
+	return &req;
+}
+
+/* The modem service we requested is now available via the client handle.
+ * Send an INIT_DRIVER request to the modem.
+ */
+static int
+ipa_client_new_server(struct qmi_handle *qmi, struct qmi_service *svc)
+{
+	const struct ipa_init_modem_driver_req *req;
+	struct ipa *ipa;
+	struct sockaddr_qrtr sq;
+	struct qmi_txn *txn;
+	int ret;
+
+	ipa = container_of(qmi, struct ipa, qmi.client_handle);
+	req = init_modem_driver_req(&ipa->qmi);
+
+	txn = kzalloc(sizeof(*txn), GFP_KERNEL);
+	if (!txn)
+		return -ENOMEM;
+
+	ret = qmi_txn_init(qmi, txn, NULL, NULL);
+	if (ret) {
+		kfree(txn);
+		return ret;
+	}
+
+	sq.sq_family = AF_QIPCRTR;
+	sq.sq_node = svc->node;
+	sq.sq_port = svc->port;
+
+	ret = qmi_send_request(qmi, &sq, txn, IPA_QMI_INIT_DRIVER,
+			       IPA_QMI_INIT_DRIVER_REQ_SZ,
+			       ipa_init_modem_driver_req_ei, req);
+	if (!ret)
+		ret = qmi_txn_wait(txn, MAX_SCHEDULE_TIMEOUT);
+	if (ret)
+		qmi_txn_cancel(txn);
+	kfree(txn);
+
+	return ret;
+}
+
+/* The only callback we supply for the client handle is notification that the
+ * service on the modem has become available.
+ */
+static struct qmi_ops ipa_client_ops = {
+	.new_server	= ipa_client_new_server,
+};
+
+static int ipa_qmi_initialize(struct ipa *ipa)
+{
+	struct ipa_qmi *ipa_qmi = &ipa->qmi;
+	int ret;
+
+	/* The only handle operation that might be interesting for the server
+	 * would be del_client, to find out when the modem side client has
+	 * disappeared.  But other than reporting the event, we wouldn't do
+	 * anything about that.  So we just pass a null pointer for its handle
+	 * operations.  All the real work is done by the message handlers.
+	 */
+	ret = qmi_handle_init(&ipa_qmi->server_handle,
+			      IPA_QMI_SERVER_MAX_RCV_SZ, NULL,
+			      ipa_server_msg_handlers);
+	if (ret)
+		return ret;
+
+	ret = qmi_add_server(&ipa_qmi->server_handle, IPA_HOST_SERVICE_SVC_ID,
+			     IPA_HOST_SVC_VERS, IPA_HOST_SERVICE_INS_ID);
+	if (ret)
+		goto err_release_server_handle;
+
+	/* The client handle is only used for sending an INIT_DRIVER request
+	 * to the modem, and receiving its response message.
+	 */
+	ret = qmi_handle_init(&ipa_qmi->client_handle,
+			      IPA_QMI_CLIENT_MAX_RCV_SZ, &ipa_client_ops,
+			      ipa_client_msg_handlers);
+	if (ret)
+		goto err_release_server_handle;
+
+	ret = qmi_add_lookup(&ipa_qmi->client_handle, IPA_MODEM_SERVICE_SVC_ID,
+			     IPA_MODEM_SVC_VERS, IPA_MODEM_SERVICE_INS_ID);
+	if (ret)
+		goto err_release_client_handle;
+
+	/* All QMI offsets are relative to the start of IPA shared memory */
+	ipa_qmi->base = ipa->shared_offset;
+	ipa_qmi->initialized = 1;
+
+	return 0;
+
+err_release_client_handle:
+	/* Releasing the handle also removes registered lookups */
+	qmi_handle_release(&ipa_qmi->client_handle);
+	memset(&ipa_qmi->client_handle, 0, sizeof(ipa_qmi->client_handle));
+err_release_server_handle:
+	/* Releasing the handle also removes registered services */
+	qmi_handle_release(&ipa_qmi->server_handle);
+	memset(&ipa_qmi->server_handle, 0, sizeof(ipa_qmi->server_handle));
+
+	return ret;
+}
+
+/* This is called by ipa_netdev_setup().  We can be informed via remoteproc
+ * that the modem has shut down, in which case this function will be called
+ * again to prepare for it coming back up again.
+ */
+int ipa_qmi_setup(struct ipa *ipa)
+{
+	ipa->qmi.init_driver_response_received = 0;
+	ipa->qmi.indication_register_received = 0;
+
+	if (!ipa->qmi.initialized)
+		return ipa_qmi_initialize(ipa);
+
+	return 0;
+}
+
+void ipa_qmi_teardown(struct ipa *ipa)
+{
+	if (!ipa->qmi.initialized)
+		return;
+
+	qmi_handle_release(&ipa->qmi.client_handle);
+	memset(&ipa->qmi.client_handle, 0, sizeof(ipa->qmi.client_handle));
+
+	qmi_handle_release(&ipa->qmi.server_handle);
+	memset(&ipa->qmi.server_handle, 0, sizeof(ipa->qmi.server_handle));
+
+	ipa->qmi.initialized = 0;
+}
diff --git a/drivers/net/ipa/ipa_qmi.h b/drivers/net/ipa/ipa_qmi.h
new file mode 100644
index 000000000000..cfdafa23cf8f
--- /dev/null
+++ b/drivers/net/ipa/ipa_qmi.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#ifndef _IPA_QMI_H_
+#define _IPA_QMI_H_
+
+#include <linux/types.h>
+#include <linux/soc/qcom/qmi.h>
+
+struct ipa;
+
+/**
+ * struct ipa_qmi - QMI state associated with an IPA
+ * @initialized		- whether QMI initialization has completed
+ * @client_handle	- used to send an QMI requests to the modem
+ * @server_handle	- used to handle QMI requests from the modem
+ * @indication_register_received - tracks modem request receipt
+ * @init_driver_response_received - tracks modem response receipt
+ */
+struct ipa_qmi {
+	u32 initialized;
+	u32 base;
+	struct qmi_handle client_handle;
+	struct qmi_handle server_handle;
+	u32 indication_register_received;
+	u32 init_driver_response_received;
+
+};
+
+int ipa_qmi_setup(struct ipa *ipa);
+void ipa_qmi_teardown(struct ipa *ipa);
+
+#endif /* !_IPA_QMI_H_ */
diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
new file mode 100644
index 000000000000..b6b278dff6fb
--- /dev/null
+++ b/drivers/net/ipa/ipa_qmi_msg.c
@@ -0,0 +1,583 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#include <linux/stddef.h>
+#include <linux/soc/qcom/qmi.h>
+
+#include "ipa_qmi_msg.h"
+
+/* QMI message structure definition for struct ipa_indication_register_req */
+struct qmi_elem_info ipa_indication_register_req_ei[] = {
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     master_driver_init_complete_valid),
+		.tlv_type	= 0x10,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   master_driver_init_complete_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     master_driver_init_complete),
+		.tlv_type	= 0x10,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   master_driver_init_complete),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     data_usage_quota_reached_valid),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   data_usage_quota_reached_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     data_usage_quota_reached),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   data_usage_quota_reached),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_indication_register_rsp */
+struct qmi_elem_info ipa_indication_register_rsp_ei[] = {
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_rsp,
+				     rsp),
+		.tlv_type	= 0x02,
+		.offset		= offsetof(struct ipa_indication_register_rsp,
+					   rsp),
+		.ei_array	= qmi_response_type_v01_ei,
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_driver_init_complete_req */
+struct qmi_elem_info ipa_driver_init_complete_req_ei[] = {
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_driver_init_complete_req,
+				     status),
+		.tlv_type	= 0x01,
+		.offset		= offsetof(struct ipa_driver_init_complete_req,
+					   status),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_driver_init_complete_rsp */
+struct qmi_elem_info ipa_driver_init_complete_rsp_ei[] = {
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_driver_init_complete_rsp,
+				     rsp),
+		.tlv_type	= 0x02,
+		.elem_size	= offsetof(struct ipa_driver_init_complete_rsp,
+					   rsp),
+		.ei_array	= qmi_response_type_v01_ei,
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_init_complete_ind */
+struct qmi_elem_info ipa_init_complete_ind_ei[] = {
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_complete_ind,
+				     status),
+		.tlv_type	= 0x02,
+		.elem_size	= offsetof(struct ipa_init_complete_ind,
+					   status),
+		.ei_array	= qmi_response_type_v01_ei,
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_mem_bounds */
+struct qmi_elem_info ipa_mem_bounds_ei[] = {
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_bounds, start),
+		.offset		= offsetof(struct ipa_mem_bounds, start),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_bounds, end),
+		.offset		= offsetof(struct ipa_mem_bounds, end),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_mem_array */
+struct qmi_elem_info ipa_mem_array_ei[] = {
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_array, start),
+		.offset		= offsetof(struct ipa_mem_array, start),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_array, count),
+		.offset		= offsetof(struct ipa_mem_array, count),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_mem_range */
+struct qmi_elem_info ipa_mem_range_ei[] = {
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_range, start),
+		.offset		= offsetof(struct ipa_mem_range, start),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_range, size),
+		.offset		= offsetof(struct ipa_mem_range, size),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_init_modem_driver_req */
+struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     platform_type_valid),
+		.tlv_type	= 0x10,
+		.elem_size	= offsetof(struct ipa_init_modem_driver_req,
+					   platform_type_valid),
+	},
+	{
+		.data_type	= QMI_SIGNED_4_BYTE_ENUM,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     platform_type),
+		.tlv_type	= 0x10,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   platform_type),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hdr_tbl_info_valid),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hdr_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hdr_tbl_info),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hdr_tbl_info),
+		.ei_array	= ipa_mem_bounds_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_route_tbl_info_valid),
+		.tlv_type	= 0x12,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_route_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_route_tbl_info),
+		.tlv_type	= 0x12,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_route_tbl_info),
+		.ei_array	= ipa_mem_array_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_route_tbl_info_valid),
+		.tlv_type	= 0x13,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_route_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_route_tbl_info),
+		.tlv_type	= 0x13,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_route_tbl_info),
+		.ei_array	= ipa_mem_array_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_filter_tbl_start_valid),
+		.tlv_type	= 0x14,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_filter_tbl_start_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_filter_tbl_start),
+		.tlv_type	= 0x14,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_filter_tbl_start),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_filter_tbl_start_valid),
+		.tlv_type	= 0x15,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_filter_tbl_start_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_filter_tbl_start),
+		.tlv_type	= 0x15,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_filter_tbl_start),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     modem_mem_info_valid),
+		.tlv_type	= 0x16,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   modem_mem_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     modem_mem_info),
+		.tlv_type	= 0x16,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   modem_mem_info),
+		.ei_array	= ipa_mem_range_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     ctrl_comm_dest_end_pt_valid),
+		.tlv_type	= 0x17,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   ctrl_comm_dest_end_pt_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     ctrl_comm_dest_end_pt),
+		.tlv_type	= 0x17,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   ctrl_comm_dest_end_pt),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     skip_uc_load_valid),
+		.tlv_type	= 0x18,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   skip_uc_load_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     skip_uc_load),
+		.tlv_type	= 0x18,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   skip_uc_load),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hdr_proc_ctx_tbl_info_valid),
+		.tlv_type	= 0x19,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hdr_proc_ctx_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hdr_proc_ctx_tbl_info),
+		.tlv_type	= 0x19,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hdr_proc_ctx_tbl_info),
+		.ei_array	= ipa_mem_bounds_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     zip_tbl_info_valid),
+		.tlv_type	= 0x1a,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   zip_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     zip_tbl_info),
+		.tlv_type	= 0x1a,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   zip_tbl_info),
+		.ei_array	= ipa_mem_bounds_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_hash_route_tbl_info_valid),
+		.tlv_type	= 0x1b,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_hash_route_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_hash_route_tbl_info),
+		.tlv_type	= 0x1b,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_hash_route_tbl_info),
+		.ei_array	= ipa_mem_array_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_hash_route_tbl_info_valid),
+		.tlv_type	= 0x1c,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_hash_route_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_hash_route_tbl_info),
+		.tlv_type	= 0x1c,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_hash_route_tbl_info),
+		.ei_array	= ipa_mem_array_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_hash_filter_tbl_start_valid),
+		.tlv_type	= 0x1d,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_hash_filter_tbl_start_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_hash_filter_tbl_start),
+		.tlv_type	= 0x1d,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_hash_filter_tbl_start),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_hash_filter_tbl_start_valid),
+		.tlv_type	= 0x1e,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_hash_filter_tbl_start_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_hash_filter_tbl_start),
+		.tlv_type	= 0x1e,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_hash_filter_tbl_start),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_init_modem_driver_rsp */
+struct qmi_elem_info ipa_init_modem_driver_rsp_ei[] = {
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     rsp),
+		.tlv_type	= 0x02,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   rsp),
+		.ei_array	= qmi_response_type_v01_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     ctrl_comm_dest_end_pt_valid),
+		.tlv_type	= 0x10,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   ctrl_comm_dest_end_pt_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     ctrl_comm_dest_end_pt),
+		.tlv_type	= 0x10,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   ctrl_comm_dest_end_pt),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     default_end_pt_valid),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   default_end_pt_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     default_end_pt),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   default_end_pt),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     modem_driver_init_pending_valid),
+		.tlv_type	= 0x12,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   modem_driver_init_pending_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     modem_driver_init_pending),
+		.tlv_type	= 0x12,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   modem_driver_init_pending),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
new file mode 100644
index 000000000000..cf3cda3bddae
--- /dev/null
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -0,0 +1,238 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#ifndef _IPA_QMI_MSG_H_
+#define _IPA_QMI_MSG_H_
+
+/* === Only "ipa_qmi" and "ipa_qmi_msg.c" should include this file === */
+
+#include <linux/types.h>
+#include <linux/soc/qcom/qmi.h>
+
+/* Request/response/indication QMI message ids used for IPA.  Receiving
+ * end issues a response for requests; indications require no response.
+ */
+#define IPA_QMI_INDICATION_REGISTER	0x20	/* modem -> AP request */
+#define IPA_QMI_INIT_DRIVER		0x21	/* AP -> modem request */
+#define IPA_QMI_INIT_COMPLETE_IND	0x22	/* AP -> modem indication */
+#define IPA_QMI_DRIVER_INIT_COMPLETE	0x35	/* modem -> AP request */
+
+/* The maximum size required for message types.  These sizes include
+ * the message data, along with type (1 byte) and length (2 byte)
+ * information for each field.  The qmi_send_*() interfaces require
+ * the message size to be provided.
+ */
+#define IPA_QMI_INDICATION_REGISTER_REQ_SZ	8	/* -> server handle */
+#define IPA_QMI_INDICATION_REGISTER_RSP_SZ	7	/* <- server handle */
+#define IPA_QMI_INIT_DRIVER_REQ_SZ		134	/* client handle -> */
+#define IPA_QMI_INIT_DRIVER_RSP_SZ		25	/* client handle <- */
+#define IPA_QMI_INIT_COMPLETE_IND_SZ		7	/* server handle -> */
+#define IPA_QMI_DRIVER_INIT_COMPLETE_REQ_SZ	4	/* -> server handle */
+#define IPA_QMI_DRIVER_INIT_COMPLETE_RSP_SZ	7	/* <- server handle */
+
+/* Maximum size of messages we expect the AP to receive (max of above) */
+#define IPA_QMI_SERVER_MAX_RCV_SZ		8
+#define IPA_QMI_CLIENT_MAX_RCV_SZ		25
+
+/* Request message for the IPA_QMI_INDICATION_REGISTER request */
+struct ipa_indication_register_req {
+	u8 master_driver_init_complete_valid;
+	u8 master_driver_init_complete;
+	u8 data_usage_quota_reached_valid;
+	u8 data_usage_quota_reached;
+};
+
+/* The response to a IPA_QMI_INDICATION_REGISTER request consists only of
+ * a standard QMI response.
+ */
+struct ipa_indication_register_rsp {
+	struct qmi_response_type_v01 rsp;
+};
+
+/* Request message for the IPA_QMI_DRIVER_INIT_COMPLETE request */
+struct ipa_driver_init_complete_req {
+	u8 status;
+};
+
+/* The response to a IPA_QMI_DRIVER_INIT_COMPLETE request consists only
+ * of a standard QMI response.
+ */
+struct ipa_driver_init_complete_rsp {
+	struct qmi_response_type_v01 rsp;
+};
+
+/* The message for the IPA_QMI_INIT_COMPLETE_IND indication consists
+ * only of a standard QMI response.
+ */
+struct ipa_init_complete_ind {
+	struct qmi_response_type_v01 status;
+};
+
+/* The AP tells the modem its platform type.  We assume Android. */
+enum ipa_platform_type {
+	IPA_QMI_PLATFORM_TYPE_INVALID		= 0,	/* Invalid */
+	IPA_QMI_PLATFORM_TYPE_TN		= 1,	/* Data card */
+	IPA_QMI_PLATFORM_TYPE_LE		= 2,	/* Data router */
+	IPA_QMI_PLATFORM_TYPE_MSM_ANDROID	= 3,	/* Android MSM */
+	IPA_QMI_PLATFORM_TYPE_MSM_WINDOWS	= 4,	/* Windows MSM */
+	IPA_QMI_PLATFORM_TYPE_MSM_QNX_V01	= 5,	/* QNX MSM */
+};
+
+/* This defines the start and end offset of a range of memory.  Both
+ * fields are offsets relative to the start of IPA shared memory.
+ * The end value is the last addressable byte *within* the range.
+ */
+struct ipa_mem_bounds {
+	u32 start;
+	u32 end;
+};
+
+/* This defines the location and size of an array.  The start value
+ * is an offset relative to the start of IPA shared memory.  The
+ * size of the array is implied by the number of entries (the entry
+ * size is assumed to be known).
+ */
+struct ipa_mem_array {
+	u32 start;
+	u32 count;
+};
+
+/* This defines the location and size of a range of memory.  The
+ * start is an offset relative to the start of IPA shared memory.
+ * This differs from the ipa_mem_bounds structure in that the size
+ * (in bytes) of the memory region is specified rather than the
+ * offset of its last byte.
+ */
+struct ipa_mem_range {
+	u32 start;
+	u32 size;
+};
+
+/* The message for the IPA_QMI_INIT_DRIVER request contains information
+ * from the AP that affects modem initialization.
+ */
+struct ipa_init_modem_driver_req {
+	u8			platform_type_valid;
+	u32			platform_type;	/* enum ipa_platform_type */
+
+	/* Modem header table information.  This defines the IPA shared
+	 * memory in which the modem may insert header table entries.
+	 */
+	u8			hdr_tbl_info_valid;
+	struct ipa_mem_bounds	hdr_tbl_info;
+
+	/* Routing table information.  These define the location and size of
+	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
+	 * offsets relative to the start of IPA shared memory.
+	 */
+	u8			v4_route_tbl_info_valid;
+	struct ipa_mem_array	v4_route_tbl_info;
+	u8			v6_route_tbl_info_valid;
+	struct ipa_mem_array	v6_route_tbl_info;
+
+	/* Filter table information.  These define the location and size of
+	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
+	 * offsets relative to the start of IPA shared memory.
+	 */
+	u8			v4_filter_tbl_start_valid;
+	u32			v4_filter_tbl_start;
+	u8			v6_filter_tbl_start_valid;
+	u32			v6_filter_tbl_start;
+
+	/* Modem memory information.  This defines the location and
+	 * size of memory available for the modem to use.
+	 */
+	u8			modem_mem_info_valid;
+	struct ipa_mem_range	modem_mem_info;
+
+	/* This defines the destination endpoint on the AP to which
+	 * the modem driver can send control commands.  IPA supports
+	 * 20 endpoints, so this must be 19 or less.
+	 */
+	u8			ctrl_comm_dest_end_pt_valid;
+	u32			ctrl_comm_dest_end_pt;
+
+	/* This defines whether the modem should load the microcontroller
+	 * or not.  It is unnecessary to reload it if the modem is being
+	 * restarted.
+	 *
+	 * NOTE: this field is named "is_ssr_bootup" elsewhere.
+	 */
+	u8			skip_uc_load_valid;
+	u8			skip_uc_load;
+
+	/* Processing context memory information.  This defines the memory in
+	 * which the modem may insert header processing context table entries.
+	 */
+	u8			hdr_proc_ctx_tbl_info_valid;
+	struct ipa_mem_bounds	hdr_proc_ctx_tbl_info;
+
+	/* Compression command memory information.  This defines the memory
+	 * in which the modem may insert compression/decompression commands.
+	 */
+	u8			zip_tbl_info_valid;
+	struct ipa_mem_bounds	zip_tbl_info;
+
+	/* Routing table information.  These define the location and size
+	 * of hashable IPv4 and IPv6 filter tables.  The start values are
+	 * offsets relative to the start of IPA shared memory.
+	 */
+	u8			v4_hash_route_tbl_info_valid;
+	struct ipa_mem_array	v4_hash_route_tbl_info;
+	u8			v6_hash_route_tbl_info_valid;
+	struct ipa_mem_array	v6_hash_route_tbl_info;
+
+	/* Filter table information.  These define the location and size
+	 * of hashable IPv4 and IPv6 filter tables.  The start values are
+	 * offsets relative to the start of IPA shared memory.
+	 */
+	u8			v4_hash_filter_tbl_start_valid;
+	u32			v4_hash_filter_tbl_start;
+	u8			v6_hash_filter_tbl_start_valid;
+	u32			v6_hash_filter_tbl_start;
+};
+
+/* The response to a IPA_QMI_INIT_DRIVER request begins with a standard
+ * QMI response, but contains other information as well.  Currently we
+ * simply wait for the the INIT_DRIVER transaction to complete and
+ * ignore any other data that might be returned.
+ */
+struct ipa_init_modem_driver_rsp {
+	struct qmi_response_type_v01	rsp;
+
+	/* This defines the destination endpoint on the modem to which
+	 * the AP driver can send control commands.  IPA supports
+	 * 20 endpoints, so this must be 19 or less.
+	 */
+	u8				ctrl_comm_dest_end_pt_valid;
+	u32				ctrl_comm_dest_end_pt;
+
+	/* This defines the default endpoint.  The AP driver is not
+	 * required to configure the hardware with this value.  IPA
+	 * supports 20 endpoints, so this must be 19 or less.
+	 */
+	u8				default_end_pt_valid;
+	u32				default_end_pt;
+
+	/* This defines whether a second handshake is required to complete
+	 * initialization.
+	 */
+	u8				modem_driver_init_pending_valid;
+	u8				modem_driver_init_pending;
+};
+
+/* Message structure definitions defined in "ipa_qmi_msg.c" */
+extern struct qmi_elem_info ipa_indication_register_req_ei[];
+extern struct qmi_elem_info ipa_indication_register_rsp_ei[];
+extern struct qmi_elem_info ipa_driver_init_complete_req_ei[];
+extern struct qmi_elem_info ipa_driver_init_complete_rsp_ei[];
+extern struct qmi_elem_info ipa_init_complete_ind_ei[];
+extern struct qmi_elem_info ipa_mem_bounds_ei[];
+extern struct qmi_elem_info ipa_mem_array_ei[];
+extern struct qmi_elem_info ipa_mem_range_ei[];
+extern struct qmi_elem_info ipa_init_modem_driver_req_ei[];
+extern struct qmi_elem_info ipa_init_modem_driver_rsp_ei[];
+
+#endif /* !_IPA_QMI_MSG_H_ */
diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
new file mode 100644
index 000000000000..c59f358b44b4
--- /dev/null
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/notifier.h>
+#include <linux/soc/qcom/smem.h>
+#include <linux/soc/qcom/smem_state.h>
+
+#include "ipa_smp2p.h"
+#include "ipa.h"
+#include "ipa_uc.h"
+#include "ipa_clock.h"
+
+/**
+ * DOC: IPA SMP2P communication with the modem
+ *
+ * SMP2P is a primitive communication mechanism available between the AP and
+ * the modem.  The IPA driver uses this for two purposes:  to enable the modem
+ * to state that the GSI hardware is ready to use; and to communicate the
+ * state of the IPA clock in the event of a crash.
+ *
+ * GSI needs to have early initialization completed before it can be used.
+ * This initialization is done either by Trust Zone or by the modem.  In the
+ * latter case, the modem uses an SMP2P interrupt to tell the AP IPA driver
+ * when the GSI is ready to use.
+ *
+ * The modem is also able to inquire about the current state of the IPA
+ * clock by trigging another SMP2P interrupt to the AP.  We communicate
+ * whether the clock is enabled using two SMP2P state bits--one to
+ * indicate the clock state (on or off), and a second to indicate the
+ * clock state bit is valid.  The modem will poll the valid bit until it
+ * is set, and at that time records whether the AP has the IPA clock enabled.
+ *
+ * Finally, if the AP kernel panics, we update the SMP2P state bits even if
+ * we never receive an interrupt from the modem requesting this.
+ */
+
+/**
+ * struct ipa_smp2p - IPA SMP2P information
+ * @ipa:		IPA pointer
+ * @valid_state:	SMEM state indicating enabled state is valid
+ * @enabled_state:	SMEM state to indicate clock is enabled
+ * @valid_bit:		Valid bit in 32-bit SMEM state mask
+ * @enabled_bit:	Enabled bit in 32-bit SMEM state mask
+ * @enabled_bit:	Enabled bit in 32-bit SMEM state mask
+ * @clock_query_irq:	IPA interrupt triggered by modem for clock query
+ * @setup_ready_irq:	IPA interrupt triggered by modem to signal GSI ready
+ * @clock_on:		Whether IPA clock is on
+ * @notified:		Whether modem has been notified of clock state
+ * @disabled:		Whether setup ready interrupt handling is disabled
+ * @mutex mutex:	Motex protecting ready interrupt/shutdown interlock
+ * @panic_notifier:	Panic notifier structure
+*/
+struct ipa_smp2p {
+	struct ipa *ipa;
+	struct qcom_smem_state *valid_state;
+	struct qcom_smem_state *enabled_state;
+	u32 valid_bit;
+	u32 enabled_bit;
+	u32 clock_query_irq;
+	u32 setup_ready_irq;
+	u32 clock_on;
+	u32 notified;
+	u32 disabled;
+	struct mutex mutex;
+	struct notifier_block panic_notifier;
+};
+
+/**
+ * ipa_smp2p_notify() - use SMP2P to tell modem about IPA clock state
+ * @smp2p:	SMP2P information
+ *
+ * This is called either when the modem has requested it (by triggering
+ * the modem clock query IPA interrupt) or whenever the AP is shutting down
+ * (via a panic notifier).  It sets the two SMP2P state bits--one saying
+ * whether the IPA clock is running, and the other indicating the first bit
+ * is valid.
+ */
+static void ipa_smp2p_notify(struct ipa_smp2p *smp2p)
+{
+	u32 value;
+	u32 mask;
+
+	if (smp2p->notified)
+		return;
+
+	smp2p->clock_on = ipa_clock_get_additional(smp2p->ipa->clock) ? 1 : 0;
+
+	/* Signal whether the clock is enabled */
+	mask = BIT(smp2p->enabled_bit);
+	value = smp2p->clock_on ? mask : 0;
+	qcom_smem_state_update_bits(smp2p->enabled_state, mask, value);
+
+	/* Now indicate that the enabled flag is valid */
+	mask = BIT(smp2p->valid_bit);
+	value = mask;
+	qcom_smem_state_update_bits(smp2p->valid_state, mask, value);
+
+	smp2p->notified = 1;
+}
+
+/* Threaded IRQ handler for modem "ipa-clock-query" SMP2P interrupt */
+static irqreturn_t ipa_smp2p_modem_clk_query_isr(int irq, void *dev_id)
+{
+	struct ipa_smp2p *smp2p = dev_id;
+
+	ipa_smp2p_notify(smp2p);
+
+	return IRQ_HANDLED;
+}
+
+static int ipa_smp2p_panic_notifier(struct notifier_block *nb,
+				    unsigned long action, void *data)
+{
+	struct ipa_smp2p *smp2p;
+
+	smp2p = container_of(nb, struct ipa_smp2p, panic_notifier);
+
+	ipa_smp2p_notify(smp2p);
+
+	if (smp2p->clock_on)
+		ipa_uc_panic_notifier(smp2p->ipa);
+
+	return NOTIFY_DONE;
+}
+
+static int ipa_smp2p_panic_notifier_register(struct ipa_smp2p *smp2p)
+{
+	/* IPA panic handler needs to run before modem shuts down */
+	smp2p->panic_notifier.notifier_call = ipa_smp2p_panic_notifier;
+	smp2p->panic_notifier.priority = INT_MAX;	/* Do it early */
+
+	return atomic_notifier_chain_register(&panic_notifier_list,
+					      &smp2p->panic_notifier);
+}
+
+static void ipa_smp2p_panic_notifier_unregister(struct ipa_smp2p *smp2p)
+{
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &smp2p->panic_notifier);
+}
+
+/* Threaded IRQ handler for modem "ipa-setup-ready" SMP2P interrupt */
+static irqreturn_t ipa_smp2p_modem_setup_ready_isr(int irq, void *dev_id)
+{
+	struct ipa_smp2p *smp2p = dev_id;
+	int ret;
+
+	mutex_lock(&smp2p->mutex);
+	if (!smp2p->disabled) {
+		ret = ipa_setup(smp2p->ipa);
+		WARN(ret, "error %d from IPA setup\n", ret);
+	}
+	mutex_unlock(&smp2p->mutex);
+
+	return IRQ_HANDLED;
+}
+
+/* Initialize SMP2P interrupts */
+static int ipa_smp2p_irq_init(struct ipa_smp2p *smp2p, const char *name,
+			      irq_handler_t handler)
+{
+	unsigned int irq;
+	int ret;
+
+	ret = platform_get_irq_byname(smp2p->ipa->pdev, name);
+	if (ret < 0)
+		return ret;
+	if (!ret)
+		return -EINVAL;		/* IRQ mapping failure */
+	irq = ret;
+
+	ret = request_threaded_irq(irq, NULL, handler, 0, name, smp2p);
+	if (ret)
+		return ret;
+
+	return irq;
+}
+
+static void ipa_smp2p_irq_exit(struct ipa_smp2p *smp2p, u32 irq)
+{
+	free_irq(irq, smp2p);
+}
+
+/* Initialize the IPA SMP2P subsystem */
+struct ipa_smp2p *ipa_smp2p_init(struct ipa *ipa, bool modem_init)
+{
+	struct qcom_smem_state *enabled_state;
+	struct device *dev = &ipa->pdev->dev;
+	struct qcom_smem_state *valid_state;
+	struct ipa_smp2p *smp2p;
+	u32 enabled_bit;
+	u32 valid_bit;
+	int ret;
+
+	valid_state = qcom_smem_state_get(dev, "ipa-clock-enabled-valid",
+					  &valid_bit);
+	if (IS_ERR(valid_state))
+		return ERR_CAST(valid_state);
+	if (valid_bit >= BITS_PER_LONG)
+		return ERR_PTR(-EINVAL);
+
+	enabled_state = qcom_smem_state_get(dev, "ipa-clock-enabled",
+					    &enabled_bit);
+	if (IS_ERR(enabled_state))
+		return ERR_CAST(enabled_state);
+	if (enabled_bit >= BITS_PER_LONG)
+		return ERR_PTR(-EINVAL);
+
+	smp2p = kzalloc(sizeof(*smp2p), GFP_KERNEL);
+	if (!smp2p)
+		return ERR_PTR(-ENOMEM);
+
+	smp2p->ipa = ipa;
+
+	/* These fields are needed by the clock query interrupt
+	 * handler, so initialize them now.
+	 */
+	mutex_init(&smp2p->mutex);
+	smp2p->valid_state = valid_state;
+	smp2p->valid_bit = valid_bit;
+	smp2p->enabled_state = enabled_state;
+	smp2p->enabled_bit = enabled_bit;
+
+	ret = ipa_smp2p_irq_init(smp2p, "ipa-clock-query",
+				 ipa_smp2p_modem_clk_query_isr);
+	if (ret < 0)
+		goto err_mutex_destroy;
+	smp2p->clock_query_irq = ret;
+
+	ret = ipa_smp2p_panic_notifier_register(smp2p);
+	if (ret)
+		goto err_irq_exit;
+
+	if (modem_init) {
+		/* Result will be non-zero (negative for error) */
+		ret = ipa_smp2p_irq_init(smp2p, "ipa-setup-ready",
+					 ipa_smp2p_modem_setup_ready_isr);
+		if (ret < 0)
+			goto err_notifier_unregister;
+		smp2p->setup_ready_irq = ret;
+	}
+
+	return smp2p;
+
+err_notifier_unregister:
+	ipa_smp2p_panic_notifier_unregister(smp2p);
+err_irq_exit:
+	ipa_smp2p_irq_exit(smp2p, smp2p->clock_query_irq);
+err_mutex_destroy:
+	mutex_destroy(&smp2p->mutex);
+	kfree(smp2p);
+
+	return ERR_PTR(ret);
+}
+
+void ipa_smp2p_exit(struct ipa_smp2p *smp2p)
+{
+	if (smp2p->setup_ready_irq)
+		ipa_smp2p_irq_exit(smp2p, smp2p->setup_ready_irq);
+	ipa_smp2p_panic_notifier_unregister(smp2p);
+	ipa_smp2p_irq_exit(smp2p, smp2p->clock_query_irq);
+	mutex_destroy(&smp2p->mutex);
+	kfree(smp2p);
+}
+
+void ipa_smp2p_disable(struct ipa_smp2p *smp2p)
+{
+	if (smp2p->setup_ready_irq) {
+		mutex_lock(&smp2p->mutex);
+		smp2p->disabled = 1;
+		mutex_unlock(&smp2p->mutex);
+	}
+}
+
+/* Reset state tracking whether we have notified the modem */
+void ipa_smp2p_notify_reset(struct ipa_smp2p *smp2p)
+{
+	u32 mask;
+
+	if (!smp2p->notified)
+		return;
+
+	/* Drop the clock reference if it was taken above */
+	if (smp2p->clock_on) {
+		ipa_clock_put(smp2p->ipa->clock);
+		smp2p->clock_on = 0;
+	}
+
+	/* Reset the clock enabled valid flag */
+	mask = BIT(smp2p->valid_bit);
+	qcom_smem_state_update_bits(smp2p->valid_state, mask, 0);
+
+	/* Mark the clock disabled for good measure... */
+	mask = BIT(smp2p->enabled_bit);
+	qcom_smem_state_update_bits(smp2p->enabled_state, mask, 0);
+
+	smp2p->notified = 0;
+}
diff --git a/drivers/net/ipa/ipa_smp2p.h b/drivers/net/ipa/ipa_smp2p.h
new file mode 100644
index 000000000000..9c7e4339a7b0
--- /dev/null
+++ b/drivers/net/ipa/ipa_smp2p.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+#ifndef _IPA_SMP2P_H_
+#define _IPA_SMP2P_H_
+
+#include <linux/types.h>
+
+struct ipa;
+
+/**
+ * ipa_smp2p_init() - Initialize the IPA SMP2P subsystem
+ * @ipa:	IPA pointer
+ * @modem_init:	Whether the modem is responsible for GSI initialization
+ *
+ * @Return:	Pointer to IPA SMP2P info, or a pointer-coded error
+ */
+struct ipa_smp2p *ipa_smp2p_init(struct ipa *ipa, bool modem_init);
+
+/**
+ * ipa_smp2p_exit() - Inverse of ipa_smp2p_init()
+ * @smp2p:	SMP2P information pointer
+ */
+void ipa_smp2p_exit(struct ipa_smp2p *smp2p);
+
+/**
+ * ipa_smp2p_disable() - Prevent "ipa-setup-ready" interrupt handling
+ * @smp2p:	SMP2P information pointer
+ *
+ * Prevent handling of the "setup ready" interrupt from the modem.
+ * This is used before initiating shutdown of the driver.
+ */
+void ipa_smp2p_disable(struct ipa_smp2p *smp2p);
+
+/**
+ * ipa_smp2p_notify_reset() - Reset modem notification state
+ * @smp2p:	SMP2P information pointer
+ *
+ * If the modem crashes it queries the IPA clock state.  In cleaning
+ * up after such a crash this is used to reset some state maintained
+ * for managing this notification.
+ */
+void ipa_smp2p_notify_reset(struct ipa_smp2p *smp2p);
+
+#endif /* _IPA_SMP2P_H_ */
-- 
2.20.1

