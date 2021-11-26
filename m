Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D408A45E3EC
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 02:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357335AbhKZBPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 20:15:22 -0500
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:49850 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237270AbhKZBNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 20:13:22 -0500
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee761a033daece-13a0c; Fri, 26 Nov 2021 09:09:46 +0800 (CST)
X-RM-TRANSID: 2ee761a033daece-13a0c
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee261a033d55bf-13ddc;
        Fri, 26 Nov 2021 09:09:46 +0800 (CST)
X-RM-TRANSID: 2ee261a033d55bf-13ddc
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        arnd@arndb.de, wanjiabing@vivo.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] ptp: ixp46x: Fix error handling in ptp_ixp_probe()
Date:   Fri, 26 Nov 2021 09:10:39 +0800
Message-Id: <20211126011039.32-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function ptp_ixp_probe(), when get irq failed
after executing platform_get_irq(), the negative value
returned will not be detected here. So fix error handling
in this place.

Fixes: 9055a2f591629 ("ixp4xx_eth: make ptp support a platform driver")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 39234852e01b..c52e01d89e47 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -272,7 +272,7 @@ static int ptp_ixp_probe(struct platform_device *pdev)
 	ixp_clock.master_irq = platform_get_irq(pdev, 0);
 	ixp_clock.slave_irq = platform_get_irq(pdev, 1);
 	if (IS_ERR(ixp_clock.regs) ||
-	    !ixp_clock.master_irq || !ixp_clock.slave_irq)
+	    (ixp_clock.master_irq < 0) || (ixp_clock.slave_irq < 0))
 		return -ENXIO;
 
 	ixp_clock.caps = ptp_ixp_caps;
-- 
2.18.2



