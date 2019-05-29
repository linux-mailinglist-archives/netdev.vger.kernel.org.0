Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CBC2D52F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfE2FoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:44:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50814 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfE2FoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 01:44:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id f204so637110wme.0
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 22:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:cc:to:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=U64UvrXWIC9KXc55IeE6ygAQmvZZ0/0qrvRXZO4DC/Y=;
        b=L8xh2AEitf4wpdBHFah8hBe9jUj7M4tNJR3amFliMRnq/xr+KvrBOUdiMdQirk8AWw
         60gI/MCalVs6/nQcSIrJ3ixd60eyj8LaOtotrjaqwm6sRdFKqiQhcValvmK+YNuqGPMR
         B6qOxO9SUYvACITEPHE3rcAPO/FlX93ZXBl3KfzTI8NbczcQusf2aDbIHVcyrYA4j2Ig
         mB8hZW6DUVLnBWxEIvpH050ptAzkeNh9zRmt0rLNzySCw7ZWwYFB6rKl3sg0rfQRopCj
         N7vWQx9MG4STUiZYTjJzHe4cN86AckDCO2iv4urjZbTehPogELCrr873pnXMyI2+GlD4
         p2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:cc:to:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=U64UvrXWIC9KXc55IeE6ygAQmvZZ0/0qrvRXZO4DC/Y=;
        b=AozkeqlqGwY4vaUg096mg/I+HjP6iqxNZeZngidDxsZHY2UoIsAsQsUHGT4KYayI12
         r6tGLu/sJFoGbNMoFo8JOTx9EMEIcPpfhJ2ksUgetDn3/FIGEVwwEss8+VGg40jQPi/a
         fEkQN0onnyxDkbJ7FBfNSkoSaq0PPmNF3dmQT9+BFb3LdwhmXENGpfyGDJ27v8lI1PzF
         ostqBUCaD15ssLuBVSJ8CGIlhIBssBbdTXIupYNp0pj4l/cm8OBQ8Rs7uGfPk21q7pqG
         gHQxsTMd4OARfLQUrb7ty5oCcZKPnx38sPYx8fhirWNNUAajqKiRoQ7CCijHIphJAdIC
         BdwQ==
X-Gm-Message-State: APjAAAV0SGeOeSkZ+iZuqA4Rz8Ui9a9DERcEo9ZmXZ2/dzVJQS8NN3MB
        /U1MI3JrNXFDkmxPeEFx5lo=
X-Google-Smtp-Source: APXvYqwIl8LPw+u6pMMSi01VKco+Ia4T8kcOrkCYgVQL6OjV2VNdNZI8N3BMnw0RlYqzR7CCR6Lllg==
X-Received: by 2002:a05:600c:259:: with SMTP id 25mr5292158wmj.177.1559108650745;
        Tue, 28 May 2019 22:44:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:1580:a255:1b64:e5f5? (p200300EA8BF3BD001580A2551B64E5F5.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:1580:a255:1b64:e5f5])
        by smtp.googlemail.com with ESMTPSA id 19sm4971827wmi.10.2019.05.28.22.44.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 22:44:10 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix MAC address being lost in PCI D3
Cc:     Albert Astals Cid <aacid@kde.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Message-ID: <425a6651-4728-babb-3ac4-1dacc87d702a@gmail.com>
Date:   Wed, 29 May 2019 07:44:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(At least) RTL8168e forgets its MAC address in PCI D3. To fix this set
the MAC address when resuming. For resuming from runtime-suspend we
had this in place already, for resuming from S3/S5 it was missing.

The commit referenced as being fixed isn't wrong, it's just the first
one where the patch applies cleanly.

Fixes: 0f07bd850d36 ("r8169: use dev_get_drvdata where possible")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reported-by: Albert Astals Cid <aacid@kde.org>
Tested-by: Albert Astals Cid <aacid@kde.org>
---
 drivers/net/ethernet/realtek/r8169.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 261858e5a..9c849c83e 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6660,6 +6660,8 @@ static int rtl8169_resume(struct device *device)
 	struct net_device *dev = dev_get_drvdata(device);
 	struct rtl8169_private *tp = netdev_priv(dev);
 
+	rtl_rar_set(tp, dev->dev_addr);
+
 	clk_prepare_enable(tp->clk);
 
 	if (netif_running(dev))
@@ -6693,6 +6695,7 @@ static int rtl8169_runtime_resume(struct device *device)
 {
 	struct net_device *dev = dev_get_drvdata(device);
 	struct rtl8169_private *tp = netdev_priv(dev);
+
 	rtl_rar_set(tp, dev->dev_addr);
 
 	if (!tp->TxDescArray)
-- 
2.21.0

