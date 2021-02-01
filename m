Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF76730B1BD
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhBAUvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhBAUvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:51:44 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E91AC06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 12:51:04 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id p20so7172474ejb.6
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 12:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ajSWcurqu38iUFiEKDJzKUUMGg4wir09Ada2/HPW3Fo=;
        b=GEJhbAeAkcfI7hIiJZFDRejhLkQQW5lPm5dAgKdm/XAgmPaiJqv8TbW5ynYbR/a7Xb
         P1NX4amfdqSV5Fbt69GJEdHai8t7RQA3yxIfHrqxyWpn0sjEY7Q45xYvgokVSQ5WAWnW
         C4f5DhGL9SjRhPy0GLVzeo4/u9NXUR6OrUjnguBuRrFS76xLHBnbDBD5r2oR9EKs5JPf
         OnsaJdSuqbC4gRscjJ//hK+FjqdWWQxt8IMtfuLEA+X7Gqcj5621snOQoWGylk9EwhMy
         zWGlVbVGw3OhXmSzkpSL0oTLvg/fI7AwaZUrMsIEgSxy0whVRIVGEDP3pleKdKURUSSE
         R3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ajSWcurqu38iUFiEKDJzKUUMGg4wir09Ada2/HPW3Fo=;
        b=mQM3slphvhP3La5WpeTznW2BqIpEKU/KdMVf9geSS5J8xVMd5M0lEjaqy9Vpu7lo1L
         uGEOOtkzeXGIv14gKGJDPKQi8V7IFcmeOU4sPvHvOaCzCSvNDOEKsFiiS2ftVOKxuV6x
         8uaSHKbuHW4dMeUHng/x88QG3m7ZXm3MyDMioEUkFj832kX5x/NbLILfMacyGam5mZl6
         ZrDCxPps7NdTD/8W8P406ZFq8afo9sEtTEDGx683WM2cw2KnN+Apx3OR59knDcNrju+d
         19f85eqVgoBZLowDn6tHpITEWBGllI8csIJ2110SxZ2do7qWLIWwvbUs2TswR6r9OYqQ
         GdnA==
X-Gm-Message-State: AOAM5336sPfYzcz/eh3fasIyML84XsLjRYqK7DTlc49eV1G/ytz8SWNy
        SDrL2bGqrgwCIgLz4zZbWOQroB+QW6Q=
X-Google-Smtp-Source: ABdhPJxMQrtWdMpn+7d7t7AJZl3te8QArzBnIGCjv/JjwpWGALuP1EKkGjCfeSEHydHjK1xYFjBdmw==
X-Received: by 2002:a17:906:bcd4:: with SMTP id lw20mr6635685ejb.415.1612212661591;
        Mon, 01 Feb 2021 12:51:01 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:a01e:aa5d:44a8:4129? (p200300ea8f1fad00a01eaa5d44a84129.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:a01e:aa5d:44a8:4129])
        by smtp.googlemail.com with ESMTPSA id b11sm1081665eja.115.2021.02.01.12.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 12:51:00 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net] r8169: fix WoL on shutdown if CONFIG_DEBUG_SHIRQ is set
Message-ID: <fe732c2c-a473-9088-3974-df83cfbd6efd@gmail.com>
Date:   Mon, 1 Feb 2021 21:50:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far phy_disconnect() is called before free_irq(). If CONFIG_DEBUG_SHIRQ
is set and interrupt is shared, then free_irq() creates an "artificial"
interrupt by calling the interrupt handler. The "link change" flag is set
in the interrupt status register, causing phylib to eventually call
phy_suspend(). Because the net_device is detached from the PHY already,
the PHY driver can't recognize that WoL is configured and powers down the
PHY.

Fixes: f1e911d5d0df ("r8169: add basic phylib support")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4253d51a9..53c2079c7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4667,10 +4667,10 @@ static int rtl8169_close(struct net_device *dev)
 
 	cancel_work_sync(&tp->wk.work);
 
-	phy_disconnect(tp->phydev);
-
 	free_irq(pci_irq_vector(pdev, 0), tp);
 
+	phy_disconnect(tp->phydev);
+
 	dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
 			  tp->RxPhyAddr);
 	dma_free_coherent(&pdev->dev, R8169_TX_RING_BYTES, tp->TxDescArray,
-- 
2.30.0

