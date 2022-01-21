Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6927B495BE3
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 09:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379572AbiAUI0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 03:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379576AbiAUI0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 03:26:41 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC2AC061574
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 00:26:41 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id h13so7189093plf.2
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 00:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xm8//4+ThFnSznVbopOEeplOnc3QAR6P4C9SkxaG9Jc=;
        b=mPwr21pt6K8t7EZH7cJaOYKYTT+O5lZ4DPzmqNNxRZC100cFtRPWhebXtzCa5/tbRY
         5LyA8kRG24Di4cuFefcutkONRSxSvncf9vdy7VHUzKeVotTb/ALOSNyCeNNXv8b2mYqk
         n4XozW+GfIQ6waOmwBPOPhkB0n4epYK8ulLSVdbG/Buajv5eaZYAXbBxYrDZyrlzxvot
         KKY6dLe1b37K2PpIMJ6mx+3m61iAHFxw5bDqakwTmz4H1hsN5nWmUE4zekkPoInYiGJ+
         r+afkGUxVdulqa6hNW5XPo1aZOJj32PF5BmEAEzkTaIDfs/vDHeRr6dwXSSRlykxV8rV
         e4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xm8//4+ThFnSznVbopOEeplOnc3QAR6P4C9SkxaG9Jc=;
        b=BxAf+TL3SeHOMbFfDEyFmri23nb+HliUSUv2HgDAf+1tLCqeM4Di4wRlSTpvi7kEkT
         yMEEkvyHKuXQNVglvl4OgYHTDgvBP9WReuaIS85FuiooTCnkC30a32mXFjD1mgodjIfe
         ugL0H6c8nQ62X9J6wZeAgKfK+rfDwsb3R3jri4Q+s0ulntJRxiPGbHD/6hkZykz4R0a+
         IIAsrzMZYIiT8rGSgSGwADwwWdwbM0ELgxPau30/7eh+MQ8tooweRSj81JCDaB2k1NYx
         cGXlJQd793gkVYL2l22cejc+JKI4gBW75a3V3nFcjjvfrm5F6pFtzoTEy5xjmRYCOpFG
         rvrg==
X-Gm-Message-State: AOAM532n5QK3xGGS32aGH1rhbUbqNeT1+CPBxt7j8rD/mK9lOCWshI7i
        XyRU7gb4E8QKiM4cuyCFeZY+Zu8m/SQ=
X-Google-Smtp-Source: ABdhPJwI4+CwLu6F4KSUlmufC1qdpWqOJoI7FLqUVX5Oc9qLWuhdEma4r4S95W7lrstHcFgNW6sdjg==
X-Received: by 2002:a17:90a:de8e:: with SMTP id n14mr15361278pjv.122.1642753600123;
        Fri, 21 Jan 2022 00:26:40 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g20sm778344pfc.194.2022.01.21.00.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 00:26:39 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] bonding: use rcu_dereference_rtnl when get bonding active slave
Date:   Fri, 21 Jan 2022 16:25:18 +0800
Message-Id: <20220121082518.1125142-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bond_option_active_slave_get_rcu() should not be used in rtnl_mutex as it
use rcu_dereference(). Replace to rcu_dereference_rtnl() so we also can use
this function in rtnl protected context.

With this update, we can rmeove the rcu_read_lock/unlock in
bonding .ndo_eth_ioctl and .get_ts_info.

Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Fixes: 94dd016ae538 ("bond: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 4 ----
 include/net/bonding.h           | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ec498ce70f35..238b56d77c36 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4133,9 +4133,7 @@ static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cm
 
 		fallthrough;
 	case SIOCGHWTSTAMP:
-		rcu_read_lock();
 		real_dev = bond_option_active_slave_get_rcu(bond);
-		rcu_read_unlock();
 		if (!real_dev)
 			return -EOPNOTSUPP;
 
@@ -5382,9 +5380,7 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 	struct net_device *real_dev;
 	struct phy_device *phydev;
 
-	rcu_read_lock();
 	real_dev = bond_option_active_slave_get_rcu(bond);
-	rcu_read_unlock();
 	if (real_dev) {
 		ops = real_dev->ethtool_ops;
 		phydev = real_dev->phydev;
diff --git a/include/net/bonding.h b/include/net/bonding.h
index f6ae3a4baea4..83cfd2d70247 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -346,7 +346,7 @@ static inline bool bond_uses_primary(struct bonding *bond)
 
 static inline struct net_device *bond_option_active_slave_get_rcu(struct bonding *bond)
 {
-	struct slave *slave = rcu_dereference(bond->curr_active_slave);
+	struct slave *slave = rcu_dereference_rtnl(bond->curr_active_slave);
 
 	return bond_uses_primary(bond) && slave ? slave->dev : NULL;
 }
-- 
2.31.1

