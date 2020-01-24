Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC7014841F
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 12:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392077AbgAXLkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 06:40:40 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37164 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392063AbgAXLkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 06:40:36 -0500
Received: by mail-lj1-f193.google.com with SMTP id v17so2146819ljg.4
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 03:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5yKNtIK37FAfFms72I6UnllUgnm7awrb5S9l39w51AI=;
        b=Ysvr8w/MIwJLe+i0RJUdm0xsDO0y6rtV0mAbC2vdLgqPuXaMj7mEm/s+/xlitv1dMB
         v6RYkQ1GEsgCwLXJydrnMedMVI4N7sIxMMh0koPSwQCMng6b8bGtHP3IdblKHNycpSSU
         uRedtO9LdehiXMROO9R4FAmci1E72wnTC0mW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5yKNtIK37FAfFms72I6UnllUgnm7awrb5S9l39w51AI=;
        b=I/sQWGgD++j5JymQqjKcpSyWrqzbxGRiziA4gu/KtnEEJiHMlGnoFvNLgQvvcKHN3w
         zxvdhU9nk+iG395xP1UhBgyAe9JfJGENdZvf3su93P1RHoq36WzHM0U4gBZpsnixP2UG
         jJxAzlAVCL2M2I5vuGE5gpYOrvaevQhd0q4OFrAyRWmlCPsVmd/q4Od+0wcfoitilpS7
         eKrbhjZd7ukcEhm0jndNwieBCVeJQiwSiQi+pm74LkK4PmszbgHSHzOMrdqHXmzZTBQr
         EBqs0Thp6DLm5kCH6vPnu6gmFL3/AgSnMYzMBTrFtrtE3OMZRJ+TNw0DWUmIEoq6TlP0
         sAmQ==
X-Gm-Message-State: APjAAAVEo+6gU5C09KqPS2iFE1w8nWTAS2tUHfqpoFSOIW/M1zLF6zMe
        YhumFbSlI2/OFU143Xj49Qiwf+FiyPA=
X-Google-Smtp-Source: APXvYqz+XNPlG9MVSrEktz5DdA1x2qMEVKfWdiR11Yvddab1sdOJtcuiDChMp1AcrL4ToouWswIt0A==
X-Received: by 2002:a2e:9b57:: with SMTP id o23mr2089143ljj.278.1579866033700;
        Fri, 24 Jan 2020 03:40:33 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s22sm2996185ljm.41.2020.01.24.03.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 03:40:33 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 3/4] net: bridge: vlan: add basic option setting support
Date:   Fri, 24 Jan 2020 13:40:21 +0200
Message-Id: <20200124114022.10883-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200124114022.10883-1-nikolay@cumulusnetworks.com>
References: <20200124114022.10883-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for option modification of single vlans and
ranges. It allows to only modify options, i.e. skip create/delete by
using the BRIDGE_VLAN_INFO_ONLY_OPTS flag. When working with a range
option changes we try to pack the notifications as much as possible.

v2: do full port (all vlans) notification only when creating/deleting
    vlans for compatibility, rework the range detection when changing
    options, add more verbose extack errors and check if a vlan should
    be used (br_vlan_should_use checks)

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_private.h        |  8 ++++
 net/bridge/br_vlan.c           | 41 +++++++++++++---
 net/bridge/br_vlan_options.c   | 87 ++++++++++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index ac38f0b674b8..06bbfefa2141 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -130,6 +130,7 @@ enum {
 #define BRIDGE_VLAN_INFO_RANGE_BEGIN	(1<<3) /* VLAN is start of vlan range */
 #define BRIDGE_VLAN_INFO_RANGE_END	(1<<4) /* VLAN is end of vlan range */
 #define BRIDGE_VLAN_INFO_BRENTRY	(1<<5) /* Global bridge VLAN entry */
+#define BRIDGE_VLAN_INFO_ONLY_OPTS	(1<<6) /* Skip create/delete/flags */
 
 struct bridge_vlan_info {
 	__u16 flags;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 403df71d2cfa..084904ee22a8 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -976,6 +976,8 @@ void br_vlan_notify(const struct net_bridge *br,
 		    const struct net_bridge_port *p,
 		    u16 vid, u16 vid_range,
 		    int cmd);
+bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
+			     const struct net_bridge_vlan *range_end);
 
 static inline struct net_bridge_vlan_group *br_vlan_group(
 					const struct net_bridge *br)
@@ -1197,6 +1199,12 @@ bool br_vlan_opts_eq(const struct net_bridge_vlan *v1,
 		     const struct net_bridge_vlan *v2);
 bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v);
 size_t br_vlan_opts_nl_size(void);
