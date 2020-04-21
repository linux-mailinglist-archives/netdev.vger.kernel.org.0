Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D8C1B2837
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgDUNl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:41:29 -0400
Received: from forward104j.mail.yandex.net ([5.45.198.247]:47698 "EHLO
        forward104j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728337AbgDUNl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:41:29 -0400
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward104j.mail.yandex.net (Yandex) with ESMTP id 4E4314A20FC;
        Tue, 21 Apr 2020 16:41:21 +0300 (MSK)
Received: from mxback12q.mail.yandex.net (mxback12q.mail.yandex.net [IPv6:2a02:6b8:c0e:1b3:0:640:3818:d096])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id 460A9CF40002;
        Tue, 21 Apr 2020 16:41:21 +0300 (MSK)
Received: from vla4-d1b041059520.qloud-c.yandex.net (vla4-d1b041059520.qloud-c.yandex.net [2a02:6b8:c17:914:0:640:d1b0:4105])
        by mxback12q.mail.yandex.net (mxback/Yandex) with ESMTP id 93xlLFHrpE-fIB0fnjQ;
        Tue, 21 Apr 2020 16:41:21 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1587476481;
        bh=xCogxVJggB4U0WxqK21fNHt81GXV7XMyn6/5t3LcMbA=;
        h=Subject:To:From:Cc:Date:Message-Id;
        b=h8iyN+76zznVlaSgkJSHKBzd+V/7zOQG160+7quNxObd2jljOUq6wQchjPfcyKg0K
         thZ5XwDNLtpkM4Md/ngAUb5yr4YWuraTezhtDrcr2yzM3Gf+apfwx80soLY+5PacVo
         zC8b3m2igt0SSBbBj4jIojJ1w5FqtG9xXL0ulWEc=
Authentication-Results: mxback12q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla4-d1b041059520.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id X5d09Yh5QJ-fG2W9Rr2;
        Tue, 21 Apr 2020 16:41:17 +0300
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
Subject: [PATCH v2 net-next] net: dsa: add GRO support via gro_cells
Date:   Tue, 21 Apr 2020 16:41:08 +0300
Message-Id: <20200421134108.167646-1-bloodyreaper@yandex.ru>
X-Mailer: git-send-email 2.26.2
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

iperf3 IPoE VLAN NAT TCP forwarding (port1.218 -> port0) setup
on 1.2 GHz MIPS board:

5.7-rc2 baseline:

[ID]  Interval         Transfer     Bitrate        Retr
[ 5]  0.00-120.01 sec  9.00 GBytes  644 Mbits/sec  413  sender
[ 5]  0.00-120.00 sec  8.99 GBytes  644 Mbits/sec       receiver

Iface      RX packets  TX packets
eth0       7097731     7097702
port0      426050      6671829
port1      6671681     425862
port1.218  6671677     425851

With this patch:

[ID]  Interval         Transfer     Bitrate        Retr
[ 5]  0.00-120.01 sec  12.2 GBytes  870 Mbits/sec  122  sender
[ 5]  0.00-120.00 sec  12.2 GBytes  870 Mbits/sec       receiver

Iface      RX packets  TX packets
eth0       9474792     9474777
port0      455200      353288
port1      9019592     455035
port1.218  353144      455024

v2:
 - Add some performance examples in the commit message;
 - No functional changes.

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

