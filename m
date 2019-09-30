Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36E4C2763
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbfI3Uyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:54:44 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43409 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbfI3Uyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:54:43 -0400
Received: by mail-qt1-f195.google.com with SMTP id c3so18824264qtv.10
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 13:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DcHbVEmro+3Qcgl5wjen57hmHH767H/6x6cNZf4PpNk=;
        b=EjarpTnnZ27ANBDqfgulII004c2nG/lcLePKo8cPOF8ArhNr3HO59NR+6aS4tf0LN0
         yl32DV8TqJuQa0Rheyj4eue2WvI8+QWdZEVmp7ZAGN3z5x7fw9x+SYkOkZcjBvp2FrEP
         bZDoPV7EpxTOQ/CNBv22IKLMfAFO4RDmrgHBTXsNdxKS/g8VukWByfv4hLjJ0JNYi6U2
         FOc2nkWxL8+IdYagCGpfYic6DUP40XNPR+e4HBEnOj0uwzNaWsPra0azS3I49Et8DeVd
         cCdJIm0ixwLH3ki+3tjBIQIW2xT6T+6017yIZ4hBI1R9Z3+2lDuJQLgTV8shW4xveMVV
         rOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DcHbVEmro+3Qcgl5wjen57hmHH767H/6x6cNZf4PpNk=;
        b=DHIJCFjovIzA3UMqZXjyS0MzV/s2Dj/+j9Xe/E1orVZWXzW51bp+eCfB85YZ2thPJF
         905onMZzVsLD+/hJE2kIgdtk1e+fiSgCXNqjgmYOWMviAMg1gv/XiW8OdOBXi6cAHHLa
         vu9yW/3mOjotJEbapWhuNb7py2a1ePYi8PkoBYtt13GptTgR9InfEBI1B6U3/BqhnnNe
         1L9a58r+Xh3BAgEIgcFL8Igx6xos7kXK1Jan0c3pG+moOxHBT53DzccSKkHGlcRjcW6d
         1GqVTw5IHiWaAmNyEOPxxrCddDAhUOHBdQ7ydfcpiKqIiFsj7nrPQP1LlclbCh74fw7/
         rHuQ==
X-Gm-Message-State: APjAAAUoexCNAJwD3SpTAjgZHAjvDjRqmdPRhnTlXaTgq3LCcJ++ix24
        yVmBfyB5JCHJBEDi/mE9q5wGOVz9iMaz5A==
X-Google-Smtp-Source: APXvYqxXWJxwSREY5T9CvJf/foGs9NBEnZHzqHZv4i8GRuUMQK638ZBiMIbgDQLzgrxnHJY2sEEVxw==
X-Received: by 2002:a65:6709:: with SMTP id u9mr26491518pgf.59.1569866539536;
        Mon, 30 Sep 2019 11:02:19 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id u1sm153873pjn.3.2019.09.30.11.02.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 11:02:18 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/5] ionic: add lif_quiesce to wait for queue activity to stop
Date:   Mon, 30 Sep 2019 11:01:58 -0700
Message-Id: <20190930180158.36101-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930180158.36101-1-snelson@pensando.io>
References: <20190930180158.36101-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though we've already turned off the queue activity with
the ionic_qcq_disable(), we need to wait for any device queues
that are processing packets to drain down before we try to
flush our packets and tear down the queues.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 372329389c84..fc4ab73bd608 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -242,6 +242,29 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq)
 	return ionic_adminq_post_wait(lif, &ctx);
 }
 
+static int ionic_lif_quiesce(struct ionic_lif *lif)
+{
+	int err;
+	struct device *dev = lif->ionic->dev;
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.attr = IONIC_LIF_ATTR_STATE,
+			.index = lif->index,
+			.state = IONIC_LIF_DISABLE
+		},
+	};
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err) {
+		dev_err(dev, "failed to quiesce lif, error = %d\n", err);
+		return err;
+	}
+
+	return (0);
+}
+
 static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
@@ -1589,6 +1612,7 @@ int ionic_stop(struct net_device *netdev)
 	netif_tx_disable(netdev);
 
 	ionic_txrx_disable(lif);
+	ionic_lif_quiesce(lif);
 	ionic_txrx_deinit(lif);
 	ionic_txrx_free(lif);
 
-- 
2.17.1

