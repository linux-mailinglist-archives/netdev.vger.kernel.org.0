Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 394A512D0AC
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfL3Obq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:31:46 -0500
Received: from fd.dlink.ru ([178.170.168.18]:39822 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfL3Obq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:31:46 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 416111B2189B; Mon, 30 Dec 2019 17:31:43 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 416111B2189B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716303; bh=GSv5uxS8JB5ZFL1df4FA5xdldqWieg3v4SkX8gUq2MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=mqnQsIA+caFid+jH4yK8H0odndwsP0uIaIt8YUT+ukX7t/jLzShPmdY9kPh98ogfG
         rZDnSwhTDruv0lx/leNjumvsjn2gDn9WA1DtUHSzdXNW22oX1jfYoBadbs2zpLOjML
         9jbuUhalzrWEC4jgmQpxwJsEEQTQkGcb9myd2l+A=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 286831B20805;
        Mon, 30 Dec 2019 17:31:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 286831B20805
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 71F111B229CB;
        Mon, 30 Dec 2019 17:31:05 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:05 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 02/19] net: dsa: add GRO support infrastructure
Date:   Mon, 30 Dec 2019 17:30:10 +0300
Message-Id: <20191230143028.27313-3-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add .gro_receive() (with shortcut) and .gro_complete() callbacks to
tagger ops and basic ETH_P_XDSA packet_offload with wrappers around
them, so DSA-tagged frames can now be processed within GRO layer if
the particular tagger implements this (will be added in subsequent
patches).

Note: no need to take RCU read locks in dsa_gro_receive() and
dsa_gro_complete() as dev->cpu_dp is not RCU-protected, at least
for now. The corresponding locks must be taken in the actual
tagger callbacks.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 include/net/dsa.h |  5 +++++
 net/dsa/dsa.c     | 43 +++++++++++++++++++++++++++++++++++++++++--
 net/dsa/dsa2.c    |  1 +
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 633d9894ab87..8a7f80709d51 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -79,6 +79,9 @@ struct dsa_device_ops {
 	 * as regular on the master net device.
 	 */
 	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
+	struct sk_buff *(*gro_receive)(struct list_head *head,
+				       struct sk_buff *skb);
+	int (*gro_complete)(struct sk_buff *skb, int nhoff);
 	unsigned int overhead;
 	const char *name;
 	enum dsa_tag_protocol proto;
@@ -170,6 +173,8 @@ struct dsa_port {
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt);
 	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
+	struct sk_buff *(*gro_receive)(struct list_head *head,
+				       struct sk_buff *skb);
 
 	enum {
 		DSA_PORT_TYPE_UNUSED = 0,
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 17281fec710c..9a8d8ce7473c 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -243,6 +243,34 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
+static struct sk_buff *dsa_gro_receive(struct list_head *head,
+				       struct sk_buff *skb)
+{
+	const struct dsa_port *cpu_dp = skb->dev->dsa_ptr;
+	struct sk_buff *pp = NULL;
+	int flush = 1;
+
+	if (unlikely(!cpu_dp) || !cpu_dp->gro_receive)
+		goto flush;
+
+	pp = cpu_dp->gro_receive(head, skb);
+	flush = 0;
+
+flush:
+	skb_gro_flush_final(skb, pp, flush);
+	return pp;
+}
+
+static int dsa_gro_complete(struct sk_buff *skb, int nhoff)
+{
+	const struct dsa_port *cpu_dp = skb->dev->dsa_ptr;
+
+	if (likely(cpu_dp) && cpu_dp->tag_ops->gro_complete)
+		return cpu_dp->tag_ops->gro_complete(skb, nhoff);
+
+	return -ENOENT;
+}
+
 #ifdef CONFIG_PM_SLEEP
 static bool dsa_is_port_initialized(struct dsa_switch *ds, int p)
 {
@@ -298,8 +326,17 @@ EXPORT_SYMBOL_GPL(dsa_switch_resume);
 #endif
 
 static struct packet_type dsa_pack_type __read_mostly = {
-	.type	= cpu_to_be16(ETH_P_XDSA),
-	.func	= dsa_switch_rcv,
+	.type		= htons(ETH_P_XDSA),
+	.func		= dsa_switch_rcv,
+};
+
+static struct packet_offload dsa_pack_offload __read_mostly = {
+	.type		= htons(ETH_P_XDSA),
+	.priority	= 10,
+	.callbacks	= {
+		.gro_receive	= dsa_gro_receive,
+		.gro_complete	= dsa_gro_complete,
+	},
 };
 
 static struct workqueue_struct *dsa_owq;
@@ -430,6 +467,7 @@ static int __init dsa_init_module(void)
 		goto register_notifier_fail;
 
 	dev_add_pack(&dsa_pack_type);
+	dev_add_offload(&dsa_pack_offload);
 
 	dsa_tag_driver_register(&DSA_TAG_DRIVER_NAME(none_ops),
 				THIS_MODULE);
@@ -448,6 +486,7 @@ static void __exit dsa_cleanup_module(void)
 	dsa_tag_driver_unregister(&DSA_TAG_DRIVER_NAME(none_ops));
 
 	dsa_slave_unregister_notifier();
+	dev_remove_offload(&dsa_pack_offload);
 	dev_remove_pack(&dsa_pack_type);
 	destroy_workqueue(dsa_owq);
 }
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c66abbed4daf..5f66e0280e8e 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -631,6 +631,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 	}
 
 	dp->type = DSA_PORT_TYPE_CPU;
+	dp->gro_receive = tag_ops->gro_receive;
 	dp->filter = tag_ops->filter;
 	dp->rcv = tag_ops->rcv;
 	dp->tag_ops = tag_ops;
-- 
2.24.1

