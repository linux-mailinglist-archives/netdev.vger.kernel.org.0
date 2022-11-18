Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B408B6302AB
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiKRXNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbiKRXMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:12:52 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4E1C5B7F
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:37 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d20so5791997plr.10
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H96Gl3HR/iE0GR+sZdgei4Yl7S+O9OOs+35/CAIskao=;
        b=V+qTxpAAET7SNrAy3lmPEQ0+am90AIbv74g0giD4QDqJWPHcL0PJQBIpYRFN2yhp8Z
         LVXEZRX147ogJclGv/BO3u8lIvGP/Ny+fImnPs1PqUSexO0qhzzkouONQ90bLAQhnbpa
         VwAbn53flpxpBQIgfdA1y6oVaoU7DDr+3ihzV45TkA9zbTlGuhL14YZG2uk6S7zgAsnX
         yZW5jQ8iVziN0hn1mrw8/LxIBRfOlfPLcvfb0FJA2w9Pz3x7NKvGWlnSf5iNdoGOvhXK
         P3SeKzapPu33NJC+WDmo0fp5GeUEULw++9A1lmEhF+cDsYxh323DSIDR8B1Nk4u34OnK
         XNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H96Gl3HR/iE0GR+sZdgei4Yl7S+O9OOs+35/CAIskao=;
        b=N861bGr4yE1o7F8JwjNzUYssJD5+/+E20/V0ihWJfOi21ON+tFXok3hKxwrR75hm7y
         1dhGFP1yTSkFG/2oA3LCU+iUeFQ5cRLjN81Ulp6EozZfb5GsPzMYtReISQN0oEAnkQ3Q
         bQwRbWZvx86hR437QhcuTD2kgz67BNw00SAq5EiAjEQlWo9ZXhYhvNU7PyRiN7mQ5LLS
         or7LcB+fNJO04NU5iblcrjKRGM5dGsgolQuTlblRlVQfI6q89xoe1s68elAnwZ4fOdMB
         TCO7K0/6XXNd5xlx2vOT1bv7xg+aANYAOhHP0ReNRNltOQhD5webZD++HZRCrb66smJF
         qlJw==
X-Gm-Message-State: ANoB5pn8nREUXa1yCRV56BXqwyCft/KNlWXkBowzIWxs1mBaOIO8mKUm
        +5mE6cSSmwzcjEZHeJZJ1OGXmnKtb/BV9g==
X-Google-Smtp-Source: AA0mqf4wzk/qJxjTl0WQVtwJDK7y6p/i94TKqOKUrd/LygsIZRKXzriF/8RfrCT7X+Wn27u7VmZIjg==
X-Received: by 2002:a17:902:da89:b0:189:8b2:b069 with SMTP id j9-20020a170902da8900b0018908b2b069mr1631441plx.13.1668812234825;
        Fri, 18 Nov 2022 14:57:14 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:14 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 02/19] pds_core: add devcmd device interfaces
Date:   Fri, 18 Nov 2022 14:56:39 -0800
Message-Id: <20221118225656.48309-3-snelson@pensando.io>
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

The devcmd interface is the basic connection to the device through the
PCI BAR for low level identification and command services.  This does
the early device initialization and finds the identity data, and adds
devcmd routines to be used by later driver bits.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/pds_core/Makefile   |   4 +-
 drivers/net/ethernet/pensando/pds_core/core.c |  43 ++
 drivers/net/ethernet/pensando/pds_core/core.h |  58 +++
 .../net/ethernet/pensando/pds_core/debugfs.c  |  67 +++
 drivers/net/ethernet/pensando/pds_core/dev.c  | 400 ++++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/main.c |  30 ++
 include/linux/pds/pds_common.h                |  67 +++
 include/linux/pds/pds_intr.h                  | 160 +++++++
 8 files changed, 828 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/pensando/pds_core/core.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/dev.c
 create mode 100644 include/linux/pds/pds_intr.h

diff --git a/drivers/net/ethernet/pensando/pds_core/Makefile b/drivers/net/ethernet/pensando/pds_core/Makefile
index 72bbc5fa68ad..446054206b6a 100644
--- a/drivers/net/ethernet/pensando/pds_core/Makefile
+++ b/drivers/net/ethernet/pensando/pds_core/Makefile
@@ -4,6 +4,8 @@
 obj-$(CONFIG_PDS_CORE) := pds_core.o
 
 pds_core-y := main.o \
-	      devlink.o
+	      devlink.o \
+	      dev.o \
+	      core.o
 
 pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/pensando/pds_core/core.c b/drivers/net/ethernet/pensando/pds_core/core.c
new file mode 100644
index 000000000000..d846e8b93575
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/core.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <net/devlink.h>
+
+#include "core.h"
+
+int pdsc_setup(struct pdsc *pdsc, bool init)
+{
+	int err = 0;
+
+	if (init)
+		err = pdsc_dev_init(pdsc);
+	else
+		err = pdsc_dev_reinit(pdsc);
+	if (err)
+		return err;
+
+	clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
+	return 0;
+}
+
+void pdsc_teardown(struct pdsc *pdsc, bool removing)
+{
+	pdsc_devcmd_reset(pdsc);
+
+	if (removing && pdsc->intr_info) {
+		devm_kfree(pdsc->dev, pdsc->intr_info);
+		pdsc->intr_info = NULL;
+	}
+
+	if (pdsc->kern_dbpage) {
+		iounmap(pdsc->kern_dbpage);
+		pdsc->kern_dbpage = NULL;
+	}
+
+	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
+}
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index 022adc4aea01..bd86a9cd8e03 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -9,8 +9,13 @@
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_intr.h>
 
 #define PDSC_DRV_DESCRIPTION	"Pensando Core PF Driver"
