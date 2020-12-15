Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC712DA591
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 02:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgLOBaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 20:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgLOBaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 20:30:09 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071AFC0617B0
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 17:29:16 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id i7so2448774pgc.8
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 17:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GxBZCxQsCUdkzL0jmb2W+BSX0fHFGApzy9UYWSaFsfA=;
        b=wjrGi6EXmsLALW5JV6tz8QuKrCuTGVWBMU/hzrdlhG63jR18/Vd8fRj8J7KZKAjyuv
         mnRv+LieMrPvP4LCHvTZpHJY4VLWuw2XrgN8Q2N/02Dxdw8tM3aLb+5Qk7dFtNMt62Vo
         TAkCngSA/CKFArV1JIisQLFUReL0gdWL9DXlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GxBZCxQsCUdkzL0jmb2W+BSX0fHFGApzy9UYWSaFsfA=;
        b=CqnenkkXYbcdMMfMf5inw2GukJhirg8qbCGUhUP/YMdgOgiF7VjNHnrpjuYxTW8dOe
         GO0SSrsJnrAV7huXuBk6TZR6af9IlX1AejzNEd9+UCIQ6eE7PBY3gT8ttsNciCxbpPH4
         vyv1H2zxulcehoenWWOV3IiH1D7j8KZJt0L2tO9/BO+rmcbnWSi2DdzJEqp0WUrPeg/5
         ucapdT13QZEyJuQYcDcGUsoWI/XzmqM82iQUe8w7Duun4DUYncJPfQaseAE9UZVqkCdx
         Ny6ym3gQe5Wnm/dhbo5YkiFEQTu/qsVgsSgHrf0zLbjbgiTxMvgMLUOPlxihJUFjPskK
         UUog==
X-Gm-Message-State: AOAM532Ux3fGizmqbqbreT+1jhXsDGpdg5rPt1YWDhh8hkte7iqm7eCm
        u0oV7qbtcvS6nGKlTA8rKaglhYlR8Qiv2afuXJk=
X-Google-Smtp-Source: ABdhPJx5mCCcBAJLDU2y8yQ8N0q0MRiR8OrRtxCB1D6VDzQCvUrT7XHyDru0fzg43laSJ3o4t8s9hA==
X-Received: by 2002:aa7:8b15:0:b029:196:59ad:ab93 with SMTP id f21-20020aa78b150000b029019659adab93mr25916535pfd.16.1607995755061;
        Mon, 14 Dec 2020 17:29:15 -0800 (PST)
Received: from localhost ([2604:5500:c29c:d401:f5da:c0a7:bcba:f83c])
        by smtp.gmail.com with ESMTPSA id a29sm21100906pfr.73.2020.12.14.17.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 17:29:13 -0800 (PST)
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
Date:   Mon, 14 Dec 2020 17:29:06 -0800
Message-Id: <20201215012907.3062-1-ivan@cloudflare.com>
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

