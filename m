Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFCEE19F42E
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgDFLKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:10:17 -0400
Received: from forward104p.mail.yandex.net ([77.88.28.107]:43565 "EHLO
        forward104p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727187AbgDFLKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 07:10:17 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2020 07:10:15 EDT
Received: from mxback2g.mail.yandex.net (mxback2g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:163])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id 2D1A14B01769;
        Mon,  6 Apr 2020 14:03:58 +0300 (MSK)
Received: from iva6-add863d6e49c.qloud-c.yandex.net (iva6-add863d6e49c.qloud-c.yandex.net [2a02:6b8:c0c:7ea0:0:640:add8:63d6])
        by mxback2g.mail.yandex.net (mxback/Yandex) with ESMTP id 1lkKD5Qv5k-3taCEc9W;
        Mon, 06 Apr 2020 14:03:58 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1586171038;
        bh=MVbOdw9l4QGn3nnIO9erS76GIdiX/YjUcUkIYMD5UTg=;
        h=Subject:To:From:Cc:Date:Message-Id;
        b=bfzLdk4ExqJTfeP8CqC6jDSZSy5lO661rPA2yyCDjnZMShwp+rNaeaquL/r9csELL
         3/vZ+zcrswugGBBiwKe5pdRTro0gPsZXB/qI0dTKtOmpbsKUiL4SbE9VwRqmIC4wCe
         InbKcGer7B9aKeu93ZNjH2gDvGbj0RNlUX1bH0nA=
Authentication-Results: mxback2g.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva6-add863d6e49c.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 2f6WU2NpeW-3r287sqM;
        Mon, 06 Apr 2020 14:03:55 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Lobakin <bloodyreaper@yandex.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Mao Wenan <maowenan@huawei.com>,
        Alexander Lobakin <bloodyreaper@yandex.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH resend net-next] net: dsa: add GRO support via gro_cells
Date:   Mon,  6 Apr 2020 14:03:18 +0300
Message-Id: <20200406110318.33738-1-bloodyreaper@yandex.ru>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gro_cells lib is used by different encapsulating netdevices, such as
geneve, macsec, vxlan etc. to speed up decapsulated traffic processing.
CPU tag is a sort of "encapsulation", and we can use the same mechs to
greatly improve overall DSA performance.
skbs are passed to the GRO layer after removing CPU tags, so we don't
need any new packet offload types as it was firstly proposed by me in
the first GRO-over-DSA variant [1].

The size of struct gro_cells is sizeof(void *), so hot struct
dsa_slave_priv becomes only 4/8 bytes bigger, and all critical fields
remain in one 32-byte cacheline.
The other positive side effect is that drivers for network devices
that can be shipped as CPU ports of DSA-driven switches can now use
napi_gro_frags() to pass skbs to kernel. Packets built that way are
completely non-linear and are likely being dropped without GRO.

This was tested on to-be-mainlined-soon Ethernet driver that uses
napi_gro_frags(), and the overall performance was on par with the
variant from [1], sometimes even better due to minimal overhead.
net.core.gro_normal_batch tuning may help to push it to the limit
on particular setups and platforms.

[1] https://lore.kernel.org/netdev/20191230143028.27313-1-alobakin@dlink.ru/

Signed-off-by: Alexander Lobakin <bloodyreaper@yandex.ru>
---
 net/dsa/Kconfig    |  1 +
 net/dsa/dsa.c      |  2 +-
 net/dsa/dsa_priv.h |  3 +++
 net/dsa/slave.c    | 10 +++++++++-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 92663dcb3aa2..739613070d07 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -9,6 +9,7 @@ menuconfig NET_DSA
 	tristate "Distributed Switch Architecture"
 	depends on HAVE_NET_DSA
 	depends on BRIDGE || BRIDGE=n
+	select GRO_CELLS
 	select NET_SWITCHDEV
 	select PHYLINK
 	select NET_DEVLINK
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index ee2610c4d46a..0384a911779e 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -234,7 +234,7 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (dsa_skb_defer_rx_timestamp(p, skb))
 		return 0;
 
-	netif_receive_skb(skb);
+	gro_cells_receive(&p->gcells, skb);
 
 	return 0;
 }
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 904cc7c9b882..6d9a1ef65fa0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/netpoll.h>
 #include <net/dsa.h>
+#include <net/gro_cells.h>
 
 enum {
 	DSA_NOTIFIER_AGEING_TIME,
@@ -77,6 +78,8 @@ struct dsa_slave_priv {
 
 	struct pcpu_sw_netstats	*stats64;
 
+	struct gro_cells	gcells;
+
 	/* DSA port data, such as switch, port index, etc. */
 	struct dsa_port		*dp;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5390ff541658..36c7491e8e5f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1762,6 +1762,11 @@ int dsa_slave_create(struct dsa_port *port)
 		free_netdev(slave_dev);
 		return -ENOMEM;
 	}
+
+	ret = gro_cells_init(&p->gcells, slave_dev);
+	if (ret)
+		goto out_free;
+
 	p->dp = port;
 	INIT_LIST_HEAD(&p->mall_tc_list);
 	p->xmit = cpu_dp->tag_ops->xmit;
@@ -1781,7 +1786,7 @@ int dsa_slave_create(struct dsa_port *port)
 	ret = dsa_slave_phy_setup(slave_dev);
 	if (ret) {
 		netdev_err(master, "error %d setting up slave phy\n", ret);
-		goto out_free;
+		goto out_gcells;
 	}
 
 	dsa_slave_notify(slave_dev, DSA_PORT_REGISTER);
@@ -1800,6 +1805,8 @@ int dsa_slave_create(struct dsa_port *port)
 	phylink_disconnect_phy(p->dp->pl);
 	rtnl_unlock();
 	phylink_destroy(p->dp->pl);
+out_gcells:
+	gro_cells_destroy(&p->gcells);
 out_free:
 	free_percpu(p->stats64);
 	free_netdev(slave_dev);
@@ -1820,6 +1827,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
 	unregister_netdev(slave_dev);
 	phylink_destroy(dp->pl);
+	gro_cells_destroy(&p->gcells);
 	free_percpu(p->stats64);
 	free_netdev(slave_dev);
 }
-- 
2.26.0

