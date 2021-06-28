Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D633B6ABA
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhF1WEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237635AbhF1WDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:17 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D79C061766
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:50 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id df12so28270632edb.2
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eqjTrbP8WLdm2CiHqRr8RY8N7+TrvxKyRWH+kkJBIzY=;
        b=MmBHDKy8rrkqrzRL4dqucGUAZAHauim1uoDW848ay0/OYYFuuwvxA5t2rMR0xDsfD+
         0kyPvk/kh/TJN+ALSXM6T+AmbDFDII412rrB1q0oVwk0cE9D8nhJGVp5OtWkdLm2TVQG
         jtoZygYedaAX80QyTJiSbw7YrpTlyRnnLUgroZkRJFi+yZGxkoRQOSLQy2zcvMYsZr6w
         DW2uPvtA9PSbrbThpR9b1E7jYkmtlUZi1QqJ8QL54Da684U+NY/5kiLDr3ckoIUaYokl
         bg8+O/by0ZIQUcDGiCmiYH6I52NiK/WRRaAX8+oIQG6oYL1EUFoZi4m1ck/vxJF5gfFl
         DqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eqjTrbP8WLdm2CiHqRr8RY8N7+TrvxKyRWH+kkJBIzY=;
        b=YnLSPsbYF+8gAmwSIJHzDggoIoDtkAjUb1qc4zleKkDkB/dkXdxvfIIC2TfScgnH+t
         FtaO5vGN0mye5Q4np24hng+NQpglwDixex1EG994ewf/gQaKtbDe5qDROYetfAQE5XRI
         L0K/Y7kByHTFIxAueJdYtQUkFvvslZtwFvP3sdNTJVYEuxS6jiXSFkhz/dbRGgoJU9aA
         8qWWzup1Zj8uBkwk49Fk3pM18ZpBjf00bZPPZw4yp2kiPvombq6IirNW3o6jJ/TSUsIe
         AETOpswpn2DYUmGc2MRXt26aaikK43O6OD7vD+pAbIdcFoJBhreYn3BluUNlwmsy867r
         evog==
X-Gm-Message-State: AOAM533MV5k4nLQfyLCoR4kMndVfowOC1Ggt77XmpiGA9/L2SspnOu1X
        NS26R78OVnz5ErkaU4A05POwW+yis5I=
X-Google-Smtp-Source: ABdhPJwQPQf68Um5A5l9tkl23Vfof98fypvViDhed1y5+9hqkPTezmp4uBDDu/mDHwjDp+do0ZFUFg==
X-Received: by 2002:a50:fb17:: with SMTP id d23mr35570329edq.58.1624917648718;
        Mon, 28 Jun 2021 15:00:48 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:48 -0700 (PDT)
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
Subject: [PATCH v4 net-next 14/14] net: dsa: replay the local bridge FDB entries pointing to the bridge dev too
Date:   Tue, 29 Jun 2021 01:00:11 +0300
Message-Id: <20210628220011.1910096-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
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
 net/dsa/port.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 255172a8599a..a833684349cb 100644
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

