Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AF938EB29
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbhEXPA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233384AbhEXO6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:58:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2092E6143D;
        Mon, 24 May 2021 14:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867773;
        bh=Pla75ePXqOjm6vomz35pFb74Fd8RlTdglMiFbCbmQ5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwU80PySFbLvm7l+965qJ9A4Z7CZumb3LTTECbhJqnvpGf6BJtYzYO8cg+TmHgadf
         IjdlbMWEOB2RVcb2YUNeGwLdheiK/S0mnxCmIZg+Dx2CMrh2yU+GPhHzMgt9oN+v/J
         v9ryJI0c2SCZ8xloFwzaToeAXI9SkPnAEPV1+uZL9tQ9E6zm1m3LnoAhv0DqRJhkZ3
         dk41ZghDWNK8vDx27u78ckXC0ytefR7pjT+Fy/Tkq8+PgMtDfO3OF+9XHyxm7N9bnp
         AQl0ay+KTGE0D3QMZfzpEgxAByabxTAh9i0814xu1f0oIu3Jk139QrvmtSDDAtdfl3
         ZN9aIn71/meDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/52] Revert "libertas: add checks for the return value of sysfs_create_group"
Date:   Mon, 24 May 2021 10:48:34 -0400
Message-Id: <20210524144903.2498518-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
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
index 2747c957d18c..a21c86d446fa 100644
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

