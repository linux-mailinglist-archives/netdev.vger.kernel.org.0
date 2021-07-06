Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEEC3BD0B2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237657AbhGFLgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234955AbhGFLbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F1461C95;
        Tue,  6 Jul 2021 11:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570544;
        bh=aVsF5TqeEP6L4jFnKmkKziYg4+Fbo0vpv3fxH2svI/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFF/sphhOe36RTnAUZL34wfjR1pkPB3K2Ax72f8wR5T4H6xgDc5vQVfJKnhuRZ2Pk
         ANf8tcAFRwz+bJeU1vrS3IAuAmDshYBFeIynkCczJzD9Gqwoy54/bwJ+gCd+0FMnod
         +AokI75vw6QA4kTTMRVowwCExlqEvLBCnItfKMVLZauxAEJvUbCNWLUqd1qjTsmsEx
         h1KWx457XXkSz3pldYedJq71U9x1DUEjb6jKV8/l12IyzDRHdt6Nx+2FgBr9GNxZUX
         xFAh4Xna8pryW86AWDfF/Hd5gzz5Nq9GHCi3yUb8AHmhS5yEUSXYgeqfPl2rT1eApg
         UHXYQ/L8pHSAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 015/137] atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
Date:   Tue,  6 Jul 2021 07:20:01 -0400
Message-Id: <20210706112203.2062605-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 34e7434ba4e97f4b85c1423a59b2922ba7dff2ea ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/nicstar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 09ad73361879..1351b05a3097 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -297,7 +297,7 @@ static void __exit nicstar_cleanup(void)
 {
 	XPRINTK("nicstar: nicstar_cleanup() called.\n");
 
-	del_timer(&ns_timer);
+	del_timer_sync(&ns_timer);
 
 	pci_unregister_driver(&nicstar_driver);
 
-- 
2.30.2

