Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CF63B73E9
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhF2OKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbhF2OKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:10:07 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DBBC0611C2
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:33 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id n25so4957251edw.9
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fKBJ+HCJQ1IihBjBCwPYHx5qSIWh4l6D9kHNjLPM2ok=;
        b=LUK7Je5mFDyxa3Ck/5fKxRcW1h76Y6D+iaxJLub1wjj+YhxP3HAS38wYKoUQvr9lrE
         RXetrSp0J6/onP+1RXJ94Rv7SKI/YQ+fQmvrmIoX3iUlXTP5F8+MJaJ+0bxX0thtmBoS
         v4OJqKxmQ+alqAMgUD+lcKUSzhzyUcqgkBOJ66Q92VDePY5CiPMtoW/xcn7nLSvSdNIu
         L7VSenM2of7PJ0i0bqvr0SnrS7pzWscde6LoC4giT+1wYl+yGwaiiFLKIiCSjyvtv04g
         b8rM5di8Muf1I3bnYbDcTLEXNWw4oPG1u4d5dgEVvOforOzv7BBYxkeZvdJd6jwLnwBP
         mvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fKBJ+HCJQ1IihBjBCwPYHx5qSIWh4l6D9kHNjLPM2ok=;
        b=QbAg4qJJq2yZ5S/FufcxhbZIPO32WgfBDL75XVM/dxomkWrL3a4DkFSAfyJomDyLXb
         h8yM4P/j3dF98D+SqK8OHIIoO2lCQJIYUyWAPOBwXQ3qJkVjtfZw6G3Aun0N1qO74A6d
         TxRtMgq5ssqEA5csUmlCSxJKcGf6XaRHnhhkDlB/e8TB4E9fSBYAG4ttkfO+YYOc3aW/
         yvYZcivbm8THQByLm6VgdbY2zIHYLf5Ac3KRwQ5rMgg000EESIwNK7BFp1cO/sp+Y3xi
         aL0yV/jj2VKsA6ATaB0KTGTAwsFkdYVfXRfnZSUsYeoveKyzNULs77nOhsxObLSI/oSN
         7gsw==
X-Gm-Message-State: AOAM532QQ7XsZomcA6VAA8p66iahWn87ISCui6hl8AR5RbX955ynwBNj
        rXXlRCaBlxZ8pfPH78G5nNX1n+NAm2c=
X-Google-Smtp-Source: ABdhPJzpk9UbzDS1mIMq0edX2hRVGUhSqmqFbRaBGLYKW+wuPinBA1YKnd78f/E78Y6iFdUMXWVNbg==
X-Received: by 2002:a05:6402:2813:: with SMTP id h19mr40161695ede.39.1624975652051;
        Tue, 29 Jun 2021 07:07:32 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 15/15] net: dsa: replay the local bridge FDB entries pointing to the bridge dev too
Date:   Tue, 29 Jun 2021 17:06:58 +0300
Message-Id: <20210629140658.2510288-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When we join a bridge that already has some local addresses pointing to
itself, we do not get those notifications. Similarly, when we leave that
bridge, we do not get notifications for the deletion of those entries.
The only switchdev notifications we get are those of entries added while
the DSA port is enslaved to the bridge.

This makes use cases such as the following work properly (with the
number of additions and removals properly balanced):

ip link add br0 type bridge
ip link add br1 type bridge
ip link set br0 address 00:01:02:03:04:05
ip link set br1 address 00:01:02:03:04:05
ip link set swp0 up
ip link set swp1 up
ip link set swp0 master br0
ip link set swp1 master br1
ip link set br0 up
ip link set br1 up
ip link del br1 # 00:01:02:03:04:05 still installed on the CPU port
ip link del br0 # 00:01:02:03:04:05 finally removed from the CPU port

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: none

 net/dsa/port.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 778b0dc2bb39..28b45b7e66df 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -199,11 +199,17 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	/* Forwarding and termination FDB entries on the port */
 	err = br_fdb_replay(br, brport_dev, dp, true,
 			    &dsa_slave_switchdev_notifier);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	/* Termination FDB entries on the bridge itself */
+	err = br_fdb_replay(br, br, dp, true, &dsa_slave_switchdev_notifier);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	err = br_vlan_replay(br, brport_dev, dp, true,
 			     &dsa_slave_switchdev_blocking_notifier, extack);
 	if (err && err != -EOPNOTSUPP)
@@ -225,11 +231,17 @@ static int dsa_port_switchdev_unsync_objs(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	/* Forwarding and termination FDB entries on the port */
 	err = br_fdb_replay(br, brport_dev, dp, false,
 			    &dsa_slave_switchdev_notifier);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	/* Termination FDB entries on the bridge itself */
+	err = br_fdb_replay(br, br, dp, false, &dsa_slave_switchdev_notifier);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	err = br_vlan_replay(br, brport_dev, dp, false,
 			     &dsa_slave_switchdev_blocking_notifier, extack);
 	if (err && err != -EOPNOTSUPP)
-- 
2.25.1

