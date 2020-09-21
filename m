Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFEF272192
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgIUK4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgIUK4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:19 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B152EC0613D2
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:18 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e17so11667649wme.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pqwHkNx0jImltrLZO0K43fN+lXj/WQjYzW88BeELohU=;
        b=ksjAAvYmkCYlp8jtCb7nM1DJsVS2cYQR9j+7H3NuzQ4j8KQF5C0Pnk/vIJcBdTbfJV
         cbO+9Bs402jPJWBPi5aiGUg1zw/p0a6Qlpb/bhzqmLxG79R/UGygVb8/15U92GIefxE7
         Yg1zxxFcnu+b87sqOq6b5Wv3xzkxF59Zc4+KfsoN6V1mfvfeHnTembsQqm1gTuVbuMxz
         ES2vgPXNgcHCsZc2dWyKIWJFINd3ot66exvd/J8jnhq1KgBkkBTwA/vjl/JXIadAtsjn
         FgfZqWDRCF3Ph1GtV9tli5p70MrO0aKmcrU9vlR2l9V7jWlHg+d/I640m2fuemJ00583
         OyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pqwHkNx0jImltrLZO0K43fN+lXj/WQjYzW88BeELohU=;
        b=rqhNHy/4TbkH2EwigHVJOJJtVH84bGcVHkum1WGPKBlz2UiVGz4ce5tOC+E5DFPSWM
         NG2lqcFoCkSeUG093AeinYdk4DXkLFuLrjaz6I8edJn0WjyFw7l0lmXioLR05XC9StZE
         2fwm25VHn2z0ctNjMxIL7Dn6r8RO3pIWWfZzo/yt+ZShKhJQ/sJ2h+M2c4F4CjFRwNY0
         Z4J/xolTRPBhDJQwEwPw1BbrNlJsGFadV5R14Q9RoE8GC2VPhE5oa84sAwWAXHFGGqLk
         BM+AT/XHG7rtCBWuDd4a7dUrdWBCeLaPsr+cJN2owm/Q+jde+k+ZjROUb0tpdkQtxx2w
         M5BQ==
X-Gm-Message-State: AOAM531Ne8Q6+vH2RPRS0et7yCB0BlXWvxzU3+z+5GLMJimoHxWgqUyg
        u9WaTW8CbssGN9B7BGsmKaoy9bWwVS5ZuxUk6aeUTg==
X-Google-Smtp-Source: ABdhPJzqRbdKTqowiZq/NlIpHHcctARlU3IDwOeq5aBXxboyvxunPaMKKcTR9HZq7MLCBJnSmyFKsw==
X-Received: by 2002:a1c:9ec1:: with SMTP id h184mr30158190wme.180.1600685777036;
        Mon, 21 Sep 2020 03:56:17 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:16 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 07/16] net: bridge: mdb: add support to extend add/del commands
Date:   Mon, 21 Sep 2020 13:55:17 +0300
Message-Id: <20200921105526.1056983-8-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Since the MDB add/del code expects an exact struct br_mdb_entry we can't
really add any extensions, thus add a new nested attribute at the level of
MDBA_SET_ENTRY called MDBA_SET_ENTRY_ATTRS which will be used to pass
all new options via netlink attributes. This patch doesn't change
anything functionally since the new attribute is not used yet, only
parsed.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h | 12 ++++++++++++
 net/bridge/br_mdb.c            | 22 +++++++++++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 75a2ac479247..dc52f8cffa0d 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -530,10 +530,22 @@ struct br_mdb_entry {
 enum {
 	MDBA_SET_ENTRY_UNSPEC,
 	MDBA_SET_ENTRY,
+	MDBA_SET_ENTRY_ATTRS,
 	__MDBA_SET_ENTRY_MAX,
 };
 #define MDBA_SET_ENTRY_MAX (__MDBA_SET_ENTRY_MAX - 1)
 
+/* [MDBA_SET_ENTRY_ATTRS] = {
+ *    [MDBE_ATTR_xxx]
+ *    ...
+ * }
+ */
+enum {
+	MDBE_ATTR_UNSPEC,
+	__MDBE_ATTR_MAX,
+};
+#define MDBE_ATTR_MAX (__MDBE_ATTR_MAX - 1)
+
 /* Embedded inside LINK_XSTATS_TYPE_BRIDGE */
 enum {
 	BRIDGE_XSTATS_UNSPEC,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index a1ff0a372185..907df6d695ec 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -670,9 +670,12 @@ static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
 	return true;
 }
 
+static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
+};
+
 static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct net_device **pdev, struct br_mdb_entry **pentry,
-			struct netlink_ext_ack *extack)
+			struct nlattr **mdb_attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct br_mdb_entry *entry;
@@ -719,6 +722,17 @@ static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 	*pentry = entry;
 
+	if (tb[MDBA_SET_ENTRY_ATTRS]) {
+		err = nla_parse_nested(mdb_attrs, MDBE_ATTR_MAX,
+				       tb[MDBA_SET_ENTRY_ATTRS],
+				       br_mdbe_attrs_pol, extack);
+		if (err)
+			return err;
+	} else {
+		memset(mdb_attrs, 0,
+		       sizeof(struct nlattr *) * (MDBE_ATTR_MAX + 1));
+	}
+
 	return 0;
 }
 
@@ -803,6 +817,7 @@ static int __br_mdb_add(struct net *net, struct net_bridge *br,
 static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		      struct netlink_ext_ack *extack)
 {
+	struct nlattr *mdb_attrs[MDBE_ATTR_MAX + 1];
 	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_port *p = NULL;
@@ -812,7 +827,7 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_bridge *br;
 	int err;
 
-	err = br_mdb_parse(skb, nlh, &dev, &entry, extack);
+	err = br_mdb_parse(skb, nlh, &dev, &entry, mdb_attrs, extack);
 	if (err < 0)
 		return err;
 
@@ -921,6 +936,7 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		      struct netlink_ext_ack *extack)
 {
+	struct nlattr *mdb_attrs[MDBE_ATTR_MAX + 1];
 	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_port *p = NULL;
@@ -930,7 +946,7 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_bridge *br;
 	int err;
 
-	err = br_mdb_parse(skb, nlh, &dev, &entry, extack);
+	err = br_mdb_parse(skb, nlh, &dev, &entry, mdb_attrs, extack);
 	if (err < 0)
 		return err;
 
-- 
2.25.4

