Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68623BD2B6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239631AbhGFLou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237628AbhGFLgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37AAD61DCD;
        Tue,  6 Jul 2021 11:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570934;
        bh=zGOVYjwyMffJLWfigNL2olJxhT7aPhNmZaFHOVgs7cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VT023MvMIe+bxiAs30p4s1npQHaAidcagDSvQMct6pQYkWTH5cPt6GJV6/PVK1gAX
         Hbxjw5YfuzHpevLeeIhy9thE5Bp2OI1U+9MaxjuboKMLp/DswQsXW2zX2Ukog4xZL9
         N2H/zhKhi2fWJhphgpzlTRTAoyjirg9qy7zsQsStyUl9rF4gpeaoaisEHfr405yn+K
         7cMb05pddR6tLCgPm88W6W38NaVUeAki6aTH/6WFJDm2ln2p5eFSLg1pDdGOO/PYTR
         /UU9NyyP1LNyZTnvSfTWIy9OOpvBtteQ/c4Pf+8Ws9bMMZhpvyHwFqZ5B1GS18saGf
         BP0YkyMAfqjCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/35] mISDN: fix possible use-after-free in HFC_cleanup()
Date:   Tue,  6 Jul 2021 07:28:16 -0400
Message-Id: <20210706112848.2066036-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 009fc857c5f6fda81f2f7dd851b2d54193a8e733 ]

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
 drivers/isdn/hardware/mISDN/hfcpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index ff48da61c94c..89cf1d695a01 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2352,7 +2352,7 @@ static void __exit
 HFC_cleanup(void)
 {
 	if (timer_pending(&hfc_tl))
-		del_timer(&hfc_tl);
+		del_timer_sync(&hfc_tl);
 
 	pci_unregister_driver(&hfc_driver);
 }
-- 
2.30.2

