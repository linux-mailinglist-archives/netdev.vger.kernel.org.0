Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EB72D537A
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 06:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732782AbgLJFxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 00:53:41 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:64054 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgLJFxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 00:53:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607579594; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=RX2ogzIEa4qWK40lF0tzLKbTuvmm8CS5Wm4w9kBCa00=; b=Mmbp7YwFGFTjEqVrqamptb7teG2j95Z9gmc7dPYASItgvXq+g+Tpj/ljgaiewOR0NIMGGJvI
 w+DogtmmG59u11Ugzqr0QX35MtRpfmorZ2ih3iqmL4XQI/xziKnlLhUj2w8a0R/e6e07uzCZ
 DdAUuZHqS0W0ZEezIJPo05JeF2U=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fd1b7a6a18369bfbb3d4fc0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 10 Dec 2020 05:52:38
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 57F35C433ED; Thu, 10 Dec 2020 05:52:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2E5C7C433CA;
        Thu, 10 Dec 2020 05:52:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2E5C7C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     loic.poulain@linaro.org, kuba@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net-next] net: qualcomm: rmnet: Update rmnet device MTU based on real device
Date:   Wed,  9 Dec 2020 22:51:46 -0700
Message-Id: <1607579506-3153-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packets sent by rmnet to the real device have variable MAP header
lengths based on the data format configured. This patch adds checks
to ensure that the real device MTU is sufficient to transmit the MAP
packet comprising of the MAP header and the IP packet. This check
is enforced when rmnet devices are created and updated and during
MTU updates of both the rmnet and real device.

Additionally, rmnet devices now have a default MTU configured which
accounts for the real device MTU and the headroom based on the data
format.

Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 15 ++++-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |  2 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    | 73 +++++++++++++++++++++-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h    |  3 +
 4 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index fcdecdd..8d51b0c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -26,7 +26,7 @@ static int rmnet_is_real_dev_registered(const struct net_device *real_dev)
 }
 
 /* Needs rtnl lock */
-static struct rmnet_port*
+struct rmnet_port*
 rmnet_get_port_rtnl(const struct net_device *real_dev)
 {
 	return rtnl_dereference(real_dev->rx_handler_data);
@@ -253,7 +253,10 @@ static int rmnet_config_notify_cb(struct notifier_block *nb,
 		netdev_dbg(real_dev, "Kernel unregister\n");
 		rmnet_force_unassociate_device(real_dev);
 		break;
-
+	case NETDEV_CHANGEMTU:
+		if (rmnet_vnd_validate_real_dev_mtu(real_dev))
+			return NOTIFY_BAD;
+		break;
 	default:
 		break;
 	}
@@ -329,9 +332,17 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	if (data[IFLA_RMNET_FLAGS]) {
 		struct ifla_rmnet_flags *flags;
+		u32 old_data_format;
 
+		old_data_format = port->data_format;
 		flags = nla_data(data[IFLA_RMNET_FLAGS]);
 		port->data_format = flags->flags & flags->mask;
+
+		if (rmnet_vnd_update_dev_mtu(port, real_dev)) {
+			port->data_format = old_data_format;
+			NL_SET_ERR_MSG_MOD(extack, "Invalid MTU on real dev");
+			return -EINVAL;
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index be51598..8d8d469 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -73,4 +73,6 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 		     struct netlink_ext_ack *extack);
 int rmnet_del_bridge(struct net_device *rmnet_dev,
 		     struct net_device *slave_dev);
+struct rmnet_port*
+rmnet_get_port_rtnl(const struct net_device *real_dev);
 #endif /* _RMNET_CONFIG_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index d58b51d..6cf46f8 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -58,9 +58,30 @@ static netdev_tx_t rmnet_vnd_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int rmnet_vnd_headroom(struct rmnet_port *port)
+{
+	u32 headroom;
+
+	headroom = sizeof(struct rmnet_map_header);
+
+	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
+		headroom += sizeof(struct rmnet_map_ul_csum_header);
+
+	return headroom;
+}
+
 static int rmnet_vnd_change_mtu(struct net_device *rmnet_dev, int new_mtu)
 {
-	if (new_mtu < 0 || new_mtu > RMNET_MAX_PACKET_SIZE)
+	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
+	struct rmnet_port *port;
+	u32 headroom;
+
+	port = rmnet_get_port_rtnl(priv->real_dev);
+
+	headroom = rmnet_vnd_headroom(port);
+
+	if (new_mtu < 0 || new_mtu > RMNET_MAX_PACKET_SIZE ||
+	    new_mtu > (priv->real_dev->mtu - headroom))
 		return -EINVAL;
 
 	rmnet_dev->mtu = new_mtu;
@@ -229,6 +250,7 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 
 {
 	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
+	u32 headroom;
 	int rc;
 
 	if (rmnet_get_endpoint(port, id)) {
@@ -242,6 +264,13 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 
 	priv->real_dev = real_dev;
 
+	headroom = rmnet_vnd_headroom(port);
+
+	if (rmnet_vnd_change_mtu(rmnet_dev, real_dev->mtu - headroom)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MTU on real dev");
+		return -EINVAL;
+	}
+
 	rc = register_netdevice(rmnet_dev);
 	if (!rc) {
 		ep->egress_dev = rmnet_dev;
@@ -283,3 +312,45 @@ int rmnet_vnd_do_flow_control(struct net_device *rmnet_dev, int enable)
 
 	return 0;
 }
+
+int rmnet_vnd_validate_real_dev_mtu(struct net_device *real_dev)
+{
+	struct hlist_node *tmp_ep;
+	struct rmnet_endpoint *ep;
+	struct rmnet_port *port;
+	unsigned long bkt_ep;
+	u32 headroom;
+
+	port = rmnet_get_port_rtnl(real_dev);
+
+	headroom = rmnet_vnd_headroom(port);
+
+	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
+		if (ep->egress_dev->mtu > (real_dev->mtu - headroom))
+			return -1;
+	}
+
+	return 0;
+}
+
+int rmnet_vnd_update_dev_mtu(struct rmnet_port *port,
+			     struct net_device *real_dev)
+{
+	struct hlist_node *tmp_ep;
+	struct rmnet_endpoint *ep;
+	unsigned long bkt_ep;
+	u32 headroom;
+
+	headroom = rmnet_vnd_headroom(port);
+
+	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
+		if (ep->egress_dev->mtu <= (real_dev->mtu - headroom))
+			continue;
+
+		if (rmnet_vnd_change_mtu(ep->egress_dev,
+					 real_dev->mtu - headroom))
+			return -1;
+	}
+
+	return 0;
+}
\ No newline at end of file
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
index 4967f34..dc3a444 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
@@ -18,4 +18,7 @@ int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
 void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev);
 void rmnet_vnd_setup(struct net_device *dev);
+int rmnet_vnd_validate_real_dev_mtu(struct net_device *real_dev);
+int rmnet_vnd_update_dev_mtu(struct rmnet_port *port,
+			     struct net_device *real_dev);
 #endif /* _RMNET_VND_H_ */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

