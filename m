Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAC618C54D
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgCTCcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:32:08 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37925 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCTCcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:32:06 -0400
Received: by mail-pl1-f193.google.com with SMTP id w3so1886083plz.5
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vfvWXeMPkJuLw370uHqvltpeOedgdDnSQPEFYPF8YTE=;
        b=YdPEg5tAgESuy1g6aMJWE+BhZD5xH+Hdi+WJETswCIjDrKhJRvP3yxsU4cSbHbHXOZ
         XaJU70nLgXOJs9HcOO6SWnW74yUSN8/8abbP4FiRRaoy18sS0K4/yRsiZnS7ovfk9APx
         yasS+aaleILTknCs5XjeCxs2KcYVSk9G8EcVsuE+SN+pnDnGeSXCTAmwp6Zd8AdrtGRG
         QRHaTo6fy3YwJ9lJ1BB1OMdPQGTPH8lxYSyJDTVkb46OAOfZpzXXRiM1YWkkxeWqAOPA
         6cTG7zECbfMeBNChWBZSvEfms2gU5hmJwwGrbXTb4Do7lEjLd+f4HB8GpGgsZkWMTw47
         seFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vfvWXeMPkJuLw370uHqvltpeOedgdDnSQPEFYPF8YTE=;
        b=hwZM7ght+IKVfKFwxirTwm89m+ELHg0wYYs+tBoO9IHw84KZ5ecaPDslfdaBC3zqqB
         80+kWWnv6he8Iyz4BeH9uYNfoiIEmOqjN/CWf0IUDxRpOXYQm+VV7GbS80+1J02JvTX4
         2bW3YFtlYeAEPDLqNRnb5z9DJbHwwr8JZDUbHPldQc3AypUi4UcoSo2cqXjHc/nAPhiB
         T/LUHMcck6wBQ4oU/Ki8g0zSvMxJiipLo9Fvrhjt1Cf7xdXIpV7gmCkhVjpcBLgWPqhS
         EqHBEGUHWsmtf8rQFQqFh9W25RsSq/qgNuPeMRC+G9FsSrEw98D4RkM4kK6iDgt9Txhg
         x8pA==
X-Gm-Message-State: ANhLgQ0o44vewVzABQO8hFpTN/qap9x0+5qkDbdsMHiOTl65txF98ZGP
        CJFKQQ6NYlqlKpsHGq0zl3NuDH6UuH0=
X-Google-Smtp-Source: ADFU+vsf77F+KlFlLxHXY1KGkNnKxKE8Ts2OLgicPgDjjjJsqErFLaDH65W+gbTNOgFUUrlhAmy0Qg==
X-Received: by 2002:a17:902:123:: with SMTP id 32mr6549862plb.38.1584671524929;
        Thu, 19 Mar 2020 19:32:04 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i124sm3606485pfg.14.2020.03.19.19.32.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2020 19:32:04 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/6] ionic: clean irq affinity on queue deinit
Date:   Thu, 19 Mar 2020 19:31:52 -0700
Message-Id: <20200320023153.48655-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320023153.48655-1-snelson@pensando.io>
References: <20200320023153.48655-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a little more cleanup when tearing down the queues.

Fixes: 1d062b7b6f64 ("ionic: Add basic adminq support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index ea44f510cb76..490f79c82bf1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -275,8 +275,10 @@ static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_SET);
+		irq_set_affinity_hint(qcq->intr.vector, NULL);
 		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
 		netif_napi_del(&qcq->napi);
+		qcq->intr.vector = 0;
 	}
 
 	qcq->flags &= ~IONIC_QCQ_F_INITED;
-- 
2.17.1

