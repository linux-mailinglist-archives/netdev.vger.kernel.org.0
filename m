Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8046302BA
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiKRXOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbiKRXNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:39 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848EEC68B2
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:57 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id a22-20020a17090a6d9600b0021896eb5554so615636pjk.1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mVwATHQ4/uKDOkIljrTgg644UPyKDTdeBO2KcWGKqXE=;
        b=ZTQ1RETjYka2RmMHdToHP3BSrMCgeaSIoOhKRTlYAC0pz415DCNQv3Mw4+3sUDnGA/
         8o6MH6kOmUNDRzI8gVLLGl6Gy3QYQGcA0zvQa584IDpAnnNd+6uoitjxbyBvptKm6OBA
         ixRjWbY9oWJ3KoHGthiSvKxD11pXFvJYUxP+L6A/IQYRirHCWUP8pgSHcAnTRA6ytZkm
         h+KJHqj2STnjnFIiiuHzdjlksjc5kx9kbX4TJhXgMu7W0QsAq9gHr9BgpuIV7f/oH9o8
         oDu9tkLg70Mi7IWn/JH0yTpVnICyk9yN6fdl+3opqPHqQpMd6kxakOqAGisAHAiAmFJw
         DvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mVwATHQ4/uKDOkIljrTgg644UPyKDTdeBO2KcWGKqXE=;
        b=Wo4PY2pJRxIQPFHjNXCPPUzwvgCRP20leYNQzkMFjxzaZE2NoN8bXECwnKqdCNk4ck
         5Hyi0kiwxc2W6z15tDgPvGokN8T4M6zr/MXnKxZRYwOhgpx1k8zlRS+6zAlL5ECMPxGU
         TZJQW3yhNqPlN5eipsOjcwD1VbL7fq/rxK2rTbo/xg3UWqmucVt6eHjsqS/idmGZUsL/
         L4FMNpggszoxZeYLDEThU1Eam3E7ArIlatZu3uw5rDcXWfoO37D1SXK9wdr/PdI7fddk
         Yq/FV5TvA4QgnQ633P9Zza8/Not0SKPsMDvcFVGQBlgGdwFsllujXtogJtaihWGgIK5o
         k7AA==
X-Gm-Message-State: ANoB5plSi03Fa6yH9xh2cWiRfFTpZ4hJw9qvTCQ//fnrMCO/+dlIL40o
        LGMft8cmMf3+tdGYTEhwPr/bmAmLMFceBA==
X-Google-Smtp-Source: AA0mqf5trh655O4U1gujKtF+92wiTMhaocwZpHkRe9oR4td4um8qMddmmTR4ey/r/aLlQsdK35slMw==
X-Received: by 2002:a17:903:2112:b0:186:67b0:afab with SMTP id o18-20020a170903211200b0018667b0afabmr1706709ple.17.1668812248570;
        Fri, 18 Nov 2022 14:57:28 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:28 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 12/19] pds_core: publish events to the clients
Date:   Fri, 18 Nov 2022 14:56:49 -0800
Message-Id: <20221118225656.48309-13-snelson@pensando.io>
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

When the Core device gets an event from the device, or notices
the device FW to be up or down, it needs to send those events
on to the clients that have an event handler.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/pds_core/adminq.c   | 17 ++++++++
 .../net/ethernet/pensando/pds_core/auxbus.c   | 40 +++++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/core.c | 15 +++++++
 drivers/net/ethernet/pensando/pds_core/core.h |  3 ++
 4 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/pensando/pds_core/adminq.c b/drivers/net/ethernet/pensando/pds_core/adminq.c
index ba9e84a7ca92..4d2d69ce81f4 100644
--- a/drivers/net/ethernet/pensando/pds_core/adminq.c
+++ b/drivers/net/ethernet/pensando/pds_core/adminq.c
@@ -34,11 +34,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
 		case PDS_EVENT_LINK_CHANGE:
 			dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_auxbus_publish(pdsc, PDSC_ALL_CLIENT_IDS, comp);
 			break;
 
 		case PDS_EVENT_RESET:
 			dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_auxbus_publish(pdsc, PDSC_ALL_CLIENT_IDS, comp);
 			break;
 
 		case PDS_EVENT_XCVR:
@@ -46,6 +48,21 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
 				 ecode, eid);
 			break;
 
