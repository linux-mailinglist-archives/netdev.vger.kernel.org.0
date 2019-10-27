Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 777C1E6894
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 22:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732765AbfJ0Vah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 17:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731310AbfJ0VSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 17:18:38 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA16520717;
        Sun, 27 Oct 2019 21:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211117;
        bh=pE0yT9Ol68fBMk/rzKDUq3s4Y8QKqjuEq7VMxFMPklc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iiOiojoZAv6DR+EihEm9o5W/zql8Fq6LvGeEOsrxK9yCLI4Ay7umTWsOz5e5mPdfc
         W3u/y8hCktsDHRbQRaF+knFCAyJ5D/4zvONjRzkH2SFKPfMwkWq+2H4WvVTfsLPhzF
         b6P6f/lBu+5pjkmhNtUnLqY4ykEsC1u6gShByNNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 037/197] net: dsa: rtl8366rb: add missing of_node_put after calling of_get_child_by_name
Date:   Sun, 27 Oct 2019 21:59:15 +0100
Message-Id: <20191027203353.725873412@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

[ Upstream commit f32eb9d80470dab05df26b6efd02d653c72e6a11 ]

of_node_put needs to be called when the device node which is got
from of_get_child_by_name finished using.
irq_domain_add_linear() also calls of_node_get() to increase refcount,
so irq_domain will not be affected when it is released.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rtl8366rb.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a268085ffad28..f5cc8b0a7c74c 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -507,7 +507,8 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 	irq = of_irq_get(intc, 0);
 	if (irq <= 0) {
 		dev_err(smi->dev, "failed to get parent IRQ\n");
-		return irq ? irq : -EINVAL;
+		ret = irq ? irq : -EINVAL;
+		goto out_put_node;
 	}
 
 	/* This clears the IRQ status register */
@@ -515,7 +516,7 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 			  &val);
 	if (ret) {
 		dev_err(smi->dev, "can't read interrupt status\n");
-		return ret;
+		goto out_put_node;
 	}
 
 	/* Fetch IRQ edge information from the descriptor */
@@ -537,7 +538,7 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 				 val);
 	if (ret) {
 		dev_err(smi->dev, "could not configure IRQ polarity\n");
-		return ret;
+		goto out_put_node;
 	}
 
 	ret = devm_request_threaded_irq(smi->dev, irq, NULL,
@@ -545,7 +546,7 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 					"RTL8366RB", smi);
 	if (ret) {
 		dev_err(smi->dev, "unable to request irq: %d\n", ret);
-		return ret;
+		goto out_put_node;
 	}
 	smi->irqdomain = irq_domain_add_linear(intc,
 					       RTL8366RB_NUM_INTERRUPT,
@@ -553,12 +554,15 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 					       smi);
 	if (!smi->irqdomain) {
 		dev_err(smi->dev, "failed to create IRQ domain\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_put_node;
 	}
 	for (i = 0; i < smi->num_ports; i++)
 		irq_set_parent(irq_create_mapping(smi->irqdomain, i), irq);
 
-	return 0;
+out_put_node:
+	of_node_put(intc);
+	return ret;
 }
 
 static int rtl8366rb_set_addr(struct realtek_smi *smi)
-- 
2.20.1



