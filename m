Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DCEC2924
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731840AbfI3Vti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:49:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33972 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731985AbfI3Vtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:49:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id y35so8126830pgl.1
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DcHbVEmro+3Qcgl5wjen57hmHH767H/6x6cNZf4PpNk=;
        b=suwAu+rB4nGCuvyvWHYZCJuWko1z8/RGwrKHtu9AAVhl8/HlhkHBcEU++JuDZwVRzQ
         Xym3L0Vi8FlX6X0gqwFX0I0xxQI5BdYVNs9v9unF9RlQGyGB2s1xpyqtpNpm846q2XDp
         xbUH0JdOp1S+jA5zzjxpW4QP17AcYG2z5aI9R8JASBFv05I23TVWmIsXK72DRVrmD+AZ
         fSjyFcCb69I8L3RTjwyd+Jq+jeEorz6Xi9qdz87V0LfZPoPcyqOl55MxxPItOFi5k3Ml
         Lhn8wbyrrfTvign0kFWqC9UWo7u7aq84uUkZ5dvvP5LN8vE9U44MZM8gP4bYX1pY23Tg
         mvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DcHbVEmro+3Qcgl5wjen57hmHH767H/6x6cNZf4PpNk=;
        b=XvpZ0gvDEs0tLOznVgNWBthmBRZwF7DI5q4lUvnB/6pJjBNkvNRJpsirkjHUfZC/vK
         e7fihpbN48lTcRnh0xDIRjP69BPw262j5Su5rKsEkXEn3Kl5izp+/OBtHDUPxTcf6HGd
         XSRUmbiBMUgVVK6ndXhKTu+I1dNJConsXy81tODfiBAbVbs7sEvbypHWlrFr9SwbDywH
         qOVZjpdQzvz92rdIyfWO8Cfq8NdgKi6Tlnz1XZPrH8DpmTIHfF7ViI0WYdGuSpPLn4IO
         6zJ/7+MWi0tlKA4sKGoaE7poL2N3y1y37/7kay8kmLwM64/wjJbeURH3Vsl1Yu/uDqkp
         HDfQ==
X-Gm-Message-State: APjAAAXFl4ZpBuDPBh0dzckSlD9aE1GEhDXuiSyza8qoGitblC3Ec2zh
        IeRGqSAeoQql60NO3mVc18s6k9jIcN4a2w==
X-Google-Smtp-Source: APXvYqwqmXYwn4oHrkI1rFKgVc+QgxTAHjQOgA5SVUbkYL5p3lHotCI+1YmK+EkA61bItXUwQA2AMQ==
X-Received: by 2002:a17:90a:8d85:: with SMTP id d5mr1541901pjo.45.1569880174690;
        Mon, 30 Sep 2019 14:49:34 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 30sm505746pjk.25.2019.09.30.14.49.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 14:49:34 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 5/5] ionic: add lif_quiesce to wait for queue activity to stop
Date:   Mon, 30 Sep 2019 14:49:20 -0700
Message-Id: <20190930214920.18764-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930214920.18764-1-snelson@pensando.io>
References: <20190930214920.18764-1-snelson@pensando.io>
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

