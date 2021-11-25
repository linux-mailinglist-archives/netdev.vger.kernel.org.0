Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB4545D5F8
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 09:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350177AbhKYIK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 03:10:27 -0500
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:11019 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347128AbhKYII0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 03:08:26 -0500
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2021 03:08:26 EST
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee3619f410fe99-0a81c; Thu, 25 Nov 2021 15:53:52 +0800 (CST)
X-RM-TRANSID: 2ee3619f410fe99-0a81c
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee2619f410cd34-3d5cc;
        Thu, 25 Nov 2021 15:53:51 +0800 (CST)
X-RM-TRANSID: 2ee2619f410cd34-3d5cc
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] ptp: ixp46x: Fix error handling in ptp_ixp_probe()
Date:   Thu, 25 Nov 2021 15:54:32 +0800
Message-Id: <20211125075432.26636-1-tangbin@cmss.chinamobile.com>
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



