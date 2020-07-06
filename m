Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC33E2151A8
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 06:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgGFE2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 00:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgGFE2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 00:28:06 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A83C061794;
        Sun,  5 Jul 2020 21:28:06 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id t11so11586739pfq.11;
        Sun, 05 Jul 2020 21:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HkDXGrpzcbv2pQ2Q2j+5F77apxMKGENskOQG8vm8n4Q=;
        b=WWDlW5FzJALhGkPj99JWuXJrJ8f38K8PQaQXGOXRAPwBJk3goQPCbbj2i2286nK0ar
         tVFQ4dsfBkCoYo7GAOm8XjZI2T0TUgqWVxJPTjga20XAJd5v0hT6bnP76D2tFh0sIblh
         aYqoe0s3opoARDqJS7BCu9q+U6hmHqBJztWLNjhGkPky4iiwdADQh8ScIgsffNcgPczA
         Xn06c1eMrREd31A7tdwA54ipH8a8J5e57IRN82Ci5mpMDmH5TDtMaU4uiianp/GYshI+
         iITdAxkd4RKpZFgXZB3302sLuGJqWiwFimejoFap+6QtxEdfugrpvn/GMPoPvvAanF7f
         0rrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HkDXGrpzcbv2pQ2Q2j+5F77apxMKGENskOQG8vm8n4Q=;
        b=ChmdqclVQaxIvFcMpBjd7eer27bmRqL3+9QLC6bxh9HUFn2gtYJd7lAr3DqGlgCvTy
         cYRbcQy9XmjKCNgiOVc71vQ8WUzAdhqmLLZbsAbQPXSE/HGcmOgIpLfZNSm96Uo6iS/r
         8NjfpQcGsa2NZkOZRYGd+S/+fbx3R5nT5awngbRIEHRXaZKzX44YTSZMWUAY37vBwWTI
         ICLeyJScoT+GwV8eQ4dD0TW4/hGMnfn8nF1jTt4Yzre3/I/pjD0A1c16nG0RNzCi9Vnj
         jQpD7INqqOPNlK/QgV9kzFJy//DBTGSIbhX26Rl6L9Q/fZKukTMGuKVEjsuKt+c+czEi
         DEvg==
X-Gm-Message-State: AOAM530X6asEKTRZX7XJzQyu5VHKyr2OoDNIKxLjwsJUHlbepo9gFF6g
        svDY6pX+RDmH/URuireY7zHYc79O
X-Google-Smtp-Source: ABdhPJz4ALl968h5Zk7sbcF3uSnkKVPZg1BAxNzxK9NXXLQSeopDHt50gjinix4Dzl1CMf7WdBpIcg==
X-Received: by 2002:aa7:8b4b:: with SMTP id i11mr43489224pfd.123.1594009685324;
        Sun, 05 Jul 2020 21:28:05 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id ia13sm16558680pjb.42.2020.07.05.21.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 21:28:04 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2 1/3] net: ethtool: Introduce ethtool_phy_ops
Date:   Sun,  5 Jul 2020 21:27:56 -0700
Message-Id: <20200706042758.168819-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706042758.168819-1-f.fainelli@gmail.com>
References: <20200706042758.168819-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to decouple ethtool from its PHY library dependency, define an
ethtool_phy_ops singleton which can be overriden by the PHY library when
it loads with an appropriate set of function pointers.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/ethtool.h | 25 +++++++++++++++++++++++++
 net/ethtool/common.c    | 11 +++++++++++
 net/ethtool/common.h    |  2 ++
 3 files changed, 38 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 48ad3b6a0150..0c139a93b67a 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -502,5 +502,30 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
 				       const struct ethtool_link_ksettings *cmd,
 				       u32 *dev_speed, u8 *dev_duplex);
 
+struct netlink_ext_ack;
+struct phy_device;
+struct phy_tdr_config;
+
+/**
+ * struct ethtool_phy_ops - Optional PHY device options
+ * @start_cable_test - Start a cable test
+ * @start_cable_test_tdr - Start a Time Domain Reflectometry cable test
+ *
+ * All operations are optional (i.e. the function pointer may be set to %NULL)
+ * and callers must take this into account. Callers must hold the RTNL lock.
+ */
+struct ethtool_phy_ops {
+	int (*start_cable_test)(struct phy_device *phydev,
+				struct netlink_ext_ack *extack);
+	int (*start_cable_test_tdr)(struct phy_device *phydev,
+				    struct netlink_ext_ack *extack,
+				    const struct phy_tdr_config *config);
+};
+
+/**
+ * ethtool_set_ethtool_phy_ops - Set the ethtool_phy_ops singleton
+ * @ops: Ethtool PHY operations to set
+ */
+void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops);
 
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index aaecfc916a4d..ce4dbae5a943 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -2,6 +2,7 @@
 
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
+#include <linux/rtnetlink.h>
 
 #include "common.h"
 
@@ -373,3 +374,13 @@ int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 
 	return 0;
 }
+
+const struct ethtool_phy_ops *ethtool_phy_ops;
+
+void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops)
+{
+	rtnl_lock();
+	ethtool_phy_ops = ops;
+	rtnl_unlock();
+}
+EXPORT_SYMBOL_GPL(ethtool_set_ethtool_phy_ops);
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index a62f68ccc43a..b83bef38368c 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -37,4 +37,6 @@ bool convert_legacy_settings_to_link_ksettings(
 int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max);
 int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info);
 
+extern const struct ethtool_phy_ops *ethtool_phy_ops;
+
 #endif /* _ETHTOOL_COMMON_H */
-- 
2.25.1

