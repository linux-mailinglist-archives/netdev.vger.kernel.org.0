Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665F638EA6E
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhEXOzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233322AbhEXOwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F697613EC;
        Mon, 24 May 2021 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867698;
        bh=oDyXkmvx+gQobzupFPp7+JRAht8mlIefsNOkh3GbdPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSZXF7RfZNBfRbLpEzsaiZRW794WDvXDqGivnDrMiH/2V69KrZubED2nXDQoZohAo
         T3qM6itNdbhm1YiMS4hoLMNX4WldL+RZQ8Duaq2xilFIz0zkP+3KMMePnYWyA7DJZR
         H6fb8KCkPOOhEfiJJKmbwbFTg9uENoHsIrhqG4KXXGUNaBHSTzmjbYoKem/JWrYr+2
         8zTrPPl6GdcF9XRizjojs2USiTMaxCiBZUFsetYJL5xwv8wYtKHnnju5tSJNVKN5iD
         bVHpgcEMw4WVTMPXnkak+PKp7K1iZOtoFXrcJvoWz79kdWK8jSxqLv8McvEJQvyvHW
         2QDU7I61CVPBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/62] Revert "libertas: add checks for the return value of sysfs_create_group"
Date:   Mon, 24 May 2021 10:47:08 -0400
Message-Id: <20210524144744.2497894-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 46651077765c80a0d6f87f3469129a72e49ce91b ]

This reverts commit 434256833d8eb988cb7f3b8a41699e2fe48d9332.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit was incorrect, the error needs to be propagated back
to the caller AND if the second group call fails, the first needs to be
removed.  There are much better ways to solve this, the driver should
NOT be calling sysfs_create_group() on its own as it is racing userspace
and loosing.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-53-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index f5b78257d551..c611e6668b21 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -805,12 +805,7 @@ static void lbs_persist_config_init(struct net_device *dev)
 {
 	int ret;
 	ret = sysfs_create_group(&(dev->dev.kobj), &boot_opts_group);
-	if (ret)
-		pr_err("failed to create boot_opts_group.\n");
-
 	ret = sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);
-	if (ret)
-		pr_err("failed to create mesh_ie_group.\n");
 }
 
 static void lbs_persist_config_remove(struct net_device *dev)
-- 
2.30.2

