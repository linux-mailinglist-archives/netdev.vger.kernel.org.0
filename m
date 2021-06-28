Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1530D3B6AB7
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbhF1WEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237380AbhF1WDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:13 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A46C0617A6
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:47 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id i24so28238323edx.4
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r/q9TNcG0vBQwziqLjQHLZZKEegjoonhtgdvGDYDkWc=;
        b=LP2YtQP2iXH0SoRYQOAL0sjU3iyIrCsLNOHgB65tA0z6TVExfnWQp/bcaDUKj5yger
         b+QhJMVHUSSe30y1WBchIVkAWAtxs9jE32VXzrDVusqv0cJYa2xwS/DH+pDquzUTUSMr
         +z8CRwcEWTJkBFFwBLhWx7b2ZEwcU0zkSHXH6a0Y5VDmkNkySXjW2l86oNvNzS8mlw3y
         FLszqCUDYJJVoE/c7OQJwxtlOXqC1VRL6OLAzylrKCHlNiA6dZwTwhcanLa8M0JfRZNC
         hADtCOq1W4Dcc7RdE9GXre9zKrZ9Ub3exd5Gu30OYC/RFFoU3ntr2GZQ7MI1QwjVpgH8
         FS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r/q9TNcG0vBQwziqLjQHLZZKEegjoonhtgdvGDYDkWc=;
        b=d/HPGef/Pfp8cXXi+gIuU9lbPfrharyYw5/qfv+/4PQou/liKzusTUCghphKIUoLfx
         y2hNI2lBYsC0TvGIhM9a4VcGxyuRcvPt93Z2Q2Cux2tJhJpBDb0R3Vc9HAZqUbxfGYG7
         Y4SS63p+A3xHxCsDDk0R1OuWnmwkPl68oCEVYs7sGuxgZy4zc1v723bAYtnS/QFD1gtD
         905T1FTjcZHm80IEPYK4Mug1s1+A3oAQlfT9JMEmzwq1FiqPETqgA2Zo4e85UNJMYfMc
         1XE2ylo4gqmsivndwSPHHLyR9t9kDM+lFURTkjwkepqOj0LUw8QvZxweg+NL+XvUpGZo
         Tbjg==
X-Gm-Message-State: AOAM531JtSVFyExQOyQ8HrxUkVsMYo6dNuF8hskdoR+dzvNBTHvNIb+h
        FP50aEGuBEYsFAdiNWPf4WpOOScszLY=
X-Google-Smtp-Source: ABdhPJxXuqiMIDnz8YQj16YuJQNCsO5pGwG1xWdcIkADjo9yUX2Acqov/xH344CMjY1T4I66OcnpxA==
X-Received: by 2002:aa7:dbc3:: with SMTP id v3mr36060380edt.63.1624917645564;
        Mon, 28 Jun 2021 15:00:45 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:45 -0700 (PDT)
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
Subject: [PATCH v4 net-next 11/14] net: dsa: include bridge addresses which are local in the host fdb list
Date:   Tue, 29 Jun 2021 01:00:08 +0300
Message-Id: <20210628220011.1910096-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

The bridge automatically creates local (not forwarded) fdb entries
pointing towards physical ports with their interface MAC addresses.
For switchdev, the significance of these fdb entries is the exact
opposite of that of non-local entries: instead of sending these frame
outwards, we must send them inwards (towards the host).

NOTE: The bridge's own MAC address is also "local". If that address is
not shared with any port, the bridge's MAC is not be added by this
functionality - but the following commit takes care of that case.

NOTE 2: We mark these addresses as host-filtered regardless of the value
of ds->assisted_learning_on_cpu_port. This is because, as opposed to the
speculative logic done for dynamic address learning on foreign
interfaces, the local FDB entries are rather fixed, so there isn't any
risk of them migrating from one bridge port to another.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ea9a7c1ce83e..d006bd04f84a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2398,10 +2398,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		fdb_info = ptr;
 
 		if (dsa_slave_dev_check(dev)) {
-			if (!fdb_info->added_by_user || fdb_info->is_local)
-				return NOTIFY_OK;
-
 			dp = dsa_slave_to_port(dev);
+
+			if (fdb_info->is_local)
+				host_addr = true;
+			else if (!fdb_info->added_by_user)
+				return NOTIFY_OK;
 		} else {
 			/* Snoop addresses added to foreign interfaces
 			 * bridged with us, or the bridge
@@ -2425,9 +2427,15 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				return NOTIFY_DONE;
 
 			dp = p->dp;
-			host_addr = true;
+			host_addr = fdb_info->is_local;
 
-			if (!fdb_info->added_by_user &&
+			/* FDB entries learned by the software bridge should
+			 * be installed as host addresses only if the driver
+			 * requests assisted learning.
+			 * On the other hand, FDB entries for local termination
+			 * should always be installed.
+			 */
+			if (!fdb_info->added_by_user && !fdb_info->is_local &&
 			    !dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
 
-- 
2.25.1

