Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBC346B6F3
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhLGJZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhLGJZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:25:23 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CEAC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 01:21:53 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id z7so32012767lfi.11
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 01:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oO56SM3oh1knOlpotzxBsJ7mXWks8VAcbwQwZRXYLnU=;
        b=hZRH6u6s301DV5JBklIswKkq17UW4OLwWo9rWUfqGVkk43Cdm27HK+JsSyd+phDTHF
         78emQ1Z0KXBrnilqqQmm1iIZbO0FS4i7Xbb75udhy3mT3yfiL+a4/vfwvZ15q92/duDb
         F86VP+BQAPMlqEbXUxX7O4uQ/f/YGHO4tO5vAVn3+FGK3IVPKNfidJ7764cCuFBJotoD
         jXTXyiTNHtCi11Kc4tTyfOh/bm1Vn7lcsf3TTMoZ936rwe3idOzxEFcQZw00dRMf623z
         ARC0LKOy6BTFhbsZr1b0e1iyTpwBm+y0qN8OoY6YTtZlYEkjkpSfudzyZCQkuukCBqZ8
         8/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oO56SM3oh1knOlpotzxBsJ7mXWks8VAcbwQwZRXYLnU=;
        b=XU8FQ9vslOrQnLxT+/lvRx7Ts1c233tSjFkp/wh3U5odGfNCq8EdaRWMbp8yG59DbF
         j0HvNbqCtCWC2djUtoDWR5h7VYeixqYgH8gkDx2Srw/D8Sewv+pz3yBQfb7cPxlEPhhh
         tKKOQEy0C0c/yq+YOhn+OGbokz3wrmQkhBRVcCKO9NTz5LcF61yVoJWTlfOrA64Q1uXy
         KAoIWDa2uDRgaGzzBVQ9df+KSYCyjTNbPyEl7xOjHn8AX2bLUjw2K6bwpiac7Rek6CyO
         O0q2sNIO6k04NwRy80RcAF9NDdgpcnho+oboMOm95X3qg0r3QCqJBMClPFJU9vhANxy/
         VInA==
X-Gm-Message-State: AOAM5301oyK3g/cSOYGaISahHJ/qrMjv+fFCxDraN5UEcSsL3/l7iQow
        osZCc2j2ki7FxKTmSRJNLSp36cucV9Z/UQ==
X-Google-Smtp-Source: ABdhPJyKulzWcdADDLek5em4cKl1W96CmJRB8ol66p347xoNX6rHRawPgnB/h/c4FKFSfl/qWC//fA==
X-Received: by 2002:ac2:4568:: with SMTP id k8mr39741220lfm.80.1638868911874;
        Tue, 07 Dec 2021 01:21:51 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id k11sm1620497lfo.111.2021.12.07.01.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 01:21:51 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH RESEND net-next v2 2/4] net: wwan: iosm: allow trace port be uninitialized
Date:   Tue,  7 Dec 2021 12:21:38 +0300
Message-Id: <20211207092140.19142-3-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
References: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
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

