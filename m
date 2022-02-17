Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490A04BAC37
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 23:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343758AbiBQWDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 17:03:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbiBQWDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 17:03:16 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CA5403FC
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:03:01 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x11so5612413pll.10
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jQJ7pFSm21WercEn0AYeLf5norbKGaKCEfK7COBn1I8=;
        b=gU9gh+eqM0ufzbMZgLJBU5+wIO3m4m2422Haz3qSQLfsI6FSJ+Pmi5s/JTZa1aOoqk
         CAcEOp+NILU1S3csecgOLmcUhRr6wG68wNxZp9f+/59pvPIZZqw5+1jDS/+p37XA5gL+
         OyZbZFZ/AbzQn3EFT3IqpQFd3P+9EX5rhQE4Gl32j7QDihmnIL6ywTR846FlbmZNTRvk
         doeU8S/AzmUX5SDFERVxrPnS7DhHrE3i518NhVWupKotUX3XDkbxQM+rx5ierIZRIa5g
         WJ2KGJsnKMJA8YEM/jhH1NmS/u914XjDvn0O25THcE/4nkF8bUkmgZ/l0IfTQCSBdO33
         nI2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jQJ7pFSm21WercEn0AYeLf5norbKGaKCEfK7COBn1I8=;
        b=ucuPZQWqYbqX3fdwvRRVW+fG2D40xeMCMObR8EtFwbywoQPk/hrmLLDbbTpipSU6XH
         jvuyk4OR2bAMlV01HfDvoNSCkk5tOgWOZqi29P6NiyxscS5wHdY42PkLLjaV7F6WgabI
         45CrPfTNmPZUtCEKfnCUrEh2Gqls841OaOXPpbDoRRsnrbxhac/Xl0rGiKxbuzudXS3T
         CL5icA7OxOaz/sSsTWambUDwnhHN83AYueQ6FQFpmQTw4Tw6/f4MOemhsMYqVhBMjeIK
         49pX7RW+Zt5fvG0DI5x196OV3cFUpVSbDo6GwwfFfDlklOJPtNwDZolH80oYs+K9Pty7
         Gavg==
X-Gm-Message-State: AOAM5304Wm4TyXrM2pdk/5+tm6+hfc193Ud1wBiznCQTTsXRdZv94v7H
        bHGm59mfTzdQ/crFqO6TXYmoXC0NlYKXMA==
X-Google-Smtp-Source: ABdhPJya8DrrVQ7/tbbki0NE/DNhlpTJtNtNoAUQFgYI2aflK7etkTZ+wrIAMxj/Bs4oLv/+xQzoNQ==
X-Received: by 2002:a17:902:d2c9:b0:14d:c8dd:7716 with SMTP id n9-20020a170902d2c900b0014dc8dd7716mr4692316plc.138.1645135381397;
        Thu, 17 Feb 2022 14:03:01 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 16sm516119pfm.200.2022.02.17.14.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 14:03:01 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Brett Creeley <brett@pensando.io>
Subject: [PATCH net-next 2/4] ionic: Use vzalloc for large per-queue related buffers
Date:   Thu, 17 Feb 2022 14:02:50 -0800
Message-Id: <20220217220252.52293-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220217220252.52293-1-snelson@pensando.io>
References: <20220217220252.52293-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett@pensando.io>

Use vzalloc for per-queue info structs that don't need any
DMA mapping to help relieve memory pressure found when used
in our limited SOC environment.

Signed-off-by: Brett Creeley <brett@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 542e395fb037..4101529c300b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -393,11 +393,11 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	ionic_qcq_intr_free(lif, qcq);
 
 	if (qcq->cq.info) {
-		devm_kfree(dev, qcq->cq.info);
+		vfree(qcq->cq.info);
 		qcq->cq.info = NULL;
 	}
 	if (qcq->q.info) {
-		devm_kfree(dev, qcq->q.info);
+		vfree(qcq->q.info);
 		qcq->q.info = NULL;
 	}
 }
@@ -528,8 +528,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	new->q.dev = dev;
 	new->flags = flags;
 
-	new->q.info = devm_kcalloc(dev, num_descs, sizeof(*new->q.info),
-				   GFP_KERNEL);
+	new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
 	if (!new->q.info) {
 		netdev_err(lif->netdev, "Cannot allocate queue info\n");
 		err = -ENOMEM;
@@ -550,8 +549,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	if (err)
 		goto err_out;
 
-	new->cq.info = devm_kcalloc(dev, num_descs, sizeof(*new->cq.info),
-				    GFP_KERNEL);
+	new->cq.info = vzalloc(num_descs * sizeof(*new->cq.info));
 	if (!new->cq.info) {
 		netdev_err(lif->netdev, "Cannot allocate completion queue info\n");
 		err = -ENOMEM;
@@ -640,14 +638,14 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 err_out_free_q:
 	dma_free_coherent(dev, new->q_size, new->q_base, new->q_base_pa);
 err_out_free_cq_info:
-	devm_kfree(dev, new->cq.info);
+	vfree(new->cq.info);
 err_out_free_irq:
 	if (flags & IONIC_QCQ_F_INTR) {
 		devm_free_irq(dev, new->intr.vector, &new->napi);
 		ionic_intr_free(lif->ionic, new->intr.index);
 	}
 err_out_free_q_info:
-	devm_kfree(dev, new->q.info);
+	vfree(new->q.info);
 err_out_free_qcq:
 	devm_kfree(dev, new);
 err_out:
-- 
2.17.1