+int br_vlan_process_options(const struct net_bridge *br,
+			    const struct net_bridge_port *p,
+			    struct net_bridge_vlan *range_start,
+			    struct net_bridge_vlan *range_end,
+			    struct nlattr **tb,
+			    struct netlink_ext_ack *extack);
 #endif
 
 struct nf_br_ops {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 75ec3da92b0b..d747756eac63 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1667,8 +1667,8 @@ void br_vlan_notify(const struct net_bridge *br,
 }
 
 /* check if v_curr can enter a range ending in range_end */
-static bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
-				    const struct net_bridge_vlan *range_end)
+bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
+			     const struct net_bridge_vlan *range_end)
 {
 	return v_curr->vid - range_end->vid == 1 &&
 	       range_end->flags == v_curr->flags &&
@@ -1824,11 +1824,11 @@ static int br_vlan_rtm_process_one(struct net_device *dev,
 {
 	struct bridge_vlan_info *vinfo, vrange_end, *vinfo_last = NULL;
 	struct nlattr *tb[BRIDGE_VLANDB_ENTRY_MAX + 1];
+	bool changed = false, skip_processing = false;
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_port *p = NULL;
 	int err = 0, cmdmap = 0;
 	struct net_bridge *br;
-	bool changed = false;
 
 	if (netif_is_bridge_master(dev)) {
 		br = netdev_priv(dev);
@@ -1882,16 +1882,43 @@ static int br_vlan_rtm_process_one(struct net_device *dev,
 	switch (cmd) {
 	case RTM_NEWVLAN:
 		cmdmap = RTM_SETLINK;
+		skip_processing = !!(vinfo->flags & BRIDGE_VLAN_INFO_ONLY_OPTS);
 		break;
 	case RTM_DELVLAN:
 		cmdmap = RTM_DELLINK;
 		break;
 	}
 
-	err = br_process_vlan_info(br, p, cmdmap, vinfo, &vinfo_last, &changed,
-				   extack);
-	if (changed)
-		br_ifinfo_notify(cmdmap, br, p);
+	if (!skip_processing) {
+		struct bridge_vlan_info *tmp_last = vinfo_last;
+
+		/* br_process_vlan_info may overwrite vinfo_last */
+		err = br_process_vlan_info(br, p, cmdmap, vinfo, &tmp_last,
+					   &changed, extack);
+
+		/* notify first if anything changed */
+		if (changed)
+			br_ifinfo_notify(cmdmap, br, p);
+
+		if (err)
+			return err;
+	}
+
+	/* deal with options */
+	if (cmd == RTM_NEWVLAN) {
+		struct net_bridge_vlan *range_start, *range_end;
+
+		if (vinfo_last) {
+			range_start = br_vlan_find(vg, vinfo_last->vid);
+			range_end = br_vlan_find(vg, vinfo->vid);
+		} else {
+			range_start = br_vlan_find(vg, vinfo->vid);
+			range_end = range_start;
+		}
+
+		err = br_vlan_process_options(br, p, range_start, range_end,
+					      tb, extack);
+	}
 
 	return err;
 }
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 55fcdc9c380c..27275ac3e42e 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -23,3 +23,90 @@ size_t br_vlan_opts_nl_size(void)
 {
 	return 0;
 }
+
+static int br_vlan_process_one_opts(const struct net_bridge *br,
+				    const struct net_bridge_port *p,
+				    struct net_bridge_vlan_group *vg,
+				    struct net_bridge_vlan *v,
+				    struct nlattr **tb,
+				    bool *changed,
+				    struct netlink_ext_ack *extack)
+{
+	*changed = false;
+	return 0;
+}
+
+int br_vlan_process_options(const struct net_bridge *br,
+			    const struct net_bridge_port *p,
+			    struct net_bridge_vlan *range_start,
+			    struct net_bridge_vlan *range_end,
+			    struct nlattr **tb,
+			    struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan *v, *curr_start = NULL, *curr_end = NULL;
+	struct net_bridge_vlan_group *vg;
+	int vid, err = 0;
+	u16 pvid;
+
+	if (p)
+		vg = nbp_vlan_group(p);
+	else
+		vg = br_vlan_group(br);
+
+	if (!range_start || !br_vlan_should_use(range_start)) {
+		NL_SET_ERR_MSG_MOD(extack, "Vlan range start doesn't exist, can't process options");
+		return -ENOENT;
+	}
+	if (!range_end || !br_vlan_should_use(range_end)) {
+		NL_SET_ERR_MSG_MOD(extack, "Vlan range end doesn't exist, can't process options");
+		return -ENOENT;
+	}
+
+	pvid = br_get_pvid(vg);
+	for (vid = range_start->vid; vid <= range_end->vid; vid++) {
+		bool changed = false;
+
+		v = br_vlan_find(vg, vid);
+		if (!v || !br_vlan_should_use(v)) {
+			NL_SET_ERR_MSG_MOD(extack, "Vlan in range doesn't exist, can't process options");
+			err = -ENOENT;
+			break;
+		}
+
+		err = br_vlan_process_one_opts(br, p, vg, v, tb, &changed,
+					       extack);
+		if (err)
+			break;
+
+		if (changed) {
+			/* vlan options changed, check for range */
+			if (!curr_start) {
+				curr_start = v;
+				curr_end = v;
+				continue;
+			}
+
+			if (v->vid == pvid ||
+			    !br_vlan_can_enter_range(v, curr_end)) {
+				br_vlan_notify(br, p, curr_start->vid,
+					       curr_end->vid, RTM_NEWVLAN);
+				curr_start = v;
+			}
+			curr_end = v;
+		} else {
+			/* nothing changed and nothing to notify yet */
+			if (!curr_start)
+				continue;
+
+			br_vlan_notify(br, p, curr_start->vid, curr_end->vid,
+				       RTM_NEWVLAN);
+			curr_start = NULL;
+			curr_end = NULL;
+		}
+	}
+	if (curr_start)
+		br_vlan_notify(br, p, curr_start->vid, curr_end->vid,
+			       RTM_NEWVLAN);
+
+	return err;
+}
-- 
2.21.0

