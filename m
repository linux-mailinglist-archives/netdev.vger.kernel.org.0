Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA75474CFE
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237811AbhLNVKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237786AbhLNVKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:32 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6908EC06173E;
        Tue, 14 Dec 2021 13:10:31 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r25so66924406edq.7;
        Tue, 14 Dec 2021 13:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qQRzAmXXLzovHTeQ0OGq4HgeHs5rmFO6afBOjf35icI=;
        b=EbYaTy1FZXFwjpv1CYbZeXZ2DBfWWQftlgDLMYQ/vl4WTznhyruYKJ7Xmye7BK7ycG
         VVkRf1a56WfN9aAdsosUxRz+M1gVc9THp2cv8yJzZRXUfBKC3qM3rh+rKC3CZvGv3oMA
         hiYQqir9IBDbOYPZ8SmazEIhs2uKDGdYF6dexpl59zgTgtepkIxGANP6MO1VlPPERF5f
         H1KR8F+ZIe4t+TsCnxS9iJaC2gcbAHsn/FOagxVFdYJXTqixF/qupWk98DOuNIvblsBz
         RXtD0eiqzbzh7AQC2aG+6koCZnZwdvuVy9mjXo3PjSy7Th7pE8z34S8E0S5dq1zX37Qi
         jzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qQRzAmXXLzovHTeQ0OGq4HgeHs5rmFO6afBOjf35icI=;
        b=7DsXO/6Ez0A1XM4/kY3NCqAkfXQI0q4faCGz12i4tsOEQpI3m7n+WNXBPSsTrLo6TG
         l447SHZt3BKqFQEAUT/f5eASv81AmiwcGrgeNIaaRWuFYkDULycs/TnTWy8sq41fz55C
         sRwlGEA5j/FxRyJGbNmd2IrgjRfkCgv0s1VWo7DD6W/BRDqpYAMLa7H2W9KfoEo2EUEI
         UJCr241xgXuZ9PLOg+Ro4x5QddlDBILS6tdRfHcW/6QlUWEbox7PhRV0Sexq7TRfiqzh
         iOgDT6PzrdOLR2E2Jm73CQT8l6qRxvXcL0fGX6fpW5KeFynbhabaH0rG2kOfp4YlDe7U
         gU/g==
X-Gm-Message-State: AOAM5314gJGrGn7fsSVYxeX0SseRKCn1u0EFd0h0K4tcU1mN36iX2tXa
        pteLVtPyE5+WR4nM9A/MNcQ=
X-Google-Smtp-Source: ABdhPJzX7wpPujsO1PE9ZnXjGDyARJUaLlPFiakpyvAJMzbWLSWNG9fQ7esDX+jTPot0XlkOf+QfxQ==
X-Received: by 2002:a17:907:c15:: with SMTP id ga21mr8119750ejc.349.1639516229623;
        Tue, 14 Dec 2021 13:10:29 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:29 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 03/16] net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
Date:   Tue, 14 Dec 2021 22:09:58 +0100
Message-Id: <20211214211011.24850-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA needs to simulate master tracking events when a binding is first
with a DSA master established and torn down, in order to give drivers
the simplifying guarantee that ->master_state_change calls are made
only when the master's readiness state to pass traffic changes.
master_state_change() provide a operational bool that DSA driver can use
to understand if DSA master is operational or not.
To avoid races, we need to block the reception of
NETDEV_UP/NETDEV_CHANGE/NETDEV_GOING_DOWN events in the netdev notifier
chain while we are changing the master's dev->dsa_ptr (this changes what
netdev_uses_dsa(dev) reports).

The dsa_master_setup() and dsa_master_teardown() functions optionally
require the rtnl_mutex to be held, if the tagger needs the master to be
promiscuous, these functions call dev_set_promiscuity(). Move the
rtnl_lock() from that function and make it top-level.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa2.c   | 8 ++++++++
 net/dsa/master.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index eb466e92069c..e8b56c84a417 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1038,6 +1038,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 	struct dsa_port *dp;
 	int err;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
 			err = dsa_master_setup(dp->master, dp);
@@ -1046,6 +1048,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 		}
 	}
 
+	rtnl_unlock();
+
 	return 0;
 }
 
@@ -1053,9 +1057,13 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list)
 		if (dsa_port_is_cpu(dp))
 			dsa_master_teardown(dp->master);
+
+	rtnl_unlock();
 }
 
 static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index f4efb244f91d..2199104ca7df 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -267,9 +267,9 @@ static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
 	if (!ops->promisc_on_master)
 		return;
 
-	rtnl_lock();
+	ASSERT_RTNL();
+
 	dev_set_promiscuity(dev, inc);
-	rtnl_unlock();
 }
 
 static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
-- 
2.33.1

