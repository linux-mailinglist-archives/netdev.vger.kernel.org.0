Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF5939A8D2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhFCRR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233303AbhFCRQE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:16:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD12161428;
        Thu,  3 Jun 2021 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740280;
        bh=ULu45IxoBA8bSyPVdAwI4v61NLUB3zhof+dpMc7sFkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRW0KB2glQvQVXMlIMj6DcWLmomV9RNPjC+PdcxDWW4dSrPrE1kR3Yh+1/cTcgvNT
         R2uuLVHxbB3liXzZRe53FBfsT3efC9DeIgUGZvajGcx/53EytPKR+2I9Ma4uJUXpa+
         Z4YCpFSMS5eAF3+gaUydoiCyDVYmaT5bPFT68tEhtKQDMwzVgrgAkj0HHffYCEzrDy
         OyXuM0L7JRnprVzyJHXqKtPR5SB9HltJbfcInXprlegE7vKG2OJKMMZAJA5PSg1epp
         rFLg95lB/6Nk7l3cdppJDFYwaOUR7oy0IdqNlUsxlE4RaaY0hqzWQFUmBbArBj7Nps
         x3hpATlcmISGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/15] bonding: init notify_work earlier to avoid uninitialized use
Date:   Thu,  3 Jun 2021 13:11:03 -0400
Message-Id: <20210603171114.3170086-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171114.3170086-1-sashal@kernel.org>
References: <20210603171114.3170086-1-sashal@kernel.org>
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
index a33e8a3b5f0a..d6363ae22052 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1267,6 +1267,7 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
 
 	slave->bond = bond;
 	slave->dev = slave_dev;
+	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
 	if (bond_kobj_init(slave))
 		return NULL;
@@ -1279,7 +1280,6 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
 			return NULL;
 		}
 	}
-	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
 	return slave;
 }
-- 
2.30.2

