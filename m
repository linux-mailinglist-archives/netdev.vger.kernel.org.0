Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573A44919DB
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349575AbiARC4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54866 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348720AbiARCpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:45:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E70A7B8123F;
        Tue, 18 Jan 2022 02:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C9BC36AF2;
        Tue, 18 Jan 2022 02:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473951;
        bh=qGh2KMC0KjqVZsHyFocmreJrZNAvnD7Xei2FC+o7QDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NY5ll3kj2VaFCGMKiCpvtgUttCQM2z/Qi+LjVK+K5vLFMG89SRjspenrYgmbrpVzZ
         4K8kvwipWtP0ylwUvWz3uT2B1uYqaK4TGr+Gg0ihqTnQ5q1N+zr5x6bQ7TRv+QVfL2
         qiRjALPvvbjEVIhJebfC8RFSMYKxEwctfwRLs498IG/AOSVvBvPG6YfeL58Iye9PId
         us9cC3K0m13wlD4VSvgRbCJ7fOpWUmok86cCQWv64DrCuQ8XPcWz/BMSdxUIF7g8aQ
         TRyOWQFC6B/HhMwapvHap9PrPMs5nCLWIEySbgA92RAR4OI1JNXaVZ4BXoudlfV8K2
         9Fg09L6l0XBlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suresh Kumar <surkumar@redhat.com>,
        Suresh Kumar <suresh2514@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 37/73] net: bonding: debug: avoid printing debug logs when bond is not notifying peers
Date:   Mon, 17 Jan 2022 21:43:56 -0500
Message-Id: <20220118024432.1952028-37-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suresh Kumar <surkumar@redhat.com>

[ Upstream commit fee32de284ac277ba434a2d59f8ce46528ff3946 ]

Currently "bond_should_notify_peers: slave ..." messages are printed whenever
"bond_should_notify_peers" function is called.

+++
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): Received LACPDU on port 1
Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): Rx Machine: Port=1, Last State=6, Curr State=6
Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): partner sync=1
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
...
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): Received LACPDU on port 2
Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): Rx Machine: Port=2, Last State=6, Curr State=6
Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): partner sync=1
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
+++

This is confusing and can also clutter up debug logs.
Print logs only when the peer notification happens.

Signed-off-by: Suresh Kumar <suresh2514@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a7eaf80f500c0..ff50ccc7dceb1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -792,9 +792,6 @@ static bool bond_should_notify_peers(struct bonding *bond)
 	slave = rcu_dereference(bond->curr_active_slave);
 	rcu_read_unlock();
 
-	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
-		   slave ? slave->dev->name : "NULL");
-
 	if (!slave || !bond->send_peer_notif ||
 	    bond->send_peer_notif %
 	    max(1, bond->params.peer_notif_delay) != 0 ||
@@ -802,6 +799,9 @@ static bool bond_should_notify_peers(struct bonding *bond)
 	    test_bit(__LINK_STATE_LINKWATCH_PENDING, &slave->dev->state))
 		return false;
 
+	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
+		   slave ? slave->dev->name : "NULL");
+
 	return true;
 }
 
-- 
2.34.1

