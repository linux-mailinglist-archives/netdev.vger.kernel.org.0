Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2DD38EA3A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhEXOxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233466AbhEXOvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 297446140C;
        Mon, 24 May 2021 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867677;
        bh=mcsPY8Xc2q/p/Dt2uGk6HUl2ZNEAW7uSXSay5z7Nj0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/KK+E/ac9emB7LUb3Vig9kYAquCJ1EjuoHl1NSklxX6LcNV95sOF0YLiDwtL1316
         B5Csz7U9R53ZaYAHiaJRUf/lR947AVORztegE0diFS849eFay7DutxhKQTffq7mW1X
         OgVyAacRCikx3LNt25jrJFH0f27xKtTGS0Qy/G3jx6sleFVEhTKiIU5+Zh+irkP9tR
         mGTKttuSA0pAywPMs3P0H4eKaXMuNZ2wMELpG2p5De+ttRWJAFZ9HQUDfSBmh5XN5c
         FEXCZLPktO4b4wtoO+DaNAY2hNFJITWsGDrhh/9Bk93mXO5SBUXmAMsYO0H1TI/eAS
         4JyUa8S9aclXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Ursula Braun <ubraun@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/62] Revert "net/smc: fix a NULL pointer dereference"
Date:   Mon, 24 May 2021 10:46:51 -0400
Message-Id: <20210524144744.2497894-10-sashal@kernel.org>
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
index 6abbdd09a580..b4a9fe452470 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -319,11 +319,6 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 	init_waitqueue_head(&smcd->lgrs_deleted);
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

