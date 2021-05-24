Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E6C38EAF9
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhEXO7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234199AbhEXO46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD5CD61447;
        Mon, 24 May 2021 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867754;
        bh=VargY4XG5cDtl7Den5zPVuw+rnYOMNgRzAdJUIQW1mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2woj8TskkmU5JvrnzbL2ZMmvEmOT8PlD4KmmZ8i8UI/H7nYtFV4/tvlDW7OKTW2H
         eafYsRCiVXRJ/f79NQy/nwwEIkX7jC0E9eWBUAaDbCGnoBBIoNHRxWVhBW+KHOeg7/
         6zRFGpdlEVepZme1VLPNbHBF+qIsN9U81WbRE7lvcyNdet/WfTWUnX638hbFSc9YwE
         I+ljmI5ObStEEpWs/AZjwjeIKiBWD8omHjgrlbQMyYTZB0Qi7WbdyI95C6bz3GChJm
         2yZRQZVocOFLPpaKP6TE5Bm2gi4Ud1MCfN1cm9jAzgtw/r4YXBlYDUdqL4tyR7KUz7
         m2Pql3HTDCT/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Ursula Braun <ubraun@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/52] Revert "net/smc: fix a NULL pointer dereference"
Date:   Mon, 24 May 2021 10:48:19 -0400
Message-Id: <20210524144903.2498518-9-sashal@kernel.org>
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

[ Upstream commit 5369ead83f5aff223b6418c99cb1fe9a8f007363 ]

This reverts commit e183d4e414b64711baf7a04e214b61969ca08dfa.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit causes a memory leak and does not properly fix the
issue it claims to fix.  I will send a follow-on patch to resolve this
properly.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Ursula Braun <ubraun@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-17-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_ism.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index e89e918b88e0..2fff79db1a59 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -289,11 +289,6 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 	INIT_LIST_HEAD(&smcd->vlan);
 	smcd->event_wq = alloc_ordered_workqueue("ism_evt_wq-%s)",
 						 WQ_MEM_RECLAIM, name);
-	if (!smcd->event_wq) {
-		kfree(smcd->conn);
-		kfree(smcd);
-		return NULL;
-	}
 	return smcd;
 }
 EXPORT_SYMBOL_GPL(smcd_alloc_dev);
-- 
2.30.2

