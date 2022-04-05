Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78764F2258
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 07:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiDEFDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 01:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiDEFCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 01:02:50 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A714C39D;
        Mon,  4 Apr 2022 22:00:30 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id i11so9923118plg.12;
        Mon, 04 Apr 2022 22:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=gIpb5pUI3vC5IHa6FCVU8hr3uxezDl4t9B5XDk1p4F4=;
        b=fSrQEFh6rJ0gYIDx2T3em9uTzc/OAm7cLjlGTfQ4pFQNO1wD9lft6wVhipqDLJIF03
         qd7Nf+PWB0nHa8nT1dpABLdpq9tx4kbCXSO56Ix7sS3bqvmO/0JfnyMiRctsl1MqGz8p
         J8UPFnK9Av1GBU0t4EEltPqJfzd6BK3AeAZEQkF+fdwgG5DfdRkhGFpYYRZpCn0Art+S
         nPHKbgjJkjEqJSQrqfaOh+FVBWU2MfvnZ2Baa8k9t/gA3lPqUyKhMXk99zGsTycZMnVH
         kGLz+FfqCKF+VXlFZmFdMX7Yy1yRL7GxumcaGYLxJ+oA1FL87R637a81t4W5wOpLaxY3
         P9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gIpb5pUI3vC5IHa6FCVU8hr3uxezDl4t9B5XDk1p4F4=;
        b=i0mv/fYYfJx7LLaRnPvjAkSp7uL/TubxMCMEqIlcls0l28EQgeCBLCApskBcY1J2m+
         ETLWKvnUcWeMkzyCoM5L/kdu6+1SJGeXWak5H84rvho8gFZ+CTOnLDt2oq4qCU9Qx7xa
         Mcn/sYschLiDOgAjn5f/ttPiCCrqu7eUcQ/PEStgiNkZMCbeF5Lm1ea/sVFYZodrTN2f
         lj7glC6XgbWrDgieztwEj8MX5WY4IyBhNTWqtGxuaU6YpucCOwxsYRpevDGtNMczMwgS
         UYS326wcBPWueaZbtjkGF0Xm0Qcoh9JFtwMIhZmdojvBLd48USPJy7GHGrJj2pL9l8DM
         qtMA==
X-Gm-Message-State: AOAM532kTxYSDU2xGELj3cR3uw4N4tyR9hVHqHPj125zvl3vl+Lwd4bX
        fKZLDYbmpyy2F9OdEo2woZE=
X-Google-Smtp-Source: ABdhPJxQct0FXMeI/WjYFLj6guDUsB4qOzFx4sghJTr+biMe2W/D0BMpf1ldvyMEl+zr9TpELgLKzw==
X-Received: by 2002:a17:902:ef48:b0:156:8ff6:e2cc with SMTP id e8-20020a170902ef4800b001568ff6e2ccmr1755529plx.130.1649134830007;
        Mon, 04 Apr 2022 22:00:30 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id p16-20020a056a000b5000b004faed463907sm14645631pfo.0.2022.04.04.22.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 22:00:29 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        cmclachlan@solarflare.com, bpf@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] net: sfc: fix using uninitialized xdp tx_queue
Date:   Tue,  5 Apr 2022 05:00:19 +0000
Message-Id: <20220405050019.12260-1-ap420073@gmail.com>
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

In order to avoid this problem
1. initializes xdp tx_queues earlier than other rx_queue in
efx_start_channels().
2. checks whether tx_queue is initialized or not in efx_xdp_tx_buffers().

Splat looks like:
   sfc 0000:08:00.1 enp8s0f1np1: TX queue 10 spurious TX completion id 250
   sfc 0000:08:00.1 enp8s0f1np1: resetting (RECOVER_OR_ALL)
   sfc 0000:08:00.1 enp8s0f1np1: MC command 0x80 inlen 100 failed rc=-22
   (raw=22) arg=789
   sfc 0000:08:00.1 enp8s0f1np1: has been disabled

Fixes: dfe44c1f52ee ("sfc: handle XDP_TX outcomes of XDP eBPF programs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
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

