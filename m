Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98DB2EAD29
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfJaKJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:09:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55237 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfJaKIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:08:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id c12so708383wml.4
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 03:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wEtFuOQbnqkCm+YMw+q0AVoffrvisp8fPIpvD68mwAY=;
        b=Xpghh2BDBzFLBYNzjJ+bYitguKy3roxfdmATYQSj3iUIQ2QpmlzG0qwHD3Kz/5jmP+
         m+guLnF1LwakF+OYc6LFL6Eyst0UROI6O8RhIJ7L4G0ZdrszNQgFmtK++krqeQJcaxLp
         37iE8iGxHIItp1LpGyzi8XtDTKXyG/nfd/wTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wEtFuOQbnqkCm+YMw+q0AVoffrvisp8fPIpvD68mwAY=;
        b=YNEPeVp20AbxBkBa2iCT6XHpiAWIWZZz0c1KxKAemxiwdLP0PlnLpqoav3osAlxfDL
         97wwESFuXMKTZ+xIdow5KhiLQuockbyLXHdVzNz+NwH5diaAtSzbtBNiHLumYxVbPQej
         dkh/sAwMO3VCuuL8TxWx8msJeoHV47YsdLbUDC5s2hMx9jRYcre9XQPKQXC1hVw/MMPc
         8IQC/3fxPP1/w20k5ihFcJbm954StdM0t3CH1PBwAUv5OreNeGx839e6GR5Aolz29PsY
         ma1VHniAR0NwwejExqpVF108OGfBNHZstzX+3w6CaigkIewyE3UCQOXwt4RL2N4B5aaP
         +lDA==
X-Gm-Message-State: APjAAAXagjIROds/ZGK3Zbyx7ZBYvktv1jCpUHuupwFmbAzUoDKYlubh
        jLGiDFOdXdl/2PZtHS3pkGhubA==
X-Google-Smtp-Source: APXvYqzule7hvriuqscJvUXX1Wh5M2p7vWtOLRWlgOaTiC+9Ep6zorMH//W6t65/6TZ0p73glJrW5w==
X-Received: by 2002:a1c:9cc6:: with SMTP id f189mr4626287wme.80.1572516530022;
        Thu, 31 Oct 2019 03:08:50 -0700 (PDT)
Received: from shitalt.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w8sm3719609wrr.44.2019.10.31.03.08.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 31 Oct 2019 03:08:49 -0700 (PDT)
From:   Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Subject: [PATCH net-next V5 1/3] firmware: broadcom: add OP-TEE based BNXT f/w manager
Date:   Thu, 31 Oct 2019 15:38:50 +0530
Message-Id: <1572516532-5977-2-git-send-email-sheetal.tigadoli@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572516532-5977-1-git-send-email-sheetal.tigadoli@broadcom.com>
References: <1572516532-5977-1-git-send-email-sheetal.tigadoli@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vikas Gupta <vikas.gupta@broadcom.com>

This driver registers on TEE bus to interact with OP-TEE based
BNXT firmware management modules

Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
---
 drivers/firmware/broadcom/Kconfig             |   8 +
 drivers/firmware/broadcom/Makefile            |   1 +
 drivers/firmware/broadcom/tee_bnxt_fw.c       | 279 ++++++++++++++++++
 include/linux/firmware/broadcom/tee_bnxt_fw.h |  14 +
 4 files changed, 302 insertions(+)
 create mode 100644 drivers/firmware/broadcom/tee_bnxt_fw.c
 create mode 100644 include/linux/firmware/broadcom/tee_bnxt_fw.h

diff --git a/drivers/firmware/broadcom/Kconfig b/drivers/firmware/broadcom/Kconfig
index d03ed8e43ad7..8e3d355a637a 100644
--- a/drivers/firmware/broadcom/Kconfig
+++ b/drivers/firmware/broadcom/Kconfig
@@ -22,3 +22,11 @@ config BCM47XX_SPROM
 	  In case of SoC devices SPROM content is stored on a flash used by
 	  bootloader firmware CFE. This driver provides method to ssb and bcma
 	  drivers to read SPROM on SoC.
