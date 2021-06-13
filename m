Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD003A5929
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 16:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhFMPBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 11:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhFMPBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 11:01:53 -0400
Received: from mxout012.mail.hostpoint.ch (mxout012.mail.hostpoint.ch [IPv6:2a00:d70:0:e::312])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE47C061574;
        Sun, 13 Jun 2021 07:59:52 -0700 (PDT)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout012.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lsRaV-000AWg-EJ; Sun, 13 Jun 2021 16:59:47 +0200
Received: from [2a02:168:6182:1:d747:8127:5b7a:4266] (helo=eleanor.home.reto-schneider.ch)
        by asmtp013.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lsRaV-00020T-BT; Sun, 13 Jun 2021 16:59:47 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        netdev@vger.kernel.org
Cc:     Stefan Roese <sr@denx.de>,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] net: ethernet: mtk_eth_soc: Support custom ifname
Date:   Sun, 13 Jun 2021 16:59:01 +0200
Message-Id: <20210613145859.1774246-2-code@reto-schneider.ch>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210613115820.1525478-1-code@reto-schneider.ch>
References: <20210613115820.1525478-1-code@reto-schneider.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Reto Schneider <reto.schneider@husqvarnagroup.com>

Name the MAC interface name according to the label property. If the
property is missing, the default name (ethX) gets used.

Labels with more than IFNAMSIZ -1 characters will be truncated silently,
which seems to be what most of the code base does when using strscpy.

Signed-off-by: Reto Schneider <reto.schneider@husqvarnagroup.com>

---

Changes in v2:
- Avoid dangerous usage of strncpy

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 64adfd24e134..a921ecc1c997 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2948,6 +2948,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 {
 	const __be32 *_id = of_get_property(np, "reg", NULL);
+	const char *const name = of_get_property(np, "label", NULL);
 	phy_interface_t phy_mode;
 	struct phylink *phylink;
 	struct mtk_mac *mac;
@@ -3020,6 +3021,9 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
 	mac->phylink = phylink;
 
+	if (name)
+		strscpy(eth->netdev[id]->name, name, IFNAMSIZ);
+
 	SET_NETDEV_DEV(eth->netdev[id], eth->dev);
 	eth->netdev[id]->watchdog_timeo = 5 * HZ;
 	eth->netdev[id]->netdev_ops = &mtk_netdev_ops;
-- 
2.30.2

