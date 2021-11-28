Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E950460630
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357443AbhK1Moq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357445AbhK1Mmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 07:42:45 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C113C0613D7
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:38:50 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id v15so29068176ljc.0
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s27J6fDgX0QHTWxUXiBGVD1cv9maHn+rDsd48EIRwRk=;
        b=jQ4GA0fx05TNYklM8lNnrwjqFQCKt5EqFpf+U3m/tsJkE7vm+Mi9HsIIuDDLhh68/R
         QDosE/tOUOBEgp0EutI9LMASCMKXSEsJ5WiITnpEYJGjh4z4F/BczoPw3xSXvnx+1ZPB
         EPuALqv8fQ1mnUD//nnQfZZMtjCNd16X6/K3yUAL/BSLZ372Y5nccbonn7jtOJFSK2rh
         sZFXH1e5SrdUeG2dHrRC23Or6CrLNG1n6PTVlCSDEGqjf6hQjuQXs7O/m+D0/yb1MM+J
         9wGgvuzhHtn2ji3yUvOc8p6MMlRjYU0UoCTlh1z8tXjcSYh/D3MnduuyJYzN+xL0qS4K
         6fcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s27J6fDgX0QHTWxUXiBGVD1cv9maHn+rDsd48EIRwRk=;
        b=FyuCjFK7kHe04OtKENndOsMzTL+id2lx7TT9ussWQTYbkekpP6s0Y7rBdymR39qFpG
         UDq5fGJwkyLE1xmM+u7CLq9ZF7lyF7GQklwp0Dxp5lkw5x4p64biW/QHIGm4FKIEsM7w
         6K9iL2PL7p5h4HSXYZOVND6f4iQ8MkVp8a8BCoywq3OTGIWnD8YKXr9PSH3agB+kbJ1J
         zVcHaCaXgLQ2lsHWEjr1Usrmk3jkT7B4+bhg66qeyLASECncVX/z7O5kTF6s7d6fGXjQ
         ai/b3OpwgMuiWZIoV0797ijKFCINABD3U+auzgMNo+t3CJ4UbO/ZQSjs+iKbJs4GJQfj
         pl4Q==
X-Gm-Message-State: AOAM5323KedgWdig0PybAM4qtHhMAQUxRLHoTiD1iG30wSUIYhgiZdWx
        LcF3wrncJOa6X6NHvDX/q2s=
X-Google-Smtp-Source: ABdhPJym1LJSTlySgbDD8TmaUwh9qQe3j2HpzwH3ektjQ793rN68rB2/T0OonWPqSXNwjSD0zCwHVA==
X-Received: by 2002:a2e:b541:: with SMTP id a1mr43927642ljn.289.1638103128885;
        Sun, 28 Nov 2021 04:38:48 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id v198sm976533lfa.89.2021.11.28.04.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:38:48 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/5] net: wwan: iosm: move debugfs knobs into a subdir
Date:   Sun, 28 Nov 2021 15:38:35 +0300
Message-Id: <20211128123837.22829-4-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211128123837.22829-1-ryazanov.s.a@gmail.com>
References: <20211128123837.22829-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The modem traces collection is a device (and so driver) specific option.
Therefore, move the related debugfs files into a driver-specific
subdirectory under the common per WWAN device directory.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/iosm/Makefile           |  1 +
 drivers/net/wwan/iosm/iosm_ipc_debugfs.c | 29 ++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_debugfs.h | 12 ++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.c    |  7 +++---
 drivers/net/wwan/iosm/iosm_ipc_imem.h    |  1 +
 drivers/net/wwan/iosm/iosm_ipc_trace.c   |  6 ++---
 6 files changed, 48 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.h

diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
index 5c2528beca2a..5091f664af0d 100644
--- a/drivers/net/wwan/iosm/Makefile
+++ b/drivers/net/wwan/iosm/Makefile
@@ -22,6 +22,7 @@ iosm-y = \
 	iosm_ipc_devlink.o		\
 	iosm_ipc_flash.o		\
 	iosm_ipc_coredump.o		\
+	iosm_ipc_debugfs.o		\
 	iosm_ipc_trace.o
 
 obj-$(CONFIG_IOSM) := iosm.o
