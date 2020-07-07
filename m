Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67CF21637F
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 03:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgGGBuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 21:50:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50172 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727871AbgGGBuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 21:50:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsck6-003wC5-Ps; Tue, 07 Jul 2020 03:49:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next v2 5/7] net: phy: dp83640: Fixup cast to restricted __be16 warning
Date:   Tue,  7 Jul 2020 03:49:37 +0200
Message-Id: <20200707014939.938621-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707014939.938621-1-andrew@lunn.ch>
References: <20200707014939.938621-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ntohs() expects to be passed a __be16. Correct the type of the
variable holding the sequence ID.

Cc: Richard Cochran <richardcochran@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/dp83640.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index ecbd5e0d685c..da31756f5a70 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -803,9 +803,10 @@ static int decode_evnt(struct dp83640_private *dp83640,
 
 static int match(struct sk_buff *skb, unsigned int type, struct rxts *rxts)
 {
-	u16 *seqid, hash;
 	unsigned int offset = 0;
 	u8 *msgtype, *data = skb_mac_header(skb);
+	__be16 *seqid;
+	u16 hash;
 
 	/* check sequenceID, messageType, 12 bit hash of offset 20-29 */
 
@@ -836,7 +837,7 @@ static int match(struct sk_buff *skb, unsigned int type, struct rxts *rxts)
 	if (rxts->msgtype != (*msgtype & 0xf))
 		return 0;
 
-	seqid = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
+	seqid = (__be16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
 	if (rxts->seqid != ntohs(*seqid))
 		return 0;
 
-- 
2.27.0.rc2

