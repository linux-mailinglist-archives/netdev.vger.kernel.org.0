Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5136302AC
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbiKRXNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiKRXMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:12:53 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B25CB973
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:40 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso6033076pjt.0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sodxy1VKB4Ksh5rw9cMvYpBoSotEVY0d3yF6g5Z4U6M=;
        b=CyxjXn8YDITtjrMENGz49V2+sYvQ7WQrZPVHjC113iwfwb+4cm2E5NSpUroOxng74G
         5ZMsVFPyvrw6b1NPPOY88IU7mMz9s49nnbB63Cz3du7L4cd2iJz4YV/EAVrgwoUXF6oc
         hgzfCnJMnjMk6dVFuSATh55sW5KkVVT5DAUwmvXZ+FVp+VYBDc9coajR08ukP5Kg2EsF
         Rk0x6d5eT4Ylww24fS7uchWxU6mqfP71OnVTaENVZ9x2qMiN/hxwcA+mmFWDmkl0W1sR
         eER09rkSlkhGqjThMHDcHhUbIM46sWA7UEuXD8k65g/eVeiE6kqtvN4hrdv7DoasCYyK
         ZpMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sodxy1VKB4Ksh5rw9cMvYpBoSotEVY0d3yF6g5Z4U6M=;
        b=TWF0tqGPXjSv2uZVu312oR1Acp+k0fq9eqYFRZhlKMEsZp0NdTXRgfpp0+y0/ixrL5
         lglYuIYQzfGAFuDEFxbmQj8w/OlCu7CSub9aXEqCdwSGntIWXLFh4XcMJPDGNPPggJhE
         gtnn9VaWkYnHbCEes3ssFA4ideDYLhub18RjMHoS59yd9PguarRkItz9sg35URkmnr8E
         2RilApZnJNgf4BpJS68jR5haicBMS65vFALWE9OSiQQSlDL7jr3oYdl9liTZtNJLyLPv
         R/O//L/e55pNp2pDXFZPuNy//EiU/ZwW2lxF3Wsjgql3DvP2t6jqEIsmGzBhngJRLlrj
         uQMg==
X-Gm-Message-State: ANoB5pl5wj+RUYTYr1UAmrjKZN8HBXsEnJYSmrxosDEd0ZH4EQMIlwWM
        MjF8ZQ6LtjYFqCstliViYxaBujqIpUFwZg==
X-Google-Smtp-Source: AA0mqf4/oNrCLX0PVc5OqgKhJ54pKxOjwOqonaPICe0jG2J7kZSKn6Squ8wGkUA4KA9NGq4+CX6+0Q==
X-Received: by 2002:a17:902:6b8b:b0:188:a40b:47c9 with SMTP id p11-20020a1709026b8b00b00188a40b47c9mr1590814plk.75.1668812236199;
        Fri, 18 Nov 2022 14:57:16 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:15 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 03/19] pds_core: health timer and workqueue
Date:   Fri, 18 Nov 2022 14:56:40 -0800
Message-Id: <20221118225656.48309-4-snelson@pensando.io>
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

Add in the periodic health check and the related workqueue,
as well as the handlers for when a FW reset is seen.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/pds_core/core.c | 60 +++++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/core.h |  9 +++
 drivers/net/ethernet/pensando/pds_core/dev.c  |  3 +
 drivers/net/ethernet/pensando/pds_core/main.c | 50 ++++++++++++++++
 4 files changed, 122 insertions(+)

diff --git a/drivers/net/ethernet/pensando/pds_core/core.c b/drivers/net/ethernet/pensando/pds_core/core.c
index d846e8b93575..49cab9e58da6 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.c
+++ b/drivers/net/ethernet/pensando/pds_core/core.c
@@ -41,3 +41,63 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 
 	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
 }
