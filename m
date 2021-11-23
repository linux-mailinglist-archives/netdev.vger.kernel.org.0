Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237B9459A48
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 03:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhKWC7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 21:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhKWC7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 21:59:02 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4FCC061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 18:55:54 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id 193so20375567qkh.10
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 18:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=IBJ/+Y3fdcJBRdWIQTRhHgn8ZXe3SfIu5a9GKSWivyY=;
        b=NTvl0yOgz+/VYqj1rK5vImho+EV87kgdeY4f+l7JIuOUpTtD20PTShR7dUTby+lFyc
         0bYn1XY1o3Ugd2h3BSkkQvMaCRRdp9zmop+S3aHINCc4d+HIJ/kkakklQRVGL2TwIa8P
         GbE6y1M9T9cTkg+bFqxP5vBEuZTboa1zQOgvwscApz3VNbQn4KL/nLOFRLhdxf1gxP1p
         i4bVwdLB/+ijqoj13ZsHfZHL+Vs0UvWtgsF05D9GzsPE5J38oBs1PtsPiYMuSPyaPkx/
         d3XwNN3MyGlJdvE26hRQKJviUxFmq+E5GhxCKe7Cu3W5fs1QoMhafyzrmxHfOusd4D3k
         F7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=IBJ/+Y3fdcJBRdWIQTRhHgn8ZXe3SfIu5a9GKSWivyY=;
        b=fOjXS3OzZqysqMoEZD9KktM51edY/MKbbTpTQMAHwNDdLuJLjDbqGNTTikpNbFlH/b
         nCTDQ4AP37NynRLclWGqGEKnvHolRmO8jlIsikZsj567H94Oljn/x9p1hbxAUJGNZxIy
         iuBRPb/IJ/kzyBIsrTkALhPxW5thblsA6MjytU8QZa0CpcJn1nm4SXbMT98JZp94e84b
         aQK+QIqNBAaKaoQ3Pn+sibdx2gM8SIp/8WDV9AcCf4BK+fq3T3C5I7e4OhW6KzfDGHBz
         +uvH4MErtU3yY47skOvoLKpp7yloLq7Anm8uwclTesmtfGF26AdEcNPiCYs7DVQxKKVb
         SvzQ==
X-Gm-Message-State: AOAM533AhxqA4wLwRQANNN/avJ4uZs6P0zQ0nhidTO33SKBAXqEVhIfk
        8glIRvVcEgw/tor6bXWn/i2g/vBzVjCFRQ==
X-Google-Smtp-Source: ABdhPJzwoH7u5VBQAYQHh2dx2a0Xh1lIGd9FU+wzMVNv7xDGg9P7AgPy+b5RCkkOstS/vdlDLYz6bA==
X-Received: by 2002:a05:620a:2486:: with SMTP id i6mr1580895qkn.331.1637636153962;
        Mon, 22 Nov 2021 18:55:53 -0800 (PST)
Received: from work ([187.105.166.74])
        by smtp.gmail.com with ESMTPSA id o20sm6002377qkp.114.2021.11.22.18.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 18:55:53 -0800 (PST)
Date:   Mon, 22 Nov 2021 23:55:48 -0300
From:   Alessandro B Maurici <abmaurici@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro B Maurici <abmaurici@gmail.com>
Subject: [PATCH] phy: fix possible double lock calling link changed handler
Message-ID: <20211122235548.38b3fc7c@work>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alessandro B Maurici <abmaurici@gmail.com>

Releases the phy lock before calling phy_link_change to avoid any worker
thread lockup. Some network drivers(eg Microchip's LAN743x), make a call to
phy_ethtool_get_link_ksettings inside the link change handler, and, due to
the commit c10a485c3de5 ("phy: phy_ethtool_ksettings_get: Lock the phy for
consistency"), this will cause a lockup.
As that mutex call is needed for consistency, we need to release the lock,
if previously locked, before calling the handler to prevent issues.

Signed-off-by: Alessandro B Maurici <abmaurici@gmail.com>
---
 drivers/net/phy/phy.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index beb2b66da132..0914e339e623 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -58,13 +58,31 @@ static const char *phy_state_to_str(enum phy_state st)
 
 static void phy_link_up(struct phy_device *phydev)
 {
+	bool must_relock = false;
+
+	if (mutex_is_locked(&phydev->lock)) {
+		must_relock = true;
+		mutex_unlock(&phydev->lock);
+	}
 	phydev->phy_link_change(phydev, true);
+	if (must_relock)
+		mutex_lock(&phydev->lock);
+
 	phy_led_trigger_change_speed(phydev);
 }
 
 static void phy_link_down(struct phy_device *phydev)
 {
+	bool must_relock = false;
+
+	if (mutex_is_locked(&phydev->lock)) {
+		must_relock = true;
+		mutex_unlock(&phydev->lock);
+	}
 	phydev->phy_link_change(phydev, false);
+	if (must_relock)
+		mutex_lock(&phydev->lock);
+
 	phy_led_trigger_change_speed(phydev);
 }
 

