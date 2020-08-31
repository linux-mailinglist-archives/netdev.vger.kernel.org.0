Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372E7257BCB
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgHaPKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgHaPKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:10:09 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9C5C06123B
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:09:59 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h15so6274417wrt.12
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=miNptBe8BBDQ8BFff+EdYOeEqxjtBQ52b3SULNJtyxc=;
        b=KCIbbX6bJsvAw+HWbPC8pnFfqDzdvidwFkeGZzKBUOH+mWa+YzLzQ5Vwyh1Obg26js
         Z2cK0jBREUgx0E/M7yG638PILVZKmUbEvGfac5/5Sy/VQrrFIWfdxxylsoaZh3dLbarw
         ryOQwwGlDMgdMJDlsxoLABpw/poFWleFOsdn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=miNptBe8BBDQ8BFff+EdYOeEqxjtBQ52b3SULNJtyxc=;
        b=TB/XxmWWTj4DWgiNElVMCjBN0g0I8HC1NK6nBAgGnAYBwBtnDlXiCGkGu0AMkRnqgP
         mXTGBCuwXkjIOadGNegozb2z0OXM1opb8TNBKlqfn6fsDBFFsBxWqdj8ejWQCvPVVpKS
         Hjfgp1U4U7liMymouIbpO3CXll1sxfqR9NAHz73Sd+tdwYJGJrDexs+bQIDzHu5VxeBk
         wpMxcXMwSlb+rntqARxGkiGysRzR4ezBId+nu03szU/2qZZOVEa/APMJdzEaTgC0vwQB
         a5QXkwTHyOeQjNCdv4zwrtuLktyt+zF/SIo64C1nokT7YoRV5/l/7fWiHLZn5/lJAzEx
         Ywjg==
X-Gm-Message-State: AOAM532qvj7kNezgEWi08inCPLNGx2Rgk2SX6Ru+C1gIkdrIdpv2WvNm
        brn0GMl0ZZn9SOAyCkwYmKKZUifvWIcbSwgD
X-Google-Smtp-Source: ABdhPJwhIRvKLrC6I3/pPOn633f+x6CwFLj3kE4Yvgnl396YPplp7fueyEU6uycGZnD7MFLoGfeiiQ==
X-Received: by 2002:a5d:4603:: with SMTP id t3mr1971503wrq.424.1598886594662;
        Mon, 31 Aug 2020 08:09:54 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:09:53 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 03/15] net: bridge: mcast: add support for src list and filter mode dumping
