Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2794F2ED2
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 14:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343922AbiDEJPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 05:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244910AbiDEIwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:52:47 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8CB24957;
        Tue,  5 Apr 2022 01:46:08 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s72so10493531pgc.5;
        Tue, 05 Apr 2022 01:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=gI2J8aSRyTbkNC+IaWdBEDHYbgFItbwMQqiY71TgsO0=;
        b=SXeV6VXwa1z91b8fOCvHHoLPLlQ3hJskEuWhqtf0aQKr5E3Q0lXBt3mFupQI0zpS5d
         4OWCIuXQB8w8xdfWctE+Ns6/44j3Ub4/cXBYFXK5n/v2u7jZoTOeP/FdZX2kE06L7Gwh
         EKqiMqcvRwIaIQg8kKno55Sv+P+bygvL34oKI5EsCPyikSqXot2FX7v48OxpaF4Ld4fm
         9s9dpICMveUrEALBvoQefZs1Dz7yble+qzuH3W7fiK41qLWLjr1nXwXMsvHk7rey5h4i
         bUuIR3sj5fdWTGrCMPcXV2iAcBf59ViFSVqZ3LC0b4NZjiJg9fPt9G2kEfxwqN1mGjpW
         FA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gI2J8aSRyTbkNC+IaWdBEDHYbgFItbwMQqiY71TgsO0=;
        b=cayuDrRLukgSY5wQM1xZOAtir2VpiJZqglK/nkG+KUhGu1q5GQrVNAGJB5+3vc5hsO
         g0jWi1XJBMHvKV5nsrIzG7a2FNdCoTSmEqOWojA5kczOcuCjsQ1/JQtb2Maz1SVgkvjn
         kq/3W9qH6f6kIikpFq9MG0582rSVdOt28TeDQd6bguJElC9f4D5q47bT6VBsMZqWy+LW
         xjvcXGqzws+9OUaaEip/tOCdQxVqqoC094udLBYBGIMcMf+d6ng/4haiUS5Pa4MlozT/
         6x8NLvuMJp0Nq1xehd8C+XpgjNZ+saTE/hNyFzXRb08ZH805x0YDaoiGGVlzaQvT3a3m
         l6sQ==
X-Gm-Message-State: AOAM530boev9CRnKFU23LIzeEo0ggRNRg+MaiFdnkJ+5QkEVQ8Uknk35
        KinVN0Ah67JeliMmQEzYfQI=
X-Google-Smtp-Source: ABdhPJxnQDW29MaOcxBPwt+fM0HcwgENbo6ecsE5BNN8vBnQkO0NtCWVN3wRHr3leZQrVgTlGiHI4w==
X-Received: by 2002:a05:6a00:130e:b0:4f3:9654:266d with SMTP id j14-20020a056a00130e00b004f39654266dmr2388416pfu.59.1649148367492;
        Tue, 05 Apr 2022 01:46:07 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id m7-20020a056a00080700b004fb28fafc4csm15512117pfk.97.2022.04.05.01.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 01:46:06 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        cmclachlan@solarflare.com, bpf@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2] net: sfc: fix using uninitialized xdp tx_queue
Date:   Tue,  5 Apr 2022 08:45:44 +0000
Message-Id: <20220405084544.2763-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases, xdp tx_queue can get used before initialization.
1. interface up/down
2. ring buffer size change

When CPU cores are lower than maximum number of channels of sfc driver,
it creates new channels only for XDP.

When an interface is up or ring buffer size is changed, all channels
are initialized.
But xdp channels are always initialized later.
So, the below scenario is possible.
Packets are received to rx queue of normal channels and it is acted
XDP_TX and tx_queue of xdp channels get used.
But these tx_queues are not initialized yet.
If so, TX DMA or queue error occurs.

In order to avoid this problem.
1. initializes xdp tx_queues earlier than other rx_queue in
efx_start_channels().
2. checks whether tx_queue is initialized or not in efx_xdp_tx_buffers().

Splat looks like:
   sfc 0000:08:00.1 enp8s0f1np1: TX queue 10 spurious TX completion id 250
   sfc 0000:08:00.1 enp8s0f1np1: resetting (RECOVER_OR_ALL)
   sfc 0000:08:00.1 enp8s0f1np1: MC command 0x80 inlen 100 failed rc=-22
   (raw=22) arg=789
   sfc 0000:08:00.1 enp8s0f1np1: has been disabled

Fixes: f28100cb9c96 ("sfc: fix lack of XDP TX queues - error XDP TX failed (-22)")
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - Change Fixes tag
 - Add Acked tag

 drivers/net/ethernet/sfc/efx_channels.c | 2 +-
 drivers/net/ethernet/sfc/tx.c           | 3 +++
 drivers/net/ethernet/sfc/tx_common.c    | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 83e27231fbe6..377df8b7f015 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -1140,7 +1140,7 @@ void efx_start_channels(struct efx_nic *efx)
 	struct efx_rx_queue *rx_queue;
 	struct efx_channel *channel;
 
-	efx_for_each_channel(channel, efx) {
+	efx_for_each_channel_rev(channel, efx) {
 		efx_for_each_channel_tx_queue(tx_queue, channel) {
 			efx_init_tx_queue(tx_queue);
 			atomic_inc(&efx->active_queues);
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index d16e031e95f4..6983799e1c05 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -443,6 +443,9 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	if (unlikely(!tx_queue))
 		return -EINVAL;
 
+	if (!tx_queue->initialised)
+		return -EINVAL;
+
 	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
 		HARD_TX_LOCK(efx->net_dev, tx_queue->core_txq, cpu);
 
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index d530cde2b864..9bc8281b7f5b 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -101,6 +101,8 @@ void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
 	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
 		  "shutting down TX queue %d\n", tx_queue->queue);
 
+	tx_queue->initialised = false;
+
 	if (!tx_queue->buffer)
 		return;
 
-- 
2.17.1

