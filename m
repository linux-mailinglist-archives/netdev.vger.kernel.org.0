Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908A1481E40
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 17:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240211AbhL3Qj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 11:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240369AbhL3QjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 11:39:19 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A960C06173F
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 08:39:19 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v16so21613466pjn.1
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 08:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KCPuHHbDjynSNm9/mvXrc8jrpJlTBEUE0T9zT3U+cgE=;
        b=aHd80rUxJ3E4xwJCm0dIZUMa0mtradbi/F7O2+NRieh3qbDRxcQ64uCGxUWpZMRcXR
         hz3ZH+tjslDBenF7qCWRiIfeJR1hgbY8TJPnCFfnqWJnYFRWT6O9wzJKFpEnxyCe+cpQ
         NwrH+o9rboFYnMGe1CXiEqTNDd2pCE9S/8mUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KCPuHHbDjynSNm9/mvXrc8jrpJlTBEUE0T9zT3U+cgE=;
        b=RzrTd1IEF/eC1RUGakeuXIR+ZlCUNVNZd6moWDZEFtnNx7t0jO3Sn8yvRZfEi7mDUJ
         waFhy04gLiX55sjW3DKgGiOutsTaqIYK5knha6dOFdOu6xKMabMUeEGH/eKDRyQGm/3l
         upSOfl19P08E2dMaZDM3CjFikz144pS+qKiIZSxh9F0cBY5ytayhWgCkAB9wsQm+DvL/
         nXG2xzU0GPARQJd3PPiSzkGKEYzkrzyfSqGp9sutPyiXjzR30U7JKNwCiN91KNt37xdQ
         IzJGLsddETKvjbn7yUx1fKghvsedQu5pPKHl3OMUGN5+mfyY8g4ZR+fRV145cG8E4qWe
         C+RQ==
X-Gm-Message-State: AOAM5300gCT/N8W1pYZD76cGWuHVFX5ghPNe4nBtp/zu40SoRaTsPJnx
        9XngJ0aCIcZUQrI9FB3kdifIfQ==
X-Google-Smtp-Source: ABdhPJyhc3VnpWPO9ExokL/6r2H/jUV+z+6s8tRofuKVkjTwAE5g1Cg1XLqm4ZhogdKwy+h0z0Pkxw==
X-Received: by 2002:a17:902:a408:b0:149:9055:98b1 with SMTP id p8-20020a170902a40800b00149905598b1mr14046237plq.2.1640882359003;
        Thu, 30 Dec 2021 08:39:19 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id l6sm27390380pfu.63.2021.12.30.08.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 08:39:18 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 5/8] net/funeth: devlink support
