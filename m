Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E04A44234A
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhKAWVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231161AbhKAWVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 18:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D10960C51;
        Mon,  1 Nov 2021 22:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635805126;
        bh=AcDYeFrkNlUvbx4cKfnnGXJjDoCrm48ay7njb/NNChg=;
        h=From:To:Cc:Subject:Date:From;
        b=o6h8VrkKaEMftU4YlKnzGXb4jW5J/V9zCLrRY2CkccAvaVOMv8906l5Yi321qSjfn
         bZ3aA3cYqOMT8Bx4pBCaNbKs1k11PTdPVdYVhf4HI2w+sfgKQLUrJdY2iUUyCt5iv3
         3G1WWfJKCqemFreWOQeinDyo4g2RPW/m622DJyq16i9jNM2qAOUxLfQOiY506JO9Vj
         j5cyLO0sLbzzaNqftqiuraxWxw5f+PhmXmrtnfPHDlo8vwVlVm0u+1Zvfs4pMteY6n
         2oH/c9fL2thg+8ZzTKkSue8ZIm2jgkTPsJzcm0P4TqTeyVykdAWL4GId2K7fxkO80I
         uO4jALes9eH1A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] netdevsim: fix uninit value in nsim_drv_configure_vfs()
Date:   Mon,  1 Nov 2021 15:18:45 -0700
Message-Id: <20211101221845.3188490-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build bot points out that I missed initializing ret
after refactoring.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 1c401078bcf3 ("netdevsim: move details of vf config to dev")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 5db40d713d2a..54345c096a16 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1723,13 +1723,11 @@ int nsim_drv_configure_vfs(struct nsim_bus_dev *nsim_bus_dev,
 			   unsigned int num_vfs)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&nsim_dev->vfs_lock);
-	if (nsim_bus_dev->num_vfs == num_vfs) {
-		ret = 0;
+	if (nsim_bus_dev->num_vfs == num_vfs)
 		goto exit_unlock;
-	}
 	if (nsim_bus_dev->num_vfs && num_vfs) {
 		ret = -EBUSY;
 		goto exit_unlock;
-- 
2.31.1

