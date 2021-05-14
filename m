Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F80A380FED
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 20:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhENSmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 14:42:14 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:41570 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhENSmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 14:42:13 -0400
Received: by mail-ed1-f54.google.com with SMTP id v5so24657859edc.8;
        Fri, 14 May 2021 11:41:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1j2CjgQxW57TkMOuAnVDHfqnEQcNfSuPJZQGVnmFSJA=;
        b=J8SMDuIRqXr9SC70H4mBfVAZ6k0wG7OdjWzxZbQWdffM5RESayj0lPgPGpPd6P7Gig
         dNqcrduAMDxcFoLamWORRV5y5c04QJ+ws/a3fYz6+qaadamtaP591rf8vVL71KyVuYM4
         q1oK2o8ddyG5CH6fCSMQ3Xs9ZxneQ4gjjE79W6NDMu/Y9h/5GgwRSPkh0XCIoqYMl71k
         5d6Q1tRu61Wkd2XUxGkkMfcl1NXQKoQ+qTAJvoBG+ajK9pxSzGkoqJdjTu2pPYDosASJ
         XI80+PSwrLcaGhSpngz6OdwiTKelh5mVHLZpROjYNZK8ZRdGYFAIWSao+k+j/1z2US2A
         90UA==
X-Gm-Message-State: AOAM533OXL3OrH13PRqCueKGpXuOmZi8rOQIQNmWTgkK78o/m94EjGog
        XoP8Xn9gEKKARpS2palnQA0e8ot6Yr1vUWjZ
X-Google-Smtp-Source: ABdhPJyxTNKn6+GyJPbWrzuE82v4D4fgdRH1Pr1QrTsEjU4XnM0G1aa5z5Rgrt8LmwOzr3dkOMs5Pw==
X-Received: by 2002:a50:9f6b:: with SMTP id b98mr6260005edf.318.1621017659634;
        Fri, 14 May 2021 11:40:59 -0700 (PDT)
Received: from turbo.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id dj17sm5081505edb.7.2021.05.14.11.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 11:40:59 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-stm32@st-md-mailman.stormreply.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next 2/3] igc: use XDP helpers
Date:   Fri, 14 May 2021 20:39:53 +0200
Message-Id: <20210514183954.7129-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514183954.7129-1-mcroce@linux.microsoft.com>
References: <20210514183954.7129-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Make use of the xdp_{init,prepare}_buff() helpers instead of
an open-coded version.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 069471b7ffb0..92c0701e2a36 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2151,12 +2151,9 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		}
 
 		if (!skb) {
-			xdp.data = pktbuf + pkt_offset;
-			xdp.data_end = xdp.data + size;
-			xdp.data_hard_start = pktbuf - igc_rx_offset(rx_ring);
-			xdp_set_data_meta_invalid(&xdp);
-			xdp.frame_sz = truesize;
-			xdp.rxq = &rx_ring->xdp_rxq;
+			xdp_init_buff(&xdp, truesize, &rx_ring->xdp_rxq);
+			xdp_prepare_buff(&xdp, pktbuf - igc_rx_offset(rx_ring),
+					 igc_rx_offset(rx_ring) + pkt_offset, size, false);
 
 			skb = igc_xdp_run_prog(adapter, &xdp);
 		}
-- 
2.31.1

