Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F17E13954E
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgAMPxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:53:19 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37329 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbgAMPxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:53:18 -0500
Received: by mail-lj1-f194.google.com with SMTP id o13so10645454ljg.4
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 07:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TaiGYJUYXXHQS6oq5Fd35tek1ycnAIZ7u32dcg64PTA=;
        b=WjAoiU9rP73BCIYmGI8gEPAz/uXm6lVuAQ74eu1sGXaWYNlyFnQk34tH1LhCcMgDsp
         Fd/4aPRFpbKgQFnzKWwR9Dkx5tRMz2gsi4UntT8S02ybAXdiqzvVAVhc4a7NlrION9tl
         LVkibyBGVTlXXw5mCsoMYGloBxDXNEP71iCsA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TaiGYJUYXXHQS6oq5Fd35tek1ycnAIZ7u32dcg64PTA=;
        b=ZZXs6OZvOb4VYwH7wC3W5AXqe9H7USnrIdF/ahaNdrjPsC8qRXk+g95qPPJdsZhMGG
         5Tt6SVHBYuyFN99cX/xCD7yCEdSOhtIo1flvy2f+6M7gddyhdXwxyhs/S7C6aG56isBn
         CrfUgEnBtD6pcrsqZ9rFhebTHydf2rDTcbjlFHIzVeyOtu3IRh27uR/afpt0T1N2fiqV
         s78rYi1LHESRofv+9xgAUBgOGFD5UAbppSpOGD8Bt7Cl6NMot6MVlFfpUR3sUuFTRxnj
         nKj+efAHODhdxWcFqDI4kI84ZJAGpcSO5KMXRAQuu+7vXLqquVnO8Sim7L+n5QM3qcKj
         9tvg==
X-Gm-Message-State: APjAAAWGnbr5Bx19o0QDJ5VTI3he0wZaBb/LbGmbQG44FJ0a68c/siwq
        DntiyziF7FLvBcymoS0QqCKIAL8BZZM=
X-Google-Smtp-Source: APXvYqwXRyy5DhbaOMJu3GZtNzzRjiRuEu0qBsIAB5UT+CZWMX/VmOX0RMDY4TOvcoFePZ/ikpqYnw==
X-Received: by 2002:a2e:9ad1:: with SMTP id p17mr11343964ljj.26.1578930795282;
        Mon, 13 Jan 2020 07:53:15 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e20sm6175658ljl.59.2020.01.13.07.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 07:53:14 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 8/8] net: bridge: vlan: notify on vlan add/delete/change flags
