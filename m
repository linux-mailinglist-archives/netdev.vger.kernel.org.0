Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86FB10E151
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 10:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfLAJwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 04:52:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42173 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfLAJwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 04:52:07 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so40389168wrf.9
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 01:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=7OF3ma73n4Oio9PDACE4qDNZxrZLe4AxY9EXAi6bSGM=;
        b=K0bIMJWcfFAZ6uMEZBlLJvZ3loen1fiMz2biaOq86rcbyh0F0qUp2qH7j0f+OYTPau
         eoCA52y83WhRWuhyPAcFqtccvHKIPapOx9P2A+ZD7th9ufeEYkZBdAbGAN6+RGuzKnfv
         VexSUKGq3Y30AkyGez43JnHU7w7H+MOmKA9W9Dsywz11gCwRiwDGh3+RsGbboZvvI1cn
         oyeI1Zj18NQavTIg4Tj5lj7i+5TUL0V50ZaBn/eZlIyGb8DfMhfpb9/HZ/U7BXQU47CX
         VvIVJYpgPQYhEqXUffhjcvdaVRY3Uu02OchlDyoiJE6eiOElV/k+K+cNqSjwtpJFLwB3
         LOUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=7OF3ma73n4Oio9PDACE4qDNZxrZLe4AxY9EXAi6bSGM=;
        b=YdooyS8+d5u8UKUGypkH3fQRRZygsy8ffNFo1iL88oNAFi43Cy/CqT15L9TBnJli1V
         tMM7myl6CghmHdoGeRqLPMDMQp6D2+vIo4CTqDcl1tfv/ErMC37igACnqhBboGwmar8/
         E0O86fWyaPQrWxJmqHqEPkkHcJgjcQGDIlH9I5uy1J8PyAtZetap7vEvaHPcIHBTTaD0
         jb2pbeQMqoqu8xuB9zjPlGFkMV0TGRwpyuOiPh5MCQN99tR5n68LSEKSRyC3S/LCruJ7
         aKg46KliotGPDkFcibMjY6AQH0lT1pzKofXb6G6YlZGvFL8lSt4Q1r176ybES0ZuQmkP
         sivg==
X-Gm-Message-State: APjAAAVpd6peXvBjA4DBkFgXR3gKEJDd4Ie73xNF+jXCirmG+Ho7yh85
        8soTeHQ8Y6gIlYf52iaN27kqU58Y
X-Google-Smtp-Source: APXvYqy88A4CssOJrDQCQp91sr5wWPE5ohPcguxy6YZzWlqZ/AG3a3/ndR3fdPsehWVWMyMIHYEzsw==
X-Received: by 2002:a5d:6089:: with SMTP id w9mr17573724wrt.228.1575193924157;
        Sun, 01 Dec 2019 01:52:04 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:1159:8f18:7fad:7ef1? (p200300EA8F4A630011598F187FAD7EF1.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:1159:8f18:7fad:7ef1])
        by smtp.googlemail.com with ESMTPSA id f1sm33595341wru.6.2019.12.01.01.52.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Dec 2019 01:52:03 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix resume on cable plug-in
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        jhdskag3 <jhdskag3@tutanota.com>
Message-ID: <5ecbf6db-f8e5-7b31-d80e-7c835eb7ae5c@gmail.com>
Date:   Sun, 1 Dec 2019 10:39:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was reported [0] that network doesn't wake up on cable plug-in with
certain chip versions. Reason is that on these chip versions the PHY
doesn't detect cable plug-in when being in power-down mode. So prevent
the PHY from powering down if WoL is enabled.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=202103

Fixes: 95fb8bb3181b ("net: phy: force phy suspend when calling phy_stop")
Reported-by: jhdskag3 <jhdskag3@tutanota.com>
Tested-by: jhdskag3 <jhdskag3@tutanota.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d47a038cb..0b47db2ff 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1542,6 +1542,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	rtl_lock_config_regs(tp);
 
 	device_set_wakeup_enable(tp_to_dev(tp), wolopts);
+	tp->dev->wol_enabled = wolopts ? 1 : 0;
 }
 
 static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
-- 
2.24.0

