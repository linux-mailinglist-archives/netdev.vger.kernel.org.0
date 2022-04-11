Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5843D4FC373
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344058AbiDKRc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348938AbiDKRcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:32:17 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAC92E9FE
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:30:01 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id s18so9881880ejr.0
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B5S8XFRnGS4ZuUwwM582W5V1tDhecUOXpZ4BPJOGbzU=;
        b=IgONo8IR+mPW+pBo96EoLpsMBSlaoliTJ80GEJ4cI2aamHqnxEvremcO0WUtzXOfpv
         8e/TREd3DDQVzzDe9PaA7g57+WIDuZjWgY0NECehgdmLB/gY0SGEm1Z/eYuLJmlXxkB+
         cZ0yPBZOEM4rYjCa8JL9On1ASJaznbSxjrnrf8+Aa4h78FEw+N9D4tmzMSrLmX1ylASZ
         9hiMa9Ei/bikJEdX5nkwMEQAsH8dUy7FII7eWGy/GsVqs7xGZ5QFESeJOxQaZzEcOQh9
         XI2rPv6ETi8vTrXV8R5M4UbcOyRCFfvxZ2xZm+rht7LxEzFDhvLjYMyaIc+FbFXF/f1D
         reUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B5S8XFRnGS4ZuUwwM582W5V1tDhecUOXpZ4BPJOGbzU=;
        b=UD9+9NPgLjrRu+8VUxKEB8YmT/iZjmz+IoNq1CEuW2r3wd1k1nf0HykqPHp641JCs0
         njOczlADbmBSGdbRfwrDRmsMjtctrK+2j2FR8x8jEpg4x2VwjsTpvAIPOBEDt93nIQjo
         bCeSsICkMGJAQHOanZEJYwYk9jn3aSyxfqQRjC4cvyLuPZxKBp8i2GYqZldALhxE5CxB
         WMD8nWPcrFDdP43TE3z2S22KFWsKtuNR4XhO9UNn6zwS8hMPmWU0N1yFjpB/mGNb0Nma
         lqjH64/NxAklmQa/V9I3yHlU508WIN+4e3eWKiRhqm4xVeURhoEmbEgEYL6ja83nyXP9
         HE6g==
X-Gm-Message-State: AOAM530RzbyZ9OETAXeH4A+k1HiorgIV2SyCLXBNHazwJHPotkenkVcD
        nbQE6it2Nax53+5ILpxS/MDzHD9dD8n5leAt
X-Google-Smtp-Source: ABdhPJx0rBGHTyNa11mn+yvRXnLrQNT6EirEP7Vexyk2a1eeyeWQJRXNGTLf7IAtUsmcyPePMmTvMQ==
X-Received: by 2002:a17:907:6296:b0:6da:64ee:1031 with SMTP id nd22-20020a170907629600b006da64ee1031mr31462695ejc.601.1649698199623;
        Mon, 11 Apr 2022 10:29:59 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090626c600b006e74ef7f092sm10325084ejc.176.2022.04.11.10.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 10:29:59 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@idosch.org, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v2 3/8] net: bridge: fdb: add ndo_fdb_flush op
Date:   Mon, 11 Apr 2022 20:29:29 +0300
Message-Id: <20220411172934.1813604-4-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411172934.1813604-1-razor@blackwall.org>
References: <20220411172934.1813604-1-razor@blackwall.org>
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

Add a minimal ndo_fdb_flush implementation which flushes all entries.
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
index 8d6bab244c4a..76ee2675457a 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -466,6 +466,7 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_fdb_add		 = br_fdb_add,
 	.ndo_fdb_del		 = br_fdb_delete,
 	.ndo_fdb_dump		 = br_fdb_dump,
+	.ndo_fdb_flush		 = br_fdb_flush,
 	.ndo_fdb_get		 = br_fdb_get,
 	.ndo_bridge_getlink	 = br_getlink,
 	.ndo_bridge_setlink	 = br_setlink,
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6ccda68bd473..64a549acdac8 100644
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
 
+int br_fdb_flush(struct ndmsg *ndm, struct nlattr *tb[],
+		 struct net_device *dev, u16 vid,
+		 struct netlink_ext_ack *extack)
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
index 6e62af2e07e9..23ef2982d1bc 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -759,7 +759,11 @@ int br_fdb_init(void);
 void br_fdb_fini(void);
 int br_fdb_hash_init(struct net_bridge *br);
 void br_fdb_hash_fini(struct net_bridge *br);
-void br_fdb_flush(struct net_bridge *br);
+void __br_fdb_flush(struct net_bridge *br);
+int br_fdb_flush(struct ndmsg *ndm, struct nlattr *tb[],
+		 struct net_device *dev, u16 vid,
+		 struct netlink_ext_ack *extack);
+
 void br_fdb_find_delete_local(struct net_bridge *br,
 			      const struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid);
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

