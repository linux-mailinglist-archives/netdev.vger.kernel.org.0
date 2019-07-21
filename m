Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F9E6F432
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 18:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfGUQu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 12:50:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfGUQu2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jul 2019 12:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vnGwkk/2tZOsPzfDCnQK0OkPgR1G41+U0hRGztZYreU=; b=1ANtJJ6g6R06uk9YESOr8K89Uw
        wLZBefm5gs6XAXphftGwSiSIQwXc5UvW9r3V59JDvjWRc68bGA5UXCA5QKZmFd4FoPx7p8g9i9B3D
        5h7XtKxZ8CScJob+azc64cD3rWwp6063rZniF9Ffonl2695HR/CVjexxG5CDTz2RPxwU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hpF2X-0006vf-N2; Sun, 21 Jul 2019 18:50:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Chris Healy <Chris.Healy@zii.aero>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] net: phy: sfp: hwmon: Fix scaling of RX power
Date:   Sun, 21 Jul 2019 18:50:08 +0200
Message-Id: <20190721165008.26597-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX power read from the SFP uses units of 0.1uW. This must be
scaled to units of uW for HWMON. This requires a divide by 10, not the
current 100.

With this change in place, sensors(1) and ethtool -m agree:

sff2-isa-0000
Adapter: ISA adapter
in0:          +3.23 V
temp1:        +33.1 C
power1:      270.00 uW
power2:      200.00 uW
curr1:        +0.01 A

        Laser output power                        : 0.2743 mW / -5.62 dBm
        Receiver signal average optical power     : 0.2014 mW / -6.96 dBm

Reported-by: chris.healy@zii.aero
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 1323061a018a ("net: phy: sfp: Add HWMON support for module sensors")
---
 drivers/net/phy/sfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 2d816aadea79..e36c04c26866 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -517,7 +517,7 @@ static int sfp_hwmon_read_sensor(struct sfp *sfp, int reg, long *value)
 
 static void sfp_hwmon_to_rx_power(long *value)
 {
-	*value = DIV_ROUND_CLOSEST(*value, 100);
+	*value = DIV_ROUND_CLOSEST(*value, 10);
 }
 
 static void sfp_hwmon_calibrate(struct sfp *sfp, unsigned int slope, int offset,
-- 
2.20.1

