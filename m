Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33461C1E6A
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 11:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbfI3Jse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 05:48:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54149 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730531AbfI3Jsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 05:48:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id i16so12605163wmd.3
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 02:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GmC7322r1fIXnYGnx5mUEofTBgplNTG1zUqDcgQPjlQ=;
        b=HTvVLH9FJrwDi7hNW0l7py5MqFE94w6U5DQr56idxLy4tAdPcP3mgZVjNVznhELrb+
         q8bIHbiIfw6346HF3Swr1wzjcXK/9qcezpN+DcxG7VULP8fS4czza4g9W1ycDPn4BnXb
         uqIOxXt8qPHzlBkCZT3HBunBXE+vF9iWbTdXMhE5aBC2e7FK1yC+u3JhzlThx8ddS5CN
         r6n0zVNF+ols4uOcjVLUiztiECnLgcTdGgImq/yk3FZIsleAsHgdkMS3hfrzExtJlx3x
         NrVqTqPsPH5R/PpogLbyTkMVYqtS/NksyQVbvh+tf3KV8nt4pZRiL1ypoQTjtRMyAUtA
         LeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GmC7322r1fIXnYGnx5mUEofTBgplNTG1zUqDcgQPjlQ=;
        b=UDn2R7HeODGSxHTjclmAh1fl4fLVwwy1HGmCJu0Ko2s0ZRR9ICtT+T26xHiK6o7+51
         BYbKhXBdn/5CQYSvwyl394PfBayKWCvYl/g4ZX0p6dqz2syEUDI6I3PdPmWvpkQyN+wJ
         6KocpI70P2HL4fkB8lO72gvkVjyWc7GxY0FnhH5zh/xGj1zDmA3+4RtdZ//cNgUkV4/6
         ve3DvX19DE9Ytyv8fZ+gaeAAUV0COJ56rt2+KSRijndykG3uuu+ZMzEz4BMmyyYDYr7h
         l9LWTVHOCEUUaJCymejba4VxCHNWCUxPZdjA3s0Cdt/uMUQFqgHwsugDy3dJXYn8/gBI
         p4mw==
X-Gm-Message-State: APjAAAUYfrt/LQkWsuE0ihedG9D6IRIcf1RTUAEuV6HCLIF4faKSWqRX
        ueZg+jW4Xl0vGNe3IisAlcoFwZm/E60=
X-Google-Smtp-Source: APXvYqwGrELr7QZYn4YMMJCv/7Ks165NyLalG+rWkB/34/sJpMgKo3TDtV4BNYBcTCSP7q8yXSRGAQ==
X-Received: by 2002:a1c:cb83:: with SMTP id b125mr17204959wmg.43.1569836907966;
        Mon, 30 Sep 2019 02:48:27 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id 3sm15600509wmo.22.2019.09.30.02.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:48:27 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch net-next 6/7] net: rtnetlink: introduce helper to get net_device instance by ifname
Date:   Mon, 30 Sep 2019 11:48:19 +0200
Message-Id: <20190930094820.11281-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930094820.11281-1-jiri@resnulli.us>
References: <20190930094820.11281-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce helper function rtnl_get_dev() that gets net_device structure
instance pointer according to passed ifname or ifname attribute.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/rtnetlink.c | 45 ++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a0017737442f..77d4719e5be0 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2778,6 +2778,23 @@ static int do_setlink(const struct sk_buff *skb,
 	return err;
 }
 
+static struct net_device *rtnl_dev_get(struct net *net,
+				       struct nlattr *ifname_attr,
+				       char *ifname)
+{
+	char buffer[IFNAMSIZ];
+
+	if (!ifname) {
+		ifname = buffer;
+		if (ifname_attr)
+			nla_strlcpy(ifname, ifname_attr, IFNAMSIZ);
+		else
+			return NULL;
+	}
+
+	return __dev_get_by_name(net, ifname);
+}
+
 static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
@@ -2807,7 +2824,7 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME])
-		dev = __dev_get_by_name(net, ifname);
+		dev = rtnl_dev_get(net, NULL, ifname);
 	else
 		goto errout;
 
@@ -2880,7 +2897,6 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *tgt_net = net;
 	struct net_device *dev = NULL;
 	struct ifinfomsg *ifm;
-	char ifname[IFNAMSIZ];
 	struct nlattr *tb[IFLA_MAX+1];
 	int err;
 	int netnsid = -1;
@@ -2894,9 +2910,6 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
-	if (tb[IFLA_IFNAME])
-		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
-
 	if (tb[IFLA_TARGET_NETNSID]) {
 		netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
 		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
@@ -2909,7 +2922,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME])
-		dev = __dev_get_by_name(tgt_net, ifname);
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], NULL);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
 	else
@@ -3081,7 +3094,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME])
-		dev = __dev_get_by_name(net, ifname);
+		dev = rtnl_dev_get(net, NULL, ifname);
 	else
 		dev = NULL;
 
@@ -3363,7 +3376,6 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *net = sock_net(skb->sk);
 	struct net *tgt_net = net;
 	struct ifinfomsg *ifm;
-	char ifname[IFNAMSIZ];
 	struct nlattr *tb[IFLA_MAX+1];
 	struct net_device *dev = NULL;
 	struct sk_buff *nskb;
@@ -3386,9 +3398,6 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return PTR_ERR(tgt_net);
 	}
 
-	if (tb[IFLA_IFNAME])
-		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
-
 	if (tb[IFLA_EXT_MASK])
 		ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
 
@@ -3397,7 +3406,7 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME])
-		dev = __dev_get_by_name(tgt_net, ifname);
+		dev = rtnl_dev_get(tgt_net, tb[IFLA_IFNAME], NULL);
 	else
 		goto out;
 
@@ -3480,16 +3489,12 @@ static int rtnl_linkprop(int cmd, struct sk_buff *skb, struct nlmsghdr *nlh,
 		return err;
 
 	ifm = nlmsg_data(nlh);
-	if (ifm->ifi_index > 0) {
+	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	} else if (tb[IFLA_IFNAME]) {
-		char ifname[IFNAMSIZ];
-
-		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
-		dev = __dev_get_by_name(net, ifname);
-	} else {
+	else if (tb[IFLA_IFNAME])
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], NULL);
+	else
 		return -EINVAL;
-	}
 
 	if (!dev)
 		return -ENODEV;
-- 
2.21.0

