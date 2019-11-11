Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 556B9F7BAC
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 19:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfKKSih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:38:37 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35137 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729031AbfKKSig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:38:36 -0500
Received: by mail-pf1-f193.google.com with SMTP id d13so11261376pfq.2
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vJ/OCO6AxKensTYNdmRFCKQLRL9aenRrnbLGG3oUGHI=;
        b=QfyUlquJlWdtkREy2n9F9LH88+2qKMOnL7NKVpAR0L7sv4iij8bJrfMKc6aNbI+9TX
         7J8VpNXOe72XzlsrurDp6aDoZdj/K7VKknkU0kn73lymo4vi9Q/EuaJnc6MNZE7MEFgh
         UBwYi/YKM9sJvYRZp+GVSOhyfIsYpdwxUC2HuC7JvP67Vx9BEa1+KAbqbYYuThxouQC+
         k/kwblU5uHa30putxBH6pomMzvwY7gHMImnPRXg42no0n1h2HRBuHtF6+3gnsomYPdHE
         cIrAWWVtpsTHxsvcsNwRt6/1o+BtkeMjulV6t+YjvJwoNluvbPNTW6w5PQEf5NsFpI2S
         72LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vJ/OCO6AxKensTYNdmRFCKQLRL9aenRrnbLGG3oUGHI=;
        b=PNl6XD8JBJe3e+DPa91ikWJM4yOdn3vc48yZs3BBQlCJ1fPVeZ5776GhCsg4H+BMkD
         ziQH9NxQnUtuQr7SOmBt9eLYBxUcUU/Hnupw1aHQklm9aPLqfl3tiFKCH9+8/WlnIQsI
         /58/3Ey98RldMEA1oaq2/agD6fAlWZCUKkrWZAaAG3EGRRCYNL+uXx9lNfYmPIbifkRF
         DRIF9tgijIF6dkjWmcJ9mmF1QkklwUKZ6MzwIuPuSIwEOoqQkOCZ6ob7hZdlCupT2xtk
         yc/5Fg6Y6jjtmcBzF19rP7sRBqLUCuhIUDAFpZRDGBxcO6pRSkaxkeLavDZ3Ef9D3bI4
         A6pA==
X-Gm-Message-State: APjAAAWzdfw3rgI0ueIx8OrU6du6VHq+kECkG80NezgEfg6ufmEa7UuA
        flo9hG2BHTJKuN0oHMh5mX9yHjPgfic=
X-Google-Smtp-Source: APXvYqx2+pGSjiyY87VGm74BxwPCCvzgQe3qHPKPRiZzF0x0fOHElMTo8hruumbmoDNNx9yonsiBNA==
X-Received: by 2002:a62:6087:: with SMTP id u129mr31065431pfb.75.1573497515063;
        Mon, 11 Nov 2019 10:38:35 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id b5sm16921762pfp.149.2019.11.11.10.38.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 10:38:34 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Christina Jacob <cjacob@marvell.com>,
        Prakash Brahmajyosyula <bprakash@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 01/18] octeontx2-af: Dump current resource provisioning status
Date:   Tue, 12 Nov 2019 00:07:57 +0530
Message-Id: <1573497494-11468-2-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christina Jacob <cjacob@marvell.com>

Added support to dump current resource provisioning status
of all resource virtualization unit (RVU) block's
(i.e NPA, NIX, SSO, SSOW, CPT, TIM) local functions attached
to a PF_FUNC into a debugfs file.

'cat /sys/kernel/debug/octeontx2/rsrc_alloc'
will show the current block LF's allocation status.

Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Prakash Brahmajyosyula <bprakash@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   4 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  18 +++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 146 +++++++++++++++++++++
 4 files changed, 169 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 06329ac..1b25948 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 
 octeontx2_mbox-y := mbox.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
-		  rvu_reg.o rvu_npc.o
+		  rvu_reg.o rvu_npc.o rvu_debugfs.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e581091..8ed5498 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2456,6 +2456,9 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_irq;
 
+	/* Initialize debugfs */
+	rvu_dbg_init(rvu);
+
 	return 0;
 err_irq:
 	rvu_unregister_interrupts(rvu);
