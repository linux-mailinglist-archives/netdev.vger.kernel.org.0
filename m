Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8945744582C
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbhKDRUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233470AbhKDRUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E1AC61076;
        Thu,  4 Nov 2021 17:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636046275;
        bh=4/Sul8tHKch7YClfCTJ74FfdEvC/YA3u92BWdTM8e4I=;
        h=From:To:Cc:Subject:Date:From;
        b=DsW5q5J5JiZncVzzECUR+mkmeB3+7Jtr9IzdM5s0kNv9hWSG8v4E4XyKKT2qHo7z4
         n0AMJoquMzkl/jjunXM+GvThX/y3fu36PnuHbxsUDzAzW8KK4ojKCDSuZinkmGevVk
         RyuzdFSBSd8TZ6Y4DREnYqx7wbFAs/XL0DS0ApJlI9wsV8WIpRJiHfEoj2psMcZlSf
         XWo9WjShpRWOArhSFS9c7BByeC0nsJpnAKdxAknb/klFUxmhAzvouGIx85Ma2hYPwO
         K/MxtZnKs5dclF2kBn5Ozp8ZLRUd9LB9JlaZKtvjs1ucqHrLJNhq4euKv374otD3R6
         gKStWbSrymrzA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net] net: dsa: mv88e6xxx: Don't support >1G speeds on 6191X on ports other than 10
Date:   Thu,  4 Nov 2021 18:17:47 +0100
Message-Id: <20211104171747.10509-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Model 88E6191X only supports >1G speeds on port 10. Port 0 and 9 are
only 1G.

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 14c678a9e41b..f00cbf5753b9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -640,7 +640,10 @@ static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
 					unsigned long *mask,
 					struct phylink_link_state *state)
 {
-	if (port == 0 || port == 9 || port == 10) {
+	bool is_6191x =
+		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6191X;
+
+	if (((port == 0 || port == 9) && !is_6191x) || port == 10) {
 		phylink_set(mask, 10000baseT_Full);
 		phylink_set(mask, 10000baseKR_Full);
 		phylink_set(mask, 10000baseCR_Full);
-- 
2.32.0

