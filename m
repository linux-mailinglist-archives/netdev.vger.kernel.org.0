Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1033BD19E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238651AbhGFLjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237481AbhGFLgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59C5461DBD;
        Tue,  6 Jul 2021 11:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570882;
        bh=g9Sw7MyBt7zMmznR+yI0NtS/691d5v/HYyyeQfyXBxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7HegnZHu/CMvymmuvw+TTTPRCwyozb1dTYFhDSKxEIKrZfPWl2xUc67oafGAciD6
         Gu0kZBzNj9HGxmefPNnEocHA0zxcWXoXHjNGdK1tDmeKoj/rcfNoh9F2rmCQjicOt8
         1X92UYh1wOaQC70xwDSM8v8Nv/VUaB1gkYbwsUWTrc0qNSG5GTlQ1DRr7xazPse/6n
         AowfIj/USY0ids7VmmKXhcdGWcBFmuFxPetHmMF5xpTD7J73RSxgcZ4Z0dfply9t7F
         2zpWBpdW1ea3etEykDWVtkZe/yptIgN2R8K9/UpoDoTbGEEc72cDdSzSFnDM6Oi0ux
         qT/Xf3UPuSxkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/45] atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
Date:   Tue,  6 Jul 2021 07:27:13 -0400
Message-Id: <20210706112749.2065541-9-sashal@kernel.org>
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
index 7b2c5019bfcd..2c1a81b85816 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -298,7 +298,7 @@ static void __exit nicstar_cleanup(void)
 {
 	XPRINTK("nicstar: nicstar_cleanup() called.\n");
 
-	del_timer(&ns_timer);
+	del_timer_sync(&ns_timer);
 
 	pci_unregister_driver(&nicstar_driver);
 
-- 
2.30.2

