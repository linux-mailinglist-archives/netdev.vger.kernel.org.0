Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1257B3BCEB9
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhGFL1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234730AbhGFLYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:24:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D32161D0D;
        Tue,  6 Jul 2021 11:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570330;
        bh=9upz0cKdc/qYU4JjyOzTGWrs6l3cCYP97s9qfpHPtkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UU0/XU+KVQVUz3gWKSgsU33S0kNb4RYZ4jaZxrcYzAk/VkXraKnNKxZ+EPnGEs80Z
         nOBmdw9BYUWOQzds3thdGhjFXCalw8f7FYd/DSNZC+svFfyHr2T7DIso/VgIYtxuxj
         Rlfqr9k03FAa3d8GR7E0VmUW3sMISNHl/L0WjfrgnELkYFIESwMfxPnay2O0puYVnF
         TpwVveMrhQv527MA14ya/stWwOh6Q/x/ZUlYLlXJ/XrT8rJX/bW5NhE7AWX95t6NHo
         eKcddD8D5lb/+tBNlCgMIGU2U+SeZmzg3N9Z9CZ0mhRgClid4vQic379rT+f5wMU4Z
         2Zf3aBvvGg8oQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 017/160] mISDN: fix possible use-after-free in HFC_cleanup()
Date:   Tue,  6 Jul 2021 07:16:03 -0400
Message-Id: <20210706111827.2060499-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 56bd2e9db6ed..e501cb03f211 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2342,7 +2342,7 @@ static void __exit
 HFC_cleanup(void)
 {
 	if (timer_pending(&hfc_tl))
-		del_timer(&hfc_tl);
+		del_timer_sync(&hfc_tl);
 
 	pci_unregister_driver(&hfc_driver);
 }
-- 
2.30.2

