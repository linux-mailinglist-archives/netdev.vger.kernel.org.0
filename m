Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380C7B9F3D
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 19:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfIURxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 13:53:22 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52764 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfIURxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 13:53:22 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46bJ8t6Vgjz1rJsn;
        Sat, 21 Sep 2019 19:53:18 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46bJ8t2bSgz1qqkQ;
        Sat, 21 Sep 2019 19:53:18 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id R6pls93qQTLy; Sat, 21 Sep 2019 19:53:15 +0200 (CEST)
X-Auth-Info: ufZYh6GUY7fuxQaECJwDEnyOvM7honLkYIiKvEt6wLg=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 21 Sep 2019 19:53:15 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH] net: dsa: microchip: Always set regmap stride to 1
Date:   Sat, 21 Sep 2019 19:53:09 +0200
Message-Id: <20190921175309.2195-1-marex@denx.de>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The regmap stride is set to 1 for regmap describing 8bit registers already.
However, for 16/32/64bit registers, the stride is 2/4/8 respectively. This
is not correct, as the switch protocol supports unaligned register reads
and writes and the KSZ87xx even uses such unaligned register accesses to
read e.g. MIB counter.

This patch fixes MIB counter access on KSZ87xx.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a24d8e61fbe7..dd60d0837fc6 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -303,7 +303,7 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 	{								\
 		.name = #width,						\
 		.val_bits = (width),					\
-		.reg_stride = (width) / 8,				\
+		.reg_stride = 1,					\
 		.reg_bits = (regbits) + (regalign),			\
 		.pad_bits = (regpad),					\
 		.max_register = BIT(regbits) - 1,			\
-- 
2.23.0.rc1

