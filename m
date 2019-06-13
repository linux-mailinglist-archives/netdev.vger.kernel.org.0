Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2705744CA3
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 21:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbfFMTyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 15:54:18 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:19912 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfFMTyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 15:54:18 -0400
Received: from localhost.localdomain ([92.148.209.44])
        by mwinf5d62 with ME
        id QKuD2000j0y1A8U03KuEMK; Thu, 13 Jun 2019 21:54:16 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 13 Jun 2019 21:54:16 +0200
X-ME-IP: 92.148.209.44
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     aviad.krawczyk@huawei.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next] hinic: Use devm_kasprintf instead of hard coding it
Date:   Thu, 13 Jun 2019 21:54:12 +0200
Message-Id: <20190613195412.1702-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'devm_kasprintf' is less verbose than:
   snprintf(NULL, 0, ...);
   devm_kzalloc(...);
   sprintf
so use it instead.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/huawei/hinic/hinic_rx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 9b4082557ad5..95b09fd110d3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -493,7 +493,7 @@ int hinic_init_rxq(struct hinic_rxq *rxq, struct hinic_rq *rq,
 		   struct net_device *netdev)
 {
 	struct hinic_qp *qp = container_of(rq, struct hinic_qp, rq);
-	int err, pkts, irqname_len;
+	int err, pkts;
 
 	rxq->netdev = netdev;
 	rxq->rq = rq;
@@ -502,13 +502,11 @@ int hinic_init_rxq(struct hinic_rxq *rxq, struct hinic_rq *rq,
 
 	rxq_stats_init(rxq);
 
-	irqname_len = snprintf(NULL, 0, "hinic_rxq%d", qp->q_id) + 1;
-	rxq->irq_name = devm_kzalloc(&netdev->dev, irqname_len, GFP_KERNEL);
+	rxq->irq_name = devm_kasprintf(&netdev->dev, GFP_KERNEL,
+				       "hinic_rxq%d", qp->q_id);
 	if (!rxq->irq_name)
 		return -ENOMEM;
 
-	sprintf(rxq->irq_name, "hinic_rxq%d", qp->q_id);
-
 	pkts = rx_alloc_pkts(rxq);
 	if (!pkts) {
 		err = -ENOMEM;
-- 
2.20.1

