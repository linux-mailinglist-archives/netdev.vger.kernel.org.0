Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782CA2A680E
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgKDPtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:49:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35302 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbgKDPtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:49:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaL2G-005Ebk-3W; Wed, 04 Nov 2020 16:49:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        David Laight <David.Laight@ACULAB.COM>,
        Lee Jones <lee.jones@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 5/7] drivers: net: smc911x: Fix passing wrong number of parameters to DBG() macro
Date:   Wed,  4 Nov 2020 16:48:56 +0100
Message-Id: <20201104154858.1247725-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201104154858.1247725-1-andrew@lunn.ch>
References: <20201104154858.1247725-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the compiler always sees the parameters passed to the DBG()
macro, it gives an error message about wrong parameters. The comment
says it all:

	/* ndev is not valid yet, so avoid passing it in. */
	DBG(SMC_DEBUG_FUNC, "--> %s\n",  __func__);

You cannot not just pass a parameter!

The DBG does not seem to have any real value, to just remove it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/smc911x.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 6978050496ac..ac1a764364fb 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -2047,8 +2047,6 @@ static int smc911x_drv_probe(struct platform_device *pdev)
 	void __iomem *addr;
 	int ret;
 
-	/* ndev is not valid yet, so avoid passing it in. */
-	DBG(SMC_DEBUG_FUNC, "--> %s\n",  __func__);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		ret = -ENODEV;
-- 
2.28.0

