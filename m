Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8822D22777
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfESRG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:06:28 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:22240 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbfESRG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 13:06:28 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 0E4444ACA;
        Sun, 19 May 2019 14:19:01 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id d9c28ecb;
        Sun, 19 May 2019 14:18:59 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] of_net: fix of_get_mac_address retval if compiled without CONFIG_OF
Date:   Sun, 19 May 2019 14:18:44 +0200
Message-Id: <1558268324-5596-1-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_get_mac_address prior to commit d01f449c008a ("of_net: add NVMEM
support to of_get_mac_address") could return only valid pointer or NULL,
after this change it could return only valid pointer or ERR_PTR encoded
error value, but I've forget to change the return value of
of_get_mac_address in case where the kernel is compiled without
CONFIG_OF, so I'm doing so now.

Cc: Mirko Lindner <mlindner@marvell.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
Reported-by: Octavio Alvarez <octallk1@alvarezp.org>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 include/linux/of_net.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index 9cd72aab76fe..0f0346e6829c 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -22,7 +22,7 @@ static inline int of_get_phy_mode(struct device_node *np)
 
 static inline const void *of_get_mac_address(struct device_node *np)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline struct net_device *of_find_net_device_by_node(struct device_node *np)
-- 
1.9.1

