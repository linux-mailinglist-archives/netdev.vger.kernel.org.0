Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909102EBFC1
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbhAFOo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbhAFOn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:43:57 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932BDC06134C;
        Wed,  6 Jan 2021 06:43:17 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id w1so2642882pjc.0;
        Wed, 06 Jan 2021 06:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DJYt8hiCkCeD9GXS/w4FMJ4EVxAjdbezO9NsUhxWdrw=;
        b=aD4qk+qHK5m9iZjRQ3AdyWO4znFZkqE9fJ+Qjh1CAEgC5qZVuEh1sHz041A8LklSuX
         BXME0Tg5Ovolk5FVTsfCl2HOjCdF3tiJAlfsdftJiT25BX+9FyHVYa5tJMbrqqDZNvOr
         PWc7kt7Vv8U+Dn00c2L+LGJ5YZYrkoIYh1mTIP2UsTLPnF5RvxtsQX9ONUksARe12/r8
         gCI26sapJNh0REmriKqZyYUmjenRipVdU/OtX362tLEVf9NHaK8q1Qfkkqi6BRmwzfOF
         2mKXPZGFoWggpRjNcwQWWgTyxeEpi4qfh1fvHwbrr+bvYOdV6ZLBLBTlSlaIVr4RoPh5
         5zfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DJYt8hiCkCeD9GXS/w4FMJ4EVxAjdbezO9NsUhxWdrw=;
        b=EBu34f+hstwwU/QzhRChuHeFnUP+laWkoFXxWLvXJJj6pqJ7avB23nV+iWSPNEKLpa
         himB2wrECGNBErNn9PQQf2P9i7f6JRmYHJAE/rRPlr3rHTLomm0XPYjm4dJYLz6j3vtT
         9/+M6dD9CELV9QzcZMbUVlM6o8tVDlCUIRnQVXFk7BuwukCLdM/duW0y7ZUnfdzEpDM9
         iDUgGnioUMMlcxcX2LhJg30/O1ldefSyzH5pkuA/TlUKesE9NR/aVzxiANrBYE7S4IrV
         fXIQXeNM0seDlFsyBYZ37hWvOqMraeWSp0gddXwyZUTG4qVbP4jixY2/VYJYeYHqvN1q
         HZ/g==
X-Gm-Message-State: AOAM532CU2Ct6c2X+2Y0ZEjfnEZIBJCZyri1TtCLCdH77nKiPZxJr4pw
        B1PbQCPwHa4RqhxfjCAu3B+sorvS/gg=
X-Google-Smtp-Source: ABdhPJxNz97H1pOSKsSbdx2hxJ8m6C/YDYdG5fbC+d2ew200pgpPSGIb8ilU3sGTmYIm6bxjQXLhvA==
X-Received: by 2002:a17:90a:ba88:: with SMTP id t8mr4566800pjr.229.1609944197246;
        Wed, 06 Jan 2021 06:43:17 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id h8sm3076774pjc.2.2021.01.06.06.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 06:43:16 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/7] bcm63xx_enet: add xmit_more support
Date:   Wed,  6 Jan 2021 22:42:04 +0800
Message-Id: <20210106144208.1935-4-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210106144208.1935-1-liew.s.piaw@gmail.com>
References: <20210106144208.1935-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support bulking hardware TX queue by using netdev_xmit_more().

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 90f8214b4d22..21744dae30ce 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -634,7 +634,8 @@ bcm_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	netdev_sent_queue(dev, skb->len);
 
 	/* kick tx dma */
-	enet_dmac_writel(priv, priv->dma_chan_en_mask,
+	if (!netdev_xmit_more() || !priv->tx_desc_count)
+		enet_dmac_writel(priv, priv->dma_chan_en_mask,
 				 ENETDMAC_CHANCFG, priv->tx_chan);
 
 	/* stop queue if no more desc available */
-- 
2.17.1

