Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538AF3CE87C
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351600AbhGSQlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343974AbhGSQgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:40 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA6AC078814
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:58 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ga14so29924850ejc.6
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yYcyZCiZBQoPwEo8PkgKkU8xnppoooSri5YHE+fHaaM=;
        b=AupFKrEpi6DreNMsGKaMtPutFkruCxWEvwt+3S1Zxpl0IvbvzbLc1bU+LfkLQeSoY6
         zP/Z+sTsONL8VQWUupHdRSsgXrRTot0vDuiND8kkTLV9EOyAc61xSTPyPeWtntRbNHfr
         ec78lILw6avc1KGvLbf/HFQvFVPyMRIy7xeNU19FQZpLR+wt/0y/xSjm2PCP4+VTdQLz
         roh5BGuCLUws1dtISXl6CbTO8jQvLg6cYBS6J0uayprHps2SpLxkv3KcEdUULkgSxh0i
         5SddzeFNXnESid5y5N141oQ7bssH6S6d9uNU0E7ivgaGpBJobVHVDQYqIUNkVbrKnkN2
         QzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yYcyZCiZBQoPwEo8PkgKkU8xnppoooSri5YHE+fHaaM=;
        b=NR0KvMF1e+YUUyEzZ+JU90kRePtUm0uOABehYiFlZTHdNcDR6SvUzJvW7SOXN+kh5r
         3CXoHkrWR0eYxTQek/o6Yp3Yvnt2mH6ix2zbirNiLx9SV2AguMEVGYwSheZ2CzWME8TE
         BwPMBXgTrQaS7Fj90t8QiW9VuQsE2ibfKPgjKEIExJL32VIMVNyy6Ey4piy/+bDkA/dC
         UQn3Dm5qSyQw1oUii5AVttoiuul/H4ga97JsKhKA9RJEowKelEPIYvoE7WJWsaueHD6a
         Ywb1OeJvTnThNJo1N3gaupp7iiV28lGBVjD1cyNLr+xC0B7nLVj0YxGfCVco99NR3Pfd
         t9SQ==
X-Gm-Message-State: AOAM532NBWp+OOVMngIOD5XUv7LbLm9rONiUm9uU+hOPhC69IDIYjzMD
        rK1igL9icG8h8LKttqYoNGW5M5o1POU674+pqJg=
X-Google-Smtp-Source: ABdhPJz5mxJOjDRwj89onF7oeVaPY+TyRNftAU4jfZWFT5dAcoqtAqJV5ng6GQuHM0+KXcVjA6heVQ==
X-Received: by 2002:a17:906:6b1b:: with SMTP id q27mr27854438ejr.169.1626714610011;
        Mon, 19 Jul 2021 10:10:10 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:10:09 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 14/15] net: bridge: vlan: notify when global options change
Date:   Mon, 19 Jul 2021 20:06:36 +0300
Message-Id: <20210719170637.435541-15-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for global options notifications. They use only RTM_NEWVLAN
since global options can only be set and are contained in a separate
vlan global options attribute. Notifications are compressed in ranges
where possible, i.e. the sequential vlan options are equal.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_vlan_options.c | 80 +++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index f290f5140547..827bfc319599 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -290,6 +290,57 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 	return false;
 }
 
+static size_t rtnl_vlan_global_opts_nlmsg_size(void)
+{
+	return NLMSG_ALIGN(sizeof(struct br_vlan_msg))
+		+ nla_total_size(0) /* BRIDGE_VLANDB_GLOBAL_OPTIONS */
+		+ nla_total_size(sizeof(u16)) /* BRIDGE_VLANDB_GOPTS_ID */
+		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
+}
+
+static void br_vlan_global_opts_notify(const struct net_bridge *br,
+				       u16 vid, u16 vid_range)
+{
+	struct net_bridge_vlan *v;
+	struct br_vlan_msg *bvm;
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+
+	/* right now notifications are done only with rtnl held */
+	ASSERT_RTNL();
+
+	skb = nlmsg_new(rtnl_vlan_global_opts_nlmsg_size(), GFP_KERNEL);
+	if (!skb)
+		goto out_err;
+
+	err = -EMSGSIZE;
+	nlh = nlmsg_put(skb, 0, 0, RTM_NEWVLAN, sizeof(*bvm), 0);
+	if (!nlh)
+		goto out_err;
+	bvm = nlmsg_data(nlh);
+	memset(bvm, 0, sizeof(*bvm));
+	bvm->family = AF_BRIDGE;
+	bvm->ifindex = br->dev->ifindex;
+
+	/* need to find the vlan due to flags/options */
+	v = br_vlan_find(br_vlan_group(br), vid);
+	if (!v)
+		goto out_kfree;
+
+	if (!br_vlan_global_opts_fill(skb, vid, vid_range, v))
+		goto out_err;
+
+	nlmsg_end(skb, nlh);
+	rtnl_notify(skb, dev_net(br->dev), 0, RTNLGRP_BRVLAN, NULL, GFP_KERNEL);
+	return;
+
+out_err:
+	rtnl_set_sk_err(dev_net(br->dev), RTNLGRP_BRVLAN, err);
+out_kfree:
+	kfree_skb(skb);
+}
+
 static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 					   struct net_bridge_vlan_group *vg,
 					   struct net_bridge_vlan *v,
@@ -311,9 +362,9 @@ int br_vlan_rtm_process_global_options(struct net_device *dev,
 				       int cmd,
 				       struct netlink_ext_ack *extack)
 {
+	struct net_bridge_vlan *v, *curr_start = NULL, *curr_end = NULL;
 	struct nlattr *tb[BRIDGE_VLANDB_GOPTS_MAX + 1];
 	struct net_bridge_vlan_group *vg;
-	struct net_bridge_vlan *v;
 	u16 vid, vid_range = 0;
 	struct net_bridge *br;
 	int err = 0;
@@ -370,7 +421,34 @@ int br_vlan_rtm_process_global_options(struct net_device *dev,
 						      extack);
 		if (err)
 			break;
+
+		if (changed) {
+			/* vlan options changed, check for range */
+			if (!curr_start) {
+				curr_start = v;
+				curr_end = v;
+				continue;
+			}
+
+			if (!br_vlan_global_opts_can_enter_range(v, curr_end)) {
+				br_vlan_global_opts_notify(br, curr_start->vid,
+							   curr_end->vid);
+				curr_start = v;
+			}
+			curr_end = v;
+		} else {
+			/* nothing changed and nothing to notify yet */
+			if (!curr_start)
+				continue;
+
+			br_vlan_global_opts_notify(br, curr_start->vid,
+						   curr_end->vid);
+			curr_start = NULL;
+			curr_end = NULL;
+		}
 	}
+	if (curr_start)
+		br_vlan_global_opts_notify(br, curr_start->vid, curr_end->vid);
 
 	return err;
 }
-- 
2.31.1

