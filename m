Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC82018CCED
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgCTLZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 07:25:35 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33336 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgCTLZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:25:34 -0400
Received: by mail-lj1-f194.google.com with SMTP id z10so5119167ljn.0
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 04:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fCaYAvSmGffnW/vysOCdODUva6zu+fQ3erD26hq5+i0=;
        b=HaTZnTodsZZieLba1ORfg3uDuthwCmHGKgebWaz0XQmI74Yfr7MQewE4cQ18X7aaic
         xrezieL4VELt1QuNVg/N10LwWPqr6zh9l3sHC+9z7dc3vU1NiudzOG7VuEjiZVa5US0Q
         YpurzCK7vnlvT9PlNojJ2cEz/mG9TIhgfc7p8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fCaYAvSmGffnW/vysOCdODUva6zu+fQ3erD26hq5+i0=;
        b=q9zlcIxiR408YflLiZY9tUezVWPU5nXZu5aGkx/z1tbMGPZUtjcwWdjaPiqDxwRhJM
         Df6zUE8bbcyXGKnZSTjNOJzt+ob88uu1QM22obv7NznM9AYsFJ+8+vO8fe9ZRlR3eVPL
         yMnbBfqH/GixrB8xBcRJnIwicSu0AUlCxENYY4fACh6ddUTpowOIP9plQGOIsCGorgfr
         b+VvqJ4cs727YDKhNYZcxUDD9J65Ls1hgYRyB+IFZlz5s6ccVHdoHg0Lw5zZj7wBa+YC
         sNadJnxkcas6bc5IpKK5aqCfBKFoMfld4cFtjpBz2P5k19niuZe7GMXrGNfTI/rf4Kjy
         9HfA==
X-Gm-Message-State: ANhLgQ06DBf1M5V68GxkbBkVUro8Lc0ubRiQQxClMLjce537LIqAfP9S
        xBKvCmDWiOeMIF5LfZ64L+2+bEMAJh8=
X-Google-Smtp-Source: ADFU+vuJ1a6F8w1OnayQOH7Joa1qLY76tUEheXQjMO4/Z2vPmpKiFY+DRoCydtIEyHp6bEmLBsonlQ==
X-Received: by 2002:a2e:a419:: with SMTP id p25mr4820243ljn.206.1584703532055;
        Fri, 20 Mar 2020 04:25:32 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l17sm3808616lje.81.2020.03.20.04.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 04:25:31 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 2/2] net: bridge: vlan options: move the tunnel command to the nested attribute
