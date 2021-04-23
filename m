Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E677368C7E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240643AbhDWFWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240528AbhDWFWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:22:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDB3C061574;
        Thu, 22 Apr 2021 22:21:24 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso646068pjn.0;
        Thu, 22 Apr 2021 22:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DV+kp1wpYcIFwJoJv9jeN6J03GSNSld+/Vb3IzRQLm0=;
        b=kGdqEK0YKXp9kFu3y7zjOBoYMHU5Ol8fp0zyDUkeJywlD5sRdudkYnSwLhfTLQMesg
         f2eNxWiHjMmZnLl4dtNbjrEmuIeoC4icA2Ao+ZxS9uvDSPiEl5vl2U2EXfeNaiJSS8Iz
         oR1wSsMucTUT+WIHKdKYamWygZMA6AzIPBqXNYOyskgT6Wecxs4+9rD6r6dHZDakFKSk
         L4zm5UDgCEOicAklt9AbQYH6M6Y1jrFRgu1mh1Rzeid5AIsMKXCxT5x3+2wUK/SSZ69C
         gElPReTCe2URmu5lepQRz+bOpUKGarsGeZJGHQvIZmIulnon8ZNFR6kbYzlzAJl71zvs
         2jMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DV+kp1wpYcIFwJoJv9jeN6J03GSNSld+/Vb3IzRQLm0=;
        b=r7kOZkNOpdn+JG3CUqVjaeWU+ks4KkWTiG07Cj9BERQA40QlT2XUYEMDq2ruDEYdZe
         MSVokrvcRyvJnOYrrvzKxDJ4QVAocWcM0WyF/im8KeWHh0EyQ3OG6mEnjxOStguSs5AR
         2klYYBu7iJHjoTRsg/Mw6EQSvH/Ne9kJNYQmUabfR5KkGXFnmHXmsYgtcb/a0W6NZ/99
         6mTbyVtfK2P2jyu4Oc7cgHMB4hFu5uEMsbJT16WuE9XXgoAzjv6ZV2fA37QO1q6r4IWF
         NyApsCncYrc7quBFb0MiOQ+43SAsf9d/plYZsDxY4GYqjPrTU2i7HOJ5PHPRlYXRMAiG
         xyFQ==
X-Gm-Message-State: AOAM533D0REJCVldB0MLi22PwN2U/GjdbopV6g0d4Pvxz7xaq14COj3S
        QDtJJXm1XTk1iOLDo5UH8ys=
X-Google-Smtp-Source: ABdhPJwKi6H4kjc+Ur+ZaInetv6Q+x9mWcW2c/9xBF8znlsl3EvesadpGacIpglSKsHSuNgFUeehyA==
X-Received: by 2002:a17:90b:2305:: with SMTP id mt5mr2562953pjb.198.1619155284334;
        Thu, 22 Apr 2021 22:21:24 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:23 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next v2 07/15] net: ethernet: mtk_eth_soc: use larger burst size for QDMA TX
Date:   Thu, 22 Apr 2021 22:21:00 -0700
Message-Id: <20210423052108.423853-8-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Improves tx performance

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e6f832dde9a6..645360cfdfe9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2193,7 +2193,7 @@ static int mtk_start_dma(struct mtk_eth *eth)
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
 		mtk_w32(eth,
 			MTK_TX_WB_DDONE | MTK_TX_DMA_EN |
-			MTK_DMA_SIZE_16DWORDS | MTK_NDP_CO_PRO |
+			MTK_TX_BT_32DWORDS | MTK_NDP_CO_PRO |
 			MTK_RX_DMA_EN | MTK_RX_2B_OFFSET |
 			MTK_RX_BT_32DWORDS,
 			MTK_QDMA_GLO_CFG);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 875e67b41561..83883d86b881 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -203,7 +203,7 @@
 #define MTK_RX_BT_32DWORDS	(3 << 11)
 #define MTK_NDP_CO_PRO		BIT(10)
 #define MTK_TX_WB_DDONE		BIT(6)
-#define MTK_DMA_SIZE_16DWORDS	(2 << 4)
+#define MTK_TX_BT_32DWORDS	(3 << 4)
 #define MTK_RX_DMA_BUSY		BIT(3)
 #define MTK_TX_DMA_BUSY		BIT(1)
 #define MTK_RX_DMA_EN		BIT(2)
-- 
2.31.1

