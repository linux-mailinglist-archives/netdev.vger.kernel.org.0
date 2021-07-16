Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2943CB9EF
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbhGPPhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:37:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241022AbhGPPho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:37:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626449689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=azzTV7NVSdjWfH7vqRJWElEUXdLny7F98+w/WRshApo=;
        b=dMd1e4K2a9+NU/mb1yX1spWQjwvawiA9t8cu0qiXsNqFMahojt0fJrUWFaGdwu2GqX0B8u
        bnhacPgaYBt6XIpU7xsCaJSiDyOOFohi4v6EiQQvXniACsIOdxil1kr1plEJVpZ1UpIKl7
        imTFKrdZ0koZccUks/wWbu9k4lT+dmw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-gL09kQQcPSe2KcucTHOVyw-1; Fri, 16 Jul 2021 11:34:46 -0400
X-MC-Unique: gL09kQQcPSe2KcucTHOVyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0C88801B34;
        Fri, 16 Jul 2021 15:34:45 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-207.ams2.redhat.com [10.36.113.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B14F5C1A1;
        Fri, 16 Jul 2021 15:34:44 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, toke@redhat.com
Subject: [PATCH RFC v2 3/5] veth: implement support for set_channel ethtool op
Date:   Fri, 16 Jul 2021 17:34:21 +0200
Message-Id: <111ce5aebbd7fdfab5e091bbd37dcea1f5ae3f8d.1626449533.git.pabeni@redhat.com>
In-Reply-To: <cover.1626449533.git.pabeni@redhat.com>
References: <cover.1626449533.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change implements the set_channel() ethtool operation,
preserving the current defaults values and allowing up set
the number of queues in the range set ad device creation
time.

The update operation tries hard to leave the device in a
consistent status in case of errors.

RFC v1 -> RFC v2:
 - don't flip device status on set_channel()
 - roll-back the changes if possible on error - Jackub

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 125 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 123 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 9eb8c1034e98..ae869c097587 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -224,10 +224,13 @@ static void veth_get_channels(struct net_device *dev,
 {
 	channels->tx_count = dev->real_num_tx_queues;
 	channels->rx_count = dev->real_num_rx_queues;
-	channels->max_tx = dev->real_num_tx_queues;
-	channels->max_rx = dev->real_num_rx_queues;
+	channels->max_tx = dev->num_tx_queues;
+	channels->max_rx = dev->num_rx_queues;
 }
 
+static int veth_set_channels(struct net_device *dev,
+			     struct ethtool_channels *ch);
+
 static const struct ethtool_ops veth_ethtool_ops = {
 	.get_drvinfo		= veth_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
@@ -237,6 +240,7 @@ static const struct ethtool_ops veth_ethtool_ops = {
 	.get_link_ksettings	= veth_get_link_ksettings,
 	.get_ts_info		= ethtool_op_get_ts_info,
 	.get_channels		= veth_get_channels,
+	.set_channels		= veth_set_channels,
 };
 
 /* general routines */
@@ -1136,6 +1140,123 @@ static int veth_napi_enable(struct net_device *dev)
 	return veth_napi_enable_range(dev, 0, dev->real_num_rx_queues);
 }
 
+static void veth_disable_range_safe(struct net_device *dev, int start, int end)
+{
+	struct veth_priv *priv = netdev_priv(dev);
+
+	if (start >= end)
+		return;
+
+	if (priv->_xdp_prog) {
+		veth_napi_del_range(dev, start, end);
+		veth_disable_xdp_range(dev, start, end, false);
+	} else if (veth_gro_requested(dev)) {
+		veth_napi_del_range(dev, start, end);
+	}
+}
+
+static int veth_enable_range_safe(struct net_device *dev, int start, int end)
+{
+	struct veth_priv *priv = netdev_priv(dev);
+	int err;
+
+	if (start >= end)
+		return 0;
+
+	if (priv->_xdp_prog) {
+		/* these channels are freshly initialized, napi is not on there even
+		 * when GRO is requeste
+		 */
+		err = veth_enable_xdp_range(dev, start, end, false);
+		if (err)
+			return err;
+
+		err = __veth_napi_enable_range(dev, start, end);
+		if (err) {
+			/* on error always delete the newly added napis */
+			veth_disable_xdp_range(dev, start, end, true);
+			return err;
+		}
+	} else if (veth_gro_requested(dev)) {
+		return veth_napi_enable_range(dev, start, end);
+	}
+	return 0;
+}
+
+static int veth_set_channels(struct net_device *dev,
+			     struct ethtool_channels *ch)
+{
+	struct veth_priv *priv = netdev_priv(dev);
+	unsigned int old_rx_count, new_rx_count;
+	struct veth_priv *peer_priv;
+	struct net_device *peer;
+	int err;
+
+	/* sanity check. Upper bounds are already enforced by the caller */
+	if (!ch->rx_count || !ch->tx_count)
+		return -EINVAL;
+
+	/* avoid braking XDP, if that is enabled */
+	peer = rtnl_dereference(priv->peer);
+	peer_priv = peer ? netdev_priv(peer) : NULL;
+	if (priv->_xdp_prog && peer && ch->rx_count < peer->real_num_tx_queues)
+		return -EINVAL;
+
+	if (peer && peer_priv && peer_priv->_xdp_prog && ch->tx_count > peer->real_num_rx_queues)
+		return -EINVAL;
+
+	old_rx_count = dev->real_num_rx_queues;
+	new_rx_count = ch->rx_count;
+	if (netif_running(dev)) {
+		/* turn device off */
+		netif_carrier_off(dev);
+		if (peer)
+			netif_carrier_off(peer);
+
+		/* try to allocate new resurces, as needed*/
+		err = veth_enable_range_safe(dev, old_rx_count, new_rx_count);
+		if (err)
+			goto out;
+	}
+
+	err = netif_set_real_num_rx_queues(dev, ch->rx_count);
+	if (err)
+		goto revert;
+
+	err = netif_set_real_num_tx_queues(dev, ch->tx_count);
+	if (err) {
+		int err2 = netif_set_real_num_rx_queues(dev, old_rx_count);
+
+		/* this error condition could happen only if rx and tx change
+		 * in opposite directions (e.g. tx nr raises, rx nr decreases)
+		 * and we can't do anything to fully restore the original
+		 * status
+		 */
+		if (err2)
+			pr_warn("Can't restore rx queues config %d -> %d %d",
+				new_rx_count, old_rx_count, err2);
+		else
+			goto revert;
+	}
+
+out:
+	if (netif_running(dev)) {
+		/* note that we need to swap the arguments WRT the enable part
+		 * to identify the range we have to disable
+		 */
+		veth_disable_range_safe(dev, new_rx_count, old_rx_count);
+		netif_carrier_on(dev);
+		if (peer)
+			netif_carrier_on(peer);
+	}
+	return err;
+
+revert:
+	new_rx_count = old_rx_count;
+	old_rx_count = ch->rx_count;
+	goto out;
+}
+
 static int veth_open(struct net_device *dev)
 {
 	struct veth_priv *priv = netdev_priv(dev);
-- 
2.26.3