Date:   Thu, 30 Dec 2021 08:39:06 -0800
Message-Id: <20211230163909.160269-6-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211230163909.160269-1-dmichail@fungible.com>
References: <20211230163909.160269-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink part, primarily FW updating.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../ethernet/fungible/funeth/funeth_devlink.c | 273 ++++++++++++++++++
 .../ethernet/fungible/funeth/funeth_devlink.h |  13 +
 2 files changed, 286 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.h

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_devlink.c b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
new file mode 100644
index 000000000000..834648b131f8
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+#include <linux/firmware.h>
+#include <linux/pci.h>
+
+#include "funeth.h"
+#include "funeth_devlink.h"
+
+/* max length of scatter-gather list used to pass FW image data to the device */
+#define FUN_FW_SGL_LEN ((ADMIN_SQE_SIZE - sizeof(struct fun_admin_swu_req)) / \
+			sizeof(struct fun_subop_sgl))
+
+/* size of each DMA buffer that is part of the above SGL */
+#define FUN_FW_SGL_BUF_LEN 65536U
+
+struct fun_fw_buf {
+	void *vaddr;
+	dma_addr_t dma_addr;
+	unsigned int data_len;
+};
+
+/* Start or commit the FW update for the given component with a FW image of
+ * size @img_size.
+ */
+static int fun_fw_update_one(struct fun_dev *fdev, unsigned int handle,
+			     unsigned int comp_id, unsigned int flags,
+			     unsigned int img_size)
+{
+	union {
+		struct fun_admin_swu_req req;
+		struct fun_admin_swu_rsp rsp;
+	} cmd;
+	int rc;
+
+	cmd.req.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_SWUPGRADE,
+						    sizeof(cmd.req));
+	cmd.req.u.upgrade =
+		FUN_ADMIN_SWU_UPGRADE_REQ_INIT(FUN_ADMIN_SWU_SUBOP_UPGRADE,
+					       flags, handle, comp_id,
+					       img_size);
+	rc = fun_submit_admin_sync_cmd(fdev, &cmd.req.common, &cmd.rsp,
+				       sizeof(cmd.rsp), 0);
+	if (!rc)
+		rc = -be32_to_cpu(cmd.rsp.u.upgrade.status);
+	return rc;
+}
+
+/* DMA a gather list of FW image data starting at @offset to the device's FW
+ * staging area.
+ */
+static int fun_fw_write(struct fun_dev *fdev, unsigned int handle,
+			unsigned int offset, unsigned int nsgl,
+			const struct fun_fw_buf *bufs)
+{
+	unsigned int cmd_sz, total_data_len = 0, i;
+	union {
+		struct fun_admin_swu_req req;
+		u8 v[ADMIN_SQE_SIZE];
+	} cmd;
+
+	cmd_sz = struct_size(&cmd.req, sgl, nsgl);
+	if (cmd_sz > sizeof(cmd))
+		return -EINVAL;
+
+	cmd.req.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_SWUPGRADE,
+						    cmd_sz);
+
+	for (i = 0; i < nsgl; i++, bufs++) {
+		total_data_len += bufs->data_len;
+		cmd.req.sgl[i] = FUN_SUBOP_SGL_INIT(FUN_DATAOP_GL, 0,
+						    i ? 0 : nsgl,
+						    bufs->data_len,
+						    bufs->dma_addr);
+	}
+
+	cmd.req.u.upgrade_data =
+		FUN_ADMIN_SWU_UPGRADE_DATA_REQ_INIT(FUN_ADMIN_SWU_SUBOP_UPGRADE_DATA,
+						    0, handle, offset,
+						    total_data_len);
+	return fun_submit_admin_sync_cmd(fdev, &cmd.req.common, NULL, 0, 0);
+}
+
+/* Convert a FW component string into a component ID.
+ * Component names are 4 characters long.
+ */
+static unsigned int fw_component_id(const char *component)
+{
+	if (strlen(component) != 4)
+		return 0;
+
+	return component[0] | (component[1] << 8) | (component[2] << 16) |
+	       (component[3] << 24);
+}
+
+/* Allocate the SG buffers for the DMA transfer of the FW image of the
+ * given size. We allocate up to the max SG length supported by the device.
+ * Return success if at least 1 buffer is allocated.
+ */
+static int fun_init_fw_dma_bufs(struct device *dev, struct fun_fw_buf *bufs,
+				size_t fw_size)
+{
+	unsigned int i, nbufs;
+
+	nbufs = min(FUN_FW_SGL_LEN, DIV_ROUND_UP(fw_size, FUN_FW_SGL_BUF_LEN));
+	for (i = 0; i < nbufs; i++, bufs++) {
+		bufs->vaddr = dma_alloc_coherent(dev, FUN_FW_SGL_BUF_LEN,
+						 &bufs->dma_addr, GFP_KERNEL);
+		if (!bufs->vaddr) {
+			if (!i)
+				return -ENOMEM;
+			break;
+		}
+	}
+	return i;
+}
+
+static void fun_free_fw_bufs(struct device *dev, struct fun_fw_buf *bufs,
+			     unsigned int nbufs)
+{
+	for ( ; nbufs; nbufs--, bufs++)
+		dma_free_coherent(dev, FUN_FW_SGL_BUF_LEN, bufs->vaddr,
+				  bufs->dma_addr);
+}
+
+/* Scatter the FW data starting at @offset into the @nbufs DMA buffers.
+ * Return the new offset into the FW image.
+ */
+static unsigned int fun_fw_scatter(struct fun_fw_buf *bufs, unsigned int nbufs,
+				   const struct firmware *fw,
+				   unsigned int offset)
+{
+	for ( ; nbufs && offset < fw->size; nbufs--, bufs++) {
+		bufs->data_len = min_t(unsigned int, fw->size - offset,
+				       FUN_FW_SGL_BUF_LEN);
+		memcpy(bufs->vaddr, fw->data + offset, bufs->data_len);
+		offset += bufs->data_len;
+	}
+	return offset;
+}
+
+static int fun_dl_flash_update(struct devlink *devlink,
+			       struct devlink_flash_update_params *params,
+			       struct netlink_ext_ack *extack)
+{
+	unsigned int comp_id, update_flags, nbufs, offset;
+	struct fun_dev *fdev = devlink_priv(devlink);
+	const char *component = params->component;
+	struct fun_fw_buf bufs[FUN_FW_SGL_LEN];
+	const struct firmware *fw;
+	int err;
+
+	if (!to_pci_dev(fdev->dev)->is_physfn)
+		return -EOPNOTSUPP;
+
+	if (!component) {
+		NL_SET_ERR_MSG_MOD(extack, "must specify FW component");
+		return -EINVAL;
+	}
+
+	comp_id = fw_component_id(component);
+	if (!comp_id) {
+		NL_SET_ERR_MSG_MOD(extack, "bad FW component");
+		return -EINVAL;
+	}
+
+	err = fun_get_fw_handle(fdev);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "can't create FW update handle");
+		return err;
+	}
+
+	fw = params->fw;
+
+	err = fun_init_fw_dma_bufs(fdev->dev, bufs, fw->size);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "unable to create FW DMA SGL");
+		return err;
+	}
+	nbufs = err;
+
+	devlink_flash_update_status_notify(devlink, "Preparing to flash",
+					   component, 0, 1);
+
+	err = fun_fw_update_one(fdev, fdev->fw_handle, comp_id,
+				FUN_ADMIN_SWU_UPGRADE_FLAG_INIT, fw->size);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unable to create device staging area for FW image");
+		goto free_bufs;
+	}
+
+	devlink_flash_update_status_notify(devlink, "Preparing to flash",
+					   component, 1, 1);
+
+	/* Write FW to the device staging area, in chunks if needed. */
+	for (offset = 0; offset < fw->size; ) {
+		unsigned int new_offset, nsgl;
+
+		new_offset = fun_fw_scatter(bufs, nbufs, fw, offset);
+		nsgl = DIV_ROUND_UP(new_offset - offset, FUN_FW_SGL_BUF_LEN);
+		devlink_flash_update_status_notify(devlink, "Staging FW",
+						   component, offset, fw->size);
+		err = fun_fw_write(fdev, fdev->fw_handle, offset, nsgl, bufs);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "error staging FW image");
+			goto free_bufs;
+		}
+		offset = new_offset;
+	}
+	devlink_flash_update_status_notify(devlink, "Staging FW",
+					   component, offset, fw->size);
+
+	update_flags = FUN_ADMIN_SWU_UPGRADE_FLAG_COMPLETE |
+		       FUN_ADMIN_SWU_UPGRADE_FLAG_DOWNGRADE;
+	err = fun_fw_update_one(fdev, fdev->fw_handle, comp_id, update_flags,
+				fw->size);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "unable to commit FW update");
+		devlink_flash_update_status_notify(devlink, "FW update failed",
+						   component, 0, fw->size);
+	} else {
+		devlink_flash_update_status_notify(devlink, "FW updated",
+						   component, fw->size,
+						   fw->size);
+	}
+
+free_bufs:
+	fun_free_fw_bufs(fdev->dev, bufs, nbufs);
+	return err;
+}
+
+static int fun_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+			   struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (err)
+		return err;
+
+	err = devlink_info_version_fixed_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_BOARD_MANUFACTURE,
+			"Fungible");
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static const struct devlink_ops fun_dl_ops = {
+	.info_get       = fun_dl_info_get,
+	.flash_update   = fun_dl_flash_update,
+};
+
+struct devlink *fun_devlink_alloc(struct device *dev)
+{
+	return devlink_alloc(&fun_dl_ops, sizeof(struct fun_ethdev), dev);
+}
+
+void fun_devlink_free(struct devlink *devlink)
+{
+	devlink_free(devlink);
+}
+
+void fun_devlink_register(struct devlink *devlink)
+{
+	devlink_register(devlink);
+}
+
+void fun_devlink_unregister(struct devlink *devlink)
+{
+	devlink_unregister(devlink);
+}
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_devlink.h b/drivers/net/ethernet/fungible/funeth/funeth_devlink.h
new file mode 100644
index 000000000000..e40464d57ff4
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_devlink.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
+#ifndef __FUNETH_DEVLINK_H
+#define __FUNETH_DEVLINK_H
+
+#include <net/devlink.h>
+
+struct devlink *fun_devlink_alloc(struct device *dev);
+void fun_devlink_free(struct devlink *devlink);
+void fun_devlink_register(struct devlink *devlink);
+void fun_devlink_unregister(struct devlink *devlink);
+
+#endif /* __FUNETH_DEVLINK_H */
-- 
2.25.1

