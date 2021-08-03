Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE6F3DED4B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhHCMBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235709AbhHCMBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:01:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D07B60EFD;
        Tue,  3 Aug 2021 12:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627992049;
        bh=DgEvXfBSRDT4pM3CN5KRXVqiEUjs4A+r7Zp0S6iNEyA=;
        h=From:To:Cc:Subject:Date:From;
        b=sN9L7Rnorddu4RuSV3Cy/KDJTjybpA0acYfIFQeDoAWt1+qTgimCU7qceWqml+/2I
         +725Rw1Y7P5MQkxxd5YBNJLCnodMGyiO8CrZSdj9kpJDqbZXjmOqzsWcVAtDijgwVk
         cZYshAuaZQ6kRqXLPhQAo/rredGzN2xiP7gKxFBJPBDwWyzoLDZAKK+M0eD9ve9E5e
         QrFQVrT6DMxWqQZUU68c7Unj+TFekV2kJJLvEI+WKqD6sIumwiBIQcVKkBhLiLfP29
         LEWyYESPMWdFW4Lcd64t8SbDR80uJDbow3laGkIRFgG3z68GPQEL2n+iBQCM/opr4g
         zEacvj24S04fw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net] net/prestera: Fix devlink groups leakage in error flow
Date:   Tue,  3 Aug 2021 15:00:43 +0300
Message-Id: <6223773b71e374192af341361055c0124df7083c.1627991916.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devlink trap group is registered but not released in error flow,
add the missing devlink_trap_groups_unregister() call.

Fixes: 0a9003f45e91 ("net: marvell: prestera: devlink: add traps/groups implementation")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index d12e21db9fd6..fa7a0682ad1e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -530,6 +530,8 @@ static int prestera_devlink_traps_register(struct prestera_switch *sw)
 		prestera_trap = &prestera_trap_items_arr[i];
 		devlink_traps_unregister(devlink, &prestera_trap->trap, 1);
 	}
+	devlink_trap_groups_unregister(devlink, prestera_trap_groups_arr,
+				       groups_count);
 err_groups_register:
 	kfree(trap_data->trap_items_arr);
 err_trap_items_alloc:
-- 
2.31.1