diff --git a/drivers/net/wwan/iosm/iosm_ipc_debugfs.c b/drivers/net/wwan/iosm/iosm_ipc_debugfs.c
new file mode 100644
index 000000000000..f2f57751a7d2
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_debugfs.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-2021 Intel Corporation.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/wwan.h>
+
+#include "iosm_ipc_imem.h"
+#include "iosm_ipc_trace.h"
+#include "iosm_ipc_debugfs.h"
+
+void ipc_debugfs_init(struct iosm_imem *ipc_imem)
+{
+	struct dentry *debugfs_pdev = wwan_get_debugfs_dir(ipc_imem->dev);
+
+	ipc_imem->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME,
+						   debugfs_pdev);
+
+	ipc_imem->trace = ipc_trace_init(ipc_imem);
+	if (!ipc_imem->trace)
+		dev_warn(ipc_imem->dev, "trace channel init failed");
+}
+
+void ipc_debugfs_deinit(struct iosm_imem *ipc_imem)
+{
+	ipc_trace_deinit(ipc_imem->trace);
+	debugfs_remove_recursive(ipc_imem->debugfs_dir);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_debugfs.h b/drivers/net/wwan/iosm/iosm_ipc_debugfs.h
new file mode 100644
index 000000000000..35788039f13f
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_debugfs.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-2021 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_DEBUGFS_H
+#define IOSM_IPC_DEBUGFS_H
+
+void ipc_debugfs_init(struct iosm_imem *ipc_imem);
+void ipc_debugfs_deinit(struct iosm_imem *ipc_imem);
+
+#endif
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index a60b93cefd2e..25b889922912 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -11,6 +11,7 @@
 #include "iosm_ipc_imem.h"
 #include "iosm_ipc_port.h"
 #include "iosm_ipc_trace.h"
+#include "iosm_ipc_debugfs.h"
 
 /* Check the wwan ips if it is valid with Channel as input. */
 static int ipc_imem_check_wwan_ips(struct ipc_mem_channel *chnl)
@@ -554,9 +555,7 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 		ctrl_chl_idx++;
 	}
 
-	ipc_imem->trace = ipc_trace_init(ipc_imem);
-	if (!ipc_imem->trace)
-		dev_warn(ipc_imem->dev, "trace channel init failed");
+	ipc_debugfs_init(ipc_imem);
 
 	ipc_task_queue_send_task(ipc_imem, ipc_imem_send_mdm_rdy_cb, 0, NULL, 0,
 				 false);
@@ -1173,7 +1172,7 @@ void ipc_imem_cleanup(struct iosm_imem *ipc_imem)
 
 	if (test_and_clear_bit(FULLY_FUNCTIONAL, &ipc_imem->flag)) {
 		ipc_mux_deinit(ipc_imem->mux);
-		ipc_trace_deinit(ipc_imem->trace);
+		ipc_debugfs_deinit(ipc_imem);
 		ipc_wwan_deinit(ipc_imem->wwan);
 		ipc_port_deinit(ipc_imem->ipc_port);
 	}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index cec38009c44a..df3b471f6fa9 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -380,6 +380,7 @@ struct iosm_imem {
 	   ev_mux_net_transmit_pending:1,
 	   reset_det_n:1,
 	   pcie_wake_n:1;
+	struct dentry *debugfs_dir;
 };
 
 /**
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.c b/drivers/net/wwan/iosm/iosm_ipc_trace.c
index c588a394cd94..5243ead90b5f 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.c
@@ -134,7 +134,6 @@ struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem)
 {
 	struct ipc_chnl_cfg chnl_cfg = { 0 };
 	struct iosm_trace *ipc_trace;
-	struct dentry *debugfs_pdev;
 
 	ipc_chnl_cfg_get(&chnl_cfg, IPC_MEM_CTRL_CHL_ID_3);
 	ipc_imem_channel_init(ipc_imem, IPC_CTYPE_CTRL, chnl_cfg,
@@ -150,15 +149,14 @@ struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem)
 	ipc_trace->chl_id = IPC_MEM_CTRL_CHL_ID_3;
 
 	mutex_init(&ipc_trace->trc_mutex);
-	debugfs_pdev = wwan_get_debugfs_dir(ipc_imem->dev);
 
 	ipc_trace->ctrl_file = debugfs_create_file(IOSM_TRC_DEBUGFS_TRACE_CTRL,
 						   IOSM_TRC_FILE_PERM,
-						   debugfs_pdev,
+						   ipc_imem->debugfs_dir,
 						   ipc_trace, &ipc_trace_fops);
 
 	ipc_trace->ipc_rchan = relay_open(IOSM_TRC_DEBUGFS_TRACE,
-					  debugfs_pdev,
+					  ipc_imem->debugfs_dir,
 					  IOSM_TRC_SUB_BUFF_SIZE,
 					  IOSM_TRC_N_SUB_BUFF,
 					  &relay_callbacks, NULL);
-- 
2.32.0

