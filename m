Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47234291860
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 18:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgJRQjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 12:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgJRQjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 12:39:08 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33BFC061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 09:39:07 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dn5so7779204edb.10
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 09:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ReBPidVWJI5UOuvjFPtVR/ClX74ZZfVh3V8CjolLSvs=;
        b=ZS5NzN+b40TlI4fUuvpvlPzD6NvTQf5BhE+vE8hHwscilf0fjYTjIIjCyMa4gSz+Xe
         OI8BOv/krNy1c6pduW6XmSyOiKX3gcupP+CqKc4CtMd7HgMC3sHVD46KR017gfQxVTNO
         gBkQfY1RzG9TR9xoq3rTHXkQ1UJj4LWPtzEbPdKMA0I7cHUt5E1Pp7KaB3+OtsI3JC2f
         /11ztRfnze377YH4nQTtu5xc4eRlfKXxMQeovMZbY4TwXe6dUzGhmuHsHDVl4vZ0bOSH
         Gho16t83CJB25Jrg3ZQiMAR28Dk76WbmrmWXhfsSqNHUMreypfzrCFMfSza9u/jFPlZa
         9pvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ReBPidVWJI5UOuvjFPtVR/ClX74ZZfVh3V8CjolLSvs=;
        b=NVQi12Cd4STRRbCLz1wWye8qH717Rkm/BdiZTpUh3liFddk5JQANFP2UtxgfeuOlo8
         bQ6mDpj6yT4mxQcr2iqgnuEdeX160qshOfos6S8/JAgxeV7duv1Qw8aUbEWpyAHSET0l
         xo8AuM31P9uM+ordSCB6uoEdqx7GJjPNwdsDnDuDi37tEq+UCon6QCbIYB+T8TpWz0zw
         4avPSfQowMHpxWztT3rQ2pAdlfb2UebVf/YP6QRc/Pfopcx7fV0Xc/hBi0x/XEsbAGA6
         6ZhL+di5GpbyipUb2cdmP9LnJLgyQfTfRe3Ue7FE+BBrGV6Q2EiGyHKSsZl/QlwylYDj
         4jzw==
X-Gm-Message-State: AOAM531kbv4G0c1rsqCuYersmiWwhOVEOff4cdy9isYr1b2+OMxZnUjJ
        FWqsOXEOV7pFw/0tpk1gDKE+721kK7g=
X-Google-Smtp-Source: ABdhPJwVj6XV5G8J+5nFujxjLkfp60FhMqsI7d5LcWb/n/JZRD6Np5T2BDhR1Z/SvUfgJJKqmOtx6Q==
X-Received: by 2002:a50:d4dc:: with SMTP id e28mr14719166edj.137.1603039146306;
        Sun, 18 Oct 2020 09:39:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:8821:97f2:24b4:2f18? (p200300ea8f232800882197f224b42f18.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8821:97f2:24b4:2f18])
        by smtp.googlemail.com with ESMTPSA id bn2sm7648532ejb.48.2020.10.18.09.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 09:39:05 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix operation under forced interrupt threading
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com>
Date:   Sun, 18 Oct 2020 18:38:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For several network drivers it was reported that using
__napi_schedule_irqoff() is unsafe with forced threading. One way to
fix this is switching back to __napi_schedule, but then we lose the
benefit of the irqoff version in general. As stated by Eric it doesn't
make sense to make the minimal hard irq handlers in drivers using NAPI
a thread. Therefore ensure that the hard irq handler is never
thread-ified.

Fixes: 9a899a35b0d6 ("r8169: switch to napi_schedule_irqoff")
Link: https://lkml.org/lkml/2020/10/18/19
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7d366b036..3b6ddc706 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4694,7 +4694,7 @@ static int rtl8169_close(struct net_device *dev)
 
 	phy_disconnect(tp->phydev);
 
-	pci_free_irq(pdev, 0, tp);
+	free_irq(pci_irq_vector(pdev, 0), tp);
 
 	dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
 			  tp->RxPhyAddr);
@@ -4745,8 +4745,8 @@ static int rtl_open(struct net_device *dev)
 
 	rtl_request_firmware(tp);
 
-	retval = pci_request_irq(pdev, 0, rtl8169_interrupt, NULL, tp,
-				 dev->name);
+	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
+			     IRQF_NO_THREAD | IRQF_SHARED, dev->name, tp);
 	if (retval < 0)
 		goto err_release_fw_2;
 
@@ -4763,7 +4763,7 @@ static int rtl_open(struct net_device *dev)
 	return retval;
 
 err_free_irq:
-	pci_free_irq(pdev, 0, tp);
+	free_irq(pci_irq_vector(pdev, 0), tp);
 err_release_fw_2:
 	rtl_release_firmware(tp);
 	rtl8169_rx_clear(tp);
-- 
2.28.0

