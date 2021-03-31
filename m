Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EBA3507CE
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhCaUJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhCaUJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:09:15 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6C9C061574;
        Wed, 31 Mar 2021 13:09:15 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id bx7so23721818edb.12;
        Wed, 31 Mar 2021 13:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W0697NyRfBd+2tsOVjmE+TGl5jywtMAxVJAPw/5s8KE=;
        b=ROlM/TZAyLqZCleOCIaJOVM6L540QCkUdDobk2S9lCbtAcRj4tqcvikObkr8Ht2DJ7
         GRKfiZyEeBHSnW3IucJJsFyEe0k/knYGTb5HCqwsEGSDsG0pAUVd0wsK+xP6sQ74ixAl
         lEMHpYHd0G3aNdNVJeTxhUMgKmvDgRTEIEDot4hnzol9oFz3yLLVj83p+csV0/5i7P9C
         VaLvZin228TI62l/6ruGgawTlGfe4fTBpzfYjM86r1McD9BOMiO2wApH7qktf9izAJRx
         Oxw+UuWl3+2TTH64K2h+SOCj49k0fgTZVlk7ixwoXHg7jj+FlWJK6GgsQ6saozXcoROq
         MENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0697NyRfBd+2tsOVjmE+TGl5jywtMAxVJAPw/5s8KE=;
        b=o3shHpoiJNP9MCS6FnzcMq0Gu7SG06h+2yoNYYqSJfI6u9fdTGxhITUkrkP1uy4JGj
         SNi0hhRVLddgw7jhUMQ8O5D6/kE0x5hasfGMa91/sW6WTvAAuB0r/zzNV3EnsNq0f1+5
         L4KHFfVh4vIgm8qbCPSmWKao3lciM2yJvnCEe5H9W4h6JsAG60DeZG+Z/lbK4D9F5GSu
         cQh2rWiocycLwjd+VS+584Su9nLm4HkllgSmUQnidzI/DK0dmr7Aq5vUoB1I7gg0RfdI
         3Mv7phoMXE+tuSVgmPHZyVIXawBloY4/DV8Sa4txGauEnmiXbeD5otLTiMe+H42Q5ks6
         jP6w==
X-Gm-Message-State: AOAM530b1qBo6Np1pVpoMkG9pJQ9lJ3i74vevVQb/F2ySbpYKI7LoNxi
        M7qFiFK/17PfpUrV0eiA+LM=
X-Google-Smtp-Source: ABdhPJzmzYHhOKjw/oLcHqKe4dt4puvqOxh5P3TJbYOCf/ha1IihJzt+Hmia024yAS/yJr0cfF6mQQ==
X-Received: by 2002:a05:6402:b2d:: with SMTP id bo13mr5901159edb.120.1617221354245;
        Wed, 31 Mar 2021 13:09:14 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r19sm1691305ejr.55.2021.03.31.13.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:09:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/9] net: enetc: consume the error RX buffer descriptors in a dedicated function
Date:   Wed, 31 Mar 2021 23:08:49 +0300
Message-Id: <20210331200857.3274425-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331200857.3274425-1-olteanv@gmail.com>
References: <20210331200857.3274425-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We can and should check the RX BD errors before starting to build the
skb. The only apparent reason why things are done in this backwards
order is to spare one call to enetc_rxbd_next.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 43 ++++++++++++--------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5a54976e6a28..362cfba7ce14 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -605,6 +605,28 @@ static void enetc_add_rx_buff_to_skb(struct enetc_bdr *rx_ring, int i,
 	enetc_put_rx_buff(rx_ring, rx_swbd);
 }
 
+static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
+					      u32 bd_status,
+					      union enetc_rx_bd **rxbd, int *i)
+{
+	if (likely(!(bd_status & ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))))
+		return false;
+
+	enetc_rxbd_next(rx_ring, rxbd, i);
+
+	while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
+		dma_rmb();
+		bd_status = le32_to_cpu((*rxbd)->r.lstatus);
+
+		enetc_rxbd_next(rx_ring, rxbd, i);
+	}
+
+	rx_ring->ndev->stats.rx_dropped++;
+	rx_ring->ndev->stats.rx_errors++;
+
+	return true;
+}
+
 #define ENETC_RXBD_BUNDLE 16 /* # of BDs to update at once */
 
 static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
@@ -634,6 +656,11 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		enetc_wr_reg_hot(rx_ring->idr, BIT(rx_ring->index));
 		dma_rmb(); /* for reading other rxbd fields */
+
+		if (enetc_check_bd_errors_and_consume(rx_ring, bd_status,
+						      &rxbd, &i))
+			break;
+
 		size = le16_to_cpu(rxbd->r.buf_len);
 		skb = enetc_map_rx_buff_to_skb(rx_ring, i, size);
 		if (!skb)
@@ -645,22 +672,6 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		enetc_rxbd_next(rx_ring, &rxbd, &i);
 
-		if (unlikely(bd_status &
-			     ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))) {
-			dev_kfree_skb(skb);
-			while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
-				dma_rmb();
-				bd_status = le32_to_cpu(rxbd->r.lstatus);
-
-				enetc_rxbd_next(rx_ring, &rxbd, &i);
-			}
-
-			rx_ring->ndev->stats.rx_dropped++;
-			rx_ring->ndev->stats.rx_errors++;
-
-			break;
-		}
-
 		/* not last BD in frame? */
 		while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
 			bd_status = le32_to_cpu(rxbd->r.lstatus);
-- 
2.25.1

