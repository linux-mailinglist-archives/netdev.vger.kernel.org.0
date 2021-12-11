Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5D74715E2
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhLKT6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbhLKT6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:19 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660A5C061751;
        Sat, 11 Dec 2021 11:58:19 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id e3so40718480edu.4;
        Sat, 11 Dec 2021 11:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bt2e9cpzmKNi/ZkvQlAApQrFQuwVRyt+mcfwXyAkA5w=;
        b=WFNleZTV8a1lyz195XL6yT7//yjN8x9dlIp6/LY3T+F6b/1jqMvSQ4r9yCWRWdPRDe
         mptmkazKzmPXMsF7z1yE6l3ESnQmXI5eIWpEtBIz6L3iZAhhO1X1ka3/AibQwkpdQSxB
         +UO9aXw/3/vKUPMw7oOpcK9IDmO914LoxCEg7EAkF36s7gr1ArqagA4AqVZHrh3OKrBy
         p/uX7wha7H/PZ1vog2fSKZ0tNwnONj8g0rDzX5gATgZF/AFo6A5CvOknOmZeSJxeCubT
         pqPuHxyO2YsCOo7lyw0DURxKF79i+qork1LEsT/I+pIyRrmeLRYT+Uxv4Sx4qvTZrncV
         RQIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bt2e9cpzmKNi/ZkvQlAApQrFQuwVRyt+mcfwXyAkA5w=;
        b=ao3p6PFUsTc2Z53/5xFiLrybrdWwjwxBToC1A4PjUfMxdxgNkTVlQpPqwys2geEvut
         TG9O82eLAfPkMftSzoqbw98SfssXkRfFf6MNawMZbNiciTnbUw9HDdk4YUeObXNlbtkS
         0J3bJ7TVNRkXlLjyezyLVzoUnoN15zy7/tDMn5nLnPb71YeX8QQoz79tToWcqsPZ5MOa
         cBqKERxErMjeZmyEieA5oV9ZE1A0R9t1pJZKzr5PWns1cZcg/g9+Fro7j0hymm/wUkFc
         CkGCuViXIvntjRn/frT7HtCta/8iX9/MKmTgmPKB9tILLgiaxRNBKGN2wjcHByo3iMWx
         xxOQ==
X-Gm-Message-State: AOAM532PvOH81Y9cDs+zzrZhp+bCbqlGREGnjCtRH0Wm/r/GsqGUi4eb
        ryqm/7vFvJe4ZXOL7lVSOW8=
X-Google-Smtp-Source: ABdhPJwOK22LrvvWTuTvTJPMQuc1N1us8sbmD7Jdrd70IxOyqncnek4n38bGapjYbR3bLwETJ60ZPw==
X-Received: by 2002:a17:906:3545:: with SMTP id s5mr33688969eja.239.1639252697811;
        Sat, 11 Dec 2021 11:58:17 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:17 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 03/15] net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
Date:   Sat, 11 Dec 2021 20:57:46 +0100
Message-Id: <20211211195758.28962-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
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
---
 net/dsa/dsa2.c   | 8 ++++++++
 net/dsa/master.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 86b1e2f11469..90e29dd42d3d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1030,6 +1030,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 	struct dsa_port *dp;
 	int err;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
 			err = dsa_master_setup(dp->master, dp);
@@ -1038,6 +1040,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 		}
 	}
 
+	rtnl_unlock();
+
 	return 0;
 }
 
@@ -1045,9 +1049,13 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
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
2.32.0

