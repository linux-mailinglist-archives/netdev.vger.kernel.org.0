Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C83E3AF334
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbhFUSAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232136AbhFUR6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:58:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC64461026;
        Mon, 21 Jun 2021 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298020;
        bh=02Y6e3yR52rQTL00zjp3aZEJEqPN/kUlX4YwZMjPUYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDxp7aw5mXNXvJYW9TK9iUb5jiC0mpQpMBnyDnWfpjUFZ/ejcgfp8HPjdF0mkHAvl
         05Rok5nKTDmr9MaaCIXwr2xfeZrWY+C9UV6XXcGqA7xi9C892lieD10IhNjeCssyEX
         iQsZvTy73Zf5eO96nBcYjobllwkKTW0hf5c0PJI4m2vbh3bV0yzC3sg0aZizymhcWy
         kJY0o3Ly25hO6ppbhaZl/KjMFkfVQoRvm7r0GQCrAU8MLCnjeqarZQb79XHovgDRON
         dmo4ex3CobeHa2SU/OVygiVh9AI9osNqvh1WONIpl4q0P5vQifjpdOH+JJ3xa6xY8F
         7Jtaf4IuQTw8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/35] sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:52:51 -0400
Message-Id: <20210621175300.735437-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 224004fbb033600715dbd626bceec10bfd9c58bc ]

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields.

The memcpy() is copying the entire structure, not just the first array.
Adjust the source argument so the compiler can do appropriate bounds
checking.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 6d84266c03ca..5cab2d3c0023 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2287,7 +2287,7 @@ static void sh_eth_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 {
 	switch (stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, *sh_eth_gstrings_stats,
+		memcpy(data, sh_eth_gstrings_stats,
 		       sizeof(sh_eth_gstrings_stats));
 		break;
 	}
-- 
2.30.2

