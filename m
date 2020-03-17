Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765B918832F
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 13:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCQMJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 08:09:55 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41340 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgCQMJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 08:09:54 -0400
Received: by mail-lf1-f68.google.com with SMTP id u26so4699028lfu.8
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 05:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YBMtaydtMsUyjN0wuzRBrD9zMyV40susRIgvtFGzgDM=;
        b=HtCfsHD2ip/yn9NfToMIjSXno04bPTqe0tHzIMe1I+8ZseVbkmq7NMZ7MMKR+qICQE
         9MIR1cYE9FGSPWqpA2O2N5fgjtg2RXT8y3rkfnpK2mYh2xvQo6+OFjnXd4xAft3pw55/
         /TOdDRNeALlxrZ9hJfLJEh6pEpA9P+QTFBpG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YBMtaydtMsUyjN0wuzRBrD9zMyV40susRIgvtFGzgDM=;
        b=MfGVKdZi3W//e30yblSQ4L3wbKhK4Yxc8bsTWValJBlOLejsNUs0d15IC9nkqkf9jB
         hE1QB8f+bPsSVJiTUszk5D2ksbnRtA2yz2CyBXaC/Tjyg8RIUJ6Bfyzcl5MTzRQNs9IJ
         eM7Ng/3qc+Gv0P26tJoez9CK4rLztDyFhohYc7RVxx6s/2Ja1QKkp8l3h/FUEmw2ZD9N
         wvnkusVFJ4zc5nBfQM49OdWarbd24kBFiydsmMVJyD0M0yJFwr9Pb6lO8lRbdVSO8u6B
         wxCwxLJMM82H7CoViCTd10O8BCQH6KEdFEmtIWtFNpdaNOpOL0MOUFF1gTeZip6+J5+4
         xiDg==
X-Gm-Message-State: ANhLgQ1aLo+a9xAjMw+QvFCNfwUV1KNdkQsGT3IiFbvl6aAgpvZ3Q+bS
        3+EeK9Cd9hUtrNKs3rTtqG3HOvAfkvY=
X-Google-Smtp-Source: ADFU+vubEYpzyVIGzs5ne4K0zVZCwChJqGTPQgUpweCXQpsnETlXu4Wt7/LNmg3KzFjaOAfiRm9f3Q==
X-Received: by 2002:ac2:5925:: with SMTP id v5mr2742225lfi.29.1584446991610;
        Tue, 17 Mar 2020 05:09:51 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 23sm2389208lfa.28.2020.03.17.05.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 05:09:40 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 2/4] net: bridge: vlan tunnel: constify bridge and port arguments
Date:   Tue, 17 Mar 2020 14:08:34 +0200
Message-Id: <20200317120836.1765164-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
References: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vlan tunnel code changes vlan options, it shouldn't touch port or
bridge options so we can constify the port argument. This would later help
us to re-use these functions from the vlan options code.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_netlink_tunnel.c |  6 +++---
 net/bridge/br_private_tunnel.h | 13 +++++++------
 net/bridge/br_vlan_tunnel.c    |  5 +++--
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
index afee292fb004..beea08b8c422 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -193,7 +193,7 @@ static const struct nla_policy vlan_tunnel_policy[IFLA_BRIDGE_VLAN_TUNNEL_MAX +
 	[IFLA_BRIDGE_VLAN_TUNNEL_FLAGS] = { .type = NLA_U16 },
 };
 
-static int br_vlan_tunnel_info(struct net_bridge_port *p, int cmd,
+static int br_vlan_tunnel_info(const struct net_bridge_port *p, int cmd,
 			       u16 vid, u32 tun_id, bool *changed)
 {
 	int err = 0;
@@ -250,8 +250,8 @@ int br_parse_vlan_tunnel_info(struct nlattr *attr,
 	return 0;
 }
 
-int br_process_vlan_tunnel_info(struct net_bridge *br,
-				struct net_bridge_port *p, int cmd,
+int br_process_vlan_tunnel_info(const struct net_bridge *br,
+				const struct net_bridge_port *p, int cmd,
 				struct vtunnel_info *tinfo_curr,
 				struct vtunnel_info *tinfo_last,
 				bool *changed)
diff --git a/net/bridge/br_private_tunnel.h b/net/bridge/br_private_tunnel.h
index 2bdef2ea3420..a9b818fc8b6c 100644
--- a/net/bridge/br_private_tunnel.h
+++ b/net/bridge/br_private_tunnel.h
@@ -18,8 +18,8 @@ struct vtunnel_info {
 /* br_netlink_tunnel.c */
 int br_parse_vlan_tunnel_info(struct nlattr *attr,
 			      struct vtunnel_info *tinfo);
-int br_process_vlan_tunnel_info(struct net_bridge *br,
-				struct net_bridge_port *p,
+int br_process_vlan_tunnel_info(const struct net_bridge *br,
+				const struct net_bridge_port *p,
 				int cmd,
 				struct vtunnel_info *tinfo_curr,
 				struct vtunnel_info *tinfo_last,
@@ -32,8 +32,9 @@ int br_fill_vlan_tunnel_info(struct sk_buff *skb,
 /* br_vlan_tunnel.c */
 int vlan_tunnel_init(struct net_bridge_vlan_group *vg);
 void vlan_tunnel_deinit(struct net_bridge_vlan_group *vg);
-int nbp_vlan_tunnel_info_delete(struct net_bridge_port *port, u16 vid);
-int nbp_vlan_tunnel_info_add(struct net_bridge_port *port, u16 vid, u32 tun_id);
+int nbp_vlan_tunnel_info_delete(const struct net_bridge_port *port, u16 vid);
+int nbp_vlan_tunnel_info_add(const struct net_bridge_port *port, u16 vid,
+			     u32 tun_id);
 void nbp_vlan_tunnel_info_flush(struct net_bridge_port *port);
 void vlan_tunnel_info_del(struct net_bridge_vlan_group *vg,
 			  struct net_bridge_vlan *vlan);
@@ -48,13 +49,13 @@ static inline int vlan_tunnel_init(struct net_bridge_vlan_group *vg)
 	return 0;
 }
 
-static inline int nbp_vlan_tunnel_info_delete(struct net_bridge_port *port,
+static inline int nbp_vlan_tunnel_info_delete(const struct net_bridge_port *port,
 					      u16 vid)
 {
 	return 0;
 }
 
-static inline int nbp_vlan_tunnel_info_add(struct net_bridge_port *port,
+static inline int nbp_vlan_tunnel_info_add(const struct net_bridge_port *port,
 					   u16 vid, u32 tun_id)
 {
 	return 0;
diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index d13d2080f527..169e005fbda2 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -89,7 +89,8 @@ static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 /* Must be protected by RTNL.
  * Must be called with vid in range from 1 to 4094 inclusive.
  */
-int nbp_vlan_tunnel_info_add(struct net_bridge_port *port, u16 vid, u32 tun_id)
+int nbp_vlan_tunnel_info_add(const struct net_bridge_port *port, u16 vid,
+			     u32 tun_id)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *vlan;
@@ -107,7 +108,7 @@ int nbp_vlan_tunnel_info_add(struct net_bridge_port *port, u16 vid, u32 tun_id)
 /* Must be protected by RTNL.
  * Must be called with vid in range from 1 to 4094 inclusive.
  */
-int nbp_vlan_tunnel_info_delete(struct net_bridge_port *port, u16 vid)
+int nbp_vlan_tunnel_info_delete(const struct net_bridge_port *port, u16 vid)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
-- 
2.24.1

