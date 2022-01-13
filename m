Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBD948DE93
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 21:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiAMUED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 15:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiAMUEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 15:04:02 -0500
Received: from wp126.webpack.hosteurope.de (wp126.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8485::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FBFC061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 12:04:02 -0800 (PST)
Received: from p5098d998.dip0.t-ipconnect.de ([80.152.217.152] helo=hermes.fivetechno.de); authenticated
        by wp126.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1n86KF-0006EQ-11; Thu, 13 Jan 2022 21:03:59 +0100
X-Virus-Scanned: by amavisd-new 2.12.1 using newest ClamAV at
        linuxbbg.five-lan.de
Received: from odroid-x2.fritz.box (pd9e89d11.dip0.t-ipconnect.de [217.232.157.17])
        (authenticated bits=0)
        by hermes.fivetechno.de (8.15.2/8.16.1/SUSE Linux 0.8) with ESMTPSA id 20DK3shg011127
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 13 Jan 2022 21:03:55 +0100
From:   Markus Reichl <m.reichl@fivetechno.de>
To:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martyn Welch <martyn.welch@collabora.com>
Cc:     Markus Reichl <m.reichl@fivetechno.de>,
        Gabriel Hojda <ghojda@yo2urs.ro>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: Correct reset handling of smsc95xx
Date:   Thu, 13 Jan 2022 21:01:11 +0100
Message-Id: <20220113200113.30702-1-m.reichl@fivetechno.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;m.reichl@fivetechno.de;1642104242;30535d97;
X-HE-SMSGID: 1n86KF-0006EQ-11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On boards with LAN9514 and no preconfigured MAC address we don't get an
ip address from DHCP after commit a049a30fc27c ("net: usb: Correct PHY handling
of smsc95xx") anymore. Adding an explicit reset before starting the phy
fixes the issue.

[1]
https://lore.kernel.org/netdev/199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com/

From: Gabriel Hojda <ghojda@yo2urs.ro>
Fixes: a049a30fc27c ("net: usb: Correct PHY handling of smsc95xx")
Signed-off-by: Gabriel Hojda <ghojda@yo2urs.ro>
Signed-off-by: Markus Reichl <m.reichl@fivetechno.de>
---
 drivers/net/usb/smsc95xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index abe0149ed917..bc1e3dd67c04 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1962,7 +1962,8 @@ static const struct driver_info smsc95xx_info = {
 	.bind		= smsc95xx_bind,
 	.unbind		= smsc95xx_unbind,
 	.link_reset	= smsc95xx_link_reset,
-	.reset		= smsc95xx_start_phy,
+	.reset		= smsc95xx_reset,
+	.check_connect	= smsc95xx_start_phy,
 	.stop		= smsc95xx_stop,
 	.rx_fixup	= smsc95xx_rx_fixup,
 	.tx_fixup	= smsc95xx_tx_fixup,
-- 
2.30.2

