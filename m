Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C739B474E0F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbhLNWod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbhLNWo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:27 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780DAC061574;
        Tue, 14 Dec 2021 14:44:26 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o20so68607849eds.10;
        Tue, 14 Dec 2021 14:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qQRzAmXXLzovHTeQ0OGq4HgeHs5rmFO6afBOjf35icI=;
        b=nJeIQ20p8bSxqr2yVM3xPQCFIeQ0Q5p/3jPbAfd53xkhQi3R/5I+HyqBAfJ6BI43SY
         1SWsjKLZ0nuUJYHxCnb8OAHiLVHUgPEcVjXb8I8YVt2yM6dSGY1FvwDvhPftOFWJuWIy
         1X/tO40vYqcdvUdXCl3YNb/3qQTz8fM0MJu0plBzuL5GCVbj9FHVGTwv/wqnHPZao9eV
         wRpK3CxioneSn87cgh7llN8ztCILxwJTlhGWZ7gBiR/VuY1GBqfpvf8HwMqOfktal4w8
         T5I78StvWxKtwp3FWzgFzrfS8/IPrCYuJB7iysVvSN0EPHVl1m9eN9IWBCodUdFf6F01
         vYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qQRzAmXXLzovHTeQ0OGq4HgeHs5rmFO6afBOjf35icI=;
        b=BRoxIluBPY7xv35HKkOweeyQ6I3sTjcCr0x7cSw5XVY3e7Lj2ixyOm9EDhWbFn/f4P
         GFiN6pF8J8O71Taz3efdWbgH55FWp33l0q7JE16KsecDbnkdCS2sr15wbqOJH4KmtvPy
         g+bg8q1c5K3JfC8vTagurjMUnlou6ApbieJRCBpc5hZ43BbFdUGS84uELIQDBFEx3SVS
         wkvDwEV/8vLjMk0/A1n5iwwETy1+kw85szjRNMXHqjl7Fkj4wf1gAL+X3RmfBZiPRjHP
         2LX1v/ryetxeD/WB8pzJNeP7vIQN/KMwr8JVxhwovTUS7PLNCzYAo4RHl5ow9L7vtroS
         hlKA==
X-Gm-Message-State: AOAM532lrlcCO9eS1AZAZjvzLcNunKhNjeYqjL21omK2fmGmbXgjMk8G
        /57oTKPAfKqMTNwAgiWYE68=
X-Google-Smtp-Source: ABdhPJzJWLUptNwalC7jeDt7WVMCSLjRP1yoKH/CrVg4T+SmeAo1yV2HpT17gspGljfq4uZBc1wzCQ==
X-Received: by 2002:a17:906:8a62:: with SMTP id hy2mr8523141ejc.347.1639521864862;
        Tue, 14 Dec 2021 14:44:24 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:24 -0800 (PST)
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
Subject: [net-next PATCH RFC v6 03/16] net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
Date:   Tue, 14 Dec 2021 23:43:56 +0100
Message-Id: <20211214224409.5770-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
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

