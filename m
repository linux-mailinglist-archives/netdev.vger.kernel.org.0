Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6E0E34AB
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 15:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393822AbfJXNrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 09:47:19 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:52638 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393816AbfJXNrT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 09:47:19 -0400
Received: from iota-build.ysoft.local (unknown [10.1.5.151])
        by uho.ysoft.cz (Postfix) with ESMTP id EBF7DA46D1;
        Thu, 24 Oct 2019 15:47:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1571924837;
        bh=09J4vORehZpPUrCjny9gMof7LTXInUPHQqnUVJsRbps=;
        h=From:To:Cc:Subject:Date:From;
        b=n//OPWXdEDnZd017TCo9yp15YZ5BasUfGALobr6LZixLa/KX90UNZ2EXqF+uvLOFa
         ju8lGPSdQIjymJYYp/NA1xqsR7hJ61kdtEvrGcL9qgmUsRmHB+4T/cEqA5hjEb8afU
         VD8L/E0Nbd2IJXBxfaHo+XJV6TGROvImCTOuDdec=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
Subject: [PATCH net-next] net: dsa: qca8k: Initialize the switch with correct number of ports
Date:   Thu, 24 Oct 2019 15:46:58 +0200
Message-Id: <1571924818-27725-1-git-send-email-michal.vokac@ysoft.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 0394a63acfe2 ("net: dsa: enable and disable all ports")
the dsa core disables all unused ports of a switch. In this case
disabling ports with numbers higher than QCA8K_NUM_PORTS causes that
some switch registers are overwritten with incorrect content.

To fix this, initialize the dsa_switch->num_ports with correct number
of ports.

Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
I actually tried and gave a T-b tag to the whole series that contains
the offending commit but obviously I was not careful enough. Who knows
what was on my mind and what I actually tested back then. Sorry.

 drivers/net/dsa/qca8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 7e742cd491e8..36c6ed98f8e7 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1083,7 +1083,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		return -ENOMEM;
 
 	priv->ds->dev = &mdiodev->dev;
-	priv->ds->num_ports = DSA_MAX_PORTS;
+	priv->ds->num_ports = QCA8K_NUM_PORTS;
 	priv->ds->priv = priv;
 	priv->ops = qca8k_switch_ops;
 	priv->ds->ops = &priv->ops;
-- 
2.1.4

