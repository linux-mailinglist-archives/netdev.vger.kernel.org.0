Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B7F3CBA00
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbhGPPkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:40:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235486AbhGPPiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626449754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HxPT38iVWdFLwRh86x5TFPqsSIEZeXMoQhmGF21B+Y8=;
        b=YacA/MXzb+fusdxR4GFS+JXqdSgq5F873f9bPPzqSeT8WfNBAIO1UY/0lQAsh/EwmNZi0c
        VuB3dpbK9amto41jHbCgEk5TYb4d3JKMkroPl/sAyGioJZ0t2JRxKC2RsrLe1Y+01RRynP
        mPcmF+hwuUmOAJFFCU77/zboDpBGBn4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-5AKqw6aRMq6lljEOiYbjlQ-1; Fri, 16 Jul 2021 11:34:49 -0400
X-MC-Unique: 5AKqw6aRMq6lljEOiYbjlQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56167192296E;
        Fri, 16 Jul 2021 15:34:47 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-207.ams2.redhat.com [10.36.113.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 109D25C1A3;
        Fri, 16 Jul 2021 15:34:45 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, toke@redhat.com
Subject: [PATCH RFC v2 4/5] veth: create by default nr_possible_cpus queues
Date:   Fri, 16 Jul 2021 17:34:22 +0200
Message-Id: <4e1de423e38765b7d1918450daa009b74db4ebe9.1626449533.git.pabeni@redhat.com>
In-Reply-To: <cover.1626449533.git.pabeni@redhat.com>
References: <cover.1626449533.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows easier XDP usage. The number of default active
queues is not changed: 1 RX and 1 TX so that this does
not introduce overhead on the datapath for queue selection.

v1 -> v2:
 - drop the module parameter, force default to nr_possible_cpus - Toke

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
note: I think here a kernel module parameter to make the default
num_{r,t}x_queues configurable could be worthy...
---
 drivers/net/veth.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ae869c097587..381670c08ba7 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1609,6 +1609,23 @@ static void veth_disable_gro(struct net_device *dev)
 	netdev_update_features(dev);
 }
 
+static int veth_init_queues(struct net_device *dev, struct nlattr *tb[])
+{
+	int err;
+
+	if (!tb[IFLA_NUM_TX_QUEUES] && dev->num_tx_queues > 1) {
+		err = netif_set_real_num_tx_queues(dev, 1);
+		if (err)
+			return err;
+	}
+	if (!tb[IFLA_NUM_RX_QUEUES] && dev->num_rx_queues > 1) {
+		err = netif_set_real_num_rx_queues(dev, 1);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static int veth_newlink(struct net *src_net, struct net_device *dev,
 			struct nlattr *tb[], struct nlattr *data[],
 			struct netlink_ext_ack *extack)
@@ -1718,13 +1735,21 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 
 	priv = netdev_priv(dev);
 	rcu_assign_pointer(priv->peer, peer);
+	err = veth_init_queues(dev, tb);
+	if (err)
+		goto err_queues;
 
 	priv = netdev_priv(peer);
 	rcu_assign_pointer(priv->peer, dev);
+	err = veth_init_queues(peer, tb);
+	if (err)
+		goto err_queues;
 
 	veth_disable_gro(dev);
 	return 0;
 
+err_queues:
+	unregister_netdevice(dev);
 err_register_dev:
 	/* nothing to do */
 err_configure_peer:
@@ -1770,6 +1795,16 @@ static struct net *veth_get_link_net(const struct net_device *dev)
 	return peer ? dev_net(peer) : dev_net(dev);
 }
 
+static unsigned int veth_get_num_queues(void)
+{
+	/* enforce the same queue limit as rtnl_create_link */
+	int queues = num_possible_cpus();
+
+	if (queues > 4096)
+		queues = 4096;
+	return queues;
+}
+
 static struct rtnl_link_ops veth_link_ops = {
 	.kind		= DRV_NAME,
 	.priv_size	= sizeof(struct veth_priv),
@@ -1780,6 +1815,8 @@ static struct rtnl_link_ops veth_link_ops = {
 	.policy		= veth_policy,
 	.maxtype	= VETH_INFO_MAX,
 	.get_link_net	= veth_get_link_net,
+	.get_num_tx_queues	= veth_get_num_queues,
+	.get_num_rx_queues	= veth_get_num_queues,
 };
 
 /*
-- 
2.26.3

