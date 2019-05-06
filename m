Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34DDD15570
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 23:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfEFVZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 17:25:36 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:38274 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfEFVZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 17:25:35 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 96A1D50A4;
        Mon,  6 May 2019 23:25:33 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id d3e8320a;
        Mon, 6 May 2019 23:25:32 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net-next v2 2/4] net: dsa: support of_get_mac_address new ERR_PTR error
Date:   Mon,  6 May 2019 23:24:45 +0200
Message-Id: <1557177887-30446-3-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1557177887-30446-1-git-send-email-ynezz@true.cz>
References: <1557177887-30446-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was NVMEM support added to of_get_mac_address, so it could now
return ERR_PTR encoded error values, so we need to adjust all current
users of of_get_mac_address to this new fact.

While at it, remove superfluous is_valid_ether_addr as the MAC address
returned from of_get_mac_address is always valid and checked by
is_valid_ether_addr anyway.

Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 316bce9..fe7b6a6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1418,7 +1418,7 @@ int dsa_slave_create(struct dsa_port *port)
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 	slave_dev->hw_features |= NETIF_F_HW_TC;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
-	if (port->mac && is_valid_ether_addr(port->mac))
+	if (!IS_ERR_OR_NULL(port->mac))
 		ether_addr_copy(slave_dev->dev_addr, port->mac);
 	else
 		eth_hw_addr_inherit(slave_dev, master);
-- 
1.9.1

