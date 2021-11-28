Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169D546064C
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 14:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357560AbhK1NDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 08:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbhK1NBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 08:01:05 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638FCC061748
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:55:34 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id e11so28905559ljo.13
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lAYjBODWXtYE0eUrwiIG3wvz5YgUWiz/ucehD2kVx78=;
        b=kTk7vS1DNYJmNSIyeXsuB+dukq9g7/GuS9VjE26bFaVewgg4Fqg0Tm+i5r5gHh4WTi
         RKeCEcHAX1N7b2k9cTkQNcgi/5dvGhrg7CQmdttBCteftJz0gQq6ojyhkLB4j94VWNjs
         scP8Ua/X0vMaSIiiShWdCJ6gvrlWO6YgP4jQGKLQZq+4gDuUZte3jBweAnF7ZKRpiyYu
         BxZFDuIEpby0BMeY94cI9xB9PZLnF5oAbyiYTz7DvU1NkN0dGS7wb0W469d/3pVmRRDH
         Yu+Ns15jYS+4bdho2TugNxxQf0q1C/QvtUCf5axzJkYRlKmpjgLBiEUUxIg38v/qmPCO
         n8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lAYjBODWXtYE0eUrwiIG3wvz5YgUWiz/ucehD2kVx78=;
        b=xEhqzVq/r1EfbgwdDqfggBZiIi45WE5Tj1cGEBNlgwmEN4RTR/B72oZ1uD18kDJweX
         IqqoEMA8yMTTTGWzhlpXTYFehxFGfM9IBP/htx7ut6Jl2gIr6DlDuKE04nlK7Ayj00Yx
         RCQnPioYZKUc6M6do+twX2s9gfGpkeR9OlFCN38DiL+9nl+Vbtw3MR/y2xHP8IEvYuFD
         1U0Wb5II05KVTaCCeoZdbd+0gTyEPIq2bFgQjDvIVODTL44kVdzHPYf04YB9ps/pCrV0
         Q2OA7GFIQeSAXjQU/EFFMKOcKB4DDU3sVoe0CYZ0pBerM/1y0fjCJnGlxwxcOv0RzbWQ
         ZRNQ==
X-Gm-Message-State: AOAM533i7/F1CLUk6d33vDqf5nghv1ZE4U84XZM8R3VKqE8qsDLFVMLV
        y1MgQGmLQrZGYmkwm2vebjkgsTVtQxI=
X-Google-Smtp-Source: ABdhPJwhbcEef4669LMtcVutfFp4ELRRrvqJbnDrfFqIEJ0F67g/ite3zDdhm4d/fHXq0WkZDC5+tw==
X-Received: by 2002:a2e:9915:: with SMTP id v21mr44506756lji.155.1638104132706;
        Sun, 28 Nov 2021 04:55:32 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id c1sm1066595ljr.111.2021.11.28.04.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:55:32 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH RESEND net-next 1/5] net: wwan: iosm: consolidate trace port init code
Date:   Sun, 28 Nov 2021 15:55:18 +0300
Message-Id: <20211128125522.23357-2-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
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

