Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC68F3240D1
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbhBXP2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238536AbhBXPTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 10:19:37 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31504C061786
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 07:18:57 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id v17so2787121ljj.9
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 07:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mZF1HWnrlItLv8PoJfvSCiIXd5pLgphu/THNbaXDQx0=;
        b=hVGBI3eNeTIDqW1xSsyugVoE1JHyluni5iY3/tzGm7h6a3AiRhmezg2pNFrdYkB6Wm
         2pObFb9UDQ4zdewQ6+Fw4m6kwsAZFC9B9doZMqbzfomo/UhtMiSiB/RwkXZEYkxGHkz5
         rvfLq9C7aSDXfhE09N0gqff7DVdY3n2RPJnY7GGmQ6yt5BsUsmmK/Jy2Euf86CTcYukK
         ZbjS5KBtrenShTm7N1qDOTPEZfz7g5LLibROH3vcAOwAxWif7kSS0/2kUtDH1DLaqfx7
         uUfxuLAQU/Z1sb2OpgNgsG17WuqE36cXheCgXlEX38JdA56u7G6RscDttcLeCFbz8KcK
         /yWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mZF1HWnrlItLv8PoJfvSCiIXd5pLgphu/THNbaXDQx0=;
        b=pt7+65JYl4/ly7J+gNEFtEkF/hZ/tpLm96eU1MmcX2SxRRrOuA8nvTQZXrxR57BQrH
         yhWpTHxpGhLmeiy5QdDGgeCLSITUJ/VOJxOodIDBcLgsu8x5XlUk3l5jEeGmZo71oxrY
         FBNomJ6fe16T3uT3u5UM4MAWIl63/3CpLZldmrmdxCqFuwkE67Kk2igKS+iw+eZe+Lx5
         23VH4QXTAA/agAuoXnmZqgOAWhgmrnyeuDcDvhbcydTSx+JG9ruWw9qgTlXYm6jN78Me
         zxg8lGEyi4G4mSsva3U5JvRZshyHFvTB/qtFXso5t12sE8QPboEueT7VfhpBf7yumcK4
         PJtA==
X-Gm-Message-State: AOAM532oJXBfCA4WG0hK+TjEJXXDNZk+ykmRrT92JZixaZ6zHCuIwXa4
        cWzuZbIl0rx2AzgmeMo/Ie4=
X-Google-Smtp-Source: ABdhPJxuKYwLcuJPWi3Wo537E5UTnlgyAUokJmgYiKzFmBWAXnl0QBwa3vDhkZ+B5QDkvmPeI8Wi9g==
X-Received: by 2002:a2e:9c10:: with SMTP id s16mr4927578lji.457.1614179935731;
        Wed, 24 Feb 2021 07:18:55 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id j137sm546006lfj.55.2021.02.24.07.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 07:18:54 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net] net: broadcom: bcm4908_enet: fix RX path possible mem leak
Date:   Wed, 24 Feb 2021 16:18:41 +0100
Message-Id: <20210224151842.2419-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

After filling RX ring slot with new skb it's required to free old skb.
Immediately on error or later in the net subsystem.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 9be33dc98072..7983c7a9fca9 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -570,6 +570,7 @@ static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
 
 		if (len < ETH_ZLEN ||
 		    (ctl & (DMA_CTL_STATUS_SOP | DMA_CTL_STATUS_EOP)) != (DMA_CTL_STATUS_SOP | DMA_CTL_STATUS_EOP)) {
+			kfree_skb(slot.skb);
 			enet->netdev->stats.rx_dropped++;
 			break;
 		}
-- 
2.26.2

