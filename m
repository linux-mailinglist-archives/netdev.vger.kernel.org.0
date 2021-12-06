Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4106846AE89
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351495AbhLFXpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbhLFXpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:45:36 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711AAC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 15:42:07 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id j18so23947455ljc.12
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 15:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oO56SM3oh1knOlpotzxBsJ7mXWks8VAcbwQwZRXYLnU=;
        b=Use5bCRN3qcHolqmwFnpPT5RSG4UErDkmDOmc/ZR6FyXeKis8YWngZHtFMaqMBUj1B
         +KUCffRPreJAdEzIr1e3grObJgOhTpg8lQvuIYiI/izGjZVohChwXolqbPuQop9hziL+
         kWn4aDqg1YKT38A6G+57sKmrok51i3F3yJBA5vj7scHyXgXCMS47/t6ar+5fsLSZJgKX
         SO2Zz6dvpeIhK/3Bpe5/y8/aIrIPGuMny6pNkok88x+uUexvcrRNa/4BqDwTeu+NLGjn
         n/ebs21eZ69NLmTaKWOJ/8XRcQFQOS561O0fy0KOnfHiuAWjM/rI9r9yjJ6x5DH+6dD6
         UImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oO56SM3oh1knOlpotzxBsJ7mXWks8VAcbwQwZRXYLnU=;
        b=2CXAEPf7CshXo+Ri3v8PM2zJPOHO1d7kn9GBte6DyV9KFAaSJp72JxbSlgaYcJDMl1
         IimGO+GEzHyQVJEO6son7CzVXUDQ1YFKMbokVfX2Agrli6L3uWTjaw3KKN2XSkDo/PcM
         YNLmzRBtHRJ2duzKZkRuTwnHtQ2uqffQ4t6vaXQEjj5GI9omo8IZ1Flh2Dvq2qfGT1+6
         heTq8tYGLNu3d7WZ6Dn3vwvmgtG+0p9bct4tkQ7wNlcIl4j+hvrwrolFIMXBc7SLgyH0
         VkvOoviSuXgrI+hLgiJOzZx1jlTkIUPi15eNYEUXT8P7TJ6ykXpzd+pRnjtiMHxFm+qq
         SKRw==
X-Gm-Message-State: AOAM531yNUwXs1mi2DzSjZUtRwbrZEHP0FY8tomJpVxSFILLj0K6DpMe
        8wDSoguMXZvy9tfSXh20QnI=
X-Google-Smtp-Source: ABdhPJyw3Py8NbpFrPnaScoyM/nkt75okEtsJxsN20ZKh4sMEuWWpO88vgsPm0hRFcRvZhEoeyCBhA==
X-Received: by 2002:a05:651c:1790:: with SMTP id bn16mr39046924ljb.475.1638834125764;
        Mon, 06 Dec 2021 15:42:05 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id f23sm1590333ljg.90.2021.12.06.15.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 15:42:05 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v2 2/4] net: wwan: iosm: allow trace port be uninitialized
Date:   Tue,  7 Dec 2021 02:41:53 +0300
Message-Id: <20211206234155.15578-3-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211206234155.15578-1-ryazanov.s.a@gmail.com>
References: <20211206234155.15578-1-ryazanov.s.a@gmail.com>
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
Changes since v1:
* no changes

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

