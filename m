Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3BF3AF3DC
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhFUSFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233535AbhFUSCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23D24613F5;
        Mon, 21 Jun 2021 17:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298108;
        bh=ixPtpWQFcVD5fCPnUsUUb8all2Nzn9FIVmPd+9/1ZP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNXHnNH3BODfJJ1ut6blx56c383QQ4FXUAdijLtmXQvBJMrOHxdmXYGd4bwFa5Dov
         n0RTssr9Et3jG54we50wfEdiS7rb1Lzbua5NYeO3uqjniwzsgIiNi6fthuvLtMUsAe
         DbgrFUd/N+Sz3505E3cvoRUPQhlOuTSGDMpeZ9u40C52ZlHpex+MdGEPfGixkAyKDy
         OMjnPAR8I3FFgDtQEaITxHQxHoFAMdg+cUv61wUCmMHcGqvorjUu2K4s9cPcEUrAKm
         MJ/jxum1e5q7TRxEbrVBFU5E3+R1S5UsqwYo1BI+Ky0U0EmoKdP9au9uDCY+cQyklO
         +4S6AeVuOgsuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/16] sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:54:45 -0400
Message-Id: <20210621175450.736067-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175450.736067-1-sashal@kernel.org>
References: <20210621175450.736067-1-sashal@kernel.org>
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
index 24638cb157ca..394ab9cdfe2c 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2302,7 +2302,7 @@ static void sh_eth_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
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

