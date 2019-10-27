Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 784DDE6892
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 22:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbfJ0VSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 17:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731301AbfJ0VSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 17:18:35 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27D91205C9;
        Sun, 27 Oct 2019 21:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211114;
        bh=+yNNbeZyOKtQ54YhJ2ztXvrf5KEN+DQ/L5ZZl5rW4UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCNnZmGf+mgzKbFnUMa4wlTyxE/htHWdLzfyB1FbrqytWqTpt8MQf3kUkWgj/XOFH
         soby4Fb8aVvFNWOCIPCE1DhgkycsafnSwJqLoi/+i7slDTUaeb8lNwo+IDdu4R9NUe
         FjzHm+43YN/Ohp+Wiwr8p6wpvngvjgImfhcPkaF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 036/197] net: mscc: ocelot: add missing of_node_put after calling of_get_child_by_name
Date:   Sun, 27 Oct 2019 21:59:14 +0100
Message-Id: <20191027203353.674156300@linuxfoundation.org>
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

[ Upstream commit d2c50b1cd94528aea8c8e9abb4cce81590f32cc4 ]

of_node_put needs to be called when the device node which is got
from of_get_child_by_name finished using.
In both cases of success and failure, we need to release 'ports',
so clean up the code using goto.

fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_board.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 2451d4a96490b..041fb9f38ecaa 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -287,13 +287,14 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 			continue;
 
 		phy = of_phy_find_device(phy_node);
+		of_node_put(phy_node);
 		if (!phy)
 			continue;
 
 		err = ocelot_probe_port(ocelot, port, regs, phy);
 		if (err) {
 			of_node_put(portnp);
-			return err;
+			goto out_put_ports;
 		}
 
 		phy_mode = of_get_phy_mode(portnp);
@@ -321,7 +322,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 				"invalid phy mode for port%d, (Q)SGMII only\n",
 				port);
 			of_node_put(portnp);
-			return -EINVAL;
+			err = -EINVAL;
+			goto out_put_ports;
 		}
 
 		serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
@@ -334,7 +336,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 					"missing SerDes phys for port%d\n",
 					port);
 
-			goto err_probe_ports;
+			of_node_put(portnp);
+			goto out_put_ports;
 		}
 
 		ocelot->ports[port]->serdes = serdes;
@@ -346,9 +349,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	dev_info(&pdev->dev, "Ocelot switch probed\n");
 
-	return 0;
-
-err_probe_ports:
+out_put_ports:
+	of_node_put(ports);
 	return err;
 }
 
-- 
2.20.1



