Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBC73B6AB8
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbhF1WEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237383AbhF1WDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:13 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0882CC061768
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:46 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t3so28240185edc.7
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cOcrEyVseqjoteqwx/PlBKbx2ck6ms2QqjNCJLmGW94=;
        b=lMTeIUOehbBkr3Cxr/4rI0sHRAiHbDjcYFnkTQDR/zzg2HNbhqCH+Owqdbdz3NSwcX
         8HSDwtuKw7kdY11kF56IV3/MQCnVUQ12/SdeQibUQey0qWEAyxzgl46AwZNo40uWmBFM
         CMK0Yz5h8Gv/sKvRTQ/SOGQgy9k6U/hEKQz5llauf6CeDud01VzLvE3TNXEZj/vVVIej
         /EHTZzL2zQINp69aOlofNxeaFOc0kHLVqaFd8LU43+PsBUc+6F5L+ytQEwHblVlFqLrR
         /QAu9RZ6uCqg6zYnM3PFFlHuTjbsp8lweS2cC5iVazUBne66pS76OxKRiWUn+17r2PTZ
         Rk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cOcrEyVseqjoteqwx/PlBKbx2ck6ms2QqjNCJLmGW94=;
        b=G0oTpB/FlGaTQ3ltLiiCAWAmFylh1OrbmvfArZSBATV4eDbIJ8uW6Fo/stXXECYxAk
         fdTVsYfpSWdXa9d8tp6xvogc63UgkfvDXqPGAZFLcHAXcf7axgVPKY63pvqQQyQ+n+Jh
         PMiUQcHa8J49NEwTaJVd8lSQVab4pT9cw6rsY2SpVhhSZIgIxzYDeAHxGCawRB96mUyG
         iroerBIFVCOi3bZyab5qBQKvEZSpGjhJU6nDMYRBAGT+saTq2YjRriWzL2mw6Hr9px/C
         exq5kxvi6nHdDVCL4Xf4jU1R5nNKeDK95ixUjSLHCVI976XtrYmjSTOP3iLFofYRFt+L
         f+AA==
X-Gm-Message-State: AOAM5323KdaQjHqo1ZUWam9rrJwsjhqJrIwiLtUgwcKG2mJwR1k2NsGg
        ZGRXtQ8OV33BB6TWbLr1zpV4id5gv40=
X-Google-Smtp-Source: ABdhPJzwNoyNpecVJykjQovr3w6RSmFWuyPSkr/IrzIZ2qBt5joRzTOtTOzsNE3zxNMD7qBy4gvuXA==
X-Received: by 2002:aa7:dc0c:: with SMTP id b12mr14422499edu.105.1624917644539;
        Mon, 28 Jun 2021 15:00:44 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 10/14] net: dsa: sync static FDB entries on foreign interfaces to hardware
Date:   Tue, 29 Jun 2021 01:00:07 +0300
Message-Id: <20210628220011.1910096-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Reuse the "assisted_learning_on_cpu_port" functionality to always add
entries for user-configured entries on foreign interfaces, even if
assisted_learning_on_cpu_port is not enabled. E.g. in this situation:

   br0
   / \
swp0 dummy0

$ bridge fdb add 02:00:de:ad:00:01 dev dummy0 vlan 1 master static

Results in DSA adding an entry in the hardware FDB, pointing this
address towards the CPU port.

The same is true for entries added to the bridge itself, e.g:

$ bridge fdb add 02:00:de:ad:00:01 dev br0 vlan 1 self local

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ac7f4f200ab1..ea9a7c1ce83e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2403,9 +2403,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 			dp = dsa_slave_to_port(dev);
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
@@ -2424,7 +2427,8 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			dp = p->dp;
 			host_addr = true;
 
-			if (!dp->ds->assisted_learning_on_cpu_port)
+			if (!fdb_info->added_by_user &&
+			    !dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
 
 			/* When the bridge learns an address on an offloaded
-- 
2.25.1