+		case PDS_EVENT_CLIENT:
+		{
+			struct pds_core_client_event *ce;
+			union pds_core_notifyq_comp *cc;
+			u16 client_id;
+
+			ce = (struct pds_core_client_event *)comp;
+			cc = (union pds_core_notifyq_comp *)&ce->client_event;
+			client_id = le16_to_cpu(ce->client_id);
+			dev_info(pdsc->dev, "NotifyQ CLIENT %d ecode %d eid %lld cc->ecode %d\n",
+				 client_id, ecode, eid, le16_to_cpu(cc->ecode));
+			pdsc_auxbus_publish(pdsc, client_id, cc);
+			break;
+		}
+
 		default:
 			dev_info(pdsc->dev, "NotifyQ ecode %d eid %lld\n",
 				 ecode, eid);
diff --git a/drivers/net/ethernet/pensando/pds_core/auxbus.c b/drivers/net/ethernet/pensando/pds_core/auxbus.c
index 1fcfe8ae9971..53c1164565b8 100644
--- a/drivers/net/ethernet/pensando/pds_core/auxbus.c
+++ b/drivers/net/ethernet/pensando/pds_core/auxbus.c
@@ -205,6 +205,46 @@ static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *pdsc,
 	return NULL;
 }
 
+static int pdsc_core_match(struct device *dev, const void *data)
+{
+	struct pds_auxiliary_dev *curr_padev;
+	struct pdsc *curr_pdsc;
+	const struct pdsc *pdsc;
+
+	/* Match the core device searching for its clients */
+	curr_padev = container_of(dev, struct pds_auxiliary_dev, aux_dev.dev);
+	curr_pdsc = (struct pdsc *)dev_get_drvdata(curr_padev->aux_dev.dev.parent);
+	pdsc = data;
+
+	if (curr_pdsc == pdsc)
+		return 1;
+
+	return 0;
+}
+
+int pdsc_auxbus_publish(struct pdsc *pdsc, u16 client_id,
+			union pds_core_notifyq_comp *event)
+{
+	struct pds_auxiliary_dev *padev;
+	struct auxiliary_device *aux_dev;
+
+	/* Search aux bus for this core's devices */
+	aux_dev = auxiliary_find_device(NULL, pdsc, pdsc_core_match);
+	while (aux_dev) {
+		padev = container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
+		if ((padev->client_id == client_id ||
+		     client_id == PDSC_ALL_CLIENT_IDS) &&
+		    padev->event_handler)
+			padev->event_handler(padev, event);
+		put_device(&aux_dev->dev);
+
+		aux_dev = auxiliary_find_device(&aux_dev->dev,
+						pdsc, pdsc_core_match);
+	}
+
+	return 0;
+}
+
 int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id)
 {
 	struct pds_auxiliary_dev *padev;
diff --git a/drivers/net/ethernet/pensando/pds_core/core.c b/drivers/net/ethernet/pensando/pds_core/core.c
index 202f1a6b4605..d1ef6acd8dd0 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.c
+++ b/drivers/net/ethernet/pensando/pds_core/core.c
@@ -532,6 +532,11 @@ void pdsc_stop(struct pdsc *pdsc)
 
 static void pdsc_fw_down(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 0,
+	};
+
 	mutex_lock(&pdsc->config_lock);
 
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
@@ -540,6 +545,9 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 		return;
 	}
 
+	/* Notify clients of fw_down */
+	pdsc_auxbus_publish(pdsc, PDSC_ALL_CLIENT_IDS, &reset_event);
+
 	netif_device_detach(pdsc->netdev);
 	pdsc_mask_interrupts(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
@@ -549,6 +557,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 
 static void pdsc_fw_up(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 1,
+	};
 	int err;
 
 	mutex_lock(&pdsc->config_lock);
@@ -573,6 +585,9 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 
 	pdsc_vf_attr_replay(pdsc);
 
+	/* Notify clients of fw_up */
+	pdsc_auxbus_publish(pdsc, PDSC_ALL_CLIENT_IDS, &reset_event);
+
 	return;
 
 err_out:
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index 3ab314217464..25f09f4f035d 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -321,6 +321,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+#define PDSC_ALL_CLIENT_IDS   0xffff
+int pdsc_auxbus_publish(struct pdsc *pdsc, u16 client_id,
+			union pds_core_notifyq_comp *event);
 int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id);
 int pdsc_auxbus_dev_del_vf(struct pdsc *pdsc, int vf_id);
 
-- 
2.17.1