Date:   Mon, 13 Jan 2020 17:52:33 +0200
Message-Id: <20200113155233.20771-9-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we can notify, send a notification on add/del or change of flags.
Notifications are also compressed when possible to reduce their number
and relieve user-space of extra processing, due to that we have to
manually notify after each add/del in order to avoid double
notifications. We try hard to notify only about the vlans which actually
changed, thus a single command can result in multiple notifications
about disjoint ranges if there were vlans which didn't change inside.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_netlink.c | 34 ++++++++++++++++++--
 net/bridge/br_private.h | 12 +++++++
 net/bridge/br_vlan.c    | 71 ++++++++++++++++++++++++++++++++---------
 3 files changed, 99 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index b3da4f46dc64..43dab4066f91 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -568,9 +568,14 @@ int br_process_vlan_info(struct net_bridge *br,
 			 bool *changed,
 			 struct netlink_ext_ack *extack)
 {
+	int err, rtm_cmd;
+
 	if (!br_vlan_valid_id(vinfo_curr->vid, extack))
 		return -EINVAL;
 
+	/* needed for vlan-only NEWVLAN/DELVLAN notifications */
+	rtm_cmd = br_afspec_cmd_to_rtm(cmd);
+
 	if (vinfo_curr->flags & BRIDGE_VLAN_INFO_RANGE_BEGIN) {
 		if (!br_vlan_valid_range(vinfo_curr, *vinfo_last, extack))
 			return -EINVAL;
@@ -580,7 +585,7 @@ int br_process_vlan_info(struct net_bridge *br,
 
 	if (*vinfo_last) {
 		struct bridge_vlan_info tmp_vinfo;
-		int v, err;
+		int v, v_change_start = 0;
 
 		if (!br_vlan_valid_range(vinfo_curr, *vinfo_last, extack))
 			return -EINVAL;
@@ -588,18 +593,41 @@ int br_process_vlan_info(struct net_bridge *br,
 		memcpy(&tmp_vinfo, *vinfo_last,
 		       sizeof(struct bridge_vlan_info));
 		for (v = (*vinfo_last)->vid; v <= vinfo_curr->vid; v++) {
+			bool curr_change = false;
+
 			tmp_vinfo.vid = v;
-			err = br_vlan_info(br, p, cmd, &tmp_vinfo, changed,
+			err = br_vlan_info(br, p, cmd, &tmp_vinfo, &curr_change,
 					   extack);
 			if (err)
 				break;
+			if (curr_change) {
+				*changed = curr_change;
+				if (!v_change_start)
+					v_change_start = v;
+			} else {
+				/* nothing to notify yet */
+				if (!v_change_start)
+					continue;
+				br_vlan_notify(br, p, v_change_start,
+					       v - 1, rtm_cmd);
+				v_change_start = 0;
+			}
 		}
+		/* v_change_start is set only if the last/whole range changed */
+		if (v_change_start)
+			br_vlan_notify(br, p, v_change_start,
+				       v - 1, rtm_cmd);
+
 		*vinfo_last = NULL;
 
 		return err;
 	}
 
-	return br_vlan_info(br, p, cmd, vinfo_curr, changed, extack);
+	err = br_vlan_info(br, p, cmd, vinfo_curr, changed, extack);
+	if (*changed)
+		br_vlan_notify(br, p, vinfo_curr->vid, 0, rtm_cmd);
+
+	return err;
 }
 
 static int br_afspec(struct net_bridge *br,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index ba162c8197da..a6226ff2f0cc 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -554,6 +554,18 @@ static inline bool br_vlan_valid_range(const struct bridge_vlan_info *cur,
 	return true;
 }
 
+static inline int br_afspec_cmd_to_rtm(int cmd)
+{
+	switch (cmd) {
+	case RTM_SETLINK:
+		return RTM_NEWVLAN;
+	case RTM_DELLINK:
+		return RTM_DELVLAN;
+	}
+
+	return 0;
+}
+
 static inline int br_opt_get(const struct net_bridge *br,
 			     enum net_bridge_opts opt)
 {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 46818362d6b7..aa6445d11209 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -257,6 +257,10 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 					  &changed, extack);
 			if (err)
 				goto out_filt;
+
+			if (changed)
+				br_vlan_notify(br, NULL, v->vid, 0,
+					       RTM_NEWVLAN);
 		}
 
 		masterv = br_vlan_get_master(br, v->vid, extack);
@@ -380,13 +384,31 @@ static void __vlan_group_free(struct net_bridge_vlan_group *vg)
 	kfree(vg);
 }
 
-static void __vlan_flush(struct net_bridge_vlan_group *vg)
+static void __vlan_flush(const struct net_bridge *br,
+			 const struct net_bridge_port *p,
+			 struct net_bridge_vlan_group *vg)
 {
 	struct net_bridge_vlan *vlan, *tmp;
+	u16 v_start = 0, v_end = 0;
 
 	__vlan_delete_pvid(vg, vg->pvid);
-	list_for_each_entry_safe(vlan, tmp, &vg->vlan_list, vlist)
+	list_for_each_entry_safe(vlan, tmp, &vg->vlan_list, vlist) {
+		/* take care of disjoint ranges */
+		if (!v_start) {
+			v_start = vlan->vid;
+		} else if (vlan->vid - v_end != 1) {
+			/* found range end, notify and start next one */
+			br_vlan_notify(br, p, v_start, v_end, RTM_DELVLAN);
+			v_start = vlan->vid;
+		}
+		v_end = vlan->vid;
+
 		__vlan_del(vlan);
+	}
+
+	/* notify about the last/whole vlan range */
+	if (v_start)
+		br_vlan_notify(br, p, v_start, v_end, RTM_DELVLAN);
 }
 
 struct sk_buff *br_handle_vlan(struct net_bridge *br,
@@ -716,7 +738,7 @@ void br_vlan_flush(struct net_bridge *br)
 	ASSERT_RTNL();
 
 	vg = br_vlan_group(br);
-	__vlan_flush(vg);
+	__vlan_flush(br, NULL, vg);
 	RCU_INIT_POINTER(br->vlgrp, NULL);
 	synchronize_rcu();
 	__vlan_group_free(vg);
@@ -925,12 +947,15 @@ static void br_vlan_disable_default_pvid(struct net_bridge *br)
 	/* Disable default_pvid on all ports where it is still
 	 * configured.
 	 */
-	if (vlan_default_pvid(br_vlan_group(br), pvid))
-		br_vlan_delete(br, pvid);
+	if (vlan_default_pvid(br_vlan_group(br), pvid)) {
+		if (!br_vlan_delete(br, pvid))
+			br_vlan_notify(br, NULL, pvid, 0, RTM_DELVLAN);
+	}
 
 	list_for_each_entry(p, &br->port_list, list) {
-		if (vlan_default_pvid(nbp_vlan_group(p), pvid))
-			nbp_vlan_delete(p, pvid);
+		if (vlan_default_pvid(nbp_vlan_group(p), pvid) &&
+		    !nbp_vlan_delete(p, pvid))
+			br_vlan_notify(br, p, pvid, 0, RTM_DELVLAN);
 	}
 
 	br->default_pvid = 0;
@@ -972,7 +997,10 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 				  &vlchange, extack);
 		if (err)
 			goto out;
-		br_vlan_delete(br, old_pvid);
+
+		if (br_vlan_delete(br, old_pvid))
+			br_vlan_notify(br, NULL, old_pvid, 0, RTM_DELVLAN);
+		br_vlan_notify(br, NULL, pvid, 0, RTM_NEWVLAN);
 		set_bit(0, changed);
 	}
 
@@ -992,7 +1020,9 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 				   &vlchange, extack);
 		if (err)
 			goto err_port;
-		nbp_vlan_delete(p, old_pvid);
+		if (nbp_vlan_delete(p, old_pvid))
+			br_vlan_notify(br, p, old_pvid, 0, RTM_DELVLAN);
+		br_vlan_notify(p->br, p, pvid, 0, RTM_NEWVLAN);
 		set_bit(p->port_no, changed);
 	}
 
