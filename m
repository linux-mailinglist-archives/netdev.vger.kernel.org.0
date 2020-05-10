Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89BC1CC94D
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 10:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgEJINE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 04:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbgEJIND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 04:13:03 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60AFC061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 01:13:01 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l18so6887743wrn.6
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 01:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QjETKwry5o5DSlhASRA1CxRDr25NztIYuQJwYglHKXg=;
        b=h+QvrbW0X3bzAsStHliD/9qa9A/TbobDJv6wWZvmRV8dY1KisSqGd519WQZQ3xIpBj
         xZLm4MwRASDdhaF4qKMwRDVcfQJFQyER8CuX3NnuQQsEejb2wylIStruKtOAZLA50VRB
         3RNB64Tv3RZbJyObBX6sxLsMwfwAfwkqiqo6qqXsCrTb2H/f87WP981iNdUlz3gh3JjB
         zcX6m6dWxOgqYmubM9cqe8W3KcVoXuDviImdDDExClD+uXTHCN3SeMwW5xCiRv1Is0fP
         TbagJvdoDaSSgTZV0uAT0+l3dZXwNqiFr2UxAYp4EavS7+yAoO28hO3/cNwjckOHzsR6
         oOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QjETKwry5o5DSlhASRA1CxRDr25NztIYuQJwYglHKXg=;
        b=EPJEGRvNMCUvZpRqjtYVVXyH3id6K6C8rEMrHoiKnHr6UNRKkNYlW0yvEbqSVULiHE
         Os8ZcP36Qkv/x3h0yDR4wDu8NY7JwCiolPUP1y3QKYqYNiI98nLH/MUDZs6mKXdOlH1U
         cS56SoElQk6Qwz6LZ/fYiMPiW/XUmZITvfiarSrEFaSU5R2QTUxxCQElVrUSy6XVBIHU
         dkFCBxOY9UG4VzPHrOkiEMImCp+FYhbIztMgj/k1Xf64SlzDTfA14j7LrCm+oFZUR1DM
         8T+9vjlIzmp59qsjyJTTlYBZeGojv6K0Q4ixxgYm8Xkm8vJoIdurqPYgiq7HO17/c+f2
         o4eQ==
X-Gm-Message-State: AGi0PuYAFgMYTS2mF0rDPrJKpgSrkrJYTilNuawPL50Y2HhTjeyWMQET
        VcHnH06UMCUQXjmh8IcSEgbmL/SK
X-Google-Smtp-Source: APiQypLXlbcsWpppjW/x+4DaBGk0rY7+eE4nLRxR7fyhBV5e9Oq/3TTUxtBjkScEJKaWPp30Qe3hCg==
X-Received: by 2002:adf:f24b:: with SMTP id b11mr12923676wrp.313.1589098380177;
        Sun, 10 May 2020 01:13:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:d448:ac33:cee7:aac0? (p200300EA8F285200D448AC33CEE7AAC0.dip0.t-ipconnect.de. [2003:ea:8f28:5200:d448:ac33:cee7:aac0])
        by smtp.googlemail.com with ESMTPSA id m82sm9551520wmf.3.2020.05.10.01.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2020 01:12:59 -0700 (PDT)
Subject: [PATCH net-next 1/2] net: phy: check for aneg disabled and half
 duplex in phy_ethtool_set_eee
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <8e7df680-e3c2-24ae-81d3-e24776583966@gmail.com>
Message-ID: <0c8429c2-7498-efe8-c223-da3d17b1e8e6@gmail.com>
Date:   Sun, 10 May 2020 10:11:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <8e7df680-e3c2-24ae-81d3-e24776583966@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EEE requires aneg and full duplex, therefore return EPROTONOSUPPORT
if aneg is disabled or aneg resulted in a half duplex mode.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 8c22d02b4..891bb6929 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1110,6 +1110,9 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 	if (!phydev->drv)
 		return -EIO;
 
+	if (phydev->autoneg == AUTONEG_DISABLE || phydev->duplex == DUPLEX_HALF)
+		return -EPROTONOSUPPORT;
+
 	/* Get Supported EEE */
 	cap = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
 	if (cap < 0)
-- 
2.26.2