+#define PDSC_TEARDOWN_RECOVERY  false
+#define PDSC_TEARDOWN_REMOVING  true
+#define PDSC_SETUP_RECOVERY	false
+#define PDSC_SETUP_INIT		true
 
 struct pdsc_dev_bar {
 	void __iomem *vaddr;
@@ -19,6 +24,22 @@ struct pdsc_dev_bar {
 	int res_index;
 };
 
+struct pdsc_devinfo {
+	u8 asic_type;
+	u8 asic_rev;
+	char fw_version[PDS_CORE_DEVINFO_FWVERS_BUFLEN + 1];
+	char serial_num[PDS_CORE_DEVINFO_SERIAL_BUFLEN + 1];
+};
+
+#define PDSC_INTR_NAME_MAX_SZ		32
+
+struct pdsc_intr_info {
+	char name[PDSC_INTR_NAME_MAX_SZ];
+	unsigned int index;
+	unsigned int vector;
+	void *data;
+};
+
 /* No state flags set means we are in a steady running state */
 enum pdsc_state_flags {
 	PDSC_S_FW_DEAD,		    /* fw stopped, waiting for startup or recovery */
@@ -34,11 +55,24 @@ struct pdsc {
 	struct dentry *dentry;
 	struct device *dev;
 	struct pdsc_dev_bar bars[PDS_CORE_BARS_MAX];
+	int num_vfs;
 	int hw_index;
 	int id;
 
 	unsigned long state;
+	u8 fw_status;
+	u8 fw_generation;
+	unsigned long last_fw_time;
+	u32 last_hb;
 
+	struct pdsc_devinfo dev_info;
+	struct pds_core_dev_identity dev_ident;
+	unsigned int nintrs;
+	struct pdsc_intr_info *intr_info;	/* array of nintrs elements */
+
+	unsigned int devcmd_timeout;
+	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
+	struct mutex config_lock;	/* lock for configuration operations */
 	struct pds_core_dev_info_regs __iomem *info_regs;
 	struct pds_core_dev_cmd_regs __iomem *cmd_regs;
 	struct pds_core_intr __iomem *intr_ctrl;
@@ -48,6 +82,8 @@ struct pdsc {
 	u64 __iomem *kern_dbpage;
 };
 
+void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
+
 struct pdsc *pdsc_dl_alloc(struct device *dev);
 void pdsc_dl_free(struct pdsc *pdsc);
 int pdsc_dl_register(struct pdsc *pdsc);
@@ -58,11 +94,33 @@ void pdsc_debugfs_create(void);
 void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
 void pdsc_debugfs_del_dev(struct pdsc *pdsc);
+void pdsc_debugfs_add_ident(struct pdsc *pdsc);
+void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
 #else
 static inline void pdsc_debugfs_create(void) { }
 static inline void pdsc_debugfs_destroy(void) { }
 static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) { }
+static inline void pdsc_debugfs_add_ident(struct pdsc *pdsc) { }
+static inline void pdsc_debugfs_add_irqs(struct pdsc *pdsc) { }
 #endif
 
+int pdsc_err_to_errno(enum pds_core_status_code code);
+bool pdsc_is_fw_running(struct pdsc *pdsc);
+bool pdsc_is_fw_good(struct pdsc *pdsc);
+int pdsc_devcmd(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
+		union pds_core_dev_comp *comp, int max_seconds);
+int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
+		       union pds_core_dev_comp *comp, int max_seconds);
+int pdsc_dev_cmd_vf_getattr(struct pdsc *pdsc, int vf, u8 attr,
+			    struct pds_core_vf_getattr_comp *comp);
+int pdsc_devcmd_init(struct pdsc *pdsc);
+int pdsc_devcmd_reset(struct pdsc *pdsc);
+int pds_devcmd_vf_start(struct pdsc *pdsc);
+int pdsc_dev_reinit(struct pdsc *pdsc);
+int pdsc_dev_init(struct pdsc *pdsc);
+
+int pdsc_setup(struct pdsc *pdsc, bool init);
+void pdsc_teardown(struct pdsc *pdsc, bool removing);
+
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/pensando/pds_core/debugfs.c b/drivers/net/ethernet/pensando/pds_core/debugfs.c
index 3f876dcc5431..698fd6d09387 100644
--- a/drivers/net/ethernet/pensando/pds_core/debugfs.c
+++ b/drivers/net/ethernet/pensando/pds_core/debugfs.c
@@ -44,4 +44,71 @@ void pdsc_debugfs_del_dev(struct pdsc *pdsc)
 	debugfs_remove_recursive(pdsc->dentry);
 	pdsc->dentry = NULL;
 }
