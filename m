Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3007C1874C4
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732691AbgCPVdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:33:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41783 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732641AbgCPVdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:33:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id f11so6345424wrp.8
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 14:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i7YOATVvrsSPvn9r0aMF6RsH98/oubZ/FNsZK+e/tgI=;
        b=ZfYDIUCDQP6nZ8yc8rCQB2TJ1ejh9mZzqIOf8+kOuIByCoved/pFY4rnIuhbcsxqrh
         ClUVclyto9/WUEY+bwnswgVsr8PNo8ibQpVMplofsuMCYzrC6d1SyXGjQ/AaBglC8Sg+
         dTMsSJbe6USDwn+vw13w6KZZSUgp6UxhpiJ05T90h4s7R2TX9dxgCGnEBdovNtE0Wmc3
         dYzARZL/f57PkCGUQK4k/ACV5ykRlUrw615/LdwZPU/MzAS1qwpCU5QZSDxJ2GCk0uL/
         Bmd27DwKzHaxo5rqnOF1nfliN8o5/xF4qRveXKzxqyKIDVLUbZg9rbSDw+5zP/l5c8bt
         SFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i7YOATVvrsSPvn9r0aMF6RsH98/oubZ/FNsZK+e/tgI=;
        b=fiY2E9wZyVA2aE4lfDtILpe+7yZZD2r395VQzY6LwC2/uJuUtiqfz4uOhzqpzdr7Si
         S5wyjmAESW/SKyaBcItC/qm7+KVwNXhNB+WDbdFxK3G5GH1gwyjR6yjHaZ6+9zJt1weq
         0ougYNBvzBowkC9JqHSNuLqGhG89P37/SyHa/lr+7oahf5epDHGR6Heb8R0rH1jCSoQn
         YCEeTO7Ml2HhTl/E1F+U2wvc70tyc9v5//puxlyLRk6MW9TkErlALriD6wFLxMhQsKZn
         Ijza8cgxGkhwAlio9LDtS2HUgIJiEfx/m68UahdCWxILVJcFEhtKKS8mT8mTfaIxtBR/
         C/nQ==
X-Gm-Message-State: ANhLgQ0kMdvgadzJtmJC4L+i3iOyoWG434zDi9Fp+4uf2qLuIHu5EEwi
        OeToxw7Ql4ScXf3Gr/M0s49pyWW0
X-Google-Smtp-Source: ADFU+vsUr4QfOCuKnuFYW6wmJUw0ONCMkgiY8BCLCs9AfR0Gh+Pq0WCycZWf/QJ8j9gq9emYelxAaw==
X-Received: by 2002:adf:e511:: with SMTP id j17mr1482369wrm.25.1584394418842;
        Mon, 16 Mar 2020 14:33:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:1dfa:b5c5:6377:a256? (p200300EA8F2960001DFAB5C56377A256.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1dfa:b5c5:6377:a256])
        by smtp.googlemail.com with ESMTPSA id k5sm1132387wmj.18.2020.03.16.14.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 14:33:38 -0700 (PDT)
Subject: [PATCH net-next 2/2] net: phy: mscc: consider interrupt source in
 interrupt handler
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <49afbad9-317a-3eff-3692-441fae3c4f49@gmail.com>
Message-ID: <14496a42-6203-b601-f301-91d28bedb09f@gmail.com>
Date:   Mon, 16 Mar 2020 22:33:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <49afbad9-317a-3eff-3692-441fae3c4f49@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trigger the respective interrupt handler functionality only if the
related interrupt source bit is set.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/mscc/mscc_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 4727aba8e..2f6229a70 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1437,8 +1437,11 @@ static irqreturn_t vsc8584_handle_interrupt(struct phy_device *phydev)
 	if (irq_status < 0 || !(irq_status & MII_VSC85XX_INT_MASK_MASK))
 		return IRQ_NONE;
 
-	vsc8584_handle_macsec_interrupt(phydev);
-	phy_mac_interrupt(phydev);
+	if (irq_status & MII_VSC85XX_INT_MASK_EXT)
+		vsc8584_handle_macsec_interrupt(phydev);
+
+	if (irq_status & MII_VSC85XX_INT_MASK_LINK_CHG)
+		phy_mac_interrupt(phydev);
 
 	return IRQ_HANDLED;
 }
-- 
2.25.1


