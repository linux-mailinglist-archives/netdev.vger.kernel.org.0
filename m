Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8FF3AF2C8
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhFUR4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232303AbhFURzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C329961357;
        Mon, 21 Jun 2021 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297964;
        bh=9vC0oU6syjYGdklmjia7zQ2uiRzVS9zWBv0i7cZ6amQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxiEEFKW0d0+rqLvzfuDu07fjNY+zRuu6xaB6AzKgH7zfVOLieqX9EQyRNt+uINND
         6vNTrfteKy7kK6hz7XtIFWGaEbSm2uFX1IGmMAzpYqV3tgQFxLAtWZyA3kS/4GcCo8
         GwiC+j07Xg6xXMEiedcel0Vy9E8Ce+tCgniGA+sXqFv/45yS17pMz8tYaMXsORa3ZQ
         G9Hpt3pZHaEXxkLQWgKcnAVw+/Ndu039Wu3FomVF6KOnvoqXocVnsh5zhN8+a35dCZ
         LnqxjFovsWF2QHILpVt5RT3GuVkO+qEVxIA7KuneLLokUxfYQrLTqTCYBN75KssM6L
         afbBo6v2R5cWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 29/39] sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:51:45 -0400
Message-Id: <20210621175156.735062-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
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
index f029c7c03804..393cf99856ed 100644
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

