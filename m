Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9BF1023E
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 00:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfD3WLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 18:11:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50595 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfD3WLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 18:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=L3nI06bt6NU6XReTGlpsW1p6d2nk8QaIeSVXpvRIt/w=; b=Crmz6DKho3BdK3jEfuihG+N1cR
        his7lQGQGiA3sQnqZYzqWrWAVU1hgqO0/y7X9+Zo9f3aUcX/4m1aSl/2noh7iMYIFbuYBczBbJv09
        6ilUWxfmVTBIZBF4QrUxgrAaNV9KzxTB37cj1UDDw7HkHDuYD7NIndFnqPnafnBXYPBs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLavX-00055Q-BN; Wed, 01 May 2019 00:08:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/2] net: dsa :mv88e6xxx: Disable unused ports
Date:   Wed,  1 May 2019 00:08:31 +0200
Message-Id: <20190430220831.19505-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190430220831.19505-1-andrew@lunn.ch>
References: <20190430220831.19505-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the NO_CPU strap is set, the switch starts in 'dumb hub' mode, with
all ports enable. Ports which are then actively used are reconfigured
as required when the driver starts. However unused ports are left
alone. Change this to disable them, and turn off any SERDES
interface. This could save some power and so reduce the temperature a
bit.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dc891d83610e..46020fe1b5e7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2599,8 +2599,18 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	/* Setup Switch Port Registers */
 	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
-		if (dsa_is_unused_port(ds, i))
+		if (dsa_is_unused_port(ds, i)) {
+			err = mv88e6xxx_port_set_state(chip, i,
+						       BR_STATE_DISABLED);
+			if (err)
+				goto unlock;
+
+			err = mv88e6xxx_serdes_power(chip, i, false);
+			if (err)
+				goto unlock;
+
 			continue;
+		}
 
 		err = mv88e6xxx_setup_port(chip, i);
 		if (err)
-- 
2.20.1

