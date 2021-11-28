Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C511546062D
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357622AbhK1Mol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357425AbhK1Mml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 07:42:41 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EFFC061761
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:38:48 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id l7so28935820lja.2
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lAYjBODWXtYE0eUrwiIG3wvz5YgUWiz/ucehD2kVx78=;
        b=M9UFVS48INXQTKg7FcmvmIbSjSYsJHpJFXoR3C4klQaTAqrs4K2KB7GORilRtZPR4K
         3W43c7yu7Z1G7Wyvj+drqfZaNUxPBzAbIO/f1615ZR/83binANZ7T9vpJO/aBoONYCQK
         +qmZzbCwZdfZx52dJzrBB/7YiC9Sh0sTSAxJ6RoCKbF7lz1Jm6DY5AcxBdqbLoaTU+5D
         HK5DC0ag4Gmup4PiOV+nV7n4/sAxuGCunaWNej57ipVGXiJZnYDq4UUf7l7dczr1oiJd
         d73aGtrGW8sk8vF/s8gXTGkARTcurOA+A79679QAs/gocWjwOGo3M2lfomP6HXiwhaOK
         qdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lAYjBODWXtYE0eUrwiIG3wvz5YgUWiz/ucehD2kVx78=;
        b=b73wf8BrCZGbuJdFnFqpW2lrprqJJo+9kZdGFHTJCBcGOrTCIGNvhiWT8oP3JRDfUZ
         cfGkNjodGhtV0doF/H6lqCEYhjjGwC1L8QyUxwK9CRH1zYmBVREAMR2ISoH+JL+BR3TX
         T3ZyIqkWuH+GXpFqtwDgxZGH7MD8UiFLIrp4JPGQXGglKOumbo2QWbg4x9eE9zVKC0eZ
         0MhJw4mIT+YhMd8KkTcr3kgJqyhpY2PR99WE0/A+Qr3BU9IeQyQ6LY4QOKntLPFrgvxe
         dc/DzYIO1shxlXtU6JNKyvvP0ZaIDAHXWiyvyPrcmhRTum97NMIowrZI9Cd1uhBruQ8x
         lt4w==
X-Gm-Message-State: AOAM532NlcCLSRoHhRmKfm8cMlhae4IZ7DKlQNdHE5LIsr/UYcWj7f2Z
        C0HUkBLAgyPMAE9Mx6eyUtE=
X-Google-Smtp-Source: ABdhPJzoxYj27HZ2+Gp7pT5tk/JVfgtmPqmJcOymSjJZXO3LHQ3EPnC8di0XgNvcJ5PYkLNDd2o6CA==
X-Received: by 2002:a2e:8753:: with SMTP id q19mr44198168ljj.375.1638103126892;
        Sun, 28 Nov 2021 04:38:46 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id v198sm976533lfa.89.2021.11.28.04.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:38:46 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/5] net: wwan: iosm: consolidate trace port init code
Date:   Sun, 28 Nov 2021 15:38:33 +0300
Message-Id: <20211128123837.22829-2-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211128123837.22829-1-ryazanov.s.a@gmail.com>
References: <20211128123837.22829-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the channel related structures initialization from
ipc_imem_channel_init() to ipc_trace_init() and call it directly. On the
one hand, this makes the trace port initialization symmetric to the
deitialization, that is, it removes the additional wrapper.

On the other hand, this change consolidates the trace port related code
into a single source file, what facilitates an upcoming disabling of
this functionality by a user choise.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c     |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 18 ------------------
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_trace.c    |  8 +++++++-
 4 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 1be07114c85d..49bdadb855e5 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -554,7 +554,7 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 		ctrl_chl_idx++;
 	}
 
-	ipc_imem->trace = ipc_imem_trace_channel_init(ipc_imem);
+	ipc_imem->trace = ipc_trace_init(ipc_imem);
 	if (!ipc_imem->trace) {
 		dev_err(ipc_imem->dev, "trace channel init failed");
 		return;
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 43f1796a8984..d2072a84ab08 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -11,7 +11,6 @@
 #include "iosm_ipc_imem_ops.h"
 #include "iosm_ipc_port.h"
 #include "iosm_ipc_task_queue.h"
-#include "iosm_ipc_trace.h"
 
 /* Open a packet data online channel between the network layer and CP. */
 int ipc_imem_sys_wwan_open(struct iosm_imem *ipc_imem, int if_id)
@@ -108,23 +107,6 @@ void ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
 			"failed to register the ipc_wwan interfaces");
 }
 
-/**
- * ipc_imem_trace_channel_init - Initializes trace channel.
- * @ipc_imem:          Pointer to iosm_imem struct.
- *
- * Returns: Pointer to trace instance on success else NULL
- */
-struct iosm_trace *ipc_imem_trace_channel_init(struct iosm_imem *ipc_imem)
-{
-	struct ipc_chnl_cfg chnl_cfg = { 0 };
-
-	ipc_chnl_cfg_get(&chnl_cfg, IPC_MEM_CTRL_CHL_ID_3);
-	ipc_imem_channel_init(ipc_imem, IPC_CTYPE_CTRL, chnl_cfg,
-			      IRQ_MOD_OFF);
-
-	return ipc_trace_init(ipc_imem);
-}
-
 /* Map SKB to DMA for transfer */
 static int ipc_imem_map_skb_to_dma(struct iosm_imem *ipc_imem,
 				   struct sk_buff *skb)
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
index e36ee2782629..f8afb217d9e2 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
@@ -141,5 +141,5 @@ int ipc_imem_sys_devlink_read(struct iosm_devlink *ipc_devlink, u8 *data,
  */
 int ipc_imem_sys_devlink_write(struct iosm_devlink *ipc_devlink,
 			       unsigned char *buf, int count);
-struct iosm_trace *ipc_imem_trace_channel_init(struct iosm_imem *ipc_imem);
+
 #endif
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.c b/drivers/net/wwan/iosm/iosm_ipc_trace.c
index c5fa12599c2b..5f5cfd39bede 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.c
@@ -132,9 +132,15 @@ static const struct file_operations ipc_trace_fops = {
  */
 struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem)
 {
-	struct iosm_trace *ipc_trace = kzalloc(sizeof(*ipc_trace), GFP_KERNEL);
+	struct ipc_chnl_cfg chnl_cfg = { 0 };
+	struct iosm_trace *ipc_trace;
 	struct dentry *debugfs_pdev;
 
+	ipc_chnl_cfg_get(&chnl_cfg, IPC_MEM_CTRL_CHL_ID_3);
+	ipc_imem_channel_init(ipc_imem, IPC_CTYPE_CTRL, chnl_cfg,
+			      IRQ_MOD_OFF);
+
+	ipc_trace = kzalloc(sizeof(*ipc_trace), GFP_KERNEL);
 	if (!ipc_trace)
 		return NULL;
 
-- 
2.32.0

