Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91DE6302B7
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiKRXOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235149AbiKRXNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:36 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8321ECC153
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:53 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p21so5809804plr.7
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G63oU9Cwrei/CJINGPHYmEvgtjsM6IAxrw6T7jYGLyA=;
        b=eLfXqccnYD6lApmHtQzZQAsjmjCkzuaSVeWVJ0gCpPkg1cF9G7u+RdaUCoK3MlP5K1
         rXbppfLGFRzknxDPmgicr0qImXF6/6WDhtMI/QJ+rd4DXnH+E45Dv1iMkY4km0b2Du6C
         BBbJs9GBCUpqlDRs/5JLUYtDlS3C6nIdGYpOUN0pqvY1SDKU4DOA1rQjpnw0OQYF3QMI
         XsU4OC5JQblBGyp4AS7nVKfYgedy/s4Gp65nv8WG71aU8PNSYL8WX/ChnDBq3FdxCizD
         ynMRs0q77z2h9clkmzR0C9QQ8sy9W7flmrzEsTCEzsHnyYGrK3n6Q28ezXZQ95SimRs1
         DaKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G63oU9Cwrei/CJINGPHYmEvgtjsM6IAxrw6T7jYGLyA=;
        b=gbHrTsdfUBeqkzcBrue5czMA8uG7lVdWJCNVBCFsLqWaRkbKo8B2uaL1IgHWoNEaPi
         qfchi5QHYxLAW1LWK82RvAwWO76Sha1YBPSVbVzXiNzWtgu8eEDt0rqm7ZeuWIQ6QY6V
         70lTVHmW+fWnqodWecd1y9xUxPaZFMPP2gMdppA5nFEX0bP3VWANODztuBbZVvVd3TEv
         NM/kz0VL+QUxzLDRv5k6GMrzBwIUbrPOxur3Oty+71SHgivN8+ZjMID+xBPc3G6AH+OV
         TllUFGqkwaZim5fZDC4q8GX1MLiVEevwpWPiNtcEdLWQ4kVqCDfavZBpJA6eZ4dRtmC+
         WYgg==
X-Gm-Message-State: ANoB5pkkp1FF4ByHZE1v7epyzp0qIQZjLXVAtQiFvVIjmZvOOcitsbuc
        Dc8IdiyLRLdhq42AwViB9/hInhBYNJ1oSQ==
X-Google-Smtp-Source: AA0mqf4F2pbVPJNEjo/AJgG6KUWgVhjc3wVW4toXY/CGwOkxQ11w7rQpC2kHKzh4/xbrFS2H/2j8ow==
X-Received: by 2002:a17:90b:3c0a:b0:212:510b:5851 with SMTP id pb10-20020a17090b3c0a00b00212510b5851mr9718618pjb.57.1668812247157;
        Fri, 18 Nov 2022 14:57:27 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:26 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 11/19] pds_core: add the aux client API
Date:   Fri, 18 Nov 2022 14:56:48 -0800
Message-Id: <20221118225656.48309-12-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the client API operations for registering, unregistering,
and running adminq commands.  We expect to add additional
operations for other clients, including requesting additional
private adminqs and IRQs, but don't have the need yet,

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/pds_core/auxbus.c   | 144 +++++++++++++++++-
 include/linux/pds/pds_auxbus.h                |  51 +++++++
 2 files changed, 193 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/pds_core/auxbus.c b/drivers/net/ethernet/pensando/pds_core/auxbus.c
index 9b67cb4006d9..1fcfe8ae9971 100644
--- a/drivers/net/ethernet/pensando/pds_core/auxbus.c
+++ b/drivers/net/ethernet/pensando/pds_core/auxbus.c
@@ -11,6 +11,144 @@
 #include <linux/pds/pds_adminq.h>
 #include <linux/pds/pds_auxbus.h>
 