+
+static void pdsc_fw_down(struct pdsc *pdsc)
+{
+	mutex_lock(&pdsc->config_lock);
+
+	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		dev_err(pdsc->dev, "%s: already happening\n", __func__);
+		mutex_unlock(&pdsc->config_lock);
+		return;
+	}
+
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
+
+	mutex_unlock(&pdsc->config_lock);
+}
+
+static void pdsc_fw_up(struct pdsc *pdsc)
+{
+	int err;
+
+	mutex_lock(&pdsc->config_lock);
+
+	if (!test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		dev_err(pdsc->dev, "%s: fw not dead\n", __func__);
+		mutex_unlock(&pdsc->config_lock);
+		return;
+	}
+
+	err = pdsc_setup(pdsc, PDSC_SETUP_RECOVERY);
+	if (err)
+		goto err_out;
+
+	mutex_unlock(&pdsc->config_lock);
+
+	return;
+
+err_out:
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
+	mutex_unlock(&pdsc->config_lock);
+}
+
+void pdsc_health_thread(struct work_struct *work)
+{
+	struct pdsc *pdsc = container_of(work, struct pdsc, health_work);
+	bool healthy;
+
+	healthy = pdsc_is_fw_good(pdsc);
+	dev_dbg(pdsc->dev, "%s: health %d fw_status %#02x fw_heartbeat %d\n",
+		__func__, healthy, pdsc->fw_status, pdsc->last_hb);
+
+	if (test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		if (healthy)
+			pdsc_fw_up(pdsc);
+	} else {
+		if (!healthy)
+			pdsc_fw_down(pdsc);
+	}
+
+	pdsc->fw_generation = pdsc->fw_status & PDS_CORE_FW_STS_F_GENERATION;
+}
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index bd86a9cd8e03..462f7df99b3f 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -12,6 +12,8 @@
 #include <linux/pds/pds_intr.h>
 
 #define PDSC_DRV_DESCRIPTION	"Pensando Core PF Driver"
+
+#define PDSC_WATCHDOG_SECS	5
 #define PDSC_TEARDOWN_RECOVERY  false
 #define PDSC_TEARDOWN_REMOVING  true
 #define PDSC_SETUP_RECOVERY	false
@@ -64,12 +66,17 @@ struct pdsc {
 	u8 fw_generation;
 	unsigned long last_fw_time;
 	u32 last_hb;
+	struct timer_list wdtimer;
+	unsigned int wdtimer_period;
+	struct work_struct health_work;
 
 	struct pdsc_devinfo dev_info;
 	struct pds_core_dev_identity dev_ident;
 	unsigned int nintrs;
 	struct pdsc_intr_info *intr_info;	/* array of nintrs elements */
 
+	struct workqueue_struct *wq;
+
 	unsigned int devcmd_timeout;
 	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
 	struct mutex config_lock;	/* lock for configuration operations */
@@ -82,6 +89,7 @@ struct pdsc {
 	u64 __iomem *kern_dbpage;
 };
 
+void pdsc_queue_health_check(struct pdsc *pdsc);
 void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
 
 struct pdsc *pdsc_dl_alloc(struct device *dev);
@@ -122,5 +130,6 @@ int pdsc_dev_init(struct pdsc *pdsc);
 
 int pdsc_setup(struct pdsc *pdsc, bool init);
 void pdsc_teardown(struct pdsc *pdsc, bool removing);
+void pdsc_health_thread(struct work_struct *work);
 
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/pensando/pds_core/dev.c b/drivers/net/ethernet/pensando/pds_core/dev.c
index addbd300e5c3..d6ef8a1bf46b 100644
--- a/drivers/net/ethernet/pensando/pds_core/dev.c
+++ b/drivers/net/ethernet/pensando/pds_core/dev.c
@@ -179,6 +179,9 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 	err = pdsc_devcmd_wait(pdsc, max_seconds);
 	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
 
+	if (err == -ENXIO || err == -ETIMEDOUT)
+		pdsc_queue_health_check(pdsc);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/pensando/pds_core/main.c b/drivers/net/ethernet/pensando/pds_core/main.c
index 770b3f895bbb..23f209d3375c 100644
--- a/drivers/net/ethernet/pensando/pds_core/main.c
+++ b/drivers/net/ethernet/pensando/pds_core/main.c
@@ -25,6 +25,31 @@ static const struct pci_device_id pdsc_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, pdsc_id_table);
 