+
+config TEE_BNXT_FW
+	tristate "Broadcom BNXT firmware manager"
+	depends on (ARCH_BCM_IPROC && OPTEE) || (COMPILE_TEST && TEE)
+	default ARCH_BCM_IPROC
+	help
+	  This module help to manage firmware on Broadcom BNXT device. The module
+	  registers on tee bus and invoke calls to manage firmware on BNXT device.
diff --git a/drivers/firmware/broadcom/Makefile b/drivers/firmware/broadcom/Makefile
index 72c7fdc20c77..17c5061c47a7 100644
--- a/drivers/firmware/broadcom/Makefile
+++ b/drivers/firmware/broadcom/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_BCM47XX_NVRAM)		+= bcm47xx_nvram.o
 obj-$(CONFIG_BCM47XX_SPROM)		+= bcm47xx_sprom.o
+obj-$(CONFIG_TEE_BNXT_FW)		+= tee_bnxt_fw.o
diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
new file mode 100644
index 000000000000..5b7ef89eb701
--- /dev/null
+++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
@@ -0,0 +1,279 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2019 Broadcom.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/tee_drv.h>
+#include <linux/uuid.h>
+
+#include <linux/firmware/broadcom/tee_bnxt_fw.h>
+
+#define MAX_SHM_MEM_SZ	SZ_4M
+
+#define MAX_TEE_PARAM_ARRY_MEMB		4
+
+enum ta_cmd {
+	/*
+	 * TA_CMD_BNXT_FASTBOOT - boot bnxt device by copying f/w into sram
+	 *
+	 *	param[0] unused
+	 *	param[1] unused
+	 *	param[2] unused
+	 *	param[3] unused
+	 *
+	 * Result:
+	 *	TEE_SUCCESS - Invoke command success
+	 *	TEE_ERROR_ITEM_NOT_FOUND - Corrupt f/w image found on memory
+	 */
+	TA_CMD_BNXT_FASTBOOT = 0,
+
+	/*
+	 * TA_CMD_BNXT_COPY_COREDUMP - copy the core dump into shm
+	 *
+	 *	param[0] (inout memref) - Coredump buffer memory reference
+	 *	param[1] (in value) - value.a: offset, data to be copied from
+	 *			      value.b: size of data to be copied
+	 *	param[2] unused
+	 *	param[3] unused
+	 *
+	 * Result:
+	 *	TEE_SUCCESS - Invoke command success
+	 *	TEE_ERROR_BAD_PARAMETERS - Incorrect input param
+	 *	TEE_ERROR_ITEM_NOT_FOUND - Corrupt core dump
+	 */
+	TA_CMD_BNXT_COPY_COREDUMP = 3,
+};
+
+/**
+ * struct tee_bnxt_fw_private - OP-TEE bnxt private data
+ * @dev:		OP-TEE based bnxt device.
+ * @ctx:		OP-TEE context handler.
+ * @session_id:		TA session identifier.
+ */
+struct tee_bnxt_fw_private {
+	struct device *dev;
+	struct tee_context *ctx;
+	u32 session_id;
+	struct tee_shm *fw_shm_pool;
+};
+
+static struct tee_bnxt_fw_private pvt_data;
+
+static void prepare_args(int cmd,
+			 struct tee_ioctl_invoke_arg *arg,
+			 struct tee_param *param)
+{
+	memset(arg, 0, sizeof(*arg));
+	memset(param, 0, MAX_TEE_PARAM_ARRY_MEMB * sizeof(*param));
+
+	arg->func = cmd;
+	arg->session = pvt_data.session_id;
+	arg->num_params = MAX_TEE_PARAM_ARRY_MEMB;
+
+	/* Fill invoke cmd params */
+	switch (cmd) {
+	case TA_CMD_BNXT_COPY_COREDUMP:
+		param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT;
+		param[0].u.memref.shm = pvt_data.fw_shm_pool;
+		param[0].u.memref.size = MAX_SHM_MEM_SZ;
+		param[0].u.memref.shm_offs = 0;
+		param[1].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INPUT;
+		break;
+	case TA_CMD_BNXT_FASTBOOT:
+	default:
+		/* Nothing to do */
+		break;
+	}
+}
+
+/**
+ * tee_bnxt_fw_load() - Load the bnxt firmware
+ *		    Uses an OP-TEE call to start a secure
+ *		    boot process.
+ * Returns 0 on success, negative errno otherwise.
+ */
+int tee_bnxt_fw_load(void)
+{
+	int ret = 0;
+	struct tee_ioctl_invoke_arg arg;
+	struct tee_param param[MAX_TEE_PARAM_ARRY_MEMB];
+
+	if (!pvt_data.ctx)
+		return -ENODEV;
+
+	prepare_args(TA_CMD_BNXT_FASTBOOT, &arg, param);
+
+	ret = tee_client_invoke_func(pvt_data.ctx, &arg, param);
+	if (ret < 0 || arg.ret != 0) {
+		dev_err(pvt_data.dev,
+			"TA_CMD_BNXT_FASTBOOT invoke failed TEE err: %x, ret:%x\n",
+			arg.ret, ret);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(tee_bnxt_fw_load);
+
+/**
+ * tee_bnxt_copy_coredump() - Copy coredump from the allocated memory
+ *			    Uses an OP-TEE call to copy coredump
+ * @buf:	destination buffer where core dump is copied into
+ * @offset:	offset from the base address of core dump area
+ * @size:	size of the dump
+ *
+ * Returns 0 on success, negative errno otherwise.
+ */
+int tee_bnxt_copy_coredump(void *buf, u32 offset, u32 size)
+{
+	struct tee_ioctl_invoke_arg arg;
+	struct tee_param param[MAX_TEE_PARAM_ARRY_MEMB];
+	void *core_data;
+	u32 rbytes = size;
+	u32 nbytes = 0;
+	int ret = 0;
+
+	if (!pvt_data.ctx)
+		return -ENODEV;
+
+	prepare_args(TA_CMD_BNXT_COPY_COREDUMP, &arg, param);
+
+	while (rbytes)  {
+		nbytes = rbytes;
+
+		nbytes = min_t(u32, rbytes, param[0].u.memref.size);
+
+		/* Fill additional invoke cmd params */
+		param[1].u.value.a = offset;
+		param[1].u.value.b = nbytes;
+
+		ret = tee_client_invoke_func(pvt_data.ctx, &arg, param);
+		if (ret < 0 || arg.ret != 0) {
+			dev_err(pvt_data.dev,
+				"TA_CMD_BNXT_COPY_COREDUMP invoke failed TEE err: %x, ret:%x\n",
+				arg.ret, ret);
+			return -EINVAL;
+		}
+
+		core_data = tee_shm_get_va(pvt_data.fw_shm_pool, 0);
+		if (IS_ERR(core_data)) {
+			dev_err(pvt_data.dev, "tee_shm_get_va failed\n");
+			return PTR_ERR(core_data);
+		}
+
+		memcpy(buf, core_data, nbytes);
+
+		rbytes -= nbytes;
+		buf += nbytes;
+		offset += nbytes;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(tee_bnxt_copy_coredump);
+
+static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
+{
+	return (ver->impl_id == TEE_IMPL_ID_OPTEE);
+}
+
+static int tee_bnxt_fw_probe(struct device *dev)
+{
+	struct tee_client_device *bnxt_device = to_tee_client_device(dev);
+	int ret, err = -ENODEV;
+	struct tee_ioctl_open_session_arg sess_arg;
+	struct tee_shm *fw_shm_pool;
+
+	memset(&sess_arg, 0, sizeof(sess_arg));
+
+	/* Open context with TEE driver */
+	pvt_data.ctx = tee_client_open_context(NULL, optee_ctx_match, NULL,
+					       NULL);
+	if (IS_ERR(pvt_data.ctx))
+		return -ENODEV;
+
+	/* Open session with Bnxt load Trusted App */
+	memcpy(sess_arg.uuid, bnxt_device->id.uuid.b, TEE_IOCTL_UUID_LEN);
+	sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
+	sess_arg.num_params = 0;
+
+	ret = tee_client_open_session(pvt_data.ctx, &sess_arg, NULL);
+	if (ret < 0 || sess_arg.ret != 0) {
+		dev_err(dev, "tee_client_open_session failed, err: %x\n",
+			sess_arg.ret);
+		err = -EINVAL;
+		goto out_ctx;
+	}
+	pvt_data.session_id = sess_arg.session;
+
+	pvt_data.dev = dev;
+
+	fw_shm_pool = tee_shm_alloc(pvt_data.ctx, MAX_SHM_MEM_SZ,
+				    TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
+	if (IS_ERR(fw_shm_pool)) {
+		tee_client_close_context(pvt_data.ctx);
+		dev_err(pvt_data.dev, "tee_shm_alloc failed\n");
+		err = PTR_ERR(fw_shm_pool);
+		goto out_sess;
+	}
+
+	pvt_data.fw_shm_pool = fw_shm_pool;
+
+	return 0;
+
+out_sess:
+	tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
+out_ctx:
+	tee_client_close_context(pvt_data.ctx);
+
+	return err;
+}
+
+static int tee_bnxt_fw_remove(struct device *dev)
+{
+	tee_shm_free(pvt_data.fw_shm_pool);
+	tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
+	tee_client_close_context(pvt_data.ctx);
+	pvt_data.ctx = NULL;
+
+	return 0;
+}
+
+static const struct tee_client_device_id tee_bnxt_fw_id_table[] = {
+	{UUID_INIT(0x6272636D, 0x2019, 0x0716,
+		    0x42, 0x43, 0x4D, 0x5F, 0x53, 0x43, 0x48, 0x49)},
+	{}
+};
+
+MODULE_DEVICE_TABLE(tee, tee_bnxt_fw_id_table);
+
+static struct tee_client_driver tee_bnxt_fw_driver = {
+	.id_table	= tee_bnxt_fw_id_table,
+	.driver		= {
+		.name		= KBUILD_MODNAME,
+		.bus		= &tee_bus_type,
+		.probe		= tee_bnxt_fw_probe,
+		.remove		= tee_bnxt_fw_remove,
+	},
+};
+
+static int __init tee_bnxt_fw_mod_init(void)
+{
+	return driver_register(&tee_bnxt_fw_driver.driver);
+}
+
+static void __exit tee_bnxt_fw_mod_exit(void)
+{
+	driver_unregister(&tee_bnxt_fw_driver.driver);
+}
+
+module_init(tee_bnxt_fw_mod_init);
+module_exit(tee_bnxt_fw_mod_exit);
+
+MODULE_AUTHOR("Vikas Gupta <vikas.gupta@broadcom.com>");
+MODULE_DESCRIPTION("Broadcom bnxt firmware manager");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/firmware/broadcom/tee_bnxt_fw.h b/include/linux/firmware/broadcom/tee_bnxt_fw.h
new file mode 100644
index 000000000000..f24c82d6ef73
--- /dev/null
+++ b/include/linux/firmware/broadcom/tee_bnxt_fw.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: BSD-2-Clause */
+/*
+ * Copyright 2019 Broadcom.
+ */
+
+#ifndef _BROADCOM_TEE_BNXT_FW_H
+#define _BROADCOM_TEE_BNXT_FW_H
+
+#include <linux/types.h>
+
+int tee_bnxt_fw_load(void);
+int tee_bnxt_copy_coredump(void *buf, u32 offset, u32 size);
+
+#endif /* _BROADCOM_TEE_BNXT_FW_H */
-- 
2.17.1

