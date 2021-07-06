Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CD93BD1A7
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbhGFLkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237478AbhGFLgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3627261DBB;
        Tue,  6 Jul 2021 11:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570880;
        bh=9iYzRJWA9VUMjadf/f1wc5risnPUGVQ9g4tnOeVEqoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGjhXqfAbqBHTt9mINacWTWRIHqLo5mhdU80nk2uthpvUvtl5xERpFGPsaMG5Z5/M
         q5lf4Nm4uSc/0ZPlAZhRPScx56yG+2uE8QEU1ggeINlDs+yYhM/kLvia9ybn7i+eUh
         o6dBUpyhuvmomDhTCkZCaK6g3oLci351OA5HPztq0dIWr5q7YzA2BeGbTi0izMXkAO
         HT/ljQhhAookCrD3cHSt/wYEhfDhrDi33DPctg6Hm23T68oWSkEOFaz5s55YuPStH4
         J7vnEaPIu3Y7gIeD63PHL8uvjUlIYKylvO/Y6+R0Zd+Yygjrmdh09yeXWqg85n5p1N
         zFa0GQ1uV0QQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/45] mISDN: fix possible use-after-free in HFC_cleanup()
Date:   Tue,  6 Jul 2021 07:27:12 -0400
Message-Id: <20210706112749.2065541-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112749.2065541-1-sashal@kernel.org>
References: <20210706112749.2065541-1-sashal@kernel.org>
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
index d2e401a8090e..3e73cb5b8304 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2349,7 +2349,7 @@ static void __exit
 HFC_cleanup(void)
 {
 	if (timer_pending(&hfc_tl))
-		del_timer(&hfc_tl);
+		del_timer_sync(&hfc_tl);
 
 	pci_unregister_driver(&hfc_driver);
 }
-- 
2.30.2

