Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9C913954B
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgAMPxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:53:20 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35393 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728801AbgAMPxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:53:17 -0500
Received: by mail-lj1-f196.google.com with SMTP id j1so10647445lja.2
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 07:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K4tsQolRiTJlNf5YBGe3vXJoYvSY3RmCQu//d2605Mw=;
        b=Yz8PvsW5GOaZ1l01Mb4Zz7cachcTSNTwK60Em12EGVnDJT/JHBIbBrB4nwAR+uFbTs
         jVpZTsf4527twvOe1o3W/prtoPMsv+qtW5TU1YO+EXhbNDQ5UjvZr3NzYNBDsxlj3Vxr
         kHOwnA5ncmqZvYjCazx3PVn5zwgnm8omPT2k4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K4tsQolRiTJlNf5YBGe3vXJoYvSY3RmCQu//d2605Mw=;
        b=bIGG9Nu16iSefNPEo+Xi7FDpq4m2YRnIUSAVFn+sXq//rmGg3F+mH23mNi6gOeKJkF
         RcZ2z96BIoYh72nij9VcREiX49TJZ8V8FEr480Gw4qh0PklNWMXCHSTSWCdDK8xtB+t7
         aub/L5k8NVACwPwGI0X1qLy3DU1efbXUnGP4lzSzv5ah4FMJa2faIGNkDmuOQRxILS6T
         3T3TTlRy7y+1aRodTzMA/KGn3Lzb04+fCcGwNhhwck4TONNCNy2SXjjOvqU8p0HJuYIH
         RCpPbzsJlYZZIjtpLb3lR8Tq/uRlbpRezzCzNla/Rwr9/3unSV92qCYlu/o50oqaCy7e
         Znmg==
X-Gm-Message-State: APjAAAUrZcGMF8ViQdpbG9xQP61ag0chbx1HL1BvVFtjz2GsBLPu+Lfe
        8GtV4FQdcXQBFe4PuVNz+aldbAYtLSY=
X-Google-Smtp-Source: APXvYqyLEn7Zxr2B3vb1N2OBy/OW6m5ZnP+8lwW8L0SOOzd5s95lnWU7ZHINhYKXRx28Ws2GocNSrg==
X-Received: by 2002:a2e:7005:: with SMTP id l5mr11807886ljc.230.1578930793820;
        Mon, 13 Jan 2020 07:53:13 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e20sm6175658ljl.59.2020.01.13.07.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 07:53:13 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 7/8] net: bridge: vlan: add rtnetlink group and notify support
Date:   Mon, 13 Jan 2020 17:52:32 +0200
Message-Id: <20200113155233.20771-8-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new rtnetlink group for bridge vlan notifications - RTNLGRP_BRVLAN
and add support for sending vlan notifications (both single and ranges).
No functional changes intended, the notification support will be used by
later patches.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/rtnetlink.h |  2 +
 net/bridge/br_private.h        | 11 +++++
 net/bridge/br_vlan.c           | 79 ++++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index e06e3e09a1b4..fe9136f87a97 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -728,6 +728,8 @@ enum rtnetlink_groups {
 #define RTNLGRP_IPV6_MROUTE_R	RTNLGRP_IPV6_MROUTE_R
 	RTNLGRP_NEXTHOP,
 #define RTNLGRP_NEXTHOP		RTNLGRP_NEXTHOP
+	RTNLGRP_BRVLAN,
+#define RTNLGRP_BRVLAN		RTNLGRP_BRVLAN
 	__RTNLGRP_MAX
 };
 #define RTNLGRP_MAX	(__RTNLGRP_MAX - 1)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index ee3871dea68f..ba162c8197da 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -960,6 +960,10 @@ int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
 			 void *ptr);
 void br_vlan_rtnl_init(void);
 void br_vlan_rtnl_uninit(void);
+void br_vlan_notify(const struct net_bridge *br,
+		    const struct net_bridge_port *p,
+		    u16 vid, u16 vid_range,
+		    int cmd);
 
 static inline struct net_bridge_vlan_group *br_vlan_group(
 					const struct net_bridge *br)
@@ -1166,6 +1170,13 @@ static inline void br_vlan_rtnl_init(void)
 static inline void br_vlan_rtnl_uninit(void)
 {
 }
+
+static inline void br_vlan_notify(const struct net_bridge *br,
+				  const struct net_bridge_port *p,
+				  u16 vid, u16 vid_range,
+				  int cmd)
+{
+}
 #endif
 
 struct nf_br_ops {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 4f911742bf5f..46818362d6b7 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1540,6 +1540,85 @@ static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
 	return false;
 }
 
+static size_t rtnl_vlan_nlmsg_size(void)
+{
+	return NLMSG_ALIGN(sizeof(struct br_vlan_msg))
+		+ nla_total_size(0) /* BRIDGE_VLANDB_ENTRY */
+		+ nla_total_size(sizeof(u16)) /* BRIDGE_VLANDB_ENTRY_RANGE */
+		+ nla_total_size(sizeof(struct bridge_vlan_info)); /* BRIDGE_VLANDB_ENTRY_INFO */
+}
+
+void br_vlan_notify(const struct net_bridge *br,
+		    const struct net_bridge_port *p,
+		    u16 vid, u16 vid_range,
+		    int cmd)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+	struct br_vlan_msg *bvm;
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+	struct net *net;
+	u16 flags = 0;
+	int ifindex;
+
+	/* right now notifications are done only with rtnl held */
+	ASSERT_RTNL();
+
+	if (p) {
+		ifindex = p->dev->ifindex;
+		vg = nbp_vlan_group(p);
+		net = dev_net(p->dev);
+	} else {
+		ifindex = br->dev->ifindex;
+		vg = br_vlan_group(br);
+		net = dev_net(br->dev);
+	}
+
+	skb = nlmsg_new(rtnl_vlan_nlmsg_size(), GFP_KERNEL);
+	if (!skb)
+		goto out_err;
+
+	err = -EMSGSIZE;
+	nlh = nlmsg_put(skb, 0, 0, cmd, sizeof(*bvm), 0);
+	if (!nlh)
+		goto out_err;
+	bvm = nlmsg_data(nlh);
+	memset(bvm, 0, sizeof(*bvm));
+	bvm->family = AF_BRIDGE;
+	bvm->ifindex = ifindex;
+
+	switch (cmd) {
+	case RTM_NEWVLAN:
+		/* need to find the vlan due to flags/options */
+		v = br_vlan_find(vg, vid);
+		if (!v || !br_vlan_should_use(v))
+			goto out_kfree;
+
+		flags = v->flags;
+		if (br_get_pvid(vg) == v->vid)
+			flags |= BRIDGE_VLAN_INFO_PVID;
+		break;
+	case RTM_DELVLAN:
+		break;
+	default:
+		goto out_kfree;
+	}
+
+	if (!br_vlan_fill_vids(skb, vid, vid_range, flags))
+		goto out_err;
+
+	nlmsg_end(skb, nlh);
+	rtnl_notify(skb, net, 0, RTNLGRP_BRVLAN, NULL, GFP_KERNEL);
+	return;
+
+out_err:
+	rtnl_set_sk_err(net, RTNLGRP_BRVLAN, err);
+out_kfree:
+	kfree_skb(skb);
+}
+
 /* check if v_curr can enter a range ending in range_end */
 static bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 				    const struct net_bridge_vlan *range_end)
-- 
2.21.0

