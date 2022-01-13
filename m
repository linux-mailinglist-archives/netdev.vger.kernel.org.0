Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D0348DE53
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 20:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbiAMTq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 14:46:26 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:54592 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiAMTqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 14:46:17 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 4723F206166A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <bcm-kernel-feedback-list@broadcom.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH] bcmgenet: add WOL IRQ check
Organization: Open Mobile Platform
Message-ID: <2b49e965-850c-9f71-cd54-6ca9b7571cc3@omp.ru>
Date:   Thu, 13 Jan 2022 22:46:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver neglects to check the result of platform_get_irq_optional()'s
call and blithely passes the negative error codes to devm_request_irq()
(which takes *unsigned* IRQ #), causing it to fail with -EINVAL.
Stop calling devm_request_irq() with the invalid IRQ #s.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

---
This patch is against DaveM's 'net.git' repo.

 drivers/net/ethernet/broadcom/genet/bcmgenet.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: net/drivers/net/ethernet/broadcom/genet/bcmgenet.c
===================================================================
--- net.orig/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ net/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4020,10 +4020,12 @@ static int bcmgenet_probe(struct platfor
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
-	err = devm_request_irq(&pdev->dev, priv->wol_irq, bcmgenet_wol_isr, 0,
-			       dev->name, priv);
-	if (!err)
-		device_set_wakeup_capable(&pdev->dev, 1);
+	if (priv->wol_irq > 0) {
+		err = devm_request_irq(&pdev->dev, priv->wol_irq,
+				       bcmgenet_wol_isr, 0, dev->name, priv);
+		if (!err)
+			device_set_wakeup_capable(&pdev->dev, 1);
+	}
 
 	/* Set the needed headroom to account for any possible
 	 * features enabling/disabling at runtime
