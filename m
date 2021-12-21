Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A79647BA82
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhLUHMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:12:36 -0500
Received: from smtpbg128.qq.com ([106.55.201.39]:37749 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234743AbhLUHMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 02:12:36 -0500
X-QQ-mid: bizesmtp39t1640070724tej8l5fr
Received: from localhost.localdomain (unknown [118.121.67.96])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 21 Dec 2021 15:12:02 +0800 (CST)
X-QQ-SSF: 01000000002000D0K000B00A0000000
X-QQ-FEAT: 3u0oYPVhaeMuRPB0Xqzd/w4o3OO6lXBAlWAfvA8AcdvTZYMUBeN15dLIO8TVW
        CuGhu0G1cGgkn+EqmhBgPksUThch5I4JXj3y1efVCSfJcTQWdduS7mGN/jPCfl8hFFdTwQE
        Qq1HGg60X9IjS5LYWnMREdZ2Fs6oaPLph0AerfiI2DS3YYf3oMX2wIUwsghVgZ1cpj9Afz5
        N1YC2Y3j94j/uKo/4XsD6AotfR4JMjIozqowoi/Yh084c12q9+0lEL0x3UU+2jvJLttEVB5
        xrHxLm9R6pLHfGmb6KVgSglsUAZ1qQcKTsU1/aNJW8GECEI/b4mB42gZ9S6A4G1xFF0jWxk
        XgbFxVNajroxwKJFqNeG1yOzG0PJta9c8SzJw9zM0ubw2GOaOEQ8yBukOxLZA==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     davem@davemloft.net
Cc:     chessman@tux.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net: tlan: replace strlcpy with strscpy
Date:   Tue, 21 Dec 2021 15:11:54 +0800
Message-Id: <20211221071154.729300-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The strlcpy should not be used because it doesn't limit the source
length. So that it will lead some potential bugs.

But the strscpy doesn't require reading memory from the src string
beyond the specified "count" bytes, and since the return value is
easier to error-check than strlcpy()'s. In addition, the implementation
is robust to the string changing out from underneath it, unlike the
current strlcpy() implementation.

Thus, replace strlcpy with strscpy.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/ti/tlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 741c42c6a417..b3da76efa8f5 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -762,12 +762,12 @@ static void tlan_get_drvinfo(struct net_device *dev,
 {
 	struct tlan_priv *priv = netdev_priv(dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
 	if (priv->pci_dev)
-		strlcpy(info->bus_info, pci_name(priv->pci_dev),
+		strscpy(info->bus_info, pci_name(priv->pci_dev),
 			sizeof(info->bus_info));
 	else
-		strlcpy(info->bus_info, "EISA",	sizeof(info->bus_info));
+		strscpy(info->bus_info, "EISA",	sizeof(info->bus_info));
 }
 
 static int tlan_get_eeprom_len(struct net_device *dev)
-- 
2.34.1

