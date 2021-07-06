Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E17A3BD2A7
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbhGFLoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237318AbhGFLgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABD7161EF2;
        Tue,  6 Jul 2021 11:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570812;
        bh=QxMsqh2Dtak9GW1fH42izSg9EdwGEWoPHdlqZYEFBgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVFgJuf+jC3dTLDEcnuSgXP/jALDykOWxrVCRsfU3AweBNfyaXklbotuwOCKqX30G
         AMbdGPv798ebCBRbnzn0v9JiGhgaSy+lfLP1etRsdU8JJ3UP6GTQBzLEpyY/MYkTSr
         1lWqA4newI7DePQaJw3EBtu5OdOkqJSH/CGadLVIZQjASimMw0x8vdpmake1SXEah/
         ONNNOJPg5i1u9MKhbTzp6yhnemKFxEctkCTYuL5Sozv0NwPraW0XN578GQrIwTmhLw
         +ebE+9r+K3rRftsWczLWxih8grenTwJM5C0pn6hAs6RNwISidgEXRzLcF/ukpv3U9Q
         vYZLFLdwIn6CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/55] atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
Date:   Tue,  6 Jul 2021 07:25:53 -0400
Message-Id: <20210706112638.2065023-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112638.2065023-1-sashal@kernel.org>
References: <20210706112638.2065023-1-sashal@kernel.org>
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
index 0d3754a4ac20..5281db3d6783 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -296,7 +296,7 @@ static void __exit nicstar_cleanup(void)
 {
 	XPRINTK("nicstar: nicstar_cleanup() called.\n");
 
-	del_timer(&ns_timer);
+	del_timer_sync(&ns_timer);
 
 	pci_unregister_driver(&nicstar_driver);
 
-- 
2.30.2

