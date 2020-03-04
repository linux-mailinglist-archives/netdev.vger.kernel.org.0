Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E5178BF0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 08:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgCDHvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 02:51:11 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41655 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbgCDHvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 02:51:10 -0500
Received: by mail-pg1-f193.google.com with SMTP id b1so591268pgm.8
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 23:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H7LQCEqt6NvHP53teXnGz80fzxZjlYC/5O57fuXLeas=;
        b=fwF9HBqUN9ODfGaj+0RVOQyRKmB+z8dfpt9d9Nwl9n1RiHkEkXwg3fiOHfC0mUffL+
         5x+UvjUabUd10NZ85tsC8kLaMvp5fLmAyBs+2ekSftS0Yw109BEA9Q6oWxLqY8E4V/KV
         TtaTkUqaRneSHt7XffDk7v2lA10RYiqzzV52eJAMQXNpIUJZw4Htt8NcyJ9iFh2NbWpW
         UjREepKDmAS0kG3eflC1cbZHeoWG10NG9ZsapbwmfNHXLGnnV8Bie5HPqhNBXQpnXLRU
         8EFdKR9BBa95fwOqiheavEoNsKBiPVK0/v0SjS8p0fv4RPKqIq+thjj9I5WvC3tmFeGU
         i2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H7LQCEqt6NvHP53teXnGz80fzxZjlYC/5O57fuXLeas=;
        b=YPwT+Lyx0pwZ0GlOxMGQR51DZbk950Sjqe9xBqoBFn9N8YlJA2FPPjQw5HLCSNgWl0
         R5NJU26fLodfBExoMEo3jCXvA3/9x9aEvh5agJC5la37rVPEnJQgUUXjEGTDR5z4nV/V
         ZWAQ0YcrN2mKoD+I/UcQ9tyJj5Okk8eoNGVvgIBT9y1siaua35EpbjAenWPTYP5yWar/
         1apyrjPCB//vd1VFB4I5GdRqriJXl7sHMdYkPGjsFkVQ7HxV1UewwJEImUBIoxBCC6DP
         H2GnSKwU2Orc4e+/LzmPTB7/sCj1t8L4AV6Y7RpPAcNdFvZIm8HlPujmOMfSTi4dpELA
         VbIg==
X-Gm-Message-State: ANhLgQ1exHkiwNg0naS940H24VRtjt7ciInKYEmjjDKEOUwBX5NOdgcg
        Nai4I0qC6R1GCZOJxcXkJfE=
X-Google-Smtp-Source: ADFU+vtnjaqhrY0NiZtcy4Cw66RdnsB5RHZgd8XIC9fzr8h1HrrlwFcLV+UZDzv327vmo/CMur0gSQ==
X-Received: by 2002:aa7:99c5:: with SMTP id v5mr1911100pfi.198.1583308269117;
        Tue, 03 Mar 2020 23:51:09 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id x66sm15569759pgb.9.2020.03.03.23.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 23:51:08 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 2/3] net: rmnet: print error message when command fails
Date:   Wed,  4 Mar 2020 07:51:02 +0000
Message-Id: <20200304075102.23430-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rmnet netlink command fails, it doesn't print any error message.
So, users couldn't know the exact reason.
In order to tell the exact reason to the user, the extack error message
is used in this patch.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 31 +++++++++++++------
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 11 ++++---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |  3 +-
 3 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index d846a0ccea8f..c2fee2b1e8e4 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -122,11 +122,10 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 	}
 
 	real_dev = __dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
-	if (!real_dev || !dev)
+	if (!real_dev) {
+		NL_SET_ERR_MSG_MOD(extack, "link does not exist");
 		return -ENODEV;
-
-	if (!data[IFLA_RMNET_MUX_ID])
-		return -EINVAL;
+	}
 
 	ep = kzalloc(sizeof(*ep), GFP_ATOMIC);
 	if (!ep)
@@ -139,7 +138,7 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 		goto err0;
 
 	port = rmnet_get_port_rtnl(real_dev);
-	err = rmnet_vnd_newlink(mux_id, dev, port, real_dev, ep);
+	err = rmnet_vnd_newlink(mux_id, dev, port, real_dev, ep, extack);
 	if (err)
 		goto err1;
 
@@ -263,12 +262,16 @@ static int rmnet_rtnl_validate(struct nlattr *tb[], struct nlattr *data[],
 {
 	u16 mux_id;
 
-	if (!data || !data[IFLA_RMNET_MUX_ID])
+	if (!data || !data[IFLA_RMNET_MUX_ID]) {
+		NL_SET_ERR_MSG_MOD(extack, "MUX ID not specifies");
 		return -EINVAL;
+	}
 
 	mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
-	if (mux_id > (RMNET_MAX_LOGICAL_EP - 1))
+	if (mux_id > (RMNET_MAX_LOGICAL_EP - 1)) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid MUX ID");
 		return -ERANGE;
+	}
 
 	return 0;
 }
@@ -406,14 +409,22 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 	/* If there is more than one rmnet dev attached, its probably being
 	 * used for muxing. Skip the briding in that case
 	 */
-	if (port->nr_rmnet_devs > 1)
+	if (port->nr_rmnet_devs > 1) {
+		NL_SET_ERR_MSG_MOD(extack, "more than one rmnet dev attached");
 		return -EINVAL;
+	}
 
-	if (port->rmnet_mode != RMNET_EPMODE_VND)
+	if (port->rmnet_mode != RMNET_EPMODE_VND) {
+		NL_SET_ERR_MSG_MOD(extack, "bridge device already exists");
 		return -EINVAL;
+	}
+
+	if (rmnet_is_real_dev_registered(slave_dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "dev is already attached another rmnet dev");
 
-	if (rmnet_is_real_dev_registered(slave_dev))
 		return -EBUSY;
+	}
 
 	err = rmnet_register_real_device(slave_dev);
 	if (err)
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 26ad40f19c64..d7c52e398e4a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -222,16 +222,17 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		      struct rmnet_port *port,
 		      struct net_device *real_dev,
-		      struct rmnet_endpoint *ep)
+		      struct rmnet_endpoint *ep,
+		      struct netlink_ext_ack *extack)
+
 {
 	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
 	int rc;
 
-	if (ep->egress_dev)
-		return -EINVAL;
-
-	if (rmnet_get_endpoint(port, id))
+	if (rmnet_get_endpoint(port, id)) {
+		NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
 		return -EBUSY;
+	}
 
 	rmnet_dev->hw_features = NETIF_F_RXCSUM;
 	rmnet_dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
index 14d77c709d4a..4967f3461ed1 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
@@ -11,7 +11,8 @@ int rmnet_vnd_do_flow_control(struct net_device *dev, int enable);
 int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		      struct rmnet_port *port,
 		      struct net_device *real_dev,
-		      struct rmnet_endpoint *ep);
+		      struct rmnet_endpoint *ep,
+		      struct netlink_ext_ack *extack);
 int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 		      struct rmnet_endpoint *ep);
 void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
-- 
2.17.1

