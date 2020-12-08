Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DAE2D25BB
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 09:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgLHIUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 03:20:12 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:44521 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbgLHIUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 03:20:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607415586; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Xw4vtPIy3/C8gYiFNPdL60ENnFaxPVuGS5QpO5sVl/A=;
 b=EB72SLemDHR0ZcQS7jHDd3QYEW7B0T2XFTlt0pCBXrdibWY1yzZ+hO0p5Bnh7ZvYwRURuOvP
 n7lAqaZx3fW8J7vmm5JxywFqZ/dlwj76pFjozEoCnTzGiVS55F/qNvW1Ak8qZmn/5LOtcfX/
 4197pDZ0BXkfK/Z/XnbaY6FIJf8=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fcf36fedc0fd8a31764d9d6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 08 Dec 2020 08:19:10
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4AFCCC43462; Tue,  8 Dec 2020 08:19:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4CBF1C433CA;
        Tue,  8 Dec 2020 08:19:09 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 08 Dec 2020 01:19:09 -0700
From:   subashab@codeaurora.org
To:     Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     stranche@codeaurora.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: rmnet: Adjust virtual device MTU on real device
 capability
In-Reply-To: <20201207121654.17fac0ef@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <1607017240-10582-1-git-send-email-loic.poulain@linaro.org>
 <3a2ca2c269911de71df6dca2e981f7fe@codeaurora.org>
 <CAMZdPi-Nrus0JrHpjg02QaVwr0TKGU=p96BjXAtd4LALAvk2HQ@mail.gmail.com>
 <20201207121654.17fac0ef@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Message-ID: <c7be03c227efc3405f4c9cd14e52d061@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> What about just returning an error on NETDEV_PRECHANGEMTU notification
>> to prevent real device MTU change while virtual rmnet devices are
>> linked? Not sure there is a more proper and thread safe way to manager
>> that otherwise.
> 
> Can't you copy what vlan devices do?  That'd seem like a reasonable and
> well tested precedent, no?

Could you try this patch. I've tried addressing most of the conditions 
here.
I haven't seen any issues with updating the MTU when rmnet devices are 
linked.

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c 
b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index fcdecdd..8d51b0c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -26,7 +26,7 @@ static int rmnet_is_real_dev_registered(const struct 
net_device *real_dev)
  }

  /* Needs rtnl lock */
-static struct rmnet_port*
+struct rmnet_port*
  rmnet_get_port_rtnl(const struct net_device *real_dev)
  {
  	return rtnl_dereference(real_dev->rx_handler_data);
@@ -253,7 +253,10 @@ static int rmnet_config_notify_cb(struct 
notifier_block *nb,
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
@@ -329,9 +332,17 @@ static int rmnet_changelink(struct net_device *dev, 
struct nlattr *tb[],

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
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h 
b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
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
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c 
b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index d58b51d..df87883 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -58,9 +58,30 @@ static netdev_tx_t rmnet_vnd_start_xmit(struct 
sk_buff *skb,
  	return NETDEV_TX_OK;
  }

+static int rmnet_vnd_headroom(struct net_device *real_dev)
+{
+	struct rmnet_port *port;
+	u32 headroom;
+
+	port = rmnet_get_port_rtnl(real_dev);
+
+	headroom = sizeof(struct rmnet_map_header);
+
+	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
+		headroom += sizeof(struct rmnet_map_dl_csum_trailer);
+
+	return headroom;
+}
+
  static int rmnet_vnd_change_mtu(struct net_device *rmnet_dev, int 
new_mtu)
  {
-	if (new_mtu < 0 || new_mtu > RMNET_MAX_PACKET_SIZE)
+	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
+	u32 headroom;
+
+	headroom = rmnet_vnd_headroom(priv->real_dev);
+
+	if (new_mtu < 0 || new_mtu > RMNET_MAX_PACKET_SIZE ||
+	    new_mtu > (priv->real_dev->mtu - headroom))
  		return -EINVAL;

  	rmnet_dev->mtu = new_mtu;
@@ -229,6 +250,7 @@ int rmnet_vnd_newlink(u8 id, struct net_device 
*rmnet_dev,

  {
  	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
+	u32 headroom;
  	int rc;

  	if (rmnet_get_endpoint(port, id)) {
@@ -242,6 +264,13 @@ int rmnet_vnd_newlink(u8 id, struct net_device 
*rmnet_dev,

  	priv->real_dev = real_dev;

+	headroom = rmnet_vnd_headroom(real_dev);
+
+	if (rmnet_vnd_change_mtu(rmnet_dev, real_dev->mtu - headroom)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MTU on real dev");
+		return -EINVAL;
+	}
+
  	rc = register_netdevice(rmnet_dev);
  	if (!rc) {
  		ep->egress_dev = rmnet_dev;
@@ -283,3 +312,51 @@ int rmnet_vnd_do_flow_control(struct net_device 
*rmnet_dev, int enable)

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
+	headroom = sizeof(struct rmnet_map_header);
+
+	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
+		headroom += sizeof(struct rmnet_map_dl_csum_trailer);
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
+	headroom = sizeof(struct rmnet_map_header);
+
+	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
+		headroom += sizeof(struct rmnet_map_dl_csum_trailer);
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
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h 
b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
