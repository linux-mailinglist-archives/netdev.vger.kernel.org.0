Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E12338E92C
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbhEXOsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233178AbhEXOsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:48:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61FB16128B;
        Mon, 24 May 2021 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867594;
        bh=dNkViws1Re3NlgzMIsfHt45FjYCBBp1jhC+qOsw+Y9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UtCKrXKs/pfwx0OnwASR3WJze0ZAT7zdNR3rrehV33ohdYBFTqiY9NuBCPFeAGzmm
         AwvnRMfU3SG1pDaB+BCx4RwwaRtd81fzGl/Z9cB5+SaJyaON9v2xJ3cEfyFe5SJ1Zv
         9v5C13FXxWE9N7zo7Yei2GCd/JzYicO0YLkDnCr6QzN0IR7YBDgg07YnKbNiOzeEku
         y4Q/39yCWp1sgzyANep59dDHQSpcLWFyzaTQpA4KtjzwEU0RkdXkxLQsPoN1EVYb7z
         Uut14bSaFjJ4Q62p9i/XSLJ2lxeG4l8uzXXNPdSm0UVFn/w4gxQZbuDYbnwK7WjXR9
         GGPDLHNgWS7uA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Ursula Braun <ubraun@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 10/63] Revert "net/smc: fix a NULL pointer dereference"
Date:   Mon, 24 May 2021 10:45:27 -0400
Message-Id: <20210524144620.2497249-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index 9c6e95882553..6558cf7643a7 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -417,11 +417,6 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
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