+void pdsc_queue_health_check(struct pdsc *pdsc)
+{
+	unsigned long mask;
+
+	/* Don't do a check when in a transition state */
+	mask = BIT_ULL(PDSC_S_INITING_DRIVER) |
+	       BIT_ULL(PDSC_S_STOPPING_DRIVER);
+	if (pdsc->state & mask)
+		return;
+
+	/* Queue a new health check if one isn't already queued */
+	queue_work(pdsc->wq, &pdsc->health_work);
+}
+
+static void pdsc_wdtimer_cb(struct timer_list *t)
+{
+	struct pdsc *pdsc = from_timer(pdsc, t, wdtimer);
+
+	dev_dbg(pdsc->dev, "%s: jiffies %ld\n", __func__, jiffies);
+	mod_timer(&pdsc->wdtimer,
+		  round_jiffies(jiffies + pdsc->wdtimer_period));
+
+	pdsc_queue_health_check(pdsc);
+}
+
 static void pdsc_unmap_bars(struct pdsc *pdsc)
 {
 	struct pdsc_dev_bar *bars = pdsc->bars;
@@ -135,9 +160,12 @@ static int pdsc_map_bars(struct pdsc *pdsc)
 
 static DEFINE_IDA(pdsc_pf_ida);
 
+#define PDSC_WQ_NAME_LEN 24
+
 static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct device *dev = &pdev->dev;
+	char wq_name[PDSC_WQ_NAME_LEN];
 	struct pdsc *pdsc;
 	int err;
 
@@ -189,6 +217,13 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_out_pci_disable_device;
 
+	/* General workqueue and timer, but don't start timer yet */
+	snprintf(wq_name, sizeof(wq_name), "%s.%d", PDS_CORE_DRV_NAME, pdsc->id);
+	pdsc->wq = create_singlethread_workqueue(wq_name);
+	INIT_WORK(&pdsc->health_work, pdsc_health_thread);
+	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
+	pdsc->wdtimer_period = PDSC_WATCHDOG_SECS * HZ;
+
 	/* PDS device setup */
 	mutex_init(&pdsc->devcmd_lock);
 	mutex_init(&pdsc->config_lock);
@@ -209,6 +244,8 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pdsc->fw_generation = PDS_CORE_FW_STS_F_GENERATION &
 			      ioread8(&pdsc->info_regs->fw_status);
+	/* Lastly, start the health check timer */
+	mod_timer(&pdsc->wdtimer, round_jiffies(jiffies + pdsc->wdtimer_period));
 
 	clear_bit(PDSC_S_INITING_DRIVER, &pdsc->state);
 	return 0;
@@ -216,6 +253,12 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out:
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 err_out_unmap_bars:
+	del_timer_sync(&pdsc->wdtimer);
+	if (pdsc->wq) {
+		flush_workqueue(pdsc->wq);
+		destroy_workqueue(pdsc->wq);
+		pdsc->wq = NULL;
+	}
 	mutex_unlock(&pdsc->config_lock);
 	mutex_destroy(&pdsc->config_lock);
 	mutex_destroy(&pdsc->devcmd_lock);
@@ -248,6 +291,13 @@ static void pdsc_remove(struct pci_dev *pdev)
 	mutex_lock(&pdsc->config_lock);
 	set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
 
+	del_timer_sync(&pdsc->wdtimer);
+	if (pdsc->wq) {
+		flush_workqueue(pdsc->wq);
+		destroy_workqueue(pdsc->wq);
+		pdsc->wq = NULL;
+	}
+
 	/* Device teardown */
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 	pdsc_debugfs_del_dev(pdsc);
-- 
2.17.1

