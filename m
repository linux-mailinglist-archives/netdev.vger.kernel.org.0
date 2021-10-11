Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695B742938D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243274AbhJKPjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243270AbhJKPjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:39:09 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819B3C061764
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:37:03 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 15-20020a630d4f000000b00287c5b3f77bso7115114pgn.11
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hdWeng6qPmeYcD52MAWN7GI/aHqi0RCXV2CYrCVhuf8=;
        b=KcRlt8vUAygaa4AFu03/QWKBYJaWAzOVOoFOSE/1xWfSLf8gXWRTNjKmagqgTNNtTn
         c8YOWS9hBUwuSnE0ejno++EJLYLRFcXuU8tuDG3D+8LbjXSPxN3EIwCt5YnMuHDYqR0e
         n31bNmu02nBLYEzGXzTCxnG5nmnoUKB0Qi4FpHKm0RL5wgcTp7uVPLxeEZMO9N777hfg
         MaRapawtMnTWrG2fkX8U8DJzWUIIcw14YBmxpA+SqHoisYiDZp9R4fOD9uOOPjPGj7R2
         /k0xyE71Cm3GE098cf9HNMQE25+dZjITRpRvy5LbKSdcdf8HhR8YISvLSvZhw69Bw68g
         6owQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hdWeng6qPmeYcD52MAWN7GI/aHqi0RCXV2CYrCVhuf8=;
        b=ufe+9opcZ3MqQYfBtzinEH5OI4wdcv519zp5P0T/Cma3ULEMHgug2A0XdRtYhbzpvF
         K5mll7ROdWK2AApWUCjhE3aCYZb0EQVIz2KXANQE1kikSlXFE6Zkseb7VQHeA/qSF8UG
         U8d23s0w9tzZueU2fDtKAp6z8wObDDxbErGcXAcYgGBZht87mtsBD/gm4khfpuCVgcoG
         MhwejEAeaTcEUywI/MyQnIbbTS/i2bUhGsaIROAfuo8SfoBJe3cYoGusNqGVFdYMbnYv
         eSGCSxHwmcX2JNuLclr3vbWUuN/Vu5M10HMYlMCy0OTlmPmOXOoBo1su2kprHYKuleb/
         mmUA==
X-Gm-Message-State: AOAM533owLQcEv28WKNqUfaQBJqOyW+XywBDXmZWnz0FBd9ElHKVBeWb
        3MdsFVF5DpyG3ycUI/guqGe9pcGAeP+VIvePCvV7jrz71avauouI5rIL5jP3eiZWYcsXBOpb5CO
        LZuG/OiHdEQuPFqcH/FwRUZPleI9MdvlQchUQkWQSSI+UrTBbetcB0iwEhY4t2XYTcak=
X-Google-Smtp-Source: ABdhPJxz6eytCy0lzKtp6C2KgvzJzx29bLahcyWT3vQL3WdWlZeWAm1iZ1zhcYj8gW7is0JxyFo5TXLQeTnujg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:94b6:8af3:6cef:e277])
 (user=jeroendb job=sendgmr) by 2002:a62:1683:0:b0:3f3:814f:4367 with SMTP id
 125-20020a621683000000b003f3814f4367mr26489505pfw.68.1633966622905; Mon, 11
 Oct 2021 08:37:02 -0700 (PDT)
Date:   Mon, 11 Oct 2021 08:36:48 -0700
In-Reply-To: <20211011153650.1982904-1-jeroendb@google.com>
Message-Id: <20211011153650.1982904-6-jeroendb@google.com>
Mime-Version: 1.0
References: <20211011153650.1982904-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH net-next v2 5/7] gve: Add netif_set_xps_queue call
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Configure XPS when adding tx queues to the notification blocks.

Fixes: dbdaa67540512 ("gve: Move some static functions to a common file")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_utils.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
index 93f3dcbeeea9..45ff7a9ab5f9 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.c
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -18,12 +18,16 @@ void gve_tx_remove_from_block(struct gve_priv *priv, int queue_idx)
 
 void gve_tx_add_to_block(struct gve_priv *priv, int queue_idx)
 {
+	unsigned int active_cpus = min_t(int, priv->num_ntfy_blks / 2,
+					 num_online_cpus());
 	int ntfy_idx = gve_tx_idx_to_ntfy(priv, queue_idx);
 	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 	struct gve_tx_ring *tx = &priv->tx[queue_idx];
 
 	block->tx = tx;
 	tx->ntfy_id = ntfy_idx;
+	netif_set_xps_queue(priv->dev, get_cpu_mask(ntfy_idx % active_cpus),
+			    queue_idx);
 }
 
 void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
-- 
2.33.0.882.g93a45727a2-goog

v2: Unchanged
