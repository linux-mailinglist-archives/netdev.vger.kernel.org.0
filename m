Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8C939A886
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhFCRQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233339AbhFCROK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:14:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B50AA61452;
        Thu,  3 Jun 2021 17:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740258;
        bh=8HrkwtKNynYcbhnarfbJU+8UFzcRtH487wuepHbJnpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0hA0FxWu/FY7W4V0gpD7/IToTDT6VK8mtj2fNdQV5o4q6z3bnvKb0CjnFGZDDEI7
         27RZ3ys668kX9rc18FHowKDIWiRKo5Gqcn4lBpmWbmOvZDHwS+wkgKueNobDbESkBQ
         JXMvL8WDtifulJXfgRbQ/qTad0BrMTWlOkGB5zAiwwRx7vTTf1SvNvxvJ82gNg2a6n
         g+S6nSZ+NPBLLtyn9ucHFhKPURI+o9onBeKFJTcyB4bMGBJzEMZemvAXU815Exq/pF
         l8gtMltcN/GZm6Qlong2CSHoRGCyYbSjQ+luNLUPJcmsYJTdECmJOOj0HGrkMnyhqa
         xZKEa/qZavqdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/17] bonding: init notify_work earlier to avoid uninitialized use
Date:   Thu,  3 Jun 2021 13:10:39 -0400
Message-Id: <20210603171052.3169893-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171052.3169893-1-sashal@kernel.org>
References: <20210603171052.3169893-1-sashal@kernel.org>
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
index 16437aa35bc4..2b721ed392ad 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1280,6 +1280,7 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
 
 	slave->bond = bond;
 	slave->dev = slave_dev;
+	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
 	if (bond_kobj_init(slave))
 		return NULL;
@@ -1292,7 +1293,6 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
 			return NULL;
 		}
 	}
-	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
 	return slave;
 }
-- 
2.30.2

