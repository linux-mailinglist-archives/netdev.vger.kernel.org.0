Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D623196354
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgC1DPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:15:01 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53447 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgC1DO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 23:14:59 -0400
Received: by mail-pj1-f67.google.com with SMTP id l36so4702138pjb.3
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 20:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ko+uCO19QCVh5AUtwf1Zhv9JBZtt+WU8A4/1xeIWCrA=;
        b=4IBv1mvUYgRsmKZauEgbcVSVcUBMysUHvV4f3tcHdr9WPcYKoYGK0gpaulJAoNXpFK
         2fLY0Ce7ahj9yYBT2oAb2Y7BOfNnhqY9e88qugPyE30L3WFrjr85TT8tebboeDnMfu+/
         39b4Mkf051Ndcd8wA14zfksb2Z3EJLfQ9X1NVDMJeEhvt2C0XI8nJZgiExEpMlgg3ByI
         NvtMEhrcf0weqj2P2TkVxTUJejYr9Xv4yNYY/clHb/ymEIK9maLYazNly5xHurSSJyHs
         v/THC+Ilevbt+y93/HgYb5Pll0jFudZ+OGQIemaC0+a/BJbAlI2BcmmaunLwqdQxMe5s
         SRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ko+uCO19QCVh5AUtwf1Zhv9JBZtt+WU8A4/1xeIWCrA=;
        b=ElKzdP2F4NJYDQsl+IPJE5DEOGDZHUsKTqFRR0z50+36ySZsNJLRAFnxpsQd9z8fwJ
         Tp+KZvT6cZYscVPqvyzaUFFeBh+MXyBJfC9IOlVcqCPQBtaTUUJT/yTgs0z6XFnIcUBI
         1HXtd4bCA+Ef6JDzEsFxBIyvz2cQNn+uEvHnaXG1T2Ef8gKOf9LeSdEREuzmOblv/GYS
         2wO75qgAaBPwAj08C+VVLCMej0V2t4ttQy1/vK8N+ZEfdSD2s63Lg1mSnr8hQRKli9Jj
         0KFWLNW5LoSG75EzE98nJgef7wXjjmlRKtirNbYEmLD09/M7ij/5xxpHJyWjgjtKMJ+D
         BUww==
X-Gm-Message-State: ANhLgQ1WMIOMXOmGgMjaLj5YoLT6C3mj3eUpMkD0y9yOeQnBd4/FcwxU
        22UagVYPNxB52P/W/Rz2V7aatw==
X-Google-Smtp-Source: ADFU+vu/QJWZr0m0tx70bu4Xm+YmqA8HoMpeR85iNNPtRCAEhPq5twCe0QF4nxOODppPAPI7QPAw/w==
X-Received: by 2002:a17:902:ec03:: with SMTP id l3mr632101pld.73.1585365298796;
        Fri, 27 Mar 2020 20:14:58 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o65sm5208391pfg.187.2020.03.27.20.14.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 20:14:58 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 5/8] ionic: clean tx queue of unfinished requests
Date:   Fri, 27 Mar 2020 20:14:45 -0700
Message-Id: <20200328031448.50794-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328031448.50794-1-snelson@pensando.io>
References: <20200328031448.50794-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean out tx requests that didn't get finished before
shutting down the queue.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  |  1 +
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 16 ++++++++++++++++
 drivers/net/ethernet/pensando/ionic/ionic_txrx.h |  1 +
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index b3f568356824..2804690657fd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1454,6 +1454,7 @@ static void ionic_txrx_deinit(struct ionic_lif *lif)
 	for (i = 0; i < lif->nxqs; i++) {
 		ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
 		ionic_tx_flush(&lif->txqcqs[i].qcq->cq);
+		ionic_tx_empty(&lif->txqcqs[i].qcq->q);
 
 		ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
 		ionic_rx_flush(&lif->rxqcqs[i].qcq->cq);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 15ff633e81ba..d233b6e77b1e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -593,6 +593,22 @@ void ionic_tx_flush(struct ionic_cq *cq)
 				   work_done, 0);
 }
 
+void ionic_tx_empty(struct ionic_queue *q)
+{
+	struct ionic_desc_info *desc_info;
+	int done = 0;
+
+	/* walk the not completed tx entries, if any */
+	while (q->head != q->tail) {
+		desc_info = q->tail;
+		q->tail = desc_info->next;
+		ionic_tx_clean(q, desc_info, NULL, desc_info->cb_arg);
+		desc_info->cb = NULL;
+		desc_info->cb_arg = NULL;
+		done++;
+	}
+}
+
 static int ionic_tx_tcp_inner_pseudo_csum(struct sk_buff *skb)
 {
 	int err;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
index 53775c62c85a..71973e3c35a6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
@@ -9,6 +9,7 @@ void ionic_tx_flush(struct ionic_cq *cq);
 
 void ionic_rx_fill(struct ionic_queue *q);
 void ionic_rx_empty(struct ionic_queue *q);
+void ionic_tx_empty(struct ionic_queue *q);
 int ionic_rx_napi(struct napi_struct *napi, int budget);
 netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev);
 
-- 
2.17.1

