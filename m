Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2259121C62A
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgGKUcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:32:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgGKUce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 16:32:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juMAg-004eo3-6R; Sat, 11 Jul 2020 22:32:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Chris Healy <cphealy@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/2] net: fec: Set max MTU size to allow the MTU to be changed
Date:   Sat, 11 Jul 2020 22:32:06 +0200
Message-Id: <20200711203206.1110108-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711203206.1110108-1-andrew@lunn.ch>
References: <20200711203206.1110108-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FEC allocates 2K buffers, but looses some of it due to
alignment. It can however support an MTU bigger than the default. This
is particularly interesting when used in combination with Ethernet
switches supporting DSA, which have extra headers. The DSA core will
try to increase the MTU to support these extra headers. If the max
size defaults to that of standard Ethernet we get a warning. By
setting the max to what the driver actually supports, we avoid this
warning.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 9f80a33c5b16..8047dda947f2 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3710,6 +3710,8 @@ fec_probe(struct platform_device *pdev)
 	fec_enet_clk_enable(ndev, false);
 	pinctrl_pm_select_sleep_state(&pdev->dev);
 
+	ndev->max_mtu = PKT_MAXBUF_SIZE - ETH_HLEN - ETH_FCS_LEN;
+
 	ret = register_netdev(ndev);
 	if (ret)
 		goto failed_register;
-- 
2.27.0.rc2

