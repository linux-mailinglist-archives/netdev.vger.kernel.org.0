Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF318CCEE
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgCTLZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 07:25:37 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38541 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgCTLZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:25:35 -0400
Received: by mail-lj1-f195.google.com with SMTP id w1so5985120ljh.5
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 04:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sOOkzeTqqaHxaR5h7BnNLL0MzJvuklzqG0SZvx8hCjU=;
        b=hjfvDdMLFArtIxyheiidxvlCqOu5M0rXA4MzX8fr+EwlmSHiil1/dh5qu2hg1mUsxf
         CO3eFSmCUyzlZYpBw8M7UbxpSOxGQcIx3SeCxXHui/3SSu+YVjT6c3RhkAjtwQn28Wpz
         Vy2rM3ELo/qdNXTuWncRsJywdpbytFZp64k6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sOOkzeTqqaHxaR5h7BnNLL0MzJvuklzqG0SZvx8hCjU=;
        b=QWeCgVHXLso5OkqXAdC91eOMfSAo3tD2cXQP48XD2ktfCgMXealE3MfPCVxNSbIvAw
         5+BtoxMoAojvgf4A+fWyj4SBgkvcLpBYQGGpBjOgg1OqtbUEVHR2gS0fLn6cycoFVMvD
         KnCq7JFPTBIVtPgmM3Hu9n49bURn8BoTGsvvXviscXUKqqc1s40c28rL4OEMjRb3aSo8
         l5vAPhfCkohjxawyxbJp8pSbHtZkjm+Pwydmr+zbWwluB2YCuEuEG0glLnMhKpA9Wi8Q
         NZzervVLztTJYvajFlMdjtwN6AdOaIg/O8Eqt6R9n1VaM3Xplz12l43hA2V10k+e1aKt
         EoIw==
X-Gm-Message-State: ANhLgQ2gF6gKHfY16YEshTePxsg/jvUJEk1fpBnGnhylLp4p34qiZy9k
        5R4l2nZP0daZfe4jo9SE5PTJesvpyfI=
X-Google-Smtp-Source: ADFU+vuGYUBGTkMTG3LVjWjyZGypJzURbzVJNm3Q+3oSwjFRgfWYjyjoXchpK2XwamUhj2rWUP+RTA==
X-Received: by 2002:a2e:8043:: with SMTP id p3mr4974070ljg.270.1584703530780;
        Fri, 20 Mar 2020 04:25:30 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l17sm3808616lje.81.2020.03.20.04.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 04:25:30 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 1/2] net: bridge: vlan options: nest the tunnel id into a tunnel info attribute
Date:   Fri, 20 Mar 2020 13:23:02 +0200
Message-Id: <20200320112303.81904-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200320112303.81904-1-nikolay@cumulusnetworks.com>
References: <20200320112303.81904-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While discussing the new API, Roopa mentioned that we'll be adding more
tunnel attributes and options in the future, so it's better to make it a
nested attribute, since this is still in net-next we can easily change it
and nest the tunnel id attribute under BRIDGE_VLANDB_ENTRY_TUNNEL_INFO.

The new format is:
 [BRIDGE_VLANDB_ENTRY]
     [BRIDGE_VLANDB_ENTRY_TUNNEL_INFO]
         [BRIDGE_VLANDB_TINFO_ID]

Any new tunnel attributes can be nested under
BRIDGE_VLANDB_ENTRY_TUNNEL_INFO.

Suggested-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/if_bridge.h | 16 ++++++++++++++-
 net/bridge/br_vlan.c           |  2 +-
 net/bridge/br_vlan_options.c   | 37 ++++++++++++++++++++++++++++------
 3 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 9dd1b1fa3291..f3624fbf8fe0 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -203,12 +203,26 @@ enum {
 	BRIDGE_VLANDB_ENTRY_INFO,
 	BRIDGE_VLANDB_ENTRY_RANGE,
 	BRIDGE_VLANDB_ENTRY_STATE,
-	BRIDGE_VLANDB_ENTRY_TUNNEL_ID,
+	BRIDGE_VLANDB_ENTRY_TUNNEL_INFO,
 	BRIDGE_VLANDB_ENTRY_STATS,
 	__BRIDGE_VLANDB_ENTRY_MAX,
 };
 #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
 
