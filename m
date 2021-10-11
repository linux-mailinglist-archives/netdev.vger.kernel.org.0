Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EBE4291E1
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242500AbhJKOeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240430AbhJKOeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:34:00 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE9FC0612E2
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 07:27:48 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t16so46709482eds.9
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 07:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IkKF1Ul6s+mIj34dxznpMYVOcEWKCsEw1mlJ7TAdqjE=;
        b=MoBAqQVF5Ya+tSlDL2xABuAKYw18mCy05no5OzZ5mXNwobaiM3js/UZmGvqv2kezSW
         u5uoN8qpaW1M6tLYibfPzzjiSaiGDZpeKAwc6oYFULYTXfAJ4BmYVqEVv3B+VdO0y3H0
         zs68M3A1znS4dYf1CXNo8SisZ3wVNr0u445YQnVpaVR9KRskUQDtRdeS0BM0Nxh81dMq
         4a5/XBGTag29rX8Wem9SgmSUL+8eGYZ3Ij4NayBhTmV9Km8j79fTVu4NsRnOto0tFM1h
         77LJ+DkQXYLABEtefD3WuT2K98Ul7Rd7dhhPy4v8pqb9eSfsIG8IMGcnGZyXJxPrx/IS
         gtkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IkKF1Ul6s+mIj34dxznpMYVOcEWKCsEw1mlJ7TAdqjE=;
        b=zerEEigAhnHhzKzRs2RNK1Gq44zyeDUiQUcI7DNFe606Cgew/tfaj5cuRoBJ+I/UyP
         OVIGan14/cOd/mkIUd+6V3AMTSpSrBaiDt+SBpYPUxNpABYBBrDrL3dolAEvF0VbFXne
         uDso/prxerRycgAVCqqU2BDxHaljFK6nNpvkIsrikjHgsPlAqBecE+oIuOkSXb7iTQwN
         r9sfO3xB8AbsYpoqaSs63CMHwwuQwCEtRE3xuNTWStcSulBIYhh3UYt4MDPyb7aYDu1N
         pSm3c47MqXSfJS39vq8ZkIOko9xiYvoW6j9wISYFrAGw1hWm76D8ptG0g6n40DhCB79g
         Ytlg==
X-Gm-Message-State: AOAM531pokBO/5P+1bw16BfbQ0JyBThWkuUley7+IP/f+K6hOERo5hrY
        ENt7zJr1hWFIbqJVJXgW1C2g0A==
X-Google-Smtp-Source: ABdhPJy2YeXCqTmqM43glitQBCX8JDlFdnBkLMzl10Bo/AMrAUexFshAZdQjhFA/5hH6qxHYyB6n/A==
X-Received: by 2002:a50:bf0f:: with SMTP id f15mr41310513edk.43.1633962467437;
        Mon, 11 Oct 2021 07:27:47 -0700 (PDT)
Received: from dtpc.gsp-berlin.local (78-22-137-109.access.telenet.be. [78.22.137.109])
        by smtp.gmail.com with ESMTPSA id x16sm3565129ejj.8.2021.10.11.07.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 07:27:47 -0700 (PDT)
From:   Maarten Zanders <maarten.zanders@mind.be>
Cc:     maarten.zanders@mind.be, Maarten Zanders <m.zanders@televic.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's
Date:   Mon, 11 Oct 2021 16:27:20 +0200
Message-Id: <20211011142720.42642-1-maarten.zanders@mind.be>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mv88e6xxx_port_ppu_updates() interpretes data in the PORT_STS
register incorrectly for internal ports (ie no PPU). In these
cases, the PHY_DETECT bit indicates link status. This results
in forcing the MAC state whenever the PHY link goes down which
is not intended. As a side effect, LED's configured to show
link status stay lit even though the physical link is down.

Add a check in mac_link_down and mac_link_up to see if it
concerns an external port and only then, look at PPU status.

Fixes: 5d5b231da7ac (net: dsa: mv88e6xxx: use PHY_DETECT in mac_link_up/mac_link_down)
Reported-by: Maarten Zanders <m.zanders@televic.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Maarten Zanders <maarten.zanders@mind.be>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ee3f32d1cf46..f5ce05d78e11 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -726,9 +726,13 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
 
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
-	     mode == MLO_AN_FIXED) && ops->port_sync_link)
+	/* Internal PHYs propagate their configuration directly to the MAC.
+	 * External PHYs depend on whether the PPU is enabled for this port.
+	 */
+	if (((!mv88e6xxx_phy_is_internal(ds, port) &&
+	      !mv88e6xxx_port_ppu_updates(chip, port)) ||
+	     mode == MLO_AN_FIXED) && ops->port_sync_link)
 		err = ops->port_sync_link(chip, port, mode, false);
 	mv88e6xxx_reg_unlock(chip);
 
@@ -750,7 +754,12 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	if (!mv88e6xxx_port_ppu_updates(chip, port) || mode == MLO_AN_FIXED) {
+	/* Internal PHYs propagate their configuration directly to the MAC.
+	 * External PHYs depend on whether the PPU is enabled for this port.
+	 */
+	if ((!mv88e6xxx_phy_is_internal(ds, port) &&
+	     !mv88e6xxx_port_ppu_updates(chip, port)) ||
+	    mode == MLO_AN_FIXED) {
 		/* FIXME: for an automedia port, should we force the link
 		 * down here - what if the link comes up due to "other" media
 		 * while we're bringing the port up, how is the exclusivity
-- 
2.25.1

