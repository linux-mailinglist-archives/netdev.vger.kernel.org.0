Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB2A2A7093
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732377AbgKDWeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729163AbgKDWeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:34:06 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2EBC0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 14:34:06 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id r10so54643pgb.10
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 14:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vJc4De0lJJqWH98ugIkZZ8d6bxE3OdbpvFhviZ678gM=;
        b=G/Tykc36AiASWvaTpQBJ1F1HTuVIDcy2KVKH+Hk7yWjNcyFmRNtpVg9s9xO4O8eaQz
         i5BziMMMsVY2uXlDFxrXG2cnZcVrm0cMo1fA6XJ6Pb21S0m3/7QvGz6znIACQv5QTzca
         juNQKN72XSqNL2Pa6XLos1kcc3oMc0k62A8DUm6QKtj8m+dTnrIXmlaUKnknqHBwDdOT
         qiFIOKS9JQeXrp8Tf7v1kjmfqdzJuqQcbZz4a7/w01qTW5EjuIHL3PSMxwnWIWniFCB/
         k3emdTCrFo1WH38sQSKpK0ry53s9sbLiC8cluZPAvTOs+ggMEHU4rK4Qo09hF0F25HNI
         jo0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vJc4De0lJJqWH98ugIkZZ8d6bxE3OdbpvFhviZ678gM=;
        b=T5DsPxLsPKUrHG+dsymi12rVuDvDGgDCZ44sF8hYPUyDN0AMAOLnbd1qIA52seNnDQ
         xsxJLKbmBtpnZkXrbybw8QkvSyD1M7HKPMjvM/pt1Y5vfPVITTDr671Xwu97Ri4edvw2
         xAl3hKaQLPRn5QHIJF0vSbvxoCDHsJ3YE56FxRC3OMzRe8KHps9Ck0FMRJTNkPhLa6rD
         tn9Dh8t8SC51keR/UtUmCjWo555h4zi1/b+8iRxylk+ssYWF/Qd50ZIGoomcul9vSXHn
         Bpn4tU0bI6f9trdIU02z6kQHPl8mu+Y5QjMTzkqcVtGLbnaponFS01PhQa8SgSbzVRBY
         2khQ==
X-Gm-Message-State: AOAM530rcWS8lZPyj6O6AGKh6lQQxzZ5gO70X4+ufszJR1FT6KFwBHKi
        LIfzi0RhQEKl6zUR2qdBCPQRuvr2/cCyKw==
X-Google-Smtp-Source: ABdhPJyRDwGn5aBggJ8V0Q6PxnRkHu+nn5XbD6PvgRsqDQiArrwh8jeNcg+b8/dlWEMNfE7qs+0C3g==
X-Received: by 2002:a62:3:0:b029:160:d92:2680 with SMTP id 3-20020a6200030000b02901600d922680mr34130pfa.44.1604529245703;
        Wed, 04 Nov 2020 14:34:05 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id z10sm3284559pff.218.2020.11.04.14.34.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 14:34:05 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/6] ionic: add lif quiesce
Date:   Wed,  4 Nov 2020 14:33:51 -0800
Message-Id: <20201104223354.63856-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201104223354.63856-1-snelson@pensando.io>
References: <20201104223354.63856-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the queues are stopped, expressly quiesce the lif.
This assures that even if the queues were in an odd state,
the firmware will close up everything cleanly.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 519d544821af..28044240caf2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1625,6 +1625,28 @@ static void ionic_lif_rss_deinit(struct ionic_lif *lif)
 	ionic_lif_rss_config(lif, 0x0, NULL, NULL);
 }
 
+static int ionic_lif_quiesce(struct ionic_lif *lif)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_STATE,
+			.state = IONIC_LIF_QUIESCE,
+		},
+	};
+	int err;
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err) {
+		netdev_err(lif->netdev, "lif quiesce failed %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static void ionic_txrx_disable(struct ionic_lif *lif)
 {
 	unsigned int i;
@@ -1639,6 +1661,8 @@ static void ionic_txrx_disable(struct ionic_lif *lif)
 		for (i = 0; i < lif->nxqs; i++)
 			err = ionic_qcq_disable(lif->rxqcqs[i], (err != -ETIMEDOUT));
 	}
+
+	ionic_lif_quiesce(lif);
 }
 
 static void ionic_txrx_deinit(struct ionic_lif *lif)
-- 
2.17.1

