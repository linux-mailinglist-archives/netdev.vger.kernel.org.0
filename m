Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C60D362A39
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244655AbhDPVYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344359AbhDPVYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:24:17 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAC9C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:50 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id j32so5260928pgm.6
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XKvE4DWjeCShfQALBHh7dPy8UVszUBAktwTlqpJ1SuA=;
        b=RTh3dyjdNkg2l3qy+UqXDbVeCrbuHkUiczFfgCK3MlfzRA+UM+OPsnupQ6evvAMhQC
         /KGMEx7IpjhDG77/d3KJftoNiBQEYiQ7Bn3ULoed99jrPwlxHP9a+AyNDCbrGPM5HFJF
         Yw3y2kOfplHB62qZA4av4+lAGN3GLufjIJbT6ZfxTXoQnBoeh43asztPTnMVUvkdCdjx
         V+Flp1UdAA6HtBFaKTdfbJ50glzi7OqgwSwXksqkvnE8lNgVhVZwAPVpW9BbRm6UlTK2
         CFc3wI3M6f8jd/qN4GVoPxBwzKTEG38gO5D1onAJGt9ovut7k2DjUntaFQG7OHQ0pUCe
         uHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XKvE4DWjeCShfQALBHh7dPy8UVszUBAktwTlqpJ1SuA=;
        b=O12EiHd88GUuUNBuSIuUP5bq9Li1Lm5Qlg3cgrU95yVVvUqFODwWv71IJtd0PxZhU0
         LjeMwwoyzJE6QAaOE1wDuz9hANOpBIn5ISwEiZkxI4s9B6hnnsNrYb7C73A3KHyTdXan
         rYof/gqTk4wL7Ju4uVxJfT1+qYZxKDFqHmHoiCvutn67Awzw/8nCMxzEbjAG+LSzStQm
         wLzQlsDVFzZicbRRUGfXNfMFOxxn369DvUGMn7z7D7evhd0bwZl7k+5bhtHWwA4xKQCn
         xouPaejqLCsC2VwU4zctP+xcwJea9vgTwsHoXvmcK12rfu/L9OyQLID1FyDe3YrT7Pa4
         LDwg==
X-Gm-Message-State: AOAM532Qc6lh6wAEIjnr+NdcvgwBQp+NU3e6CrREee1Qv5mT7gTSO8gh
        Sf1MRf1tnisewRX5x5qr9ziOFm9nVpWTJg==
X-Google-Smtp-Source: ABdhPJzVJ8QZZdbz/QVNSTYcuDPABiYfYCmYUH1UI/9mMjwkeGKq7mu8SCbPRApPMGJR46DKNwJs2A==
X-Received: by 2002:a65:6201:: with SMTP id d1mr922931pgv.147.1618608230538;
        Fri, 16 Apr 2021 14:23:50 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:23:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 09/10] net: enetc: fix buffer leaks with XDP_TX enqueue rejections
Date:   Sat, 17 Apr 2021 00:22:24 +0300
Message-Id: <20210416212225.3576792-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
References: <20210416212225.3576792-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

If the TX ring is congested, enetc_xdp_tx() returns false for the
current XDP frame (represented as an array of software BDs).

This array of software TX BDs is constructed in enetc_rx_swbd_to_xdp_tx_swbd
from software BDs freshly cleaned from the RX ring. The issue is that we
scrub the RX software BDs too soon, more precisely before we know that
we can enqueue the TX BDs successfully into the TX ring.

If we can't enqueue them (and enetc_xdp_tx returns false), we call
enetc_xdp_drop which attempts to recycle the buffers held by the RX
software BDs. But because we scrubbed those RX BDs already, two things
happen:

(a) we leak their memory
(b) we populate the RX software BD ring with an all-zero rx_swbd
    structure, which makes the buffer refill path allocate more memory.

enetc_refill_rx_ring
-> if (unlikely(!rx_swbd->page))
   -> enetc_new_page

That is a recipe for fast OOM.

Fixes: 7ed2bc80074e ("net: enetc: add support for XDP_TX")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 0b84d4a74889..f0ba612d5ce3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1175,9 +1175,7 @@ static void enetc_build_xdp_buff(struct enetc_bdr *rx_ring, u32 bd_status,
 }
 
 /* Convert RX buffer descriptors to TX buffer descriptors. These will be
- * recycled back into the RX ring in enetc_clean_tx_ring. We need to scrub the
- * RX software BDs because the ownership of the buffer no longer belongs to the
- * RX ring, so enetc_refill_rx_ring may not reuse rx_swbd->page.
+ * recycled back into the RX ring in enetc_clean_tx_ring.
  */
 static int enetc_rx_swbd_to_xdp_tx_swbd(struct enetc_tx_swbd *xdp_tx_arr,
 					struct enetc_bdr *rx_ring,
@@ -1199,7 +1197,6 @@ static int enetc_rx_swbd_to_xdp_tx_swbd(struct enetc_tx_swbd *xdp_tx_arr,
 		tx_swbd->is_dma_page = true;
 		tx_swbd->is_xdp_tx = true;
 		tx_swbd->is_eof = false;
-		memset(rx_swbd, 0, sizeof(*rx_swbd));
 	}
 
 	/* We rely on caller providing an rx_ring_last > rx_ring_first */
@@ -1317,6 +1314,17 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				tx_ring->stats.xdp_tx += xdp_tx_bd_cnt;
 				rx_ring->xdp.xdp_tx_in_flight += xdp_tx_bd_cnt;
 				xdp_tx_frm_cnt++;
+				/* The XDP_TX enqueue was successful, so we
+				 * need to scrub the RX software BDs because
+				 * the ownership of the buffers no longer
+				 * belongs to the RX ring, and we must prevent
+				 * enetc_refill_rx_ring() from reusing
+				 * rx_swbd->page.
+				 */
+				while (orig_i != i) {
+					rx_ring->rx_swbd[orig_i].page = NULL;
+					enetc_bdr_idx_inc(rx_ring, &orig_i);
+				}
 			}
 			break;
 		case XDP_REDIRECT:
-- 
2.25.1

