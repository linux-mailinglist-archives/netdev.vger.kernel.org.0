Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2DE414307
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhIVH6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbhIVH6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:18 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5247C061756;
        Wed, 22 Sep 2021 00:56:48 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t8so4148491wrq.4;
        Wed, 22 Sep 2021 00:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KChZ9vztwXy3+pdU48Vrm1H6vHjqGIR3wlVImXEJQOs=;
        b=BTMIIfAbvIrMcz3bknYFN+9Sei/GzCVXT9apOdAWAESh6I1zJP9J3BdcA7hZnOzQlQ
         ySCmP2yfkGG7DbhUkYiwtR/qx3ZlpYh7bpCZ8m3yD6WfQZNFN+wQCGi9mGSh5JJ8CqBO
         JdohK+ENNQMK4O7ot1eDX7Nv0aC7wbXlBQOCNrXiYha2fgXhPMa+MOVPl4skmv1vIP5B
         3prpbmcVICsbw5WLay0Ywuq1iiMG0vUvHSpaDFtIhmOMyzUYhvwi5WRc8C0U95lAF/oj
         WtR3L7Hoy53K8fp5qZ0fRxOcgXsQG7D3zJAWJKcmhwh2WjC9L7xr32IUr9Bofy3RtCQY
         Iaxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KChZ9vztwXy3+pdU48Vrm1H6vHjqGIR3wlVImXEJQOs=;
        b=ghZD8mbdlQoiLQyXrUJo3aHlL9EK1vm9ol281mIOAVCayZZt3gkXtaMysJTqu3s1LS
         TDFF0g4YfpP5J1VVf+h2Nh7QCfalFkgKEA31ztMGGFQoyGhXOqnWLvKKXgEypZ6aHMO9
         ZEEoNHCWKHw1Wf1BL8g4asFghVRtjK7RTso5bZ7SLD9rzRD58lGGLLqV+HkrY6RdlNIS
         kCaInXdpd455sig1KDDkE/TSFVYcNoem2jf87VIK8Yk9PrEbMATH7ZVrGU8/1OOrHtOq
         TPGGP+yyMWPMU8Y73lSrwan5LHtfqzeei2vM7+FFZJEGpo7jbFSIRSRVp9GoBVlM+3Uf
         1aqw==
X-Gm-Message-State: AOAM531EyFZTZTbmGSpPO9xXIk0YTfqRB7MjGVhvdJt0150Mg4qRf0L7
        aWL/1ProxVTJm/+TBafFPVY=
X-Google-Smtp-Source: ABdhPJzmTVI9YSIbfDFypYjzaRFFOkPN2QHPvPbwOTm7qhliB9v38XQHZr6MmXtSdARqyWfttAUe3g==
X-Received: by 2002:adf:d214:: with SMTP id j20mr40236286wrh.119.1632297407378;
        Wed, 22 Sep 2021 00:56:47 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:46 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 04/13] ice: use the xsk batched rx allocation interface
Date:   Wed, 22 Sep 2021 09:56:04 +0200
Message-Id: <20210922075613.12186-5-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Use the new xsk batched rx allocation interface for the zero-copy data
path. As the array of struct xdp_buff pointers kept by the driver is
really a ring that wraps, the allocation routine is modified to detect
a wrap and in that case call the allocation function twice. The
allocation function cannot deal with wrapped rings, only arrays. As we
now know exactly how many buffers we get and that there is no
wrapping, the allocation function can be simplified even more as all
if-statements in the allocation loop can be removed, improving
performance.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 44 ++++++++++--------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index f4ab5259a56c..7682eaa9a9ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -365,44 +365,38 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 	union ice_32b_rx_flex_desc *rx_desc;
 	u16 ntu = rx_ring->next_to_use;
 	struct xdp_buff **xdp;
-	bool ok = true;
+	u32 nb_buffs, i;
 	dma_addr_t dma;
 
-	if (!count)
-		return true;
-
 	rx_desc = ICE_RX_DESC(rx_ring, ntu);
 	xdp = &rx_ring->xdp_buf[ntu];
 
-	do {
-		*xdp = xsk_buff_alloc(rx_ring->xsk_pool);
-		if (!xdp) {
-			ok = false;
-			break;
-		}
+	nb_buffs = min_t(u16, count, rx_ring->count - ntu);
+	nb_buffs = xsk_buff_alloc_batch(rx_ring->xsk_pool, xdp, nb_buffs);
+	if (!nb_buffs)
+		return false;
 
+	i = nb_buffs;
+	while (i--) {
 		dma = xsk_buff_xdp_get_dma(*xdp);
 		rx_desc->read.pkt_addr = cpu_to_le64(dma);
-		rx_desc->wb.status_error0 = 0;
 
 		rx_desc++;
 		xdp++;
-		ntu++;
-
-		if (unlikely(ntu == rx_ring->count)) {
-			rx_desc = ICE_RX_DESC(rx_ring, 0);
-			xdp = rx_ring->xdp_buf;
-			ntu = 0;
-		}
-	} while (--count);
+	}
 
-	if (rx_ring->next_to_use != ntu) {
-		/* clear the status bits for the next_to_use descriptor */
-		rx_desc->wb.status_error0 = 0;
-		ice_release_rx_desc(rx_ring, ntu);
+	ntu += nb_buffs;
+	if (ntu == rx_ring->count) {
+		rx_desc = ICE_RX_DESC(rx_ring, 0);
+		xdp = rx_ring->xdp_buf;
+		ntu = 0;
 	}
 
-	return ok;
+	/* clear the status bits for the next_to_use descriptor */
+	rx_desc->wb.status_error0 = 0;
+	ice_release_rx_desc(rx_ring, ntu);
+
+	return count == nb_buffs ? true : false;
 }
 
 /**
@@ -545,7 +539,7 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 			break;
 
 		xdp = &rx_ring->xdp_buf[rx_ring->next_to_clean];
-		(*xdp)->data_end = (*xdp)->data + size;
+		xsk_buff_set_size(*xdp, size);
 		xsk_buff_dma_sync_for_cpu(*xdp, rx_ring->xsk_pool);
 
 		xdp_res = ice_run_xdp_zc(rx_ring, *xdp);
-- 
2.29.0

