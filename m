Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0F02FDF67
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731791AbhATXta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388238AbhATVdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 16:33:17 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F775C061387
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 13:28:03 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id j12so8181488pfj.12
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 13:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GxBZCxQsCUdkzL0jmb2W+BSX0fHFGApzy9UYWSaFsfA=;
        b=OhlY4GugbFiYhJiu50/CtP/Z4AhcGkhphYKSdJZ2/86gZKj5DgbP0xh8gPW72Hu1A6
         DdtuijJY97h56PMwDPtGJzrnccfMPqlK/eP0gdY6cZdZZMn4B9DGYTUZorFHmJ1+G8Xr
         NL/TlrWm7blrSkHJaT1S9y0qoscP5XVa4ICtQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GxBZCxQsCUdkzL0jmb2W+BSX0fHFGApzy9UYWSaFsfA=;
        b=pP4JGcIAj+vl6mWhue6FvuPXtRnnJPUItULVhgKNoj+qEndkev13yz/GsptwQPkcSh
         2uFe1YfS21jQtS2Jewa6C65iH8ynATFl3+qXZ5UbPS+J3c4vrOG1R0oJ21IrvmNbvYMJ
         E7NdN6Eks3uYSp7b8ct0Fs6E4QM/PeKSlB1YOYl5SJ/b2uwvOkUODiZwU7g/KYu9iKOi
         QSDhLC9J27TFgK5kLWeyUqN4pZJ+FMKbGlUPm5JADp40/Q8ZoZ94LEYyKYf+PIJDc5+I
         Zz4sMQSJSd/0PMT+fM3aKfSKqlWeoaAlWQaqnoYlXoE26j5EnvIVRWX2N84CEvHmlM7G
         RjBA==
X-Gm-Message-State: AOAM5303Mqh0hbrw0F43cOIPUMll/EQlzYvvggskZMN7DPE9jDTknj9j
        xpk/drez0pr8z0Qe3ZxGC4mcNG0MwiTEcMhO
X-Google-Smtp-Source: ABdhPJxb7pqkpkXuCPIl0IM+TI3xg276y5qgR0X0JvSQHkz1P/VfETOx1bM+4MTqcRozXgRQX2iOiA==
X-Received: by 2002:a63:f255:: with SMTP id d21mr4170608pgk.149.1611178082371;
        Wed, 20 Jan 2021 13:28:02 -0800 (PST)
Received: from localhost ([2604:5500:c29c:d401:f404:1a29:5dd:89c3])
        by smtp.gmail.com with ESMTPSA id 14sm2974952pfi.131.2021.01.20.13.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 13:28:01 -0800 (PST)
From:   Ivan Babrou <ivan@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Ivan Babrou <ivan@cloudflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next] sfc: reduce the number of requested xdp ev queues
Date:   Wed, 20 Jan 2021 13:27:59 -0800
Message-Id: <20210120212759.81548-1-ivan@cloudflare.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this change the driver tries to allocate too many queues,
breaching the number of available msi-x interrupts on machines
with many logical cpus and default adapter settings:

Insufficient resources for 12 XDP event queues (24 other channels, max 32)

Which in turn triggers EINVAL on XDP processing:

sfc 0000:86:00.0 ext0: XDP TX failed (-22)

Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index a4a626e9cd9a..1bfeee283ea9 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -17,6 +17,7 @@
 #include "rx_common.h"
 #include "nic.h"
 #include "sriov.h"
+#include "workarounds.h"
 
 /* This is the first interrupt mode to try out of:
  * 0 => MSI-X
@@ -137,6 +138,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 {
 	unsigned int n_channels = parallelism;
 	int vec_count;
+	int tx_per_ev;
 	int n_xdp_tx;
 	int n_xdp_ev;
 
@@ -149,9 +151,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	 * multiple tx queues, assuming tx and ev queues are both
 	 * maximum size.
 	 */
-
+	tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
 	n_xdp_tx = num_possible_cpus();
-	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
+	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
 
 	vec_count = pci_msix_vec_count(efx->pci_dev);
 	if (vec_count < 0)
-- 
2.29.2

