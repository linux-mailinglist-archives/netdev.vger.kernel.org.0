Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3753368D8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhCKAgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:46 -0500
Received: from correo.us.es ([193.147.175.20]:50052 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhCKAgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 96B5212E82A
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87F76DA78B
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:17 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7CA52DA73D; Thu, 11 Mar 2021 01:36:17 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2CFB6DA704;
        Thu, 11 Mar 2021 01:36:15 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:15 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id EE4CB42DC6E2;
        Thu, 11 Mar 2021 01:36:14 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 05/23] net: ppp: resolve forwarding path for bridge pppoe devices
Date:   Thu, 11 Mar 2021 01:35:46 +0100
Message-Id: <20210311003604.22199-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Pass on the PPPoE session ID, destination hardware address and the real
device.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ppp/ppp_generic.c | 22 ++++++++++++++++++++++
 drivers/net/ppp/pppoe.c       | 23 +++++++++++++++++++++++
 include/linux/netdevice.h     |  2 ++
 include/linux/ppp_channel.h   |  3 +++
 4 files changed, 50 insertions(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index d445ecb1d0c7..930e49ef15f6 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1560,12 +1560,34 @@ static void ppp_dev_priv_destructor(struct net_device *dev)
 		ppp_destroy_interface(ppp);
 }
 
+static int ppp_fill_forward_path(struct net_device_path_ctx *ctx,
+				 struct net_device_path *path)
+{
+	struct ppp *ppp = netdev_priv(ctx->dev);
+	struct ppp_channel *chan;
+	struct channel *pch;
+
+	if (ppp->flags & SC_MULTILINK)
+		return -EOPNOTSUPP;
+
+	if (list_empty(&ppp->channels))
+		return -ENODEV;
+
+	pch = list_first_entry(&ppp->channels, struct channel, clist);
+	chan = pch->chan;
+	if (!chan->ops->fill_forward_path)
+		return -EOPNOTSUPP;
+
+	return chan->ops->fill_forward_path(ctx, path, chan);
+}
+
 static const struct net_device_ops ppp_netdev_ops = {
 	.ndo_init	 = ppp_dev_init,
 	.ndo_uninit      = ppp_dev_uninit,
 	.ndo_start_xmit  = ppp_start_xmit,
 	.ndo_do_ioctl    = ppp_net_ioctl,
 	.ndo_get_stats64 = ppp_get_stats64,
+	.ndo_fill_forward_path = ppp_fill_forward_path,
 };
 
 static struct device_type ppp_type = {
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index d7f50b835050..6c72d74827b2 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -972,8 +972,31 @@ static int pppoe_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	return __pppoe_xmit(sk, skb);
 }
 
+static int pppoe_fill_forward_path(struct net_device_path_ctx *ctx,
+				   struct net_device_path *path,
+				   const struct ppp_channel *chan)
+{
+	struct sock *sk = (struct sock *)chan->private;
+	struct pppox_sock *po = pppox_sk(sk);
+	struct net_device *dev = po->pppoe_dev;
+
+	if (sock_flag(sk, SOCK_DEAD) ||
+	    !(sk->sk_state & PPPOX_CONNECTED) || !dev)
+		return -1;
+
+	path->type = DEV_PATH_PPPOE;
+	path->encap.proto = htons(ETH_P_PPP_SES);
+	path->encap.id = be16_to_cpu(po->num);
+	memcpy(path->encap.h_dest, po->pppoe_pa.remote, ETH_ALEN);
+	path->dev = ctx->dev;
+	ctx->dev = dev;
+
+	return 0;
+}
+
 static const struct ppp_channel_ops pppoe_chan_ops = {
 	.start_xmit = pppoe_xmit,
+	.fill_forward_path = pppoe_fill_forward_path,
 };
 
 static int pppoe_recvmsg(struct socket *sock, struct msghdr *m,
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8159be6c9aa7..c8917eb1adac 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -835,6 +835,7 @@ enum net_device_path_type {
 	DEV_PATH_ETHERNET = 0,
 	DEV_PATH_VLAN,
 	DEV_PATH_BRIDGE,
+	DEV_PATH_PPPOE,
 };
 
 struct net_device_path {
@@ -844,6 +845,7 @@ struct net_device_path {
 		struct {
 			u16		id;
 			__be16		proto;
+			u8		h_dest[ETH_ALEN];
 		} encap;
 		struct {
 			enum {
diff --git a/include/linux/ppp_channel.h b/include/linux/ppp_channel.h
index 98966064ee68..91f9a928344e 100644
--- a/include/linux/ppp_channel.h
+++ b/include/linux/ppp_channel.h
@@ -28,6 +28,9 @@ struct ppp_channel_ops {
 	int	(*start_xmit)(struct ppp_channel *, struct sk_buff *);
 	/* Handle an ioctl call that has come in via /dev/ppp. */
 	int	(*ioctl)(struct ppp_channel *, unsigned int, unsigned long);
+	int	(*fill_forward_path)(struct net_device_path_ctx *,
+				     struct net_device_path *,
+				     const struct ppp_channel *);
 };
 
 struct ppp_channel {
-- 
2.20.1