+/**
+ * pds_client_register - Register the client with the device
+ * @padev:  ptr to the client device info
+ * @padrv:  ptr to the client driver info
+ *
+ * Register the client with the core and with the DSC.  The core
+ * will fill in the client padev->client_id for use in calls
+ * to the DSC AdminQ
+ */
+static int pds_client_register(struct pds_auxiliary_dev *padev,
+			       struct pds_auxiliary_drv *padrv)
+{
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev;
+	struct pdsc *pdsc;
+	int err;
+	u16 ci;
+
+	pdsc = (struct pdsc *)dev_get_drvdata(padev->aux_dev.dev.parent);
+	dev = pdsc->dev;
+
+	if (pdsc->state)
+		return -ENXIO;
+
+	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
+	strscpy(cmd.client_reg.devname, dev_name(&padev->aux_dev.dev),
+		sizeof(cmd.client_reg.devname));
+
+	err = pdsc_adminq_post(pdsc, &pdsc->adminqcq, &cmd, &comp, false);
+	if (err) {
+		dev_info(dev, "register dev_name %s with DSC failed, status %d: %pe\n",
+			 dev_name(&padev->aux_dev.dev), comp.status, ERR_PTR(err));
+		return err;
+	}
+
+	ci = le16_to_cpu(comp.client_reg.client_id);
+	if (!ci) {
+		dev_err(dev, "%s: device returned null client_id\n", __func__);
+		return -EIO;
+	}
+
+	padev->client_id = ci;
+	padev->event_handler = padrv->event_handler;
+
+	return 0;
+}
+
+/**
+ * pds_client_unregister - Disconnect the client from the device
+ * @padev:  ptr to the client device info
+ *
+ * Disconnect the client from the core and with the DSC.
+ */
+static int pds_client_unregister(struct pds_auxiliary_dev *padev)
+{
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev;
+	struct pdsc *pdsc;
+	int err;
+
+	pdsc = (struct pdsc *)dev_get_drvdata(padev->aux_dev.dev.parent);
+	dev = pdsc->dev;
+
+	if (pdsc->state)
+		return -ENXIO;
+
+	cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
+	cmd.client_unreg.client_id = cpu_to_le16(padev->client_id);
+
+	err = pdsc_adminq_post(pdsc, &pdsc->adminqcq, &cmd, &comp, false);
+	if (err)
+		dev_info(dev, "unregister dev_name %s failed, status %d: %pe\n",
+			 dev_name(&padev->aux_dev.dev), comp.status, ERR_PTR(err));
+
+	padev->client_id = 0;
+
+	return err;
+}
+
+/**
+ * pds_client_adminq_cmd - Process an adminq request for the client
+ * @padev:   ptr to the client device
+ * @req:     ptr to buffer with request
+ * @req_len: length of actual struct used for request
+ * @resp:    ptr to buffer where answer is to be copied
+ * @flags:   optional flags from pds_core_adminq_flags
+ *
+ * Return: 0 on success, or
+ *         negative for error
+ *
+ * Client sends pointers to request and response buffers
+ * Core copies request data into pds_core_client_request_cmd
+ * Core sets other fields as needed
+ * Core posts to AdminQ
+ * Core copies completion data into response buffer
+ */
+static int pds_client_adminq_cmd(struct pds_auxiliary_dev *padev,
+				 union pds_core_adminq_cmd *req,
+				 size_t req_len,
+				 union pds_core_adminq_comp *resp,
+				 u64 flags)
+{
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev;
+	struct pdsc *pdsc;
+	size_t cp_len;
+	int err;
+
+	pdsc = (struct pdsc *)dev_get_drvdata(padev->aux_dev.dev.parent);
+	dev = pdsc->dev;
+
+	dev_dbg(dev, "%s: %s opcode %d\n",
+		__func__, dev_name(&padev->aux_dev.dev), req->opcode);
+
+	if (pdsc->state)
+		return -ENXIO;
+
+	/* Wrap the client's request */
+	cmd.client_request.opcode = PDS_AQ_CMD_CLIENT_CMD;
+	cmd.client_request.client_id = cpu_to_le16(padev->client_id);
+	cp_len = min_t(size_t, req_len, sizeof(cmd.client_request.client_cmd));
+	memcpy(cmd.client_request.client_cmd, req, cp_len);
+
+	err = pdsc_adminq_post(pdsc, &pdsc->adminqcq, &cmd, resp, !!(flags & PDS_AQ_FLAG_FASTPOLL));
+	if (err && err != -EAGAIN)
+		dev_info(dev, "client admin cmd failed: %pe\n", ERR_PTR(err));
+
+	return err;
+}
+
+static struct pds_core_ops pds_core_ops = {
+	.register_client = pds_client_register,
+	.unregister_client = pds_client_unregister,
+	.adminq_cmd = pds_client_adminq_cmd,
+};
+
 static void pdsc_auxbus_dev_release(struct device *dev)
 {
 	struct pds_auxiliary_dev *padev =
@@ -21,7 +159,8 @@ static void pdsc_auxbus_dev_release(struct device *dev)
 
 static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *pdsc,
 							  char *name, u32 id,
-							  struct pci_dev *client_dev)
+							  struct pci_dev *client_dev,
+							  struct pds_core_ops *ops)
 {
 	struct auxiliary_device *aux_dev;
 	struct pds_auxiliary_dev *padev;
@@ -31,6 +170,7 @@ static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *pdsc,
 	if (!padev)
 		return NULL;
 
+	padev->ops = ops;
 	padev->pcidev = client_dev;
 
 	aux_dev = &padev->aux_dev;
@@ -99,7 +239,7 @@ int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id)
 		id = PCI_DEVID(pdsc->pdev->bus->number,
 			       pci_iov_virtfn_devfn(pdsc->pdev, vf_id));
 		padev = pdsc_auxbus_dev_register(pdsc, pdsc->viftype_status[vt].name, id,
-						 pdsc->pdev);
+						 pdsc->pdev, &pds_core_ops);
 		pdsc->vfs[vf_id].padev = padev;
 
 		/* We only support a single type per VF, so jump out here */
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
index 7ad66d726b01..ac121b44c71a 100644
--- a/include/linux/pds/pds_auxbus.h
+++ b/include/linux/pds/pds_auxbus.h
@@ -27,6 +27,7 @@ struct pds_auxiliary_drv {
 
 struct pds_auxiliary_dev {
 	struct auxiliary_device aux_dev;
+	struct pds_core_ops *ops;
 	struct pci_dev *pcidev;
 	u32 id;
 	u16 client_id;
@@ -34,4 +35,54 @@ struct pds_auxiliary_dev {
 			      union pds_core_notifyq_comp *event);
 	void *priv;
 };
+
+struct pds_fw_state {
+	unsigned long last_fw_time;
+	u32 fw_heartbeat;
+	u8  fw_status;
+};
+
+/*
+ *   ptrs to functions to be used by the client for core services
+ */
+struct pds_core_ops {
+
+	/* .register() - register the client with the device
+	 * padev:  ptr to the client device info
+	 * padrv:  ptr to the client driver info
+	 * Register the client with the core and with the DSC.  The core
+	 * will fill in the client padrv->client_id for use in calls
+	 * to the DSC AdminQ
+	 */
+	int (*register_client)(struct pds_auxiliary_dev *padev,
+			       struct pds_auxiliary_drv *padrv);
+
+	/* .unregister() - disconnect the client from the device
+	 * padev:  ptr to the client device info
+	 * Disconnect the client from the core and with the DSC.
+	 */
+	int (*unregister_client)(struct pds_auxiliary_dev *padev);
+
+	/* .adminq_cmd() - process an adminq request for the client
+	 * padev:  ptr to the client device
+	 * req:     ptr to buffer with request
+	 * req_len: length of actual struct used for request
+	 * resp:    ptr to buffer where answer is to be copied
+	 * flags:   optional flags defined by enum pds_core_adminq_flags
+	 *	    and used for more flexible adminq behvior
+	 *
+	 * returns 0 on success, or
+	 *         negative for error
+	 * Client sends pointers to request and response buffers
+	 * Core copies request data into pds_core_client_request_cmd
+	 * Core sets other fields as needed
+	 * Core posts to AdminQ
+	 * Core copies completion data into response buffer
+	 */
+	int (*adminq_cmd)(struct pds_auxiliary_dev *padev,
+			  union pds_core_adminq_cmd *req,
+			  size_t req_len,
+			  union pds_core_adminq_comp *resp,
+			  u64 flags);
+};
 #endif /* _PDSC_AUXBUS_H_ */
-- 
2.17.1

