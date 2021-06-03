Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18EA39A6E8
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhFCRJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231211AbhFCRJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C0FA613F5;
        Thu,  3 Jun 2021 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740078;
        bh=ws4tnBWRdmcJLjKeg1D3Tbm7arG9oCWLv/kaC7cgc8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9zoCIrkpOq+zkDslvkj8M/C3qQFzkyO345qUxUTveGgomJkRPun6WYqGVzPnMwSQ
         PCWcdqsGpxWMlM14erOb7IHc3CJ7gXT/GvO1vWYQBtmz8fpValiTZeeGrgAXyW769G
         nbkROtuhl1M+P14mK+WOiAZRcwMwVDB28z8yvBFEN9CYfWjP5GRr5fGZPbJfBO3oqL
         DRAQhkq6AuLUuJ6YEgQfkzL7qhLeweaqJC5AVkFWCXC6VJN/5mZgx9C/SHMfg/tppl
         34hlWB8lt2L/sjTt+59YpivUmvcLbsA/3Biy4q/NZ4tYuIueseba0yZCt+N2Dt2RtD
         8fbUy2LJejb8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 19/43] bonding: init notify_work earlier to avoid uninitialized use
Date:   Thu,  3 Jun 2021 13:07:09 -0400
Message-Id: <20210603170734.3168284-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 35d96e631860226d5dc4de0fad0a415362ec2457 ]

If bond_kobj_init() or later kzalloc() in bond_alloc_slave() fail,
then we call kobject_put() on the slave->kobj. This in turn calls
the release function slave_kobj_release() which will always try to
cancel_delayed_work_sync(&slave->notify_work), which shouldn't be
done on an uninitialized work struct.

Always initialize the work struct earlier to avoid problems here.

Syzbot bisected this down to a completely pointless commit, some
fault injection may have been at work here that caused the alloc
failure in the first place, which may interact badly with bisect.

Reported-by: syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 74cbbb22470b..fa4bf727a48d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1526,6 +1526,7 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
 
 	slave->bond = bond;
 	slave->dev = slave_dev;
+	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
 	if (bond_kobj_init(slave))
 		return NULL;
@@ -1538,7 +1539,6 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
 			return NULL;
 		}
 	}
-	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
 	return slave;
 }
-- 
2.30.2

