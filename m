Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8060038EA38
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhEXOxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233646AbhEXOvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EA4C61132;
        Mon, 24 May 2021 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867678;
        bh=pGVpLtSMWaOVVz49mJPWWGTE8xs1/cMgTS/V3efAK3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acWkxI/tEb1hTcC24xRTo2tJ2qPuzdW0srvJqBUzw5YtEXwi2w+bc4n6cJZ13ER5E
         ht2U5hAWsFsXczp9vj/WS7aKreSEzgT9k3T3Qh02izKua7O/rRgXyJqz6PZsm/DWmE
         DCSTm7J/Vn5Ikkw2ztoN8tAlPWAYJm8AGhZdD0mbX/Afp3vBrnM43EcYAgrYg6Lchi
         GHeusMTvpbhXqSYbKJjsB+UQFg0CVoUtrzUzg4QPdrcKFbJP+p9L2ekU9A2NaN5MaZ
         xkx8VkSbQFUpIoffl7YUuw8kPglEZQUgc7tyPm2RQSzFy3GoBiHYVo/USYQ5fUoQen
         wKePhAPxj8/uA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/62] net/smc: properly handle workqueue allocation failure
Date:   Mon, 24 May 2021 10:46:52 -0400
Message-Id: <20210524144744.2497894-11-sashal@kernel.org>
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

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit bbeb18f27a44ce6adb00d2316968bc59dc640b9b ]

In smcd_alloc_dev(), if alloc_ordered_workqueue() fails, properly catch
it, clean up and return NULL to let the caller know there was a failure.
Move the call to alloc_ordered_workqueue higher in the function in order
to abort earlier without needing to unwind the call to device_initialize().

Cc: Ursula Braun <ubraun@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-18-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_ism.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index b4a9fe452470..024ca21392f7 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -304,6 +304,14 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 		return NULL;
 	}
 
+	smcd->event_wq = alloc_ordered_workqueue("ism_evt_wq-%s)",
+						 WQ_MEM_RECLAIM, name);
+	if (!smcd->event_wq) {
+		kfree(smcd->conn);
+		kfree(smcd);
+		return NULL;
+	}
+
 	smcd->dev.parent = parent;
 	smcd->dev.release = smcd_release;
 	device_initialize(&smcd->dev);
@@ -317,8 +325,6 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 	INIT_LIST_HEAD(&smcd->vlan);
 	INIT_LIST_HEAD(&smcd->lgr_list);
 	init_waitqueue_head(&smcd->lgrs_deleted);
-	smcd->event_wq = alloc_ordered_workqueue("ism_evt_wq-%s)",
-						 WQ_MEM_RECLAIM, name);
 	return smcd;
 }
 EXPORT_SYMBOL_GPL(smcd_alloc_dev);
-- 
2.30.2

