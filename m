Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9143249BE67
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiAYWX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:23:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35052 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiAYWX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:23:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A016184A
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 22:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D2EC340ED;
        Tue, 25 Jan 2022 22:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643149405;
        bh=VTJqecm5X/zvzaE/jGRrIqxDW1iScy7AUV6tqYM48Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3ePmBC+rSjOxPAZC/mrZBxzJeQ3Gmm2ufFG5IG1mnMqkrSC7cO8z11DHF8D2cXPN
         MSgwFcNZ6rlh6h3hHKjKhCY/bGq5YiZBdR36tCMxfLaA0zoIIT4ZBO40JhT0IPqmTq
         4wt2VgHnNaDMdYSXEyDprAg32DqjP9jKbvrG0/gTd6uf/PFcv03qn33ixevZZpvYTE
         0H9hWiPXdkTbUHvTRB6SAJSxvAa5vR0RVtBIN7pwc6zliDorlyzlLnYIxe+UNlEjnQ
         YWDZR8FTdD6LL1EjHzE8gO0nB6g11ZoQuVmnihTaX4UyHGm5ppp1d8R9g/XtBjTKRn
         YsQEEQZrmeGoQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dave@thedillows.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 3/3] ethernet: broadcom/sb1250-mac: don't write directly to netdev->dev_addr
Date:   Tue, 25 Jan 2022 14:23:17 -0800
Message-Id: <20220125222317.1307561-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125222317.1307561-1-kuba@kernel.org>
References: <20220125222317.1307561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev->dev_addr is const now.

Compile tested bigsur_defconfig and sb1250_swarm_defconfig.

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/sb1250-mac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ethernet/broadcom/sb1250-mac.c
index f38f40eb966e..a1a38456c9a3 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -2183,9 +2183,7 @@ static int sbmac_init(struct platform_device *pldev, long long base)
 		ea_reg >>= 8;
 	}
 
-	for (i = 0; i < 6; i++) {
-		dev->dev_addr[i] = eaddr[i];
-	}
+	eth_hw_addr_set(dev, eaddr);
 
 	/*
 	 * Initialize context (get pointers to registers and stuff), then
-- 
2.34.1