@@ -2482,6 +2485,7 @@ static void rvu_remove(struct pci_dev *pdev)
 {
 	struct rvu *rvu = pci_get_drvdata(pdev);
 
+	rvu_dbg_exit(rvu);
 	rvu_unregister_interrupts(rvu);
 	rvu_flr_wq_destroy(rvu);
 	rvu_cgx_exit(rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index c9d60b0..9e8ef1f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -35,6 +35,12 @@
 #define RVU_PFVF_FUNC_SHIFT	0
 #define RVU_PFVF_FUNC_MASK	0x3FF
 
+#ifdef CONFIG_DEBUG_FS
+struct rvu_debugfs {
+	struct dentry *root;
+};
+#endif
+
 struct rvu_work {
 	struct	work_struct work;
 	struct	rvu *rvu;
@@ -263,6 +269,10 @@ struct rvu {
 	struct list_head	cgx_evq_head; /* cgx event queue head */
 
 	char mkex_pfl_name[MKEX_NAME_LEN]; /* Configured MKEX profile name */
+
+#ifdef CONFIG_DEBUG_FS
+	struct rvu_debugfs	rvu_dbg;
+#endif
 };
 
 static inline void rvu_write64(struct rvu *rvu, u64 block, u64 offset, u64 val)
@@ -501,4 +511,12 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 			  struct npc_mcam_alloc_and_write_entry_rsp *rsp);
 int rvu_mbox_handler_npc_get_kex_cfg(struct rvu *rvu, struct msg_req *req,
 				     struct npc_get_kex_cfg_rsp *rsp);
+
+#ifdef CONFIG_DEBUG_FS
+void rvu_dbg_init(struct rvu *rvu);
+void rvu_dbg_exit(struct rvu *rvu);
+#else
+static inline void rvu_dbg_init(struct rvu *rvu) {}
+static inline void rvu_dbg_exit(struct rvu *rvu) {}
+#endif
 #endif /* RVU_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
new file mode 100644
index 0000000..ede6cdb
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Admin Function driver
+ *
+ * Copyright (C) 2019 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "rvu_struct.h"
+#include "rvu_reg.h"
+#include "rvu.h"
+
+#define DEBUGFS_DIR_NAME "octeontx2"
+
+#define rvu_dbg_NULL NULL
+
+#define RVU_DEBUG_FOPS(name, read_op, write_op) \
+static const struct file_operations rvu_dbg_##name##_fops = { \
+	.owner = THIS_MODULE, \
+	.open = simple_open, \
+	.read = rvu_dbg_##read_op, \
+	.write = rvu_dbg_##write_op \
+}
+
+/* Dumps current provisioning status of all RVU block LFs */
+static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
+					  char __user *buffer,
+					  size_t count, loff_t *ppos)
+{
+	int index, off = 0, flag = 0, go_back = 0, off_prev;
+	struct rvu *rvu = filp->private_data;
+	int lf, pf, vf, pcifunc;
+	struct rvu_block block;
+	int bytes_not_copied;
+	int buf_size = 2048;
+	char *buf;
+
+	/* don't allow partial reads */
+	if (*ppos != 0)
+		return 0;
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOSPC;
+	off +=	scnprintf(&buf[off], buf_size - 1 - off, "\npcifunc\t\t");
+	for (index = 0; index < BLK_COUNT; index++)
+		if (strlen(rvu->hw->block[index].name))
+			off +=	scnprintf(&buf[off], buf_size - 1 - off,
+					  "%*s\t", (index - 1) * 2,
+					  rvu->hw->block[index].name);
+	off += scnprintf(&buf[off], buf_size - 1 - off, "\n");
+	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
+		for (vf = 0; vf <= rvu->hw->total_vfs; vf++) {
+			pcifunc = pf << 10 | vf;
+			if (!pcifunc)
+				continue;
+
+			if (vf) {
+				go_back = scnprintf(&buf[off],
+						    buf_size - 1 - off,
+						    "PF%d:VF%d\t\t", pf,
+						    vf - 1);
+			} else {
+				go_back = scnprintf(&buf[off],
+						    buf_size - 1 - off,
+						    "PF%d\t\t", pf);
+			}
+
+			off += go_back;
+			for (index = 0; index < BLKTYPE_MAX; index++) {
+				block = rvu->hw->block[index];
+				if (!strlen(block.name))
+					continue;
+				off_prev = off;
+				for (lf = 0; lf < block.lf.max; lf++) {
+					if (block.fn_map[lf] != pcifunc)
+						continue;
+					flag = 1;
+					off += scnprintf(&buf[off], buf_size - 1
+							- off, "%3d,", lf);
+				}
+				if (flag && off_prev != off)
+					off--;
+				else
+					go_back++;
+				off += scnprintf(&buf[off], buf_size - 1 - off,
+						"\t");
+			}
+			if (!flag)
+				off -= go_back;
+			else
+				flag = 0;
+			off--;
+			off +=	scnprintf(&buf[off], buf_size - 1 - off, "\n");
+		}
+	}
+
+	bytes_not_copied = copy_to_user(buffer, buf, off);
+	kfree(buf);
+
+	if (bytes_not_copied)
+		return -EFAULT;
+
+	*ppos = off;
+	return off;
+}
+
+RVU_DEBUG_FOPS(rsrc_status, rsrc_attach_status, NULL);
+
+void rvu_dbg_init(struct rvu *rvu)
+{
+	struct device *dev = &rvu->pdev->dev;
+	struct dentry *pfile;
+
+	rvu->rvu_dbg.root = debugfs_create_dir(DEBUGFS_DIR_NAME, NULL);
+	if (!rvu->rvu_dbg.root) {
+		dev_err(rvu->dev, "%s failed\n", __func__);
+		return;
+	}
+	pfile = debugfs_create_file("rsrc_alloc", 0444, rvu->rvu_dbg.root, rvu,
+				    &rvu_dbg_rsrc_status_fops);
+	if (!pfile)
+		goto create_failed;
+
+	return;
+
+create_failed:
+	dev_err(dev, "Failed to create debugfs dir\n");
+	debugfs_remove_recursive(rvu->rvu_dbg.root);
+}
+
+void rvu_dbg_exit(struct rvu *rvu)
+{
+	debugfs_remove_recursive(rvu->rvu_dbg.root);
+}
+
+#endif /* CONFIG_DEBUG_FS */
-- 
2.7.4

