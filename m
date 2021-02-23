Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26B532296C
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 12:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhBWLUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbhBWLUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:20:52 -0500
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9482CC06174A
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:20:07 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:254f:253d:debc:790b])
        by xavier.telenet-ops.be with bizsmtp
        id YbL52400V1v7dkx01bL55Y; Tue, 23 Feb 2021 12:20:06 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lEVjZ-0011vc-9r; Tue, 23 Feb 2021 12:20:05 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lEVjY-009KOx-Sv; Tue, 23 Feb 2021 12:20:04 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: dsa: sja1105: Remove unneeded cast in sja1105_crc32()
Date:   Tue, 23 Feb 2021 12:20:03 +0100
Message-Id: <20210223112003.2223332-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sja1105_unpack() takes a "const void *buf" as its first parameter, so
there is no need to cast away the "const" of the "buf" variable before
calling it.

Drop the cast, as it prevents the compiler performing some checks.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Compile-tested only.

BTW, sja1105_packing() and packing() are really bad APIs, as the input
pointer parameters cannot be const due to the direction depending on
"op".  This means the compiler cannot do const checks.  Worse, callers
are required to cast away constness to prevent the compiler from
issueing warnings.  Please don't do this!
---
 drivers/net/dsa/sja1105/sja1105_static_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 139b7b4fbd0d5252..a8efb7fac3955307 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -85,7 +85,7 @@ u32 sja1105_crc32(const void *buf, size_t len)
 	/* seed */
 	crc = ~0;
 	for (i = 0; i < len; i += 4) {
-		sja1105_unpack((void *)buf + i, &word, 31, 0, 4);
+		sja1105_unpack(buf + i, &word, 31, 0, 4);
 		crc = crc32_le(crc, (u8 *)&word, 4);
 	}
 	return ~crc;
-- 
2.25.1

