Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99FF858B02
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfF0TnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:43:06 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:34121 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0TnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 15:43:05 -0400
Received: by mail-qk1-f201.google.com with SMTP id h198so3688989qke.1
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=L4qaAnZe4Ztf1cznBBEJGB9/EFFCE71pnMap9910TSE=;
        b=gkbqhG07O0Q4zmI01GDNaJVJ86oizZwselU1siybeml2dXn9iLkaTBNrD5PYHQuf1n
         aHk9ZWkNtl9fCI0g5LcDvQ/QqxKK9Zal3BnlYNI7vKiybcr59qyqEPJjyoQFe/EXoqgt
         +WgXziCKOyTsnisieU8KHUFBB8QWDoix5pUWRtb4NC0Py1tm27nlskI7K9H+SpO6B9Kq
         NRuCIsy89HFpjiRsR3L0qXfdIH75vK7GTu213XY+W7QRO/M2YMXf2WllM15LegTupiEU
         8VqmcHNRBrPQzFGD0Q2j89VoFP9oQxuP1K7B9i6AZIL8S83qK31kICAEVrIBj5u0fzPl
         5I1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=L4qaAnZe4Ztf1cznBBEJGB9/EFFCE71pnMap9910TSE=;
        b=WLKtC74OyCQhXr6cToYr9vhnbzQtn4PiqxqBscofun2w0gW2jq9GhETurANRNILf93
         jCeXx5UqWsequYTvS/Plb1YJnbNYS7lvrVMzbQzLagibOsdtWeqGaENhbPm/k/dFpo2w
         AapV6Abls2/XZ+tKev/u9zbAaAg/Gp0BfNteXcEfAO5vvvOclPkUKyFxO0E9x+C4xQVG
         XpJDsLlC306WdK6YticWySKocLizURt+lOKF6c4Bn+K8CjcLsf6ZOncpEbBC3/Ge5Esr
         7AdK1vw7d4l9qpnopH1UIuofphJEIQabrHDsk0z9HDBDMgg4RyBufaZNgFnmBoJsXQSr
         BWLQ==
X-Gm-Message-State: APjAAAVvE0bXa7CV3nqvG0JPqp1fLTIcLoTLrGAT311v3twcP3AinEKZ
        vkhYigiXcElUKzZ/GT+iHyZnqWUSs1pdGZMHHdTwNjuQXlPBZAJg7pyma+oEMgZWe8FltHXm/DK
        7ap/UjLLAIV0EuEEqRb27qaEoWwG9GaA1a/6LsSJGQYSqVrmDw9AB8uGstSCE3Zt5
X-Google-Smtp-Source: APXvYqyJG2c7UcnCyFuwJtGG6DYGIFQxBFh4MHlmXFUVqH+YmqhjdUvhs/ZYgeDcGQi1Grb81M79rC7YyHp6
X-Received: by 2002:a37:47d6:: with SMTP id u205mr5112007qka.214.1561664584420;
 Thu, 27 Jun 2019 12:43:04 -0700 (PDT)
Date:   Thu, 27 Jun 2019 12:43:00 -0700
Message-Id: <20190627194300.92202-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCHv2 next 1/3] loopback: create blackhole net device similar to loopack.
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a blackhole net device that can be used for "dead"
dst entries instead of loopback device. This blackhole device differs
from loopback in few aspects: (a) It's not per-ns. (b)  MTU on this
device is ETH_MIN_MTU (c) The xmit function is essentially kfree_skb().
and (d) since it's not registered it won't have ifindex.

Lower MTU effectively make the device not pass the MTU check during
the route check when a dst associated with the skb is dead.

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
v1->v2
  no change

 drivers/net/loopback.c    | 76 ++++++++++++++++++++++++++++++++++-----
 include/linux/netdevice.h |  2 ++
 2 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 87d361666cdd..3b39def5471e 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -55,6 +55,13 @@
 #include <net/net_namespace.h>
 #include <linux/u64_stats_sync.h>
 
+/* blackhole_netdev - a device used for dsts that are marked expired!
+ * This is global device (instead of per-net-ns) since it's not needed
+ * to be per-ns and gets initialized at boot time.
+ */
+struct net_device *blackhole_netdev;
+EXPORT_SYMBOL(blackhole_netdev);
+
 /* The higher levels take care of making this non-reentrant (it's
  * called with bh's disabled).
  */
