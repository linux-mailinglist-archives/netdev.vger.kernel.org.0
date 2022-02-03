Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE63C4A8B1D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344584AbiBCSCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiBCSCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:02:33 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E17C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 10:02:33 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id s16so2869923pgs.13
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 10:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8bmNKCvl6r0Jvy0kDmKUltRBM7ghG0/K/gpqd7A2b1Y=;
        b=ib4QG00DInelDiP+aByXJAdzesBbwVsvT1X97Z6GdGqzRVatJf8JNudzCDsDzQ/j/J
         G94PDu/VfTu2RIoWlITHA0AxAkvWZaFjPdlVVyvLD1aoY1tn+6tCgLErjQs0oFYhkqdt
         vQSlfbU7iptKka5CH9cB6kYrd35tgpDcwKyn1Ha+mOI3vRCjdqHH3iRNO/Yd7skEJk5a
         L5TiN7d/kc1twbWk7D1bgj94hVr5DFBkOZ9hDQbFY7bTQVQBhwPF2binQ3rdpBybZHMg
         CG59aRb57MHmcIiRk1CKSLJceAJ7qh8C40eGk57LDhd+kuwwDxBE9DtkmdcDTH0l7Vd0
         PgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8bmNKCvl6r0Jvy0kDmKUltRBM7ghG0/K/gpqd7A2b1Y=;
        b=65gLRj1w2URUVGGeAcTJ0JZj79sDzlayiwpPwOKgUMFlZ4KcGf2NS1L3VUpsf4fb3x
         U/Vy3THsR15RTGOnTV0Ew5v/Y8xiGZnMfQMNAjzFT4SrsZtXodTOEHGoRr2MJ0mfwWol
         9wS6vvC7U32LygvPW4iZEXvg1Z9Z4DqdxxLLQtJFm2T69QQQcEWEBiahndyVMmxDnTmu
         hEMfqGS1FNRUPWfoA4rd7Zaz/+cPsf9NcuXQ1IpgHDHzZlGEhsUXYhFdSV0EMcsccTxt
         9xIe5yQL36I/6u+e6/oxMftz0e3FeH7DxG799T56yP7flji9VxvlK/gp74F/5P9z7u6b
         QKxw==
X-Gm-Message-State: AOAM530b6gztIwO73rcOCa8kW5EwPr/EQkLec14ntQu/yVYjpS4oqTJ8
        7qcw3vVET7E/wrXRsn5bXoM=
X-Google-Smtp-Source: ABdhPJzcq2xVMzIpUc3/Gi/H8ucgGh5yvXE+Lzx+8zExM/N56l3hKn2DPD2UTZdYWfFo2Jzd1rUj7Q==
X-Received: by 2002:a63:451f:: with SMTP id s31mr29651080pga.114.1643911353015;
        Thu, 03 Feb 2022 10:02:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b3be:296f:182e:18d5])
        by smtp.gmail.com with ESMTPSA id ms14sm10702487pjb.15.2022.02.03.10.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 10:02:32 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] net: typhoon: implement ndo_features_check method
Date:   Thu,  3 Feb 2022 10:02:26 -0800
Message-Id: <20220203180227.3751784-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220203180227.3751784-1-eric.dumazet@gmail.com>
References: <20220203180227.3751784-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Instead of disabling TSO if MAX_SKB_FRAGS > 32, implement
ndo_features_check() method for this driver.

If skb has more than 32 frags, use the following heuristic:

1) force GSO for gso packets.
2) Otherwise force linearization.

Most locally generated packets will use a small number
of fragments anyway.

For forwarding workloads, we can limit gro_max_size at ingress,
we might also implement gro_max_segs if needed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/3com/typhoon.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 8aec5d9fbfef2803c181387537300502a937caf0..67b1a1f439d841ed0ed0f620e9477607ac6e2fae 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -138,11 +138,6 @@ MODULE_PARM_DESC(use_mmio, "Use MMIO (1) or PIO(0) to access the NIC. "
 module_param(rx_copybreak, int, 0);
 module_param(use_mmio, int, 0);
 
-#if defined(NETIF_F_TSO) && MAX_SKB_FRAGS > 32
-#warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO
-#undef NETIF_F_TSO
-#endif
-
 #if TXLO_ENTRIES <= (2 * MAX_SKB_FRAGS)
 #error TX ring too small!
 #endif
@@ -2261,9 +2256,27 @@ typhoon_test_mmio(struct pci_dev *pdev)
 	return mode;
 }
 
+#if MAX_SKB_FRAGS > 32
+static netdev_features_t typhoon_features_check(struct sk_buff *skb,
+						struct net_device *dev,
+						netdev_features_t features)
+{
+	if (skb_shinfo(skb)->nr_frags > 32) {
+		if (skb_is_gso(skb))
+			features &= ~NETIF_F_GSO_MASK;
+		else
+			features &= ~NETIF_F_SG;
+	}
+	return features;
+}
+#endif
+
 static const struct net_device_ops typhoon_netdev_ops = {
 	.ndo_open		= typhoon_open,
 	.ndo_stop		= typhoon_close,
+#if MAX_SKB_FRAGS > 32
+	.ndo_features_check	= typhoon_features_check,
+#endif
 	.ndo_start_xmit		= typhoon_start_tx,
 	.ndo_set_rx_mode	= typhoon_set_rx_mode,
 	.ndo_tx_timeout		= typhoon_tx_timeout,
-- 
2.35.0.263.gb82422642f-goog