+/* [BRIDGE_VLANDB_ENTRY] = {
+ *     [BRIDGE_VLANDB_ENTRY_TUNNEL_INFO] = {
+ *         [BRIDGE_VLANDB_TINFO_ID]
+ *         ...
+ *     }
+ * }
+ */
+enum {
+	BRIDGE_VLANDB_TINFO_UNSPEC,
+	BRIDGE_VLANDB_TINFO_ID,
+	__BRIDGE_VLANDB_TINFO_MAX,
+};
+#define BRIDGE_VLANDB_TINFO_MAX (__BRIDGE_VLANDB_TINFO_MAX - 1)
+
 /* [BRIDGE_VLANDB_ENTRY] = {
  *     [BRIDGE_VLANDB_ENTRY_STATS] = {
  *         [BRIDGE_VLANDB_STATS_RX_BYTES]
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 4398f3796665..f9092c71225f 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1888,7 +1888,7 @@ static const struct nla_policy br_vlan_db_policy[BRIDGE_VLANDB_ENTRY_MAX + 1] =
 					    .len = sizeof(struct bridge_vlan_info) },
 	[BRIDGE_VLANDB_ENTRY_RANGE]	= { .type = NLA_U16 },
 	[BRIDGE_VLANDB_ENTRY_STATE]	= { .type = NLA_U8 },
-	[BRIDGE_VLANDB_ENTRY_TUNNEL_ID] = { .type = NLA_U32 },
+	[BRIDGE_VLANDB_ENTRY_TUNNEL_INFO] = { .type = NLA_NESTED },
 };
 
 static int br_vlan_rtm_process_one(struct net_device *dev,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 138e180cf4d8..b39427f75457 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -12,12 +12,21 @@
 static bool __vlan_tun_put(struct sk_buff *skb, const struct net_bridge_vlan *v)
 {
 	__be32 tid = tunnel_id_to_key32(v->tinfo.tunnel_id);
+	struct nlattr *nest;
 
 	if (!v->tinfo.tunnel_dst)
 		return true;
 
-	return !nla_put_u32(skb, BRIDGE_VLANDB_ENTRY_TUNNEL_ID,
-			    be32_to_cpu(tid));
+	nest = nla_nest_start(skb, BRIDGE_VLANDB_ENTRY_TUNNEL_INFO);
+	if (!nest)
+		return false;
+	if (nla_put_u32(skb, BRIDGE_VLANDB_TINFO_ID, be32_to_cpu(tid))) {
+		nla_nest_cancel(skb, nest);
+		return false;
+	}
+	nla_nest_end(skb, nest);
+
+	return true;
 }
 
 static bool __vlan_tun_can_enter_range(const struct net_bridge_vlan *v_curr,
@@ -45,7 +54,8 @@ bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
 size_t br_vlan_opts_nl_size(void)
 {
 	return nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_ENTRY_STATE */
-	       + nla_total_size(sizeof(u32)); /* BRIDGE_VLANDB_ENTRY_TUNNEL_ID */
+	       + nla_total_size(0) /* BRIDGE_VLANDB_ENTRY_TUNNEL_INFO */
+	       + nla_total_size(sizeof(u32)); /* BRIDGE_VLANDB_TINFO_ID */
 }
 
 static int br_vlan_modify_state(struct net_bridge_vlan_group *vg,
@@ -85,14 +95,19 @@ static int br_vlan_modify_state(struct net_bridge_vlan_group *vg,
 	return 0;
 }
 
+static const struct nla_policy br_vlandb_tinfo_pol[BRIDGE_VLANDB_TINFO_MAX + 1] = {
+	[BRIDGE_VLANDB_TINFO_ID]	= { .type = NLA_U32 },
+};
+
 static int br_vlan_modify_tunnel(const struct net_bridge_port *p,
 				 struct net_bridge_vlan *v,
 				 struct nlattr **tb,
 				 bool *changed,
 				 struct netlink_ext_ack *extack)
 {
+	struct nlattr *tun_tb[BRIDGE_VLANDB_TINFO_MAX + 1], *attr;
 	struct bridge_vlan_info *vinfo;
-	int cmdmap;
+	int cmdmap, err;
 	u32 tun_id;
 
 	if (!p) {
@@ -104,12 +119,22 @@ static int br_vlan_modify_tunnel(const struct net_bridge_port *p,
 		return -EINVAL;
 	}
 
+	attr = tb[BRIDGE_VLANDB_ENTRY_TUNNEL_INFO];
+	err = nla_parse_nested(tun_tb, BRIDGE_VLANDB_TINFO_MAX, attr,
+			       br_vlandb_tinfo_pol, extack);
+	if (err)
+		return err;
+
+	if (!tun_tb[BRIDGE_VLANDB_TINFO_ID]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing tunnel id attribute");
+		return -ENOENT;
+	}
 	/* vlan info attribute is guaranteed by br_vlan_rtm_process_one */
 	vinfo = nla_data(tb[BRIDGE_VLANDB_ENTRY_INFO]);
 	cmdmap = vinfo->flags & BRIDGE_VLAN_INFO_REMOVE_TUN ? RTM_DELLINK :
 							      RTM_SETLINK;
 	/* when working on vlan ranges this represents the starting tunnel id */
-	tun_id = nla_get_u32(tb[BRIDGE_VLANDB_ENTRY_TUNNEL_ID]);
+	tun_id = nla_get_u32(tun_tb[BRIDGE_VLANDB_TINFO_ID]);
 	/* tunnel ids are mapped to each vlan in increasing order,
 	 * the starting vlan is in BRIDGE_VLANDB_ENTRY_INFO and v is the
 	 * current vlan, so we compute: tun_id + v - vinfo->vid
@@ -137,7 +162,7 @@ static int br_vlan_process_one_opts(const struct net_bridge *br,
 		if (err)
 			return err;
 	}
-	if (tb[BRIDGE_VLANDB_ENTRY_TUNNEL_ID]) {
+	if (tb[BRIDGE_VLANDB_ENTRY_TUNNEL_INFO]) {
 		err = br_vlan_modify_tunnel(p, v, tb, changed, extack);
 		if (err)
 			return err;
-- 
2.25.1

