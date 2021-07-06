Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7572B3BD5DA
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241975AbhGFMZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237038AbhGFLfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E60A61CAC;
        Tue,  6 Jul 2021 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570714;
        bh=hwQiKcNGE0Xio6rSiYQJxLTcOiPsZ+b0zJLF94n8MdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvFYKdqXQJXKx20ViK/tVbDlPfGZOUJyXpjQ4R2m+NyNujedyv2VLVRP1jZI5dp12
         boo+LcQJ2/npOllhG0E4M90SD9sFVNExkhbAK4n7zPHRHujlg5Hgkoi0DzA0V/cu3v
         WnCxo4KwZHKuh4OacM9ZR3BSA+QpffPPmOTlSkJGxC7CFY+NzFNpQt/DzJI1Y/ATHv
         oMoa+SkmcZd+6GUU8DHQnTuxUi/MvOo1eY5I4BkFy5+CxqnjIsNuIG08z3CNzzl9Xn
         UxOEjSzOr4s/GbA/OWykkJS+4pDiBoWcS1QczDTOxoTs0yxbmgNRPQ0xcXK+Kqxqvh
         bGBjsX8e5Sh4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/74] atm: iphase: fix possible use-after-free in ia_module_exit()
Date:   Tue,  6 Jul 2021 07:23:57 -0400
Message-Id: <20210706112502.2064236-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 8c7a996d1f16..46990352b5d3 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3295,7 +3295,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-        del_timer(&ia_timer);
+	del_timer_sync(&ia_timer);
 }
 
 module_init(ia_module_init);
-- 
2.30.2

