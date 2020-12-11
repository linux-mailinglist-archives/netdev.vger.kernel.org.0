Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0AB2D7866
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436509AbgLKO6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406399AbgLKO6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 09:58:10 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4CDC0613D3;
        Fri, 11 Dec 2020 06:57:30 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id x24so1441364pgf.0;
        Fri, 11 Dec 2020 06:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QBp1qTybeH98RpRF+PA2xVajeq4l+q8xrL0O38yJ++k=;
        b=buwXBmHERsmpLFrozn8Izd7nIUr+sMxVjJUjZ1BRixxJGWxVq/KVZS3G2CAAr/rjMQ
         Y6xhJKCp2E2JeRrCXVJvoKGsf+UchTw0Q0469KnIHHvOteRXjURiUMgf9UQA0DoBMvGw
         s1KGCeqnaGk4suL0J9cGYF9AXRKqu+i8Ztyvz8gpvHzxmQRx3Z106I26DGbMmGupSDmK
         Q8lEMw7cmUbTAv055xFBihr3S4ttoGoslaRQje2fqp7rrG79p/hrjkARiwkJRpAADlXd
         N9Iv547IK/8OD2yn0q/pXp8CQuApAVKUb58X9MM3Ui5x0kBcLskQoVviz1zdjiuqFSmm
         1bFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QBp1qTybeH98RpRF+PA2xVajeq4l+q8xrL0O38yJ++k=;
        b=QbjmS8QbEeYCzFj2GFxHI9IQSbAFV6aT0U/JR8Tg0xhq5x2jJOFy/k+fb4KkpnFGnv
         e6F41T2xd2kOMhEp9P/5fewIcUlBOhteesIIIaq7bXf7uGDTavyKvwbMzWj+nMxW/PxB
         Sqzyr42EieNi4BNzmKI7gWJ/ovVhyztor7Al2ehpOey7z0CoPYCt5V01xzILpwNSH6T/
         BMJp3gvaGMcbStdl8w3umaBjZkPnOnNbXuwSsoBBavgplf2A264eCXsHhCv3DFs4lXsU
         6TJV6ss/u+W5LAh6eKVsJJn0V7W9g4bOXDTy6+KS0WwLlBqE4ziJY/uiwJLV8ncO2J9L
         lCCA==
X-Gm-Message-State: AOAM532psJrL6oro0dy2x0zk5T2BlI05djGzvUY1MIAedwTBG2uspoSB
        pRsyi4axh2WFhzSm7wtwzs9qBs4VxVQVFqhP
X-Google-Smtp-Source: ABdhPJyIgRqePZTspps6rp7bR77VU4ydPAxuVrWUzPlmn86AfcT4yk5A6eYQ4Bl7hgfQ24XTJcfoJQ==
X-Received: by 2002:a63:d45:: with SMTP id 5mr11992116pgn.424.1607698650349;
        Fri, 11 Dec 2020 06:57:30 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id k23sm10583085pfk.50.2020.12.11.06.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:57:29 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com
Subject: [PATCH net 1/2] ice, xsk: clear the status bits for the next_to_use descriptor
Date:   Fri, 11 Dec 2020 15:57:11 +0100
Message-Id: <20201211145712.72957-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211145712.72957-1-bjorn.topel@gmail.com>
References: <20201211145712.72957-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

On the Rx side, the next_to_use index points to the next item in the
HW ring to be refilled/allocated, and next_to_clean points to the next
item to potentially be processed.

When the HW Rx ring is fully refilled, i.e. no packets has been
processed, the next_to_use will be next_to_clean - 1. When the ring is
fully processed next_to_clean will be equal to next_to_use. The latter
case is where a bug is triggered.

If the next_to_use bits are not cleared, and the "fully processed"
state is entered, a stale descriptor can be processed.

The skb-path correctly clear the status bit for the next_to_use
descriptor, but the AF_XDP zero-copy path did not do that.

This change adds the status bits clearing of the next_to_use
descriptor.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 797886524054..98101a8e2952 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -446,8 +446,11 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 		}
 	} while (--count);
 
-	if (rx_ring->next_to_use != ntu)
+	if (rx_ring->next_to_use != ntu) {
+		/* clear the status bits for the next_to_use descriptor */
+		rx_desc->wb.status_error0 = 0;
 		ice_release_rx_desc(rx_ring, ntu);
+	}
 
 	return ret;
 }
-- 
2.27.0

