Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BBA46B6F2
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhLGJZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhLGJZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:25:22 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8D4C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 01:21:52 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id k23so26297504lje.1
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 01:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jwBUn2JCyUxt/6DBJHGdGqGcL6DOG78oWiBTZowoBDE=;
        b=KEI0JFa8osIUK1BLx5PY3kSgipER2Lpg78kN1Mv3hD9OLtP+eo+OhKtghtBw9S+KGo
         uhy5gwwCwPjsPX24xqqwDMfGn5ftHISfezbdaP+6S4PCqVMbSNt6/9bWjs4t5jzZG+S4
         TqFwl8cn6Rnel3BV4SKX1gyui9AudPH82D7jr6VT7vDP6fHMgZE6E+zZwJ8h3oVFKQ09
         NSM8YnFJqdanGGulp5sKy84Z8moMke6IOBCkiOkP83/mCohUCI8/8MnHvYfHG3sXaY3y
         C8IcQqMrmbVY0aGlsSynZCdoFLQhNNGI+bD753ZOeeqID6Jiqew913svIBhXEnyOJekb
         fbUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jwBUn2JCyUxt/6DBJHGdGqGcL6DOG78oWiBTZowoBDE=;
        b=w8DmsTCkivNOQ0365T0H2vFTvm2cYwTnblPBTjrn/IW97fcurT0q95dnwKQgVAoAoA
         /0TaIYkPbsH9HzQzqkGDHO0gRKD5gHdkNFua3PvTqN8NpL2+1O1JtSXE1ZUeVvSG2/P5
         dEbyxDgOO9mIaprnJs3/KklKdgG9dGQk0AFrgYgo1jb3FFU1CvmvuRCs6v0tCdJrLOJH
         B0iSEbdusZzDXqqR1hukbhDTm2fZ31ftpYk4ZjGhbNGt82Vpn3zUTn65p1w/wTn0Q3/d
         LZUT3Ja1qCZJccZxk2c1YlchhTzhyym7aFsvz1hrhY362eRHy8lIm39fY0NcVNv2fZsV
         y9nA==
X-Gm-Message-State: AOAM533up7UCDJkjo5NB6tJ3DToAydnlvwZ7fQfk0AO9xR5j9Vk7BoLw
        p8FkV5Uh7cEDQp1KoSR4zEo=
X-Google-Smtp-Source: ABdhPJwQCJPaIk5N5B0H2AYUYXjF6njmXghPacjQpxsMJC1s0XDGdFLeKr2oZpL5knjmmJxP9sTsiw==
X-Received: by 2002:a2e:6e17:: with SMTP id j23mr38950803ljc.99.1638868910876;
        Tue, 07 Dec 2021 01:21:50 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id k11sm1620497lfo.111.2021.12.07.01.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 01:21:50 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH RESEND net-next v2 1/4] net: wwan: iosm: consolidate trace port init code
Date:   Tue,  7 Dec 2021 12:21:37 +0300
Message-Id: <20211207092140.19142-2-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
References: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
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
Changes since v1:
* no changes

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

