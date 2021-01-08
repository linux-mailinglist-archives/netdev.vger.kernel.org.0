Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789072EEA53
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbhAHAV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729594AbhAHAVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:49 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2058C061285
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:40 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id t16so12105557ejf.13
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X3pmz+ujiBMI6GcrWzziu9yXfMvE0tJgnG+mRpoow8Q=;
        b=XPO+DCxGEexsr+zjEXkjzrXB3gMN2wx6upcZLYWB4zEc91CsK2MiUJugtayuWrSiIu
         9UPNu1rEpNyQihRyglPQMZJS7xtZiOwbX7j6r1CK6scHTYU/8Y9XnPFmeRKYpZpksbfA
         tIgAJWpJ+U4GADGxYeNTz+s5lVMSEGhJrsKkddYxgeTWx+cY5msWLtTZq0Iso0WTCqGw
         lBYQ/HprVPWAJfjodkgSkrmD9LsdFPnWKsd3f5v+QJ2oQ46G0Mqhx53cONLEHKrF3ctW
         DMely1s9f0H2uAszIUlB7nzVOUuCeTo+Ql+En35gODK7bREV5sIc0Nh3DZdFoh8P8VTw
         e3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X3pmz+ujiBMI6GcrWzziu9yXfMvE0tJgnG+mRpoow8Q=;
        b=iKdB1nVvd5SLoi+HC7DjPaqH9NoYUGGSg1WZu53lpa6H3mJuVomHp9mCv/RLmOVVuL
         /EkP4YtkZZyQT7ZANwymWUEvKw3kfsuWfjoy5AC9Iw1qiumR2xzNHKBkJ3ouMnftLs3l
         9VfpUa0HKcOiQdji87cjIsz26Y/rE3STrUXWNDOugP9N/jE8lWyh5Ca+36y8U8StYGKC
         76RLOT8XZdEcvb9FylqjAIaRolJF/aAb+GoD69tWQdsJ1fwjKV7GoqXZt3MAgcG283qm
         u3aIbIj8+Q5jq8tdYNa0b3QGvMqjpQovdP83njgor7JESn1/qH1UPaA/zy4Su4bcBk8E
         bsTg==
X-Gm-Message-State: AOAM531b1B2zXtofn9s0n7D/DV7OGSXDWWrp0SnmwoFw2OvOK5yU16W2
        3ixXkwJ+lvx3KTwCLJ689+4=
X-Google-Smtp-Source: ABdhPJypjzQFm4fZOweQ6j7Oere2HrX5b8yIFChMs7mX9kSdkkllnAt2q+P05ES51dCLlNZvOZyXjQ==
X-Received: by 2002:a17:906:f0c9:: with SMTP id dk9mr941748ejb.51.1610065239531;
        Thu, 07 Jan 2021 16:20:39 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 11/18] net: openvswitch: propagate errors from dev_get_stats
Date:   Fri,  8 Jan 2021 02:19:58 +0200
Message-Id: <20210108002005.3429956-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The dev_get_stats function can now return an error code, so the code
that retrieves vport statistics and sends them through netlink needs to
propagate that error code. Remove the drastic BUG_ON checks.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
Patch is new (Eric's suggestion).

 net/openvswitch/datapath.c | 20 ++++++++++++++------
 net/openvswitch/vport.c    | 10 ++++++++--
 net/openvswitch/vport.h    |  2 +-
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 9d6ef6cb9b26..5c60a23d0c27 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1987,7 +1987,10 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 			goto nla_put_failure;
 	}
 
-	ovs_vport_get_stats(vport, &vport_stats);
+	err = ovs_vport_get_stats(vport, &vport_stats);
+	if (err)
+		goto error;
+
 	if (nla_put_64bit(skb, OVS_VPORT_ATTR_STATS,
 			  sizeof(struct ovs_vport_stats), &vport_stats,
 			  OVS_VPORT_ATTR_PAD))
@@ -2028,7 +2031,8 @@ struct sk_buff *ovs_vport_cmd_build_info(struct vport *vport, struct net *net,
 
 	retval = ovs_vport_cmd_fill_info(vport, skb, net, portid, seq, 0, cmd,
 					 GFP_KERNEL);
-	BUG_ON(retval < 0);
+	if (retval)
+		return ERR_PTR(retval);
 
 	return skb;
 }
@@ -2173,6 +2177,8 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
+	if (err)
+		goto exit_unlock_free;
 
 	new_headroom = netdev_get_fwd_headroom(vport->dev);
 
@@ -2181,7 +2187,6 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	else
 		netdev_set_rx_headroom(vport->dev, dp->max_headroom);
 
-	BUG_ON(err < 0);
 	ovs_unlock();
 
 	ovs_notify(&dp_vport_genl_family, reply, info);
@@ -2234,7 +2239,8 @@ static int ovs_vport_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_SET, GFP_KERNEL);
-	BUG_ON(err < 0);
+	if (err)
+		goto exit_unlock_free;
 
 	ovs_unlock();
 	ovs_notify(&dp_vport_genl_family, reply, info);
@@ -2274,7 +2280,8 @@ static int ovs_vport_cmd_del(struct sk_buff *skb, struct genl_info *info)
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_DEL, GFP_KERNEL);
-	BUG_ON(err < 0);
+	if (err)
+		goto exit_unlock_free;
 
 	/* the vport deletion may trigger dp headroom update */
 	dp = vport->dp;
@@ -2321,7 +2328,8 @@ static int ovs_vport_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_GET, GFP_ATOMIC);
-	BUG_ON(err < 0);
+	if (err)
+		goto exit_unlock_free;
 	rcu_read_unlock();
 
 	return genlmsg_reply(reply, info);
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 215a818bf9ce..e66c949fd97a 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -267,11 +267,15 @@ void ovs_vport_del(struct vport *vport)
  *
  * Must be called with ovs_mutex or rcu_read_lock.
  */
-void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
+int ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
 {
 	struct rtnl_link_stats64 dev_stats;
+	int err;
+
+	err = dev_get_stats(vport->dev, &dev_stats);
+	if (err)
+		return err;
 
-	dev_get_stats(vport->dev, &dev_stats);
 	stats->rx_errors  = dev_stats.rx_errors;
 	stats->tx_errors  = dev_stats.tx_errors;
 	stats->tx_dropped = dev_stats.tx_dropped;
@@ -281,6 +285,8 @@ void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
 	stats->rx_packets = dev_stats.rx_packets;
 	stats->tx_bytes	  = dev_stats.tx_bytes;
 	stats->tx_packets = dev_stats.tx_packets;
+
+	return 0;
 }
 
 /**
diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 1eb7495ac5b4..8927ba5c491b 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -30,7 +30,7 @@ void ovs_vport_del(struct vport *);
 
 struct vport *ovs_vport_locate(const struct net *net, const char *name);
 
-void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
+int ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
 
 int ovs_vport_set_options(struct vport *, struct nlattr *options);
 int ovs_vport_get_options(const struct vport *, struct sk_buff *);
-- 
2.25.1