+
+static int identity_show(struct seq_file *seq, void *v)
+{
+	struct pdsc *pdsc = seq->private;
+	struct pds_core_dev_identity *ident;
+	int vt;
+
+	ident = &pdsc->dev_ident;
+
+	seq_printf(seq, "asic_type:        0x%x\n", pdsc->dev_info.asic_type);
+	seq_printf(seq, "asic_rev:         0x%x\n", pdsc->dev_info.asic_rev);
+	seq_printf(seq, "serial_num:       %s\n", pdsc->dev_info.serial_num);
+	seq_printf(seq, "fw_version:       %s\n", pdsc->dev_info.fw_version);
+	seq_printf(seq, "fw_status:        0x%x\n",
+		   ioread8(&pdsc->info_regs->fw_status));
+	seq_printf(seq, "fw_heartbeat:     0x%x\n",
+		   ioread32(&pdsc->info_regs->fw_heartbeat));
+
+	seq_printf(seq, "nlifs:            %d\n", le32_to_cpu(ident->nlifs));
+	seq_printf(seq, "nintrs:           %d\n", le32_to_cpu(ident->nintrs));
+	seq_printf(seq, "ndbpgs_per_lif:   %d\n", le32_to_cpu(ident->ndbpgs_per_lif));
+	seq_printf(seq, "intr_coal_mult:   %d\n", le32_to_cpu(ident->intr_coal_mult));
+	seq_printf(seq, "intr_coal_div:    %d\n", le32_to_cpu(ident->intr_coal_div));
+
+	seq_puts(seq, "vif_types:        ");
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++)
+		seq_printf(seq, "%d ", le16_to_cpu(pdsc->dev_ident.vif_types[vt]));
+	seq_puts(seq, "\n");
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(identity);
+
+void pdsc_debugfs_add_ident(struct pdsc *pdsc)
+{
+	debugfs_create_file("identity", 0400, pdsc->dentry, pdsc, &identity_fops);
+}
+
+static int irqs_show(struct seq_file *seq, void *v)
+{
+	struct pdsc *pdsc = seq->private;
+	struct pdsc_intr_info *intr_info;
+	int i;
+
+	seq_printf(seq, "index  vector  name (nintrs %d)\n", pdsc->nintrs);
+
+	if (!pdsc->intr_info)
+		return 0;
+
+	for (i = 0; i < pdsc->nintrs; i++) {
+		intr_info = &pdsc->intr_info[i];
+		if (!intr_info->vector)
+			continue;
+
+		seq_printf(seq, "% 3d    % 3d     %s\n",
+			   i, intr_info->vector, intr_info->name);
+	}
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(irqs);
+
+void pdsc_debugfs_add_irqs(struct pdsc *pdsc)
+{
+	debugfs_create_file("irqs", 0400, pdsc->dentry, pdsc, &irqs_fops);
+}
+
 #endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/net/ethernet/pensando/pds_core/dev.c b/drivers/net/ethernet/pensando/pds_core/dev.c
new file mode 100644
index 000000000000..addbd300e5c3
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/dev.c
@@ -0,0 +1,400 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/utsname.h>
+#include <linux/ctype.h>
+
+#include "core.h"
+
+#define PDS_CASE_STRINGIFY(opcode) case (opcode): return #opcode
+
+int pdsc_err_to_errno(enum pds_core_status_code code)
+{
+	switch (code) {
+	case PDS_RC_SUCCESS:
+		return 0;
+	case PDS_RC_EVERSION:
+	case PDS_RC_EQTYPE:
+	case PDS_RC_EQID:
+	case PDS_RC_EINVAL:
+	case PDS_RC_ENOSUPP:
+		return -EINVAL;
+	case PDS_RC_EPERM:
+		return -EPERM;
+	case PDS_RC_ENOENT:
+		return -ENOENT;
+	case PDS_RC_EAGAIN:
+		return -EAGAIN;
+	case PDS_RC_ENOMEM:
+		return -ENOMEM;
+	case PDS_RC_EFAULT:
+		return -EFAULT;
+	case PDS_RC_EBUSY:
+		return -EBUSY;
+	case PDS_RC_EEXIST:
+		return -EEXIST;
+	case PDS_RC_EVFID:
+		return -ENODEV;
+	case PDS_RC_ECLIENT:
+		return -ECHILD;
+	case PDS_RC_ENOSPC:
+		return -ENOSPC;
+	case PDS_RC_ERANGE:
+		return -ERANGE;
+	case PDS_RC_BAD_ADDR:
+		return -EFAULT;
+	case PDS_RC_EOPCODE:
+	case PDS_RC_EINTR:
+	case PDS_RC_DEV_CMD:
+	case PDS_RC_ERROR:
+	case PDS_RC_ERDMA:
+	case PDS_RC_EIO:
+	default:
+		return -EIO;
+	}
+}
+
+bool pdsc_is_fw_running(struct pdsc *pdsc)
+{
+	pdsc->fw_status = ioread8(&pdsc->info_regs->fw_status);
+	pdsc->last_fw_time = jiffies;
+	pdsc->last_hb = ioread32(&pdsc->info_regs->fw_heartbeat);
+
+	/* Firmware is useful only if the running bit is set and
+	 * fw_status != 0xff (bad PCI read)
+	 */
+	return (pdsc->fw_status != 0xff) &&
+		(pdsc->fw_status & PDS_CORE_FW_STS_F_RUNNING);
+}
+
+bool pdsc_is_fw_good(struct pdsc *pdsc)
+{
+	return pdsc_is_fw_running(pdsc) &&
+		(pdsc->fw_status & PDS_CORE_FW_STS_F_GENERATION) == pdsc->fw_generation;
+}
+
+static u8 pdsc_devcmd_status(struct pdsc *pdsc)
+{
+	return ioread8(&pdsc->cmd_regs->comp.status);
+}
+
+static bool pdsc_devcmd_done(struct pdsc *pdsc)
+{
+	return ioread32(&pdsc->cmd_regs->done) & PDS_CORE_DEV_CMD_DONE;
+}
+
+static void pdsc_devcmd_dbell(struct pdsc *pdsc)
+{
+	iowrite32(0, &pdsc->cmd_regs->done);
+	iowrite32(1, &pdsc->cmd_regs->doorbell);
+}
+
+static void pdsc_devcmd_clean(struct pdsc *pdsc)
+{
+	iowrite32(0, &pdsc->cmd_regs->doorbell);
+	memset_io(&pdsc->cmd_regs->cmd, 0, sizeof(pdsc->cmd_regs->cmd));
+}
+
+static const char *pdsc_devcmd_str(int opcode)
+{
+	switch (opcode) {
+	PDS_CASE_STRINGIFY(PDS_CORE_CMD_NOP);
+	PDS_CASE_STRINGIFY(PDS_CORE_CMD_IDENTIFY);
+	PDS_CASE_STRINGIFY(PDS_CORE_CMD_RESET);
+	PDS_CASE_STRINGIFY(PDS_CORE_CMD_INIT);
+	PDS_CASE_STRINGIFY(PDS_CORE_CMD_FW_DOWNLOAD);
+	PDS_CASE_STRINGIFY(PDS_CORE_CMD_FW_CONTROL);
+	PDS_CASE_STRINGIFY(PDS_CORE_CMD_VF_GETATTR);
+	PDS_CASE_STRINGIFY(PDS_CORE_CMD_VF_SETATTR);
+	default:
+		return "PDS_CORE_CMD_UNKNOWN";
+	}
+}
+
+static int pdsc_devcmd_wait(struct pdsc *pdsc, int max_seconds)
+{
+	struct device *dev = pdsc->dev;
+	unsigned long start_time;
+	unsigned long max_wait;
+	unsigned long duration;
+	int timeout = 0;
+	int status = 0;
+	int done = 0;
+	int err = 0;
+	int opcode;
+
+	opcode = ioread8(&pdsc->cmd_regs->cmd.opcode);
+
+	start_time = jiffies;
+	max_wait = start_time + (max_seconds * HZ);
+
+	while (!done && !timeout) {
+		done = pdsc_devcmd_done(pdsc);
+		if (done)
+			break;
+
+		timeout = time_after(jiffies, max_wait);
+		if (timeout)
+			break;
+
+		usleep_range(100, 200);
+	}
+	duration = jiffies - start_time;
+
+	if (done && duration > HZ)
+		dev_dbg(dev, "DEVCMD %d %s after %ld secs\n",
+			opcode, pdsc_devcmd_str(opcode), duration / HZ);
+
+	if (!done || timeout) {
+		dev_err(dev, "DEVCMD %d %s timeout, done %d timeout %d max_seconds=%d\n",
+			opcode, pdsc_devcmd_str(opcode), done, timeout,
+			max_seconds);
+		err = -ETIMEDOUT;
+		pdsc_devcmd_clean(pdsc);
+	}
+
+	status = pdsc_devcmd_status(pdsc);
+	err = pdsc_err_to_errno(status);
+	if (status != PDS_RC_SUCCESS && status != PDS_RC_EAGAIN)
+		dev_err(dev, "DEVCMD %d %s failed, status=%d err %d %pe\n",
+			opcode, pdsc_devcmd_str(opcode), status, err,
+			ERR_PTR(err));
+
+	return err;
+}
+
+int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
+		       union pds_core_dev_comp *comp, int max_seconds)
+{
+	int err;
+
+	memcpy_toio(&pdsc->cmd_regs->cmd, cmd, sizeof(*cmd));
+	pdsc_devcmd_dbell(pdsc);
+	err = pdsc_devcmd_wait(pdsc, max_seconds);
+	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
+
+	return err;
+}
+
+int pdsc_devcmd(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
+		union pds_core_dev_comp *comp, int max_seconds)
+{
+	int err;
+
+	mutex_lock(&pdsc->devcmd_lock);
+	err = pdsc_devcmd_locked(pdsc, cmd, comp, max_seconds);
+	mutex_unlock(&pdsc->devcmd_lock);
+
+	return err;
+}
+
+int pdsc_devcmd_init(struct pdsc *pdsc)
+{
+	union pds_core_dev_comp comp = { 0 };
+	union pds_core_dev_cmd cmd = {
+		.opcode = PDS_CORE_CMD_INIT,
+	};
+
+	return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+int pdsc_devcmd_reset(struct pdsc *pdsc)
+{
+	union pds_core_dev_comp comp = { 0 };
+	union pds_core_dev_cmd cmd = {
+		.reset.opcode = PDS_CORE_CMD_RESET,
+	};
+
+	return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+static int pdsc_devcmd_identify_locked(struct pdsc *pdsc)
+{
+	union pds_core_dev_comp comp = { 0 };
+	union pds_core_dev_cmd cmd = {
+		.identify.opcode = PDS_CORE_CMD_IDENTIFY,
+		.identify.ver = PDS_CORE_IDENTITY_VERSION_1,
+	};
+
+	return pdsc_devcmd_locked(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+int pdsc_dev_cmd_vf_getattr(struct pdsc *pdsc, int vf, u8 attr,
+			    struct pds_core_vf_getattr_comp *comp)
+{
+	union pds_core_dev_cmd cmd = {
+		.vf_getattr.opcode = PDS_CORE_CMD_VF_GETATTR,
+		.vf_getattr.attr = attr,
+		.vf_getattr.vf_index = cpu_to_le16(vf),
+	};
+	int err;
+
+	if (vf >= pdsc->num_vfs)
+		return -ENODEV;
+
+	switch (attr) {
+	case PDS_CORE_VF_ATTR_SPOOFCHK:
+	case PDS_CORE_VF_ATTR_TRUST:
+	case PDS_CORE_VF_ATTR_LINKSTATE:
+	case PDS_CORE_VF_ATTR_MAC:
+	case PDS_CORE_VF_ATTR_VLAN:
+	case PDS_CORE_VF_ATTR_RATE:
+		break;
+	case PDS_CORE_VF_ATTR_STATSADDR:
+	default:
+		return -EINVAL;
+	}
+
+	err = pdsc_devcmd(pdsc, &cmd,
+			  (union pds_core_dev_comp *)comp,
+			  pdsc->devcmd_timeout);
+
+	return err;
+}
+
+int pds_devcmd_vf_start(struct pdsc *pdsc)
+{
+	union pds_core_dev_comp comp = { 0 };
+	union pds_core_dev_cmd cmd = {
+		.vf_ctrl.opcode = PDS_CORE_CMD_VF_CTRL,
+		.vf_ctrl.ctrl_opcode = PDS_CORE_VF_CTRL_START_ALL,
+	};
+	int err;
+
+	err = pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+
+	return err;
+}
+
+static void pdsc_init_devinfo(struct pdsc *pdsc)
+{
+	pdsc->dev_info.asic_type = ioread8(&pdsc->info_regs->asic_type);
+	pdsc->dev_info.asic_rev = ioread8(&pdsc->info_regs->asic_rev);
+
+	memcpy_fromio(pdsc->dev_info.fw_version,
+		      pdsc->info_regs->fw_version,
+		      PDS_CORE_DEVINFO_FWVERS_BUFLEN);
+
+	memcpy_fromio(pdsc->dev_info.serial_num,
+		      pdsc->info_regs->serial_num,
+		      PDS_CORE_DEVINFO_SERIAL_BUFLEN);
+
+	pdsc->dev_info.fw_version[PDS_CORE_DEVINFO_FWVERS_BUFLEN] = 0;
+	pdsc->dev_info.serial_num[PDS_CORE_DEVINFO_SERIAL_BUFLEN] = 0;
+
+	dev_dbg(pdsc->dev, "fw_version %s\n", pdsc->dev_info.fw_version);
+}
+
+static int pdsc_identify(struct pdsc *pdsc)
+{
+	struct pds_core_drv_identity drv = { 0 };
+	size_t sz;
+	int err;
+
+	drv.drv_type = cpu_to_le32(PDS_DRIVER_LINUX);
+	drv.kernel_ver = cpu_to_le32(LINUX_VERSION_CODE);
+	snprintf(drv.kernel_ver_str, sizeof(drv.kernel_ver_str),
+		 "%s %s", utsname()->release, utsname()->version);
+	snprintf(drv.driver_ver_str, sizeof(drv.driver_ver_str),
+		 "%s %s", PDS_CORE_DRV_NAME, utsname()->release);
+
+	/* Next let's get some info about the device
+	 * We use the devcmd_lock at this level in order to
+	 * get safe access to the cmd_regs->data before anyone
+	 * else can mess it up
+	 */
+	mutex_lock(&pdsc->devcmd_lock);
+
+	sz = min_t(size_t, sizeof(drv), sizeof(pdsc->cmd_regs->data));
+	memcpy_toio(&pdsc->cmd_regs->data, &drv, sz);
+
+	err = pdsc_devcmd_identify_locked(pdsc);
+	if (!err) {
+		sz = min_t(size_t, sizeof(pdsc->dev_ident), sizeof(pdsc->cmd_regs->data));
+		memcpy_fromio(&pdsc->dev_ident, &pdsc->cmd_regs->data, sz);
+	}
+	mutex_unlock(&pdsc->devcmd_lock);
+
+	if (err) {
+		dev_err(pdsc->dev, "Cannot identify device: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
+	if (isprint(pdsc->dev_info.fw_version[0]) &&
+	    isascii(pdsc->dev_info.fw_version[0]))
+		dev_info(pdsc->dev, "FW: %.*s\n",
+			 (int)(sizeof(pdsc->dev_info.fw_version) - 1),
+			 pdsc->dev_info.fw_version);
+	else
+		dev_info(pdsc->dev, "FW: (invalid string) 0x%02x 0x%02x 0x%02x 0x%02x ...\n",
+			 (u8)pdsc->dev_info.fw_version[0],
+			 (u8)pdsc->dev_info.fw_version[1],
+			 (u8)pdsc->dev_info.fw_version[2],
+			 (u8)pdsc->dev_info.fw_version[3]);
+
+	return 0;
+}
+
+int pdsc_dev_reinit(struct pdsc *pdsc)
+{
+	pdsc_init_devinfo(pdsc);
+
+	return pdsc_identify(pdsc);
+}
+
+int pdsc_dev_init(struct pdsc *pdsc)
+{
+	unsigned int nintrs;
+	int err;
+
+	/* Initial init and reset of device */
+	pdsc_init_devinfo(pdsc);
+	pdsc->devcmd_timeout = PDS_CORE_DEVCMD_TIMEOUT;
+
+	err = pdsc_devcmd_reset(pdsc);
+	if (err)
+		return err;
+
+	err = pdsc_identify(pdsc);
+	if (err)
+		return err;
+
+	pdsc_debugfs_add_ident(pdsc);
+
+	/* Now we can reserve interrupts */
+	nintrs = le32_to_cpu(pdsc->dev_ident.nintrs);
+	nintrs = min_t(unsigned int, num_online_cpus(), nintrs);
+
+	/* Get intr_info struct array for tracking */
+	pdsc->intr_info = devm_kcalloc(pdsc->dev, nintrs,
+				       sizeof(*pdsc->intr_info), GFP_KERNEL);
+	if (!pdsc->intr_info) {
+		err = -ENOSPC;
+		goto err_out;
+	}
+
+	err = pci_alloc_irq_vectors(pdsc->pdev, nintrs, nintrs, PCI_IRQ_MSIX);
+	if (err != nintrs) {
+		dev_err(pdsc->dev, "Can't get %d intrs from OS: %pe\n",
+			nintrs, ERR_PTR(err));
+		err = -ENOSPC;
+		goto err_out;
+	}
+	pdsc->nintrs = nintrs;
+	pdsc_debugfs_add_irqs(pdsc);
+
+	return 0;
+
+err_out:
+	if (pdsc->intr_info) {
+		devm_kfree(pdsc->dev, pdsc->intr_info);
+		pdsc->intr_info = NULL;
+	}
+	return err;
+}
diff --git a/drivers/net/ethernet/pensando/pds_core/main.c b/drivers/net/ethernet/pensando/pds_core/main.c
index 4bdbcc1c17a7..770b3f895bbb 100644
--- a/drivers/net/ethernet/pensando/pds_core/main.c
+++ b/drivers/net/ethernet/pensando/pds_core/main.c
@@ -189,6 +189,15 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_out_pci_disable_device;
 
+	/* PDS device setup */
+	mutex_init(&pdsc->devcmd_lock);
+	mutex_init(&pdsc->config_lock);
+
+	mutex_lock(&pdsc->config_lock);
+	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
+	if (err)
+		goto err_out_unmap_bars;
+
 	/* publish devlink device */
 	err = pdsc_dl_register(pdsc);
 	if (err) {
@@ -196,10 +205,21 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out;
 	}
 
+	mutex_unlock(&pdsc->config_lock);
+
+	pdsc->fw_generation = PDS_CORE_FW_STS_F_GENERATION &
+			      ioread8(&pdsc->info_regs->fw_status);
+
 	clear_bit(PDSC_S_INITING_DRIVER, &pdsc->state);
 	return 0;
 
 err_out:
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
+err_out_unmap_bars:
+	mutex_unlock(&pdsc->config_lock);
+	mutex_destroy(&pdsc->config_lock);
+	mutex_destroy(&pdsc->devcmd_lock);
+	pci_free_irq_vectors(pdev);
 	pci_clear_master(pdev);
 	pdsc_unmap_bars(pdsc);
 	pci_release_regions(pdev);
@@ -224,10 +244,20 @@ static void pdsc_remove(struct pci_dev *pdev)
 	 */
 	pdsc_dl_unregister(pdsc);
 
+	/* Now we can lock it up and tear it down */
+	mutex_lock(&pdsc->config_lock);
+	set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
+
 	/* Device teardown */
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
+	pdsc_debugfs_del_dev(pdsc);
+	mutex_unlock(&pdsc->config_lock);
+	mutex_destroy(&pdsc->config_lock);
+	mutex_destroy(&pdsc->devcmd_lock);
 	ida_free(&pdsc_pf_ida, pdsc->id);
 
 	/* PCI teardown */
+	pci_free_irq_vectors(pdev);
 	pci_clear_master(pdev);
 	pdsc_unmap_bars(pdsc);
 	pci_release_regions(pdev);
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 7de3c1b8526b..e7fe84379a2f 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -10,4 +10,71 @@
 #define PDS_CORE_ADDR_LEN	52
 #define PDS_CORE_ADDR_MASK	(BIT_ULL(PDS_ADDR_LEN) - 1)
 
+/*
+ * enum pds_core_status_code - Device command return codes
+ */
+enum pds_core_status_code {
+	PDS_RC_SUCCESS	= 0,	/* Success */
+	PDS_RC_EVERSION	= 1,	/* Incorrect version for request */
+	PDS_RC_EOPCODE	= 2,	/* Invalid cmd opcode */
+	PDS_RC_EIO	= 3,	/* I/O error */
+	PDS_RC_EPERM	= 4,	/* Permission denied */
+	PDS_RC_EQID	= 5,	/* Bad qid */
+	PDS_RC_EQTYPE	= 6,	/* Bad qtype */
+	PDS_RC_ENOENT	= 7,	/* No such element */
+	PDS_RC_EINTR	= 8,	/* operation interrupted */
+	PDS_RC_EAGAIN	= 9,	/* Try again */
+	PDS_RC_ENOMEM	= 10,	/* Out of memory */
+	PDS_RC_EFAULT	= 11,	/* Bad address */
+	PDS_RC_EBUSY	= 12,	/* Device or resource busy */
+	PDS_RC_EEXIST	= 13,	/* object already exists */
+	PDS_RC_EINVAL	= 14,	/* Invalid argument */
+	PDS_RC_ENOSPC	= 15,	/* No space left or alloc failure */
+	PDS_RC_ERANGE	= 16,	/* Parameter out of range */
+	PDS_RC_BAD_ADDR	= 17,	/* Descriptor contains a bad ptr */
+	PDS_RC_DEV_CMD	= 18,	/* Device cmd attempted on AdminQ */
+	PDS_RC_ENOSUPP	= 19,	/* Operation not supported */
+	PDS_RC_ERROR	= 29,	/* Generic error */
+	PDS_RC_ERDMA	= 30,	/* Generic RDMA error */
+	PDS_RC_EVFID	= 31,	/* VF ID does not exist */
+	PDS_RC_BAD_FW	= 32,	/* FW file is invalid or corrupted */
+	PDS_RC_ECLIENT	= 33,   /* No such client id */
+};
+
+enum pds_core_driver_type {
+	PDS_DRIVER_LINUX   = 1,
+	PDS_DRIVER_WIN     = 2,
+	PDS_DRIVER_DPDK    = 3,
+	PDS_DRIVER_FREEBSD = 4,
+	PDS_DRIVER_IPXE    = 5,
+	PDS_DRIVER_ESXI    = 6,
+};
+
+/* PDSC interface uses identity version 1 and PDSC uses 2 */
+#define PDSC_IDENTITY_VERSION_1		1
+#define PDSC_IDENTITY_VERSION_2		2
+
+#define PDS_CORE_IFNAMSIZ		16
+
+/**
+ * enum pds_core_logical_qtype - Logical Queue Types
+ * @PDS_CORE_QTYPE_ADMINQ:    Administrative Queue
+ * @PDS_CORE_QTYPE_NOTIFYQ:   Notify Queue
+ * @PDS_CORE_QTYPE_RXQ:       Receive Queue
+ * @PDS_CORE_QTYPE_TXQ:       Transmit Queue
+ * @PDS_CORE_QTYPE_EQ:        Event Queue
+ * @PDS_CORE_QTYPE_MAX:       Max queue type supported
+ */
+enum pds_core_logical_qtype {
+	PDS_CORE_QTYPE_ADMINQ  = 0,
+	PDS_CORE_QTYPE_NOTIFYQ = 1,
+	PDS_CORE_QTYPE_RXQ     = 2,
+	PDS_CORE_QTYPE_TXQ     = 3,
+	PDS_CORE_QTYPE_EQ      = 4,
+
+	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
+};
+
+typedef void (*pds_core_cb)(void *cb_arg);
+
 #endif /* _PDS_COMMON_H_ */
diff --git a/include/linux/pds/pds_intr.h b/include/linux/pds/pds_intr.h
new file mode 100644
index 000000000000..bcdafd492e65
--- /dev/null
+++ b/include/linux/pds/pds_intr.h
@@ -0,0 +1,160 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
+/* Copyright (c) 2022 Pensando Systems, Inc.  All rights reserved. */
+
+#ifndef _PDS_INTR_H_
+#define _PDS_INTR_H_
+
+/*
+ * Interrupt control register
+ * @coal_init:        Coalescing timer initial value, in
+ *                    device units.  Use @identity->intr_coal_mult
+ *                    and @identity->intr_coal_div to convert from
+ *                    usecs to device units:
+ *
+ *                      coal_init = coal_usecs * coal_mutl / coal_div
+ *
+ *                    When an interrupt is sent the interrupt
+ *                    coalescing timer current value
+ *                    (@coalescing_curr) is initialized with this
+ *                    value and begins counting down.  No more
+ *                    interrupts are sent until the coalescing
+ *                    timer reaches 0.  When @coalescing_init=0
+ *                    interrupt coalescing is effectively disabled
+ *                    and every interrupt assert results in an
+ *                    interrupt.  Reset value: 0
+ * @mask:             Interrupt mask.  When @mask=1 the interrupt
+ *                    resource will not send an interrupt.  When
+ *                    @mask=0 the interrupt resource will send an
+ *                    interrupt if an interrupt event is pending
+ *                    or on the next interrupt assertion event.
+ *                    Reset value: 1
+ * @credits:          Interrupt credits.  This register indicates
+ *                    how many interrupt events the hardware has
+ *                    sent.  When written by software this
+ *                    register atomically decrements @int_credits
+ *                    by the value written.  When @int_credits
+ *                    becomes 0 then the "pending interrupt" bit
+ *                    in the Interrupt Status register is cleared
+ *                    by the hardware and any pending but unsent
+ *                    interrupts are cleared.
+ *                    !!!IMPORTANT!!! This is a signed register.
+ * @flags:            Interrupt control flags
+ *                       @unmask -- When this bit is written with a 1
+ *                       the interrupt resource will set mask=0.
+ *                       @coal_timer_reset -- When this
+ *                       bit is written with a 1 the
+ *                       @coalescing_curr will be reloaded with
+ *                       @coalescing_init to reset the coalescing
+ *                       timer.
+ * @mask_on_assert:   Automatically mask on assertion.  When
+ *                    @mask_on_assert=1 the interrupt resource
+ *                    will set @mask=1 whenever an interrupt is
+ *                    sent.  When using interrupts in Legacy
+ *                    Interrupt mode the driver must select
+ *                    @mask_on_assert=0 for proper interrupt
+ *                    operation.
+ * @coalescing_curr:  Coalescing timer current value, in
+ *                    microseconds.  When this value reaches 0
+ *                    the interrupt resource is again eligible to
+ *                    send an interrupt.  If an interrupt event
+ *                    is already pending when @coalescing_curr
+ *                    reaches 0 the pending interrupt will be
+ *                    sent, otherwise an interrupt will be sent
+ *                    on the next interrupt assertion event.
+ */
+struct pds_core_intr {
+	u32 coal_init;
+	u32 mask;
+	u16 credits;
+	u16 flags;
+#define PDS_CORE_INTR_F_UNMASK		0x0001
+#define PDS_CORE_INTR_F_TIMER_RESET	0x0002
+	u32 mask_on_assert;
+	u32 coalescing_curr;
+	u32 rsvd6[3];
+};
+#ifndef __CHECKER__
+static_assert(sizeof(struct pds_core_intr) == 32);
+#endif /* __CHECKER__ */
+
+#define PDS_CORE_INTR_CTRL_REGS_MAX		2048
+#define PDS_CORE_INTR_CTRL_COAL_MAX		0x3F
+#define PDS_CORE_INTR_INDEX_NOT_ASSIGNED	-1
+
+struct pds_core_intr_status {
+	u32 status[2];
+};
+
+/**
+ * enum pds_core_intr_mask_vals - valid values for mask and mask_assert.
+ * @PDS_CORE_INTR_MASK_CLEAR:	unmask interrupt.
+ * @PDS_CORE_INTR_MASK_SET:	mask interrupt.
+ */
+enum pds_core_intr_mask_vals {
+	PDS_CORE_INTR_MASK_CLEAR	= 0,
+	PDS_CORE_INTR_MASK_SET		= 1,
+};
+
+/**
+ * enum pds_core_intr_credits_bits - Bitwise composition of credits values.
+ * @PDS_CORE_INTR_CRED_COUNT:	bit mask of credit count, no shift needed.
+ * @PDS_CORE_INTR_CRED_COUNT_SIGNED: bit mask of credit count, including sign bit.
+ * @PDS_CORE_INTR_CRED_UNMASK:	unmask the interrupt.
+ * @PDS_CORE_INTR_CRED_RESET_COALESCE: reset the coalesce timer.
+ * @PDS_CORE_INTR_CRED_REARM:	unmask the and reset the timer.
+ */
+enum pds_core_intr_credits_bits {
+	PDS_CORE_INTR_CRED_COUNT		= 0x7fffu,
+	PDS_CORE_INTR_CRED_COUNT_SIGNED		= 0xffffu,
+	PDS_CORE_INTR_CRED_UNMASK		= 0x10000u,
+	PDS_CORE_INTR_CRED_RESET_COALESCE	= 0x20000u,
+	PDS_CORE_INTR_CRED_REARM		= (PDS_CORE_INTR_CRED_UNMASK |
+					   PDS_CORE_INTR_CRED_RESET_COALESCE),
+};
+
+static inline void pds_core_intr_coal_init(struct pds_core_intr __iomem *intr_ctrl,
+					   u32 coal)
+{
+	iowrite32(coal, &intr_ctrl->coal_init);
+}
+
+static inline void pds_core_intr_mask(struct pds_core_intr __iomem *intr_ctrl,
+				      u32 mask)
+{
+	iowrite32(mask, &intr_ctrl->mask);
+}
+
+static inline void pds_core_intr_credits(struct pds_core_intr __iomem *intr_ctrl,
+					 u32 cred, u32 flags)
+{
+	if (WARN_ON_ONCE(cred > PDS_CORE_INTR_CRED_COUNT)) {
+		cred = ioread32(&intr_ctrl->credits);
+		cred &= PDS_CORE_INTR_CRED_COUNT_SIGNED;
+	}
+
+	iowrite32(cred | flags, &intr_ctrl->credits);
+}
+
+static inline void pds_core_intr_clean_flags(struct pds_core_intr __iomem *intr_ctrl,
+					     u32 flags)
+{
+	u32 cred;
+
+	cred = ioread32(&intr_ctrl->credits);
+	cred &= PDS_CORE_INTR_CRED_COUNT_SIGNED;
+	cred |= flags;
+	iowrite32(cred, &intr_ctrl->credits);
+}
+
+static inline void pds_core_intr_clean(struct pds_core_intr __iomem *intr_ctrl)
+{
+	pds_core_intr_clean_flags(intr_ctrl, PDS_CORE_INTR_CRED_RESET_COALESCE);
+}
+
+static inline void pds_core_intr_mask_assert(struct pds_core_intr __iomem *intr_ctrl,
+					     u32 mask)
+{
+	iowrite32(mask, &intr_ctrl->mask_on_assert);
+}
+
+#endif /* _PDS_INTR_H_ */
-- 
2.17.1

