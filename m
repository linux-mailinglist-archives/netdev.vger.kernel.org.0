Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B594FE299
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356148AbiDLN3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356781AbiDLN2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:28:11 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE125659A
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:19 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id c6so7190403edn.8
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JYUem4jVllKE4fErwzsUEmzSIjtFH958yAp/oX4NO6c=;
        b=rhgdR0Yr5H06JUf05oWHKLjjoT1+tiA41ga1HncvSzBN67TKCJsdCCEqd6jqMmJXD3
         dZCOja0r6B4mxTixieRUYUcCpO75IrzSvrWrJArRnTIpe4U8tTcGb0g13MH64I4rTf1+
         xCwLEQfYai8lpSPGqaOD7hYfImpGgtaC4Acf/mV5PbGMbl83Hp07d5gTup62BQwWyfvW
         uQGG3ka1JWgwF+ByBRSuDWTOq4HrwCVhSd/D8dCZx5VylmN3AVcFqZ94K896EB73whOk
         qdWS/v/o3GNUfzRAl3Uk92LlcpN3szWQEFpjOuxf15cIhm8T1WDNXrWXCkZyxeF2o19F
         5O3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JYUem4jVllKE4fErwzsUEmzSIjtFH958yAp/oX4NO6c=;
        b=COsU4nmq+ENV6EBQKrWvmIBYVPElH5zwEs2sQ5aBHrE9F5Zff3ZD6hur4KVWwVzYq9
         ma9Zo+KUrYewrD89Ptbzfe58p/XfflvxgRpaGUHLNLV3r284tj0oJ1kZlktv6+BvIzee
         zJ+PlMTMs0tRV1nHQG0Pu5kqtoa6EZyJfbn8YuLXtYdBNL08AI32SfICP9LHeXIUQ6Jn
         fYwMXI2fNr3jCCfXlXtRCh5nfdR7JabAMTCM8mh3KXyD8CQ4KLTCxJ8zB8O/9KPTdndt
         DGWdZ/MSrfZxmiRG4NCwpj8AJpexhju+Mmn65JF3ork3o83t4Arw35zkLLKDUdXoVD8v
         CAAw==
X-Gm-Message-State: AOAM530gDJvB3K6o+GLNZ26RNuEHV9Fq2CT3iXjtdPMllaiz6B5zy2dz
        4CJYFRw/ZZ2QAhabzVlI7itKU4EeJkse5nwk
X-Google-Smtp-Source: ABdhPJwsGXTRB0DSW4kgzXKegX1MacwRNtcWIm7EGlewK/Bq18TVrNiTk9X/G4hllkqNOTxMn35e4Q==
X-Received: by 2002:a05:6402:14d0:b0:41d:946b:7494 with SMTP id f16-20020a05640214d000b0041d946b7494mr2814997edx.190.1649769792890;
        Tue, 12 Apr 2022 06:23:12 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm3771301ejn.204.2022.04.12.06.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:23:12 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v3 4/8] net: bridge: fdb: add ndo_fdb_del_bulk
Date:   Tue, 12 Apr 2022 16:22:41 +0300
Message-Id: <20220412132245.2148794-5-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412132245.2148794-1-razor@blackwall.org>
References: <20220412132245.2148794-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a minimal ndo_fdb_del_bulk implementation which flushes all entries.
Support for more fine-grained filtering will be added in the following
patches.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_device.c   |  1 +
 net/bridge/br_fdb.c      | 25 ++++++++++++++++++++++++-
 net/bridge/br_netlink.c  |  2 +-
 net/bridge/br_private.h  |  6 +++++-
 net/bridge/br_sysfs_br.c |  2 +-
 5 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8d6bab244c4a..58a4f70e01e3 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -465,6 +465,7 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_fix_features        = br_fix_features,
 	.ndo_fdb_add		 = br_fdb_add,
 	.ndo_fdb_del		 = br_fdb_delete,
+	.ndo_fdb_del_bulk	 = br_fdb_delete_bulk,
 	.ndo_fdb_dump		 = br_fdb_dump,
 	.ndo_fdb_get		 = br_fdb_get,
 	.ndo_bridge_getlink	 = br_getlink,
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6ccda68bd473..fd7012c32cd5 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -559,7 +559,7 @@ void br_fdb_cleanup(struct work_struct *work)
 }
 
 /* Completely flush all dynamic entries in forwarding database.*/
-void br_fdb_flush(struct net_bridge *br)
+void __br_fdb_flush(struct net_bridge *br)
 {
 	struct net_bridge_fdb_entry *f;
 	struct hlist_node *tmp;
@@ -572,6 +572,29 @@ void br_fdb_flush(struct net_bridge *br)
 	spin_unlock_bh(&br->hash_lock);
 }
 
+int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
+		       struct net_device *dev, u16 vid,
+		       struct netlink_ext_ack *extack)
+{
+	struct net_bridge *br;
+
+	if (netif_is_bridge_master(dev)) {
+		br = netdev_priv(dev);
+	} else {
+		struct net_bridge_port *p = br_port_get_rtnl(dev);
+
+		if (!p) {
+			NL_SET_ERR_MSG_MOD(extack, "Device is not a bridge port");
+			return -EINVAL;
+		}
+		br = p->br;
+	}
+
+	__br_fdb_flush(br);
+
+	return 0;
+}
+
 /* Flush all entries referring to a specific port.
  * if do_all is set also flush static entries
  * if vid is set delete all entries that match the vlan_id
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 200ad05b296f..c59c775730bb 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1327,7 +1327,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	}
 
 	if (data[IFLA_BR_FDB_FLUSH])
-		br_fdb_flush(br);
+		__br_fdb_flush(br);
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	if (data[IFLA_BR_MCAST_ROUTER]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 6e62af2e07e9..3ba50e41aa4f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -759,7 +759,8 @@ int br_fdb_init(void);
 void br_fdb_fini(void);
 int br_fdb_hash_init(struct net_bridge *br);
 void br_fdb_hash_fini(struct net_bridge *br);
-void br_fdb_flush(struct net_bridge *br);
+void __br_fdb_flush(struct net_bridge *br);
+
 void br_fdb_find_delete_local(struct net_bridge *br,
 			      const struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid);
@@ -781,6 +782,9 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 
 int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 		  struct net_device *dev, const unsigned char *addr, u16 vid);
+int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
+		       struct net_device *dev, u16 vid,
+		       struct netlink_ext_ack *extack);
 int br_fdb_add(struct ndmsg *nlh, struct nlattr *tb[], struct net_device *dev,
 	       const unsigned char *addr, u16 vid, u16 nlh_flags,
 	       struct netlink_ext_ack *extack);
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 3f7ca88c2aa3..7a2cf3aebc84 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -344,7 +344,7 @@ static DEVICE_ATTR_RW(group_addr);
 static int set_flush(struct net_bridge *br, unsigned long val,
 		     struct netlink_ext_ack *extack)
 {
-	br_fdb_flush(br);
+	__br_fdb_flush(br);
 	return 0;
 }
 
-- 
2.35.1

