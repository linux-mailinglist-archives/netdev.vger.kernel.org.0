Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DF331EA9C
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 14:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhBRNyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:54:15 -0500
Received: from ni.piap.pl ([195.187.100.5]:44326 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232078AbhBRMoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 07:44:46 -0500
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ni.piap.pl (Postfix) with ESMTPSA id 49B8B442FB3;
        Thu, 18 Feb 2021 13:34:42 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl 49B8B442FB3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1613651682; bh=V4pv1Jj17FC4YOPVXn6cAR3969CfZNdSYbAHlbXzUXI=;
        h=From:To:Subject:Date:From;
        b=fOXLg4YkGuarOvSNkVzRA6PuqaGbk8IBgl4zrNyYyBoAagH5APqb4+faVkr9+de9l
         hEsrciEBYwgyl1mWaNIqxGZ7VBGrVW+3biS99ss5cIJoB0IvRLF/EVHUj0FixWHhcB
         1EVlGbi4w1gBWdRXQNM4kNKgiSHeq/YyTPA1p4FE=
From:   "Krzysztof Halasa" <khalasa@piap.pl>
To:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Marvell Sky2 Ethernet adapter: fix warning messages.
Sender: khalasa@piap.pl
Date:   Thu, 18 Feb 2021 13:34:42 +0100
Message-ID: <m3a6s1r1ul.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 4
X-KLMS-Message-Action: skipped
X-KLMS-AntiSpam-Status: not scanned, whitelist
X-KLMS-AntiPhishing: not scanned, whitelist
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, not scanned, whitelist
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sky2.c driver uses netdev_warn() before the net device is initialized.
Fix it by using dev_warn() instead.

Signed-off-by: Krzysztof Halasa <khalasa@piap.pl>

--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4806,12 +4806,11 @@ static struct net_device *sky2_init_netdev(struct s=
ky2_hw *hw, unsigned port,
 	if (!is_valid_ether_addr(dev->dev_addr)) {
 		struct sockaddr sa =3D { AF_UNSPEC };
=20
-		netdev_warn(dev,
-			    "Invalid MAC address, defaulting to random\n");
+		dev_warn(&hw->pdev->dev, "Invalid MAC address, defaulting to random\n");
 		eth_hw_addr_random(dev);
 		memcpy(sa.sa_data, dev->dev_addr, ETH_ALEN);
 		if (sky2_set_mac_address(dev, &sa))
-			netdev_warn(dev, "Failed to set MAC address.\n");
+			dev_warn(&hw->pdev->dev, "Failed to set MAC address.\n");
 	}
=20
 	return dev;

--=20
Krzysztof Halasa

Sie=C4=87 Badawcza =C5=81ukasiewicz
Przemys=C5=82owy Instytut Automatyki i Pomiar=C3=B3w PIAP
Al. Jerozolimskie 202, 02-486 Warszawa
