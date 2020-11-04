Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59A12A6811
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbgKDPtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:49:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgKDPtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:49:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaL2F-005EbY-Ut; Wed, 04 Nov 2020 16:49:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        David Laight <David.Laight@ACULAB.COM>,
        Lee Jones <lee.jones@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 1/7] drivers: net: smc91x: Fix set but unused W=1 warning
Date:   Wed,  4 Nov 2020 16:48:52 +0100
Message-Id: <20201104154858.1247725-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201104154858.1247725-1-andrew@lunn.ch>
References: <20201104154858.1247725-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/smsc/smc91x.c:706:51: warning: variable ‘pkt_len’ set but not used [-Wunused-but-set-variable]
  706 |  unsigned int saved_packet, packet_no, tx_status, pkt_len;

Add a new macro for getting fields out of the header, which only gets
the status, not the length which in this case is not needed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/smc91x.c |  4 ++--
 drivers/net/ethernet/smsc/smc91x.h | 10 ++++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index f6b73afd1879..61333939a73e 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -703,7 +703,7 @@ static void smc_tx(struct net_device *dev)
 {
 	struct smc_local *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
-	unsigned int saved_packet, packet_no, tx_status, pkt_len;
+	unsigned int saved_packet, packet_no, tx_status;
 
 	DBG(3, dev, "%s\n", __func__);
 
@@ -720,7 +720,7 @@ static void smc_tx(struct net_device *dev)
 
 	/* read the first word (status word) from this packet */
 	SMC_SET_PTR(lp, PTR_AUTOINC | PTR_READ);
-	SMC_GET_PKT_HDR(lp, tx_status, pkt_len);
+	SMC_GET_PKT_HDR_STATUS(lp, tx_status);
 	DBG(2, dev, "TX STATUS 0x%04x PNR 0x%02x\n",
 	    tx_status, packet_no);
 
diff --git a/drivers/net/ethernet/smsc/smc91x.h b/drivers/net/ethernet/smsc/smc91x.h
index 387539a8094b..705d9d6ebaa5 100644
--- a/drivers/net/ethernet/smsc/smc91x.h
+++ b/drivers/net/ethernet/smsc/smc91x.h
@@ -1056,6 +1056,16 @@ static const char * chip_ids[ 16 ] =  {
 		}							\
 	} while (0)
 
+#define SMC_GET_PKT_HDR_STATUS(lp, status)				\
+	do {								\
+		if (SMC_32BIT(lp)) {					\
+			unsigned int __val = SMC_inl(ioaddr, DATA_REG(lp)); \
+			(status) = __val & 0xffff;			\
+		} else {						\
+			(status) = SMC_inw(ioaddr, DATA_REG(lp));	\
+		}							\
+	} while (0)
+
 #define SMC_PUSH_DATA(lp, p, l)					\
 	do {								\
 		if (SMC_32BIT(lp)) {				\
-- 
2.28.0

