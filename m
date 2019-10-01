Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4306C2C35
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 05:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732532AbfJADDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 23:03:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44244 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732527AbfJADDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 23:03:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so6853073pfn.11
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 20:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ra25RNhjIRkmQ2witDEK7DYxjD1zYQcWgRZeLnVr1eQ=;
        b=Zkuk59gdlP/pDUuUpdXbgO7z8CDg5uTvxT6n8JrKWcoHv8sECJvwfOuiALzrZylkeI
         Mo4bepLWtSYBr/88tDu+fTeFtxDQXyss4kC2Oqfd3r6cTeuvcSw++f2mmNy8ySEU1S0m
         Xu/x8oUqvanvyTorCeJ13OXtvvof/mpbwl2nkxQUJrMVcQ9ECp97VblTKhi7phmrTRxS
         ALYC6uRqcQUghx5jqyDoVtKaDsuVqITExb4G1taswj753t5ALq+IS5HAk5CWCqXg+PFF
         WFKI+zl5qKhVuThaqvrCeRBVjATydbB8Pg35Cf2YeZCXYsgPtXGL9xvyK9otdCvgOj3w
         nU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ra25RNhjIRkmQ2witDEK7DYxjD1zYQcWgRZeLnVr1eQ=;
        b=kCaGik1VFm43MlIUzcY5u+jSX5yhONU6yz3hIW8KXhmXV0CTYDAYmjOap849LbyVQ0
         CTAAnQoeu787N/E/lzlbGWnkJtBJz+J2MJDIpRvtBne7OzP5mJV+4TeWhmUs3vM3rYCW
         HtQL/b7xrdfvKfpN4kdGnfGzYWmgcnjZtvgV7E0dlosieS6qxJKP7eqyMyOmBqa1zzvF
         CXffn9fvew5jiyktOY1+n6JaRS3Gwq+xjz4JFl2nri4hNARiA+kPJh9vGYy49XE1W5XA
         8+arRK5I1UdWWRmqmbePvWQGY0S3xD/hz2gKsXZBWB2H2CW8UU09yw4fQ1iIvP6OI7GY
         mzMA==
X-Gm-Message-State: APjAAAUZr/agcY1lJ+PNZHbTha+ewCLJif41dI9OS1c+pfnxBkAznDlj
        ifDXvW6BryGVyuUHldxEduaiZZlwIlXcWQ==
X-Google-Smtp-Source: APXvYqy+uoqdrqpyLCjMJ92s3fvRdg3+xzm5FI0fabZ1iUL0gZ34jQ3ksQlEPO5kVTNhZIV9RtpsjQ==
X-Received: by 2002:a63:dc13:: with SMTP id s19mr27443517pgg.272.1569899020265;
        Mon, 30 Sep 2019 20:03:40 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id y17sm14831062pfo.171.2019.09.30.20.03.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 20:03:39 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 5/5] ionic: add lif_quiesce to wait for queue activity to stop
Date:   Mon, 30 Sep 2019 20:03:26 -0700
Message-Id: <20191001030326.29623-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191001030326.29623-1-snelson@pensando.io>
References: <20191001030326.29623-1-snelson@pensando.io>
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
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 372329389c84..559b96ae48f5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -242,6 +242,21 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq)
 	return ionic_adminq_post_wait(lif, &ctx);
 }
 
+static void ionic_lif_quiesce(struct ionic_lif *lif)
+{
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
+	ionic_adminq_post_wait(lif, &ctx);
+}
+
 static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
@@ -1589,6 +1604,7 @@ int ionic_stop(struct net_device *netdev)
 	netif_tx_disable(netdev);
 
 	ionic_txrx_disable(lif);
+	ionic_lif_quiesce(lif);
 	ionic_txrx_deinit(lif);
 	ionic_txrx_free(lif);
 
-- 
2.17.1