@@ -1007,22 +1037,28 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 		if (!test_bit(p->port_no, changed))
 			continue;
 
-		if (old_pvid)
+		if (old_pvid) {
 			nbp_vlan_add(p, old_pvid,
 				     BRIDGE_VLAN_INFO_PVID |
 				     BRIDGE_VLAN_INFO_UNTAGGED,
 				     &vlchange, NULL);
+			br_vlan_notify(p->br, p, old_pvid, 0, RTM_NEWVLAN);
+		}
 		nbp_vlan_delete(p, pvid);
+		br_vlan_notify(br, p, pvid, 0, RTM_DELVLAN);
 	}
 
 	if (test_bit(0, changed)) {
-		if (old_pvid)
+		if (old_pvid) {
 			br_vlan_add(br, old_pvid,
 				    BRIDGE_VLAN_INFO_PVID |
 				    BRIDGE_VLAN_INFO_UNTAGGED |
 				    BRIDGE_VLAN_INFO_BRENTRY,
 				    &vlchange, NULL);
+			br_vlan_notify(br, NULL, old_pvid, 0, RTM_NEWVLAN);
+		}
 		br_vlan_delete(br, pvid);
+		br_vlan_notify(br, NULL, pvid, 0, RTM_DELVLAN);
 	}
 	goto out;
 }
@@ -1115,6 +1151,7 @@ int nbp_vlan_init(struct net_bridge_port *p, struct netlink_ext_ack *extack)
 				   &changed, extack);
 		if (ret)
 			goto err_vlan_add;
+		br_vlan_notify(p->br, p, p->br->default_pvid, 0, RTM_NEWVLAN);
 	}
 out:
 	return ret;
@@ -1196,7 +1233,7 @@ void nbp_vlan_flush(struct net_bridge_port *port)
 	ASSERT_RTNL();
 
 	vg = nbp_vlan_group(port);
-	__vlan_flush(vg);
+	__vlan_flush(port->br, port, vg);
 	RCU_INIT_POINTER(port->vlgrp, NULL);
 	synchronize_rcu();
 	__vlan_group_free(vg);
@@ -1462,8 +1499,8 @@ int br_vlan_bridge_event(struct net_device *dev, unsigned long event, void *ptr)
 {
 	struct netdev_notifier_changeupper_info *info;
 	struct net_bridge *br = netdev_priv(dev);
-	bool changed;
-	int ret = 0;
+	int vlcmd = 0, ret = 0;
+	bool changed = false;
 
 	switch (event) {
 	case NETDEV_REGISTER:
@@ -1471,9 +1508,11 @@ int br_vlan_bridge_event(struct net_device *dev, unsigned long event, void *ptr)
 				  BRIDGE_VLAN_INFO_PVID |
 				  BRIDGE_VLAN_INFO_UNTAGGED |
 				  BRIDGE_VLAN_INFO_BRENTRY, &changed, NULL);
+		vlcmd = RTM_NEWVLAN;
 		break;
 	case NETDEV_UNREGISTER:
-		br_vlan_delete(br, br->default_pvid);
+		changed = !br_vlan_delete(br, br->default_pvid);
+		vlcmd = RTM_DELVLAN;
 		break;
 	case NETDEV_CHANGEUPPER:
 		info = ptr;
@@ -1487,6 +1526,8 @@ int br_vlan_bridge_event(struct net_device *dev, unsigned long event, void *ptr)
 		br_vlan_link_state_change(dev, br);
 		break;
 	}
+	if (changed)
+		br_vlan_notify(br, NULL, br->default_pvid, 0, vlcmd);
 
 	return ret;
 }
-- 
2.21.0