@@ -150,12 +157,14 @@ static const struct net_device_ops loopback_ops = {
 	.ndo_set_mac_address = eth_mac_addr,
 };
 
-/* The loopback device is special. There is only one instance
- * per network namespace.
- */
-static void loopback_setup(struct net_device *dev)
+static void gen_lo_setup(struct net_device *dev,
+			 unsigned int mtu,
+			 const struct ethtool_ops *eth_ops,
+			 const struct header_ops *hdr_ops,
+			 const struct net_device_ops *dev_ops,
+			 void (*dev_destructor)(struct net_device *dev))
 {
-	dev->mtu		= 64 * 1024;
+	dev->mtu		= mtu;
 	dev->hard_header_len	= ETH_HLEN;	/* 14	*/
 	dev->min_header_len	= ETH_HLEN;	/* 14	*/
 	dev->addr_len		= ETH_ALEN;	/* 6	*/
@@ -174,11 +183,20 @@ static void loopback_setup(struct net_device *dev)
 		| NETIF_F_NETNS_LOCAL
 		| NETIF_F_VLAN_CHALLENGED
 		| NETIF_F_LOOPBACK;
-	dev->ethtool_ops	= &loopback_ethtool_ops;
-	dev->header_ops		= &eth_header_ops;
-	dev->netdev_ops		= &loopback_ops;
+	dev->ethtool_ops	= eth_ops;
+	dev->header_ops		= hdr_ops;
+	dev->netdev_ops		= dev_ops;
 	dev->needs_free_netdev	= true;
-	dev->priv_destructor	= loopback_dev_free;
+	dev->priv_destructor	= dev_destructor;
+}
+
+/* The loopback device is special. There is only one instance
+ * per network namespace.
+ */
+static void loopback_setup(struct net_device *dev)
+{
+	gen_lo_setup(dev, (64 * 1024), &loopback_ethtool_ops, &eth_header_ops,
+		     &loopback_ops, loopback_dev_free);
 }
 
 /* Setup and register the loopback device. */
@@ -213,3 +231,43 @@ static __net_init int loopback_net_init(struct net *net)
 struct pernet_operations __net_initdata loopback_net_ops = {
 	.init = loopback_net_init,
 };
+
+/* blackhole netdevice */
+static netdev_tx_t blackhole_netdev_xmit(struct sk_buff *skb,
+					 struct net_device *dev)
+{
+	kfree_skb(skb);
+	net_warn_ratelimited("%s(): Dropping skb.\n", __func__);
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops blackhole_netdev_ops = {
+	.ndo_start_xmit = blackhole_netdev_xmit,
+};
+
+/* This is a dst-dummy device used specifically for invalidated
+ * DSTs and unlike loopback, this is not per-ns.
+ */
+static void blackhole_netdev_setup(struct net_device *dev)
+{
+	gen_lo_setup(dev, ETH_MIN_MTU, NULL, NULL, &blackhole_netdev_ops, NULL);
+}
+
+/* Setup and register the blackhole_netdev. */
+static int __init blackhole_netdev_init(void)
+{
+	blackhole_netdev = alloc_netdev(0, "blackhole_dev", NET_NAME_UNKNOWN,
+					blackhole_netdev_setup);
+	if (!blackhole_netdev)
+		return -ENOMEM;
+
+	dev_init_scheduler(blackhole_netdev);
+	dev_activate(blackhole_netdev);
+
+	blackhole_netdev->flags |= IFF_UP | IFF_RUNNING;
+	dev_net_set(blackhole_netdev, &init_net);
+
+	return 0;
+}
+
+device_initcall(blackhole_netdev_init);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eeacebd7debb..88292953aa6f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4870,4 +4870,6 @@ do {								\
 #define PTYPE_HASH_SIZE	(16)
 #define PTYPE_HASH_MASK	(PTYPE_HASH_SIZE - 1)
 
+extern struct net_device *blackhole_netdev;
+
 #endif	/* _LINUX_NETDEVICE_H */
-- 
2.22.0.410.gd8fdbe21b5-goog

