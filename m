Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49623BD5DD
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242030AbhGFMZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237043AbhGFLfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E27661CAB;
        Tue,  6 Jul 2021 11:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570717;
        bh=D0aqLcDHnyIhmX9cVux80w3kOxWK9bN3LSxoqo//I1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dlgd3e8cXxKAh/DcSldA6/q/BirDY4z/bbcH035wplHVYwY/HyryUEdPNeLEctLno
         Z1JIsU7kDNr5SAIytGS7QuzEsJVusFzZ/m8cSNrDaeij+QPKQPJ+xUaJUvGjf24+F1
         wh309Vb/T8YxI7GOSMnPIUdg/u+K7bP+WvUv6NO7kahEBgmHHFlzCR6GEF6IcfS+dG
         MwVXu1HQUbX/NWzhf1HajzgU3Cbz1pZw2buUWqgU7oOS69eJszud1kW9bjW+UJWfQE
         ZtcsP81t9o0X91RhhnylmdD5fpFfUQ8PXdUsd3R207kzaoyg1qhQDZb6nfO1yzDQWT
         XMaya/b7wsp8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/74] atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
Date:   Tue,  6 Jul 2021 07:23:59 -0400
Message-Id: <20210706112502.2064236-11-sashal@kernel.org>
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
index bb9835c62641..5ec7b6a60145 100644
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

