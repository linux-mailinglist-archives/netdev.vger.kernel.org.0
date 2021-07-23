Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC3D3D4023
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhGWRWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhGWRWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:22:31 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED45FC0613C1
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:03:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mt6so3384546pjb.1
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LQqcpN8H/3KExiBgBruWu91XA5dtgK73sPdM6wSUTbM=;
        b=OS2tLctLevA6ggwV9r5HiAV0EPjAHjn1oUj1zdHS3snmCrnUYS/QROcEea2hQfbrIg
         dGmTpRh9gW2C/r9iFk4B8m75IDnlPKVQeyZdthyvmwZ4FYIuMfSp9ixQHHrGP5Vwk7po
         9zfcft823jgUioYNwaf+af3+Lb9Fv+W17y2prxxR6JRp/UcRm52n6nBQAfqZIoNKTNXP
         hz/2IRuV388m10qs4Dgpflp+3OT8uW0zqDBtCCKiENzSAteVVrQzXqrcxmffH7OkocvO
         R/BrgpRHliU+tqb9dOgCHELZBmBdU55NcLtZWV7B2x8M4Rp9FK0R0iPWbesQQclEnDeR
         XSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LQqcpN8H/3KExiBgBruWu91XA5dtgK73sPdM6wSUTbM=;
        b=XBMmM3PRBgGM5LmNi0eO3xpi7nUf32DIbG8XQzJg+mNulTXIwPaq4GtZFUWyjioU89
         wwOfq5DSNmozXCoAnMOVkQzTmnWnxH/43QXTOzQU8OgEwfFJL5jekZaJnNRm8WdQCK46
         7f8iHUSyVZipT8F74ChsaklwLOU2P38AzGpCtJ5qFwAHOoA1MFzACZYPgLRhcaShL48K
         Ri5H5xOL8+Tl0HTjesH6C7Bps7J6AhA+AdaEbQs8fTdYhhz5rVfCiXBRRzPz0kvYl2tT
         2Qd8SYwdbrsl9FiWo3XIR9rTl4gvw/+weAWRUOGoO/lRNih/EDSkI60F2UcTjfPQ9eFl
         WBwg==
X-Gm-Message-State: AOAM530PYjlFXMPwLAxXK6rANmSPmC78tAMr2N5sqNo7fHnN+bfZkMDK
        15TR+vQpfdgid1QE301VqV9ulw==
X-Google-Smtp-Source: ABdhPJxCMJNL4YCCMISi5EQpGE/71m0xr9ySE0OYJHWJOyAhHf/TtF1Ar0NhJ/giFqjSXBJJDHbiKw==
X-Received: by 2002:a63:c041:: with SMTP id z1mr6028843pgi.49.1627063383517;
        Fri, 23 Jul 2021 11:03:03 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c23sm19437934pfo.174.2021.07.23.11.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 11:03:03 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 4/5] ionic: fix up dim accounting for tx and rx
Date:   Fri, 23 Jul 2021 11:02:48 -0700
Message-Id: <20210723180249.57599-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210723180249.57599-1-snelson@pensando.io>
References: <20210723180249.57599-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to count the correct Tx and/or Rx packets for dynamic
interrupt moderation, depending on which we're processing on
the queue interrupt.

Fixes: 04a834592bf5 ("ionic: dynamic interrupt moderation")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 28 ++++++++++++++-----
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 9d3a04110685..1c6e2b9fc96b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -451,11 +451,12 @@ void ionic_rx_empty(struct ionic_queue *q)
 	q->tail_idx = 0;
 }
 
-static void ionic_dim_update(struct ionic_qcq *qcq)
+static void ionic_dim_update(struct ionic_qcq *qcq, int napi_mode)
 {
 	struct dim_sample dim_sample;
 	struct ionic_lif *lif;
 	unsigned int qi;
+	u64 pkts, bytes;
 
 	if (!qcq->intr.dim_coal_hw)
 		return;
@@ -463,10 +464,23 @@ static void ionic_dim_update(struct ionic_qcq *qcq)
 	lif = qcq->q.lif;
 	qi = qcq->cq.bound_q->index;
 
+	switch (napi_mode) {
+	case IONIC_LIF_F_TX_DIM_INTR:
+		pkts = lif->txqstats[qi].pkts;
+		bytes = lif->txqstats[qi].bytes;
+		break;
+	case IONIC_LIF_F_RX_DIM_INTR:
+		pkts = lif->rxqstats[qi].pkts;
+		bytes = lif->rxqstats[qi].bytes;
+		break;
+	default:
+		pkts = lif->txqstats[qi].pkts + lif->rxqstats[qi].pkts;
+		bytes = lif->txqstats[qi].bytes + lif->rxqstats[qi].bytes;
+		break;
+	}
+
 	dim_update_sample(qcq->cq.bound_intr->rearm_count,
-			  lif->txqstats[qi].pkts,
-			  lif->txqstats[qi].bytes,
-			  &dim_sample);
+			  pkts, bytes, &dim_sample);
 
 	net_dim(&qcq->dim, dim_sample);
 }
@@ -487,7 +501,7 @@ int ionic_tx_napi(struct napi_struct *napi, int budget)
 				     ionic_tx_service, NULL, NULL);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
-		ionic_dim_update(qcq);
+		ionic_dim_update(qcq, IONIC_LIF_F_TX_DIM_INTR);
 		flags |= IONIC_INTR_CRED_UNMASK;
 		cq->bound_intr->rearm_count++;
 	}
@@ -526,7 +540,7 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 		ionic_rx_fill(cq->bound_q);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
-		ionic_dim_update(qcq);
+		ionic_dim_update(qcq, IONIC_LIF_F_RX_DIM_INTR);
 		flags |= IONIC_INTR_CRED_UNMASK;
 		cq->bound_intr->rearm_count++;
 	}
@@ -572,7 +586,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 		ionic_rx_fill(rxcq->bound_q);
 
 	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
-		ionic_dim_update(qcq);
+		ionic_dim_update(qcq, 0);
 		flags |= IONIC_INTR_CRED_UNMASK;
 		rxcq->bound_intr->rearm_count++;
 	}
-- 
2.17.1