Date:   Fri, 20 Mar 2020 13:23:03 +0200
Message-Id: <20200320112303.81904-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200320112303.81904-1-nikolay@cumulusnetworks.com>
References: <20200320112303.81904-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a nested tunnel info attribute we can add a separate
one for the tunnel command and require it explicitly from user-space. It
must be one of RTM_SETLINK/DELLINK. Only RTM_SETLINK requires a valid
tunnel id, DELLINK just removes it if it was set before. This allows us
to have all tunnel attributes and control in one place, thus removing
the need for an outside vlan info flag.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/if_bridge.h |  2 +-
 net/bridge/br_vlan_options.c   | 47 ++++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index f3624fbf8fe0..bfe621ea51b3 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -131,7 +131,6 @@ enum {
 #define BRIDGE_VLAN_INFO_RANGE_END	(1<<4) /* VLAN is end of vlan range */
 #define BRIDGE_VLAN_INFO_BRENTRY	(1<<5) /* Global bridge VLAN entry */
 #define BRIDGE_VLAN_INFO_ONLY_OPTS	(1<<6) /* Skip create/delete/flags */
-#define BRIDGE_VLAN_INFO_REMOVE_TUN	(1<<7) /* Remove tunnel mapping */
 
 struct bridge_vlan_info {
 	__u16 flags;
@@ -219,6 +218,7 @@ enum {
 enum {
 	BRIDGE_VLANDB_TINFO_UNSPEC,
 	BRIDGE_VLANDB_TINFO_ID,
+	BRIDGE_VLANDB_TINFO_CMD,
 	__BRIDGE_VLANDB_TINFO_MAX,
 };
 #define BRIDGE_VLANDB_TINFO_MAX (__BRIDGE_VLANDB_TINFO_MAX - 1)
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index b39427f75457..dce6f79de397 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -97,6 +97,7 @@ static int br_vlan_modify_state(struct net_bridge_vlan_group *vg,
 
 static const struct nla_policy br_vlandb_tinfo_pol[BRIDGE_VLANDB_TINFO_MAX + 1] = {
 	[BRIDGE_VLANDB_TINFO_ID]	= { .type = NLA_U32 },
+	[BRIDGE_VLANDB_TINFO_CMD]	= { .type = NLA_U32 },
 };
 
 static int br_vlan_modify_tunnel(const struct net_bridge_port *p,
@@ -107,8 +108,8 @@ static int br_vlan_modify_tunnel(const struct net_bridge_port *p,
 {
 	struct nlattr *tun_tb[BRIDGE_VLANDB_TINFO_MAX + 1], *attr;
 	struct bridge_vlan_info *vinfo;
-	int cmdmap, err;
-	u32 tun_id;
+	u32 tun_id = 0;
+	int cmd, err;
 
 	if (!p) {
 		NL_SET_ERR_MSG_MOD(extack, "Can't modify tunnel mapping of non-port vlans");
@@ -125,23 +126,35 @@ static int br_vlan_modify_tunnel(const struct net_bridge_port *p,
 	if (err)
 		return err;
 
-	if (!tun_tb[BRIDGE_VLANDB_TINFO_ID]) {
-		NL_SET_ERR_MSG_MOD(extack, "Missing tunnel id attribute");
+	if (!tun_tb[BRIDGE_VLANDB_TINFO_CMD]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing tunnel command attribute");
 		return -ENOENT;
 	}
-	/* vlan info attribute is guaranteed by br_vlan_rtm_process_one */
-	vinfo = nla_data(tb[BRIDGE_VLANDB_ENTRY_INFO]);
-	cmdmap = vinfo->flags & BRIDGE_VLAN_INFO_REMOVE_TUN ? RTM_DELLINK :
-							      RTM_SETLINK;
-	/* when working on vlan ranges this represents the starting tunnel id */
-	tun_id = nla_get_u32(tun_tb[BRIDGE_VLANDB_TINFO_ID]);
-	/* tunnel ids are mapped to each vlan in increasing order,
-	 * the starting vlan is in BRIDGE_VLANDB_ENTRY_INFO and v is the
-	 * current vlan, so we compute: tun_id + v - vinfo->vid
-	 */
-	tun_id += v->vid - vinfo->vid;
-
-	return br_vlan_tunnel_info(p, cmdmap, v->vid, tun_id, changed);
+	cmd = nla_get_u32(tun_tb[BRIDGE_VLANDB_TINFO_CMD]);
+	switch (cmd) {
+	case RTM_SETLINK:
+		if (!tun_tb[BRIDGE_VLANDB_TINFO_ID]) {
+			NL_SET_ERR_MSG_MOD(extack, "Missing tunnel id attribute");
+			return -ENOENT;
+		}
+		/* when working on vlan ranges this is the starting tunnel id */
+		tun_id = nla_get_u32(tun_tb[BRIDGE_VLANDB_TINFO_ID]);
+		/* vlan info attr is guaranteed by br_vlan_rtm_process_one */
+		vinfo = nla_data(tb[BRIDGE_VLANDB_ENTRY_INFO]);
+		/* tunnel ids are mapped to each vlan in increasing order,
+		 * the starting vlan is in BRIDGE_VLANDB_ENTRY_INFO and v is the
+		 * current vlan, so we compute: tun_id + v - vinfo->vid
+		 */
+		tun_id += v->vid - vinfo->vid;
+		break;
+	case RTM_DELLINK:
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported tunnel command");
+		return -EINVAL;
+	}
+
+	return br_vlan_tunnel_info(p, cmd, v->vid, tun_id, changed);
 }
 
 static int br_vlan_process_one_opts(const struct net_bridge *br,
-- 
2.25.1

