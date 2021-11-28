Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF07460632
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357637AbhK1Mor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357446AbhK1Mmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 07:42:45 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92802C061763
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:38:49 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id m27so37015395lfj.12
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MGJnwlQPpiNh66b9SCMbW7HB4dAqYbf0gLkVpa0vFto=;
        b=obA7XDn85RpbIt1jBiGBdrsWsaBUNCKRKNVSF0oqOIw/OS0eTxpDYlHXmW4eTSftrC
         o53R2ztL5DGbxQYekxwoAM87z1prwiP9XH5hfBJ3jiEk6oIXQbHb1iF9D7bceDEjYU5H
         kiziM+9sMnBuQ/11ygZ/FPQ8Lqo00AGLbvZKtESY/Ha32cSipdoF5EMMDTkxQfoMtMUK
         MJ3Beg5eId81sCXY4utsY47JcvBscPPjZ+YhqietAaBmEzujzMPuwSJfkRbD9fvv4bEs
         GhLdmqXsYkawL/fGdfEHxOe4ufnm1wPr5o/Y/QtRH/l93hDef7BaoyNpO1jsNUWhNRo2
         BHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MGJnwlQPpiNh66b9SCMbW7HB4dAqYbf0gLkVpa0vFto=;
        b=y9cl/Hw7Kq5tAhqr6Rn24NY4P0pcCWk4YdAj5TgV1QN6herVY9e76SRWnRNq0nHRqd
         8T2bhpS+VzD031Egrzozb0zPc+tone7gMvmis/fvXrkp7+PfrBKOcNuphRu6hWktKRuF
         FgYDWWkuWDfzPZww8OCrEiPw321KiUihSEw4M+FyAVcN8WJihMgG4NN47p3MrDsiuXVH
         7X/8WeFULL/7ACAepi+YvuPbsbABHdeokmaiCeQc3RhdyeTJkU126KksDnZ4YC82A+j0
         dZcQ7DQrQ0j/AfXi9tvjgYmctqTdDe1q0p0RUL7mylGPFIOgmeOSDgSOnBj8zJvNh+QW
         76DQ==
X-Gm-Message-State: AOAM530jm8dZh3KcKTpwBtEtV1EcgjPBYP3bwBShvYRqEHXrJ1hW1Wt6
        Bj1dzs07r/PCmICvXXwcFsU=
X-Google-Smtp-Source: ABdhPJyKtOoP0146KfaPiZ6L6qKHzkjN5BatT7HusqKHLZOnOIlglViYhBKZzT3+RG+MuiOdf5G3wA==
X-Received: by 2002:a05:6512:1313:: with SMTP id x19mr22092679lfu.279.1638103127878;
        Sun, 28 Nov 2021 04:38:47 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id v198sm976533lfa.89.2021.11.28.04.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:38:47 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/5] net: wwan: iosm: allow trace port be uninitialized
Date:   Sun, 28 Nov 2021 15:38:34 +0300
Message-Id: <20211128123837.22829-3-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211128123837.22829-1-ryazanov.s.a@gmail.com>
References: <20211128123837.22829-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Collecting modem firmware traces is optional for the regular modem use.
There are not many reasons for aborting device initialization due to an
inability to initialize the trace port and (or) its debugfs interface.
So, demote the initialization failure erro message into a warning and do
not break the initialization sequence in this case. Rework packet
processing and deinitialization so that they do not crash in case of
uninitialized trace port.

This change is mainly a preparation for an upcoming configuration option
introduction that will help disable driver debugfs functionality.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c  | 8 +++-----
 drivers/net/wwan/iosm/iosm_ipc_trace.c | 3 +++
 drivers/net/wwan/iosm/iosm_ipc_trace.h | 5 +++++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 49bdadb855e5..a60b93cefd2e 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -272,7 +272,7 @@ static void ipc_imem_dl_skb_process(struct iosm_imem *ipc_imem,
 		if (port_id == IPC_MEM_CTRL_CHL_ID_7)
 			ipc_imem_sys_devlink_notify_rx(ipc_imem->ipc_devlink,
 						       skb);
-		else if (port_id == ipc_imem->trace->chl_id)
+		else if (ipc_is_trace_channel(ipc_imem, port_id))
 			ipc_trace_port_rx(ipc_imem->trace, skb);
 		else
 			wwan_port_rx(ipc_imem->ipc_port[port_id]->iosm_port,
@@ -555,10 +555,8 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 	}
 
 	ipc_imem->trace = ipc_trace_init(ipc_imem);
-	if (!ipc_imem->trace) {
-		dev_err(ipc_imem->dev, "trace channel init failed");
-		return;
-	}
+	if (!ipc_imem->trace)
+		dev_warn(ipc_imem->dev, "trace channel init failed");
 
 	ipc_task_queue_send_task(ipc_imem, ipc_imem_send_mdm_rdy_cb, 0, NULL, 0,
 				 false);
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.c b/drivers/net/wwan/iosm/iosm_ipc_trace.c
index 5f5cfd39bede..c588a394cd94 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.c
@@ -172,6 +172,9 @@ struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem)
  */
 void ipc_trace_deinit(struct iosm_trace *ipc_trace)
 {
+	if (!ipc_trace)
+		return;
+
 	debugfs_remove(ipc_trace->ctrl_file);
 	relay_close(ipc_trace->ipc_rchan);
 	mutex_destroy(&ipc_trace->trc_mutex);
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.h b/drivers/net/wwan/iosm/iosm_ipc_trace.h
index 53346183af9c..419540c91219 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.h
@@ -45,6 +45,11 @@ struct iosm_trace {
 	enum trace_ctrl_mode mode;
 };
 
+static inline bool ipc_is_trace_channel(struct iosm_imem *ipc_mem, u16 chl_id)
+{
+	return ipc_mem->trace && ipc_mem->trace->chl_id == chl_id;
+}
+
 struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem);
 void ipc_trace_deinit(struct iosm_trace *ipc_trace);
 void ipc_trace_port_rx(struct iosm_trace *ipc_trace, struct sk_buff *skb);
-- 
2.32.0

