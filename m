Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F71D188330
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 13:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgCQMKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 08:10:11 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35051 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgCQMKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 08:10:10 -0400
Received: by mail-lj1-f196.google.com with SMTP id u12so22545470ljo.2
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 05:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hmS/lQhsaapFOz3Rfd3WQVjsqoU/mKBs+PwdwTNRXZA=;
        b=YnbWaU5HFKkQE0O2UF9IguWnTH+xB5zhYfVL5nBQYnADtdqonEKycJX8G14iWU15lx
         LoDa5+bcd+BNfqQUF3YQN4+ZcRLBb6vlTaLTv1TH8Uq341Mzm7LG5hnNEbvUQb/ZrseT
         G30ePB7bsxSdBa+4RYAyZuXcLd0gjFwwKqKRs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hmS/lQhsaapFOz3Rfd3WQVjsqoU/mKBs+PwdwTNRXZA=;
        b=qIj4L3lVuVOi7Ml70offK4LeShGgpUrdhIdLMGZ1ekg4f5npnMvp88CRftKPccVVgq
         0fM3T2Sfre1unqhBZ6DG6TjInC0DxrTztml6HnHIHCVwnWQQ5AHTrvWymVhVNFjvpYkL
         rJkWk99mFwPIgH64DcDKlptCcABriSC+HRgTNtfzJKX62joHd5J6GcF9obOvkwFYPiGp
         S3V+aAIfX4mJMyxZNkB4BqJfXx9NXHrYpxl2glHMDhQYbRFT99YrbQB78riPTdNnF1zt
         qlZi7hYmecGzYHjl71omTETgZ7rFN/hjgBO1x5wilgXrKmde/j8rAGflhDltd7USjNCs
         kFcA==
X-Gm-Message-State: ANhLgQ3tW4Z6AdtioDK+CAmfBpzcGTVQJEWRPvyY2Fh/jC9HJmbCPokL
        XA+0VIWLBT8BgMqXqpQOqInJs1Fjutk=
X-Google-Smtp-Source: ADFU+vvFzDIeCzARd3j7cNRTFcuhRMMToVklCLXu+kCO4Qp+GKVIoWIwTjwMIjPjn4qvWbm4Ed3LFw==
X-Received: by 2002:a2e:920c:: with SMTP id k12mr2473964ljg.209.1584447007393;
        Tue, 17 Mar 2020 05:10:07 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 23sm2389208lfa.28.2020.03.17.05.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 05:09:58 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 3/4] net: bridge: vlan options: add support for tunnel id dumping
Date:   Tue, 17 Mar 2020 14:08:35 +0200
Message-Id: <20200317120836.1765164-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
References: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new option - BRIDGE_VLANDB_ENTRY_TUNNEL_ID which is used to dump
the tunnel id mapping. Since they're unique per vlan they can enter a
vlan range if they're consecutive, thus we can calculate the tunnel id
range map simply as: vlan range end id - vlan range start id. The
starting point is the tunnel id in BRIDGE_VLANDB_ENTRY_TUNNEL_ID. This
is similar to how the tunnel entries can be created in a range via the
old API (a vlan range maps to a tunnel range).

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_netlink_tunnel.c |  4 ++--
 net/bridge/br_private_tunnel.h |  2 ++
 net/bridge/br_vlan_options.c   | 29 ++++++++++++++++++++++++++---
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 42f7ca38ad80..36760ff69711 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -192,6 +192,7 @@ enum {
 	BRIDGE_VLANDB_ENTRY_INFO,
 	BRIDGE_VLANDB_ENTRY_RANGE,
 	BRIDGE_VLANDB_ENTRY_STATE,
+	BRIDGE_VLANDB_ENTRY_TUNNEL_ID,
 	__BRIDGE_VLANDB_ENTRY_MAX,
 };
 #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
index beea08b8c422..996a77620814 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -26,8 +26,8 @@ static size_t __get_vlan_tinfo_size(void)
 		  nla_total_size(sizeof(u16)); /* IFLA_BRIDGE_VLAN_TUNNEL_FLAGS */
 }
 
-static bool vlan_tunid_inrange(struct net_bridge_vlan *v_curr,
-			       struct net_bridge_vlan *v_last)
+bool vlan_tunid_inrange(const struct net_bridge_vlan *v_curr,
+			const struct net_bridge_vlan *v_last)
 {
 	__be32 tunid_curr = tunnel_id_to_key32(v_curr->tinfo.tunnel_id);
 	__be32 tunid_last = tunnel_id_to_key32(v_last->tinfo.tunnel_id);
diff --git a/net/bridge/br_private_tunnel.h b/net/bridge/br_private_tunnel.h
index a9b818fc8b6c..b27a0c0371f2 100644
--- a/net/bridge/br_private_tunnel.h
+++ b/net/bridge/br_private_tunnel.h
@@ -43,6 +43,8 @@ int br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
 				  struct net_bridge_vlan_group *vg);
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 				 struct net_bridge_vlan *vlan);
+bool vlan_tunid_inrange(const struct net_bridge_vlan *v_curr,
+			const struct net_bridge_vlan *v_last);
 #else
 static inline int vlan_tunnel_init(struct net_bridge_vlan_group *vg)
 {
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 24cf2a621df9..d3618da32b8e 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -4,25 +4,48 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
+#include <net/ip_tunnels.h>
 
 #include "br_private.h"
+#include "br_private_tunnel.h"
+
+static bool __vlan_tun_put(struct sk_buff *skb, const struct net_bridge_vlan *v)
+{
+	__be32 tid = tunnel_id_to_key32(v->tinfo.tunnel_id);
+
+	if (!v->tinfo.tunnel_dst)
+		return true;
+
+	return !nla_put_u32(skb, BRIDGE_VLANDB_ENTRY_TUNNEL_ID,
+			    be32_to_cpu(tid));
+}
+
+static bool __vlan_tun_can_enter_range(const struct net_bridge_vlan *v_curr,
+				       const struct net_bridge_vlan *range_end)
+{
+	return (!v_curr->tinfo.tunnel_dst && !range_end->tinfo.tunnel_dst) ||
+	       vlan_tunid_inrange(v_curr, range_end);
+}
 
 /* check if the options' state of v_curr allow it to enter the range */
 bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
 			   const struct net_bridge_vlan *range_end)
 {
-	return v_curr->state == range_end->state;
+	return v_curr->state == range_end->state &&
+	       __vlan_tun_can_enter_range(v_curr, range_end);
 }
 
 bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
 {
 	return !nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_STATE,
-			   br_vlan_get_state(v));
+			   br_vlan_get_state(v)) &&
+	       __vlan_tun_put(skb, v);
 }
 
 size_t br_vlan_opts_nl_size(void)
 {
-	return nla_total_size(sizeof(u8)); /* BRIDGE_VLANDB_ENTRY_STATE */
+	return nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_ENTRY_STATE */
+	       + nla_total_size(sizeof(u32)); /* BRIDGE_VLANDB_ENTRY_TUNNEL_ID */
 }
 
 static int br_vlan_modify_state(struct net_bridge_vlan_group *vg,
-- 
2.24.1

