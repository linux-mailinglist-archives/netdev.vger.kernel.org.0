Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E785C2F8A72
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbhAPB1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbhAPB1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:27:12 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6F2C061798
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:54 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id b26so15901954lff.9
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=UdHEWyruKeLwhur2IPon0E2SQ67SwSzgz0jmbjT0WV0=;
        b=Q0zC83esqBajHjZTq2YfJrbzN7uPnJH+0UO7AXZBnM5gJya1TABSJgZ5XG6gYGdvfT
         STUbJhIfwa3ZwtRyYm3nXALsrYfgfHh/oNq3oWcDU45QdPOYfztmd/Z4oQhwG7mWiShh
         p+9QvDBt0+QFqZHvQr33ZJtxq1m3DM/x7mdv/W2UGvODcpIR6yijQXOanmud4YBuJHLD
         Lc0Xyn1Yi9cSsKRLYjgvTEJZAblpJk8vJaCGXfKzbUdY8adcSDLnjOjlIInmv/gbMcEg
         nbOfSaisOleFXD2yEkUm5Zn/fWgX8Hr8Th63UAVGEOw1LnKNhPvwXp6Y2kMcNuJ0n/nf
         9GGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=UdHEWyruKeLwhur2IPon0E2SQ67SwSzgz0jmbjT0WV0=;
        b=f+poB78N/cBgYV8MW+cVf6sl/3Ulv8nEbweBTAwIkIi7m05KrSlhZC85+H2Z0nVFpF
         7ScLXziE0M5/oNrZ3bPuAnFoyLgyqZU6rbpfQkrFHbzEPeISSQ7pQpLAZ3d/CviskN47
         guJGStkmX9Gj+Xcs7xDCfoGazGL+KQmzoX/X8Yi9eP7PUz5l1HX4iPfxPW+lJoMJqWY2
         ED6IfBAjGLW67CIPbT4cIUn+ZJJCMBPj+LZlkQYq22rJmtCGktsgc5mOrG1dlzgSKJYT
         28CJ74uIx+p9LPtFWfX67350OTihcG2ed2bWFcpwe+IY8VOy/BmZ114SNz4MgPPpPa5b
         99wQ==
X-Gm-Message-State: AOAM5317uHacNtFTSUqVJFMrxruIvDyxc1b9oPLWSEh6xGKlukjvHzEp
        mOnDAcSMC0zEXxxbhEEZTd7UNA==
X-Google-Smtp-Source: ABdhPJwI6WlAeciwO+KLLF3mxaeKfOwhTg4LTvuP2qdfdrpS9QjYm+XuCWC81lu50Y4pXCZ2xjyB7w==
X-Received: by 2002:a19:e8a:: with SMTP id 132mr6335019lfo.108.1610760352872;
        Fri, 15 Jan 2021 17:25:52 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 198sm1085686lfn.51.2021.01.15.17.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:25:52 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org
Subject: [RFC net-next 6/7] net: dsa: Sync static FDB entries on foreign interfaces to hardware
Date:   Sat, 16 Jan 2021 02:25:14 +0100
Message-Id: <20210116012515.3152-7-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210116012515.3152-1-tobias@waldekranz.com>
References: <20210116012515.3152-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse the "assisted_learning_on_cpu_port" functionality to always add
entries for user-configured entries on foreign interfaces, even if
assisted_learning_on_cpu_port is not enabled. E.g. in this situation:

   br0
   / \
swp0 dummy0

$ bridge fdb add 02:00:de:ad:00:01 dev dummy0 vlan 1 master

Results in DSA adding an entry in the hardware FDB, pointing this
address towards the CPU port.

The same is true for entries added to the bridge itself, e.g:

$ bridge fdb add 02:00:de:ad:00:01 dev br0 vlan 1 self

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/slave.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1ac46ad4a846..f89b5eb4d2d6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2181,9 +2181,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			else if (!fdb_info->added_by_user)
 				return NOTIFY_OK;
 		} else {
-			/* Snoop addresses learnt on foreign interfaces
-			 * bridged with us, for switches that don't
-			 * automatically learn SA from CPU-injected traffic
+			/* Snoop addresses added to foreign interfaces
+			 * bridged with us, or the bridge
+			 * itself. Dynamically learned addresses can
+			 * also be added for switches that don't
+			 * automatically learn SA from CPU-injected
+			 * traffic.
 			 */
 			struct net_device *br_dev;
 			struct dsa_slave_priv *p;
@@ -2205,7 +2208,8 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 			dp = p->dp->cpu_dp;
 
-			if (!dp->ds->assisted_learning_on_cpu_port)
+			if (!fdb_info->added_by_user &&
+			    !dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
 		}
 
-- 
2.17.1

