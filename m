Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE2B14690A
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgAWN2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:28:22 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33530 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbgAWN2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 08:28:22 -0500
Received: by mail-lj1-f194.google.com with SMTP id y6so3413066lji.0
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 05:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r24xwJHaX2hC96CiEChFw7MOG1aaK78Eb3xmDOTsOPI=;
        b=g8W6vuNandt0AmyFT0ZUbDWkX83nTQOiHuxv+JJt2asFCxzp0Q6SeWAEDKPxnZRtPZ
         U8GQxVfBFhlyxcQ9T6ZQwTIWiTYCE/Uuh0FyT/iZ+nqWirBLHkuMBOQctVa6FRsuvrYz
         o/g04Av0PSKnSnOY2qj7j+v1KT8ZfNanwlVEk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r24xwJHaX2hC96CiEChFw7MOG1aaK78Eb3xmDOTsOPI=;
        b=e3AUwgv2satH9vch/9Jhu1GsGmVwk0+PfLHuV+Bp7xbefs7Pm6K6NgiSCWKcEF9Fkd
         1DBDi4IvyyhbinX0r/rP5ej8UbeeqLVRChx9Vu7QLwFDHHE/UjC+SdgY0Tm1cpUzTVQc
         G9u0JNQfSN3NRi5fWPH9mMnRqjuH9j3qtOitiPWj2I2dyQieQZr8b5pBZRPstepMZAV3
         04l9g+sp3tPtjmsMlOBWiNGY07Hqt4ZT7FSuqyyswFcPcIDFZVSxI1ekWQ6a0Y/iMwne
         iS1ukDMnQldthUHv/lqIuakQvqtQnYFlLvYqE+fKeMyH77iJkMutgywe3V+leJQMIRPS
         5GIw==
X-Gm-Message-State: APjAAAXdgbQpgzQuBt1H+EhrGgRMUhv/W1CvzjUhh00lageXMCRzLaub
        gn70aV3E0bf5isjPPqlZDm4ragPPRDk=
X-Google-Smtp-Source: APXvYqynhjqoTmrKJ7L9ZaCRPVgezV07Np7Ubjf5FLzf1jGk9kEZTEeGJpPyXzUlowJE9BuUzUK+JQ==
X-Received: by 2002:a2e:b4f6:: with SMTP id s22mr22698486ljm.218.1579786098995;
        Thu, 23 Jan 2020 05:28:18 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b20sm1238571ljp.20.2020.01.23.05.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 05:28:18 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 3/4] net: bridge: vlan: add basic option setting support
Date:   Thu, 23 Jan 2020 15:28:06 +0200
Message-Id: <20200123132807.613-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200123132807.613-1-nikolay@cumulusnetworks.com>
References: <20200123132807.613-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for option modification of single vlans and
ranges. It allows to only modify options, i.e. skip create/delete by
using the BRIDGE_VLAN_INFO_ONLY_OPTS flag.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_private.h        |  7 ++++
 net/bridge/br_vlan.c           | 32 ++++++++++++++--
 net/bridge/br_vlan_options.c   | 68 ++++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index ac38f0b674b8..06bbfefa2141 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -130,6 +130,7 @@ enum {
 #define BRIDGE_VLAN_INFO_RANGE_BEGIN	(1<<3) /* VLAN is start of vlan range */
 #define BRIDGE_VLAN_INFO_RANGE_END	(1<<4) /* VLAN is end of vlan range */
 #define BRIDGE_VLAN_INFO_BRENTRY	(1<<5) /* Global bridge VLAN entry */
+#define BRIDGE_VLAN_INFO_ONLY_OPTS	(1<<6) /* skip create/delete */
 
 struct bridge_vlan_info {
 	__u16 flags;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 403df71d2cfa..8ca8a9258510 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1197,6 +1197,13 @@ bool br_vlan_opts_eq(const struct net_bridge_vlan *v1,
 		     const struct net_bridge_vlan *v2);
 bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v);
 size_t br_vlan_opts_nl_size(void);
+int br_vlan_process_options(const struct net_bridge *br,
+			    const struct net_bridge_port *p,
+			    struct net_bridge_vlan *range_start,
+			    struct net_bridge_vlan *range_end,
+			    struct nlattr **tb,
+			    bool *changed,
+			    struct netlink_ext_ack *extack);
 #endif
 
 struct nf_br_ops {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 75ec3da92b0b..468d1a861c66 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
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
@@ -1882,14 +1882,40 @@ static int br_vlan_rtm_process_one(struct net_device *dev,
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
+	if (!skip_processing) {
+		struct bridge_vlan_info *tmp_last = vinfo_last;
+
+		/* br_process_vlan_info may overwrite vinfo_last */
+		err = br_process_vlan_info(br, p, cmdmap, vinfo, &tmp_last,
+					   &changed, extack);
+		if (err)
+			goto out;
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
+					      tb, &changed, extack);
+	}
+
+out:
 	if (changed)
 		br_ifinfo_notify(cmdmap, br, p);
 
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 55fcdc9c380c..1c76a1ba9a8c 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -23,3 +23,71 @@ size_t br_vlan_opts_nl_size(void)
 {
 	return 0;
 }
+
+static int br_vlan_process_one_opts(const struct net_bridge *br,
+				    const struct net_bridge_port *p,
+				    struct net_bridge_vlan *v,
+				    struct nlattr **tb,
+				    bool *changed,
+				    struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+int br_vlan_process_options(const struct net_bridge *br,
+			    const struct net_bridge_port *p,
+			    struct net_bridge_vlan *range_start,
+			    struct net_bridge_vlan *range_end,
+			    struct nlattr **tb,
+			    bool *changed,
+			    struct netlink_ext_ack *extack)
+{
+	int vid, err = 0, v_change_start = 0;
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+
+	if (p)
+		vg = nbp_vlan_group(p);
+	else
+		vg = br_vlan_group(br);
+
+	/* we require at least range_start to process options */
+	if (!range_start || !range_end) {
+		NL_SET_ERR_MSG_MOD(extack, "Vlan doesn't exist, can't process options");
+		return -ENOENT;
+	}
+
+	for (vid = range_start->vid; vid <= range_end->vid; vid++) {
+		bool curr_change = false;
+
+		v = br_vlan_find(vg, vid);
+		if (!v) {
+			NL_SET_ERR_MSG_MOD(extack, "Vlan doesn't exist, can't process options");
+			err = -ENOENT;
+			break;
+		}
+
+		err = br_vlan_process_one_opts(br, p, v, tb, &curr_change,
+					       extack);
+		if (err)
+			break;
+
+		if (curr_change) {
+			*changed = curr_change;
+			if (!v_change_start)
+				v_change_start = vid;
+		} else {
+			/* nothing to notify yet */
+			if (!v_change_start)
+				continue;
+			br_vlan_notify(br, p, v_change_start, vid - 1,
+				       RTM_NEWVLAN);
+			v_change_start = 0;
+		}
+	}
+	/* v_change_start is set only if the last/whole range changed */
+	if (v_change_start)
+		br_vlan_notify(br, p, v_change_start, vid - 1, RTM_NEWVLAN);
+
+	return err;
+}
-- 
2.21.0

