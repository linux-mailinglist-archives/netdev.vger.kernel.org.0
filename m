Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4407349C036
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbiAZAiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiAZAiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:38:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82507C06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 16:38:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E5FD61514
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 00:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E40C340EE;
        Wed, 26 Jan 2022 00:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643157486;
        bh=VTJqecm5X/zvzaE/jGRrIqxDW1iScy7AUV6tqYM48Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNndjlWv82LFPFnnsSndsTmWMhAwNTi4FrfawdlBXjBlaTOngUa0rzoomz0aPxrP0
         PkWWY1I3/9rzoLXkmg8V2tetmof706MO4AA+yyyEEjN3olqEr+vLMZOUXx1L/FMO5p
         gF+KzPrss/YhTTL5HKVYySFj8YPJhL6cFUi6b4THbl/yMxkv65huX8tECYZhCSjhF+
         goajC3YT7jtxFUHBSCP6aah84FU+3YyPjUZTML2b78nRQzflVYWizxGsMknvzShzqg
         MneFhGCpytk5J6ZuxqhPUkr48k7WcouQINmkyQeXK0ZjQK60OsUcUBV16qGuCUIN81
         8gaG3/wYXe1rg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dave@thedillows.org, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 3/6] ethernet: broadcom/sb1250-mac: don't write directly to netdev->dev_addr
Date:   Tue, 25 Jan 2022 16:37:58 -0800
Message-Id: <20220126003801.1736586-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126003801.1736586-1-kuba@kernel.org>
References: <20220126003801.1736586-1-kuba@kernel.org>
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

