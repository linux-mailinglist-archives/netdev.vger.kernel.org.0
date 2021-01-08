Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AF22EEA4B
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbhAHAVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728954AbhAHAVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:45 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2A0C0612FA
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:31 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id dk8so9556640edb.1
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RnIaag0tweoJmelZ4Q1Xq1u3Ft4Miz3Y1p4DbCIrsek=;
        b=RuYTgz1lXSX0WHSUrBi/GXNCTSta453FL88vJdsGijA/EU6x97o9iiRiDL0VD36Pqr
         5NmhMKKkglOkPN5PBEgEDIQMn9zCp9++2jAIWBZawf7fKfFeypFN9vHbRm3Nh/RFjenM
         wbQTbgkVHYiOiJNFUFg6MSxdY+EnvY0ap4+ty8++AOTnvzTq1CsJ5kG6/S02NPNkf+Z/
         JyNqKp3XdFdipm7ywz6Nixfqar5zij1k67mje85DvKmyD3muB+Yt+/oWQrVqUV+A8xHs
         2mL5DsBriwkAQbf2+UBbNfW1/ns7VrmuQ60SjyqCPhSCNr//+jpHQSCBLqp43LgJ+POe
         mdRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RnIaag0tweoJmelZ4Q1Xq1u3Ft4Miz3Y1p4DbCIrsek=;
        b=AFgzVYBM3caAGVj2RYaMCWH8ao9o0+AtcFH18Z2ZbFTIBOTdu2NF1CrjfyyNNLxANM
         7XwdU0WS2d4072qWddkUvumvdCTRIroLRjRIzbQWJY88Mvg0iN+xb1E4FUfdGxq0KPl+
         uUNmBzN/UKucHit31D25kekfE4dg6sHSELAW/kQ6feVuv8npUyrfoGWryN+7erSirK7y
         FNjXhs7Isy0dwPcsaU3YzDXhJsTwwSaglZ2tAX38eclfn9EslberCPCfPnWLoXiMIjwE
         0QTMv30o87jfDwPs8T2gb2el4lI1PCCzj/hPwhZnxaJ/r/9TRBt0QyRfI1c33/N8CpBD
         OIaw==
X-Gm-Message-State: AOAM532+tUqmu851CbcNHrJ8FNuVa9PhzTcgy1GUd02UYiRpYsJ/nAHS
        KroSIApW3D+8yn/6CMsarYU=
X-Google-Smtp-Source: ABdhPJzhxUs2AliG9AB7n500jiE0u4I3rBRmPCuzaCt8cCB3AzcsxMmBnQWoQhJaWfPCrDbmdXAUlg==
X-Received: by 2002:a05:6402:1692:: with SMTP id a18mr3321206edv.321.1610065230737;
        Thu, 07 Jan 2021 16:20:30 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:30 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 05/18] s390/appldata_net_sum: hold the netdev lists lock when retrieving device statistics
Date:   Fri,  8 Jan 2021 02:19:52 +0200
Message-Id: <20210108002005.3429956-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

In the case of the appldata driver, an RCU read-side critical section is
used to ensure the integrity of the list of network interfaces, because
the driver iterates through all net devices in the netns to aggregate
statistics. We still need some protection against an interface
registering or deregistering, and the writer-side lock, the netns's
mutex, is fine for that, because it offers sleepable context.

The ops->callback function is called from under appldata_ops_mutex
protection, so this is proof that the context is sleepable and holding
a mutex is therefore fine.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 arch/s390/appldata/appldata_net_sum.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/s390/appldata/appldata_net_sum.c b/arch/s390/appldata/appldata_net_sum.c
index 59c282ca002f..4db886980cba 100644
--- a/arch/s390/appldata/appldata_net_sum.c
+++ b/arch/s390/appldata/appldata_net_sum.c
@@ -78,8 +78,9 @@ static void appldata_get_net_sum_data(void *data)
 	tx_dropped = 0;
 	collisions = 0;
 
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
+	netif_lists_lock(&init_net);
+
+	for_each_netdev(&init_net, dev) {
 		const struct rtnl_link_stats64 *stats;
 		struct rtnl_link_stats64 temp;
 
@@ -95,7 +96,8 @@ static void appldata_get_net_sum_data(void *data)
 		collisions += stats->collisions;
 		i++;
 	}
-	rcu_read_unlock();
+
+	netif_lists_unlock(&init_net);
 
 	net_data->nr_interfaces = i;
 	net_data->rx_packets = rx_packets;
-- 
2.25.1