Date:   Mon, 31 Aug 2020 18:08:33 +0300
Message-Id: <20200831150845.1062447-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support per port group src list (address and timer) and filter mode
dumping. Currently limited only to IPv4.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/if_bridge.h | 21 +++++++++++
 net/bridge/br_mdb.c            | 66 ++++++++++++++++++++++++++++++++--
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index c1227aecd38f..75a2ac479247 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -455,10 +455,31 @@ enum {
 enum {
 	MDBA_MDB_EATTR_UNSPEC,
 	MDBA_MDB_EATTR_TIMER,
+	MDBA_MDB_EATTR_SRC_LIST,
+	MDBA_MDB_EATTR_GROUP_MODE,
 	__MDBA_MDB_EATTR_MAX
 };
 #define MDBA_MDB_EATTR_MAX (__MDBA_MDB_EATTR_MAX - 1)
 
+/* per mdb entry source */
+enum {
+	MDBA_MDB_SRCLIST_UNSPEC,
+	MDBA_MDB_SRCLIST_ENTRY,
+	__MDBA_MDB_SRCLIST_MAX
+};
+#define MDBA_MDB_SRCLIST_MAX (__MDBA_MDB_SRCLIST_MAX - 1)
+
+/* per mdb entry per source attributes
+ * these are embedded in MDBA_MDB_SRCLIST_ENTRY
+ */
+enum {
+	MDBA_MDB_SRCATTR_UNSPEC,
+	MDBA_MDB_SRCATTR_ADDRESS,
+	MDBA_MDB_SRCATTR_TIMER,
+	__MDBA_MDB_SRCATTR_MAX
+};
+#define MDBA_MDB_SRCATTR_MAX (__MDBA_MDB_SRCATTR_MAX - 1)
+
 /* multicast router types */
 enum {
 	MDB_RTR_TYPE_DISABLED,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 025a5aff2b2f..7e6a1f6aff8a 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -77,6 +77,52 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
 #endif
 }
 
+static int __mdb_fill_srcs(struct sk_buff *skb,
+			   struct net_bridge_port_group *p)
+{
+	struct net_bridge_group_src *ent;
+	struct nlattr *nest, *nest_ent;
+
+	if (hlist_empty(&p->src_list))
+		return 0;
+
+	nest = nla_nest_start(skb, MDBA_MDB_EATTR_SRC_LIST);
+	if (!nest)
+		return -EMSGSIZE;
+
+	hlist_for_each_entry(ent, &p->src_list, node) {
+		nest_ent = nla_nest_start(skb, MDBA_MDB_SRCLIST_ENTRY);
+		if (!nest_ent)
+			goto out_cancel_err;
+		switch (ent->addr.proto) {
+		case htons(ETH_P_IP):
+			if (nla_put_in_addr(skb, MDBA_MDB_SRCATTR_ADDRESS,
+					    ent->addr.u.ip4)) {
+				nla_nest_cancel(skb, nest_ent);
+				goto out_cancel_err;
+			}
+			break;
+		default:
+			nla_nest_cancel(skb, nest_ent);
+			continue;
+		}
+		if (nla_put_u32(skb, MDBA_MDB_SRCATTR_TIMER,
+				br_timer_value(&ent->timer))) {
+			nla_nest_cancel(skb, nest_ent);
+			goto out_cancel_err;
+		}
+		nla_nest_end(skb, nest_ent);
+	}
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+
+out_cancel_err:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static int __mdb_fill_info(struct sk_buff *skb,
 			   struct net_bridge_mdb_entry *mp,
 			   struct net_bridge_port_group *p)
@@ -119,6 +165,15 @@ static int __mdb_fill_info(struct sk_buff *skb,
 		nla_nest_cancel(skb, nest_ent);
 		return -EMSGSIZE;
 	}
+	if (p &&
+	    mp->br->multicast_igmp_version == 3 &&
+	    mp->addr.proto == htons(ETH_P_IP) &&
+	    (__mdb_fill_srcs(skb, p) ||
+	     nla_put_u8(skb, MDBA_MDB_EATTR_GROUP_MODE, p->filter_mode))) {
+		nla_nest_cancel(skb, nest_ent);
+		return -EMSGSIZE;
+	}
+
 	nla_nest_end(skb, nest_ent);
 
 	return 0;
@@ -127,7 +182,7 @@ static int __mdb_fill_info(struct sk_buff *skb,
 static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			    struct net_device *dev)
 {
-	int idx = 0, s_idx = cb->args[1], err = 0;
+	int idx = 0, s_idx = cb->args[1], err = 0, pidx = 0, s_pidx = cb->args[2];
 	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_mdb_entry *mp;
 	struct nlattr *nest, *nest2;
@@ -152,7 +207,7 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			break;
 		}
 
-		if (mp->host_joined) {
+		if (!s_pidx && mp->host_joined) {
 			err = __mdb_fill_info(skb, mp, NULL);
 			if (err) {
 				nla_nest_cancel(skb, nest2);
@@ -164,13 +219,19 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 		      pp = &p->next) {
 			if (!p->port)
 				continue;
+			if (pidx < s_pidx)
+				goto skip_pg;
 
 			err = __mdb_fill_info(skb, mp, p);
 			if (err) {
 				nla_nest_cancel(skb, nest2);
 				goto out;
 			}
+skip_pg:
+			pidx++;
 		}
+		pidx = 0;
+		s_pidx = 0;
 		nla_nest_end(skb, nest2);
 skip:
 		idx++;
@@ -178,6 +239,7 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 
 out:
 	cb->args[1] = idx;
+	cb->args[2] = pidx;
 	nla_nest_end(skb, nest);
 	return err;
 }
-- 
2.25.4

