Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA2339A7F4
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhFCRNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232726AbhFCRMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0E6D61414;
        Thu,  3 Jun 2021 17:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740208;
        bh=QjZL+O3NSFI77h2z5WDWGc3+ZvAdpEVYHaA7LKIbBw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzpHVR+0onU6Kd2dVYZeTgpc42PwOLMiK2voWOVs8lfYfs2wCgYFtpkLjYf/aO4rp
         0BzkSDQXHJuaVzEe1cPS622nIoATzgKjVa6FWbaHyWmgUXDa6VZCVI0FRUvMUf7jxa
         8shQyKovIaxUbTIpYKhzjrCfULrMsOLN21crrZnpf3ElgGoxbdk+IyjlvghRPD6b1P
         J/8JGa2zuDJ6+TWWnKnNIbtPKyXWMNPMyTaKtBGodCS79gQeWQ+cP9zlewOtGcm4iG
         gKbHgW8LRj0DidXrSSpv/qzknr0eydx0rqpKYWyk/WvdbqbxC5GAcq/UF6T2Ab6KE0
         HT66+bd+IEA/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/23] bonding: init notify_work earlier to avoid uninitialized use
Date:   Thu,  3 Jun 2021 13:09:43 -0400
Message-Id: <20210603170959.3169420-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170959.3169420-1-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
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
index c21c4291921f..c814b266af79 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1310,6 +1310,7 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
 
 	slave->bond = bond;
 	slave->dev = slave_dev;
+	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
 	if (bond_kobj_init(slave))
 		return NULL;
@@ -1322,7 +1323,6 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
 			return NULL;
 		}
 	}
-	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
 	return slave;
 }
-- 
2.30.2

