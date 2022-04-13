Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABBCC4FF541
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbiDMKzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiDMKy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:54:56 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1EB5A085
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:35 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c6so1856419edn.8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mqsQMGWoSGIiSBxMnK2lmj4CXMMwYXskZS4euBUat3E=;
        b=CqDiUuwWy9Ar00ARP8AYHLDoMiZ0B5XU5oPXE/n2LzKIKzDb49qspNm4EVvgWriuLB
         KZinTcU15VppmpjZEA9orOK8DU7Fo2EdjIq516B5dDIi3jLwGJ4d1e3sGe2O+aDhJKY+
         H9VjOjlcifF4ptjMaqMKm55ysi4GaMzGDDfudxGhosRVz+6ueUxA+jloInbsRhcDb53O
         BwZTcmhYey2vPRJNCxvZxI2Xuz5WeRJyvv6jWAxY+JB7qlxOUvKlNqP06BAXFyx5wTRW
         u2a2YqRGR7QoqxFD7gp5t4D9kXT208DcQkRoSH6JOZTt+0/FHhUaA1KOsD5huESnC9iO
         hKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mqsQMGWoSGIiSBxMnK2lmj4CXMMwYXskZS4euBUat3E=;
        b=psmaotGFuowUeRE25W4rsfyyZEnBCB2ShPy2LKdmWQ0HlLNY7EYME+ISJ4ThYugUyQ
         aO+VQ6RYUpJn1SJrBqCeSmPpt8WxcK0ciZDROaUf7G+jYsLD6CZ+5DJn5YuroYmD3HI1
         QYzDRL+F+IosPynRTXEmSnqwsCWD1C77YPbbPiQqFgFinizgNTChdFJZe9R/wl4YhcoQ
         fiMs/W0CxM2SKyz8UcGLetGkyjH6Gr/0OEclNGP59IFAoq6jD496fLcFmEffrMacea4a
         jIZgl/utO3fYppw/U+eobOD7qHOQ3f7fLzIDcDtBXCf15YawzS3v2OIX4sLx/iMG7RWh
         0OwA==
X-Gm-Message-State: AOAM531INgkwAFq4+SRRd4YOmw6qGKqoxnuHdKBgaKFlZANwOqK9WyJQ
        yWRUbHWa/oFsBdOQc5pAMcPKWKUeTVYlBkmJ
X-Google-Smtp-Source: ABdhPJyxmiTlU/gzlQY4BZV1whXOgPfQ2aPbByMtiLISua5V8l2KvoggVWfXCVu9uWjQFwcmNY+YoA==
X-Received: by 2002:a05:6402:270b:b0:419:3383:7a9f with SMTP id y11-20020a056402270b00b0041933837a9fmr43266917edd.191.1649847153925;
        Wed, 13 Apr 2022 03:52:33 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709063bc800b006e898cfd926sm2960952ejf.134.2022.04.13.03.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:52:33 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4 12/12] net: bridge: fdb: add support for flush filtering based on ifindex and vlan
Date:   Wed, 13 Apr 2022 13:52:02 +0300
Message-Id: <20220413105202.2616106-13-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413105202.2616106-1-razor@blackwall.org>
References: <20220413105202.2616106-1-razor@blackwall.org>
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

Add support for fdb flush filtering based on destination ifindex and
vlan id. The ifindex must either match a port's device ifindex or the
bridge's. The vlan support is trivial since it's already validated by
rtnl_fdb_del, we just need to fill it in.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v2: validate ifindex and fill in vlan id
v3: NDFA -> NDA attributes
v4: use port's ifindex if NTF_MASTER is used and NDA_IFINDEX is not
    specified

 net/bridge/br_fdb.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 74d759d09f94..1a3d583fbc8e 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -622,12 +622,44 @@ static unsigned long __ndm_flags_to_fdb_flags(u8 ndm_flags)
 	return flags;
 }
 
+static int __fdb_flush_validate_ifindex(const struct net_bridge *br,
+					int ifindex,
+					struct netlink_ext_ack *extack)
+{
+	const struct net_device *dev;
+
+	dev = __dev_get_by_index(dev_net(br->dev), ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown flush device ifindex");
+		return -ENODEV;
+	}
+	if (!netif_is_bridge_master(dev) && !netif_is_bridge_port(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flush device is not a bridge or bridge port");
+		return -EINVAL;
+	}
+	if (netif_is_bridge_master(dev) && dev != br->dev) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Flush bridge device does not match target bridge device");
+		return -EINVAL;
+	}
+	if (netif_is_bridge_port(dev)) {
+		struct net_bridge_port *p = br_port_get_rtnl(dev);
+
+		if (p->br != br) {
+			NL_SET_ERR_MSG_MOD(extack, "Port belongs to a different bridge device");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
 		       struct net_device *dev, u16 vid,
 		       struct netlink_ext_ack *extack)
 {
 	u8 ndm_flags = ndm->ndm_flags & ~FDB_FLUSH_IGNORED_NDM_FLAGS;
-	struct net_bridge_fdb_flush_desc desc = {};
+	struct net_bridge_fdb_flush_desc desc = { .vlan_id = vid };
 	struct net_bridge_port *p = NULL;
 	struct net_bridge *br;
 
@@ -663,6 +695,17 @@ int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
 
 		desc.flags_mask |= __ndm_flags_to_fdb_flags(ndm_flags_mask);
 	}
+	if (tb[NDA_IFINDEX]) {
+		int err, ifidx = nla_get_s32(tb[NDA_IFINDEX]);
+
+		err = __fdb_flush_validate_ifindex(br, ifidx, extack);
+		if (err)
+			return err;
+		desc.port_ifindex = ifidx;
+	} else if (p) {
+		/* flush was invoked with port device and NTF_MASTER */
+		desc.port_ifindex = p->dev->ifindex;
+	}
 
 	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
 		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
-- 
2.35.1

