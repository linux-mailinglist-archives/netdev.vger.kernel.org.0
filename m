Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B71F3BD0B6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhGFLg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232157AbhGFLa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 241EE61DF8;
        Tue,  6 Jul 2021 11:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570541;
        bh=wdCXofuB2KYAO8nzZBa7xRnRlrsESV5l62oHr9sXKgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nhld0U5FURYtJUKujOxkEh/kMfP7Tenw9PTKN5jJuFPP5D1uuR8KbUb5mQ4CjpoDE
         gKYlUaLmhJseN1PTY1loqGRHaUu3zhfYq75nDNyqEbOLJO4ywDxcOFyG3JzRU/2N+T
         kxHCfkCW2Wqr0xULL9yYwhdeRhox5pUXJbss8Xd+SFa+/JI8tv0Tq1+RtVUV2cYBVL
         c/WCaXllMVVr55b+jubtm02cHdP3j5/r8KGXYb0Z3+/UHxuPQvLDYmCH8tA7zk9o7G
         j7lrW84k0Lk8xEQqHK7DVkdt1D5a3pFHKC0nvza/DlKNKDANV0zsXR9q2BXF11Dvpt
         GKYlJXYPRGwqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 013/137] atm: iphase: fix possible use-after-free in ia_module_exit()
Date:   Tue,  6 Jul 2021 07:19:59 -0400
Message-Id: <20210706112203.2062605-13-sashal@kernel.org>
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

[ Upstream commit 1c72e6ab66b9598cac741ed397438a52065a8f1f ]

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
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index eef637fd90b3..a59554e5b8b0 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3279,7 +3279,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-        del_timer(&ia_timer);
+	del_timer_sync(&ia_timer);
 }
 
 module_init(ia_module_init);
-- 
2.30.2

