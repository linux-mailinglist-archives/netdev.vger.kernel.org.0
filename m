Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2038C3FB858
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 16:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhH3OgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 10:36:06 -0400
Received: from laubervilliers-656-1-228-164.w92-154.abo.wanadoo.fr ([92.154.28.164]:53938
        "EHLO ssq0.pkh.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbhH3OgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 10:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pkh.me; s=selector1;
        t=1630334107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kgxy1yAh7dMUGFIGxX89+EstgFdP9XB/Xv6c2oPXvCw=;
        b=F7Eq76EXP+tRVI3tVHAQ9/JIeWcuVUHmCGaV/DjpG5D8KhXnVfpLbeM9bALMOyX8moBUyk
        QQauk4tiRdyliOgNe9k/O0iwVgJN/vYlACOFy+yalLb1eaLfksTnU4TgT++Phdh+TzQ7cw
        zvnbYXKdWu91zrTEiQyfFs6CxZsw/es=
Received: from localhost (ssq0.pkh.me [local])
        by ssq0.pkh.me (OpenSMTPD) with ESMTPA id 680a0b7d;
        Mon, 30 Aug 2021 14:35:07 +0000 (UTC)
Date:   Mon, 30 Aug 2021 16:35:07 +0200
From:   =?utf-8?B?Q2zDqW1lbnQgQsWTc2No?= <u@pkh.me>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Willy Liu <willy.liu@realtek.com>, netdev@vger.kernel.org,
        linux-sunxi@lists.linux.dev, devicetree@vger.kernel.org
Subject: Re: sunxi H5 DTB fix for realtek regression
Message-ID: <YSzsmy1f2//NNzXm@ssq0.pkh.me>
References: <YSwr6YZXjNrdKoBZ@ssq0.pkh.me>
 <YSziXfll/p/5OrOv@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yBy1AuXrmCsyj5+w"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YSziXfll/p/5OrOv@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yBy1AuXrmCsyj5+w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Aug 30, 2021 at 03:51:25PM +0200, Andrew Lunn wrote:
[...]
> > I'm sorry for not sending a proper patch: I unfortunately have very little
> > clue about what I'm doing here so it's very hard for me to elaborate a
> > proper commit description.
> 
> Hi Clément
> 
> You are not too far away from a proper patch. I can either guide you,
> if you want to learn, or the allwinner maintainer can probably take
> your work and finish it off.

See attached patch, heavily based on other commits.

Note: running `git grep 'phy-mode\s*=\s*"rgmii"' arch` shows that it might
affect other hardware as well. I don't know how one is supposed to check
that, but I would guess at least sun50i-a64-nanopi-a64.dts is affected (a
quick internet search shows that it's using a RTL8211E¹)

The grep returns 231 occurences... A lot of other boards might have a
broken network right now.

[1]: http://nanopi.io/nanopi-a64.html

-- 
Clément B.

--yBy1AuXrmCsyj5+w
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="0001-arm64-dts-sun50i-h5-NanoPI-Neo-2-phy-mode-rgmii-id.patch"

From 771f3ad9f8749dd29039a623b25feb818f182104 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Cl=C3=A9ment=20B=C5=93sch?= <u@pkh.me>
Date: Mon, 30 Aug 2021 16:28:08 +0200
Subject: [PATCH] arm64: dts: sun50i: h5: NanoPI Neo 2: phy-mode rgmii-id

Since commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay
config") network is broken on the NanoPi Neo 2.

This patch changes the phy-mode to use internal delays both for RX and
TX as has been done for other boards affected by the same commit.

Fixes: bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay config")
---
 arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
index 02f8e72f0cad..05486cccee1c 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
@@ -75,7 +75,7 @@ &emac {
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 
-- 
2.33.0


--yBy1AuXrmCsyj5+w--
