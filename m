Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F0E3AF454
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbhFUSIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234315AbhFUSFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:05:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05A216141E;
        Mon, 21 Jun 2021 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298178;
        bh=7FhEY9bKQFM0Cn+9zjlCF4QRg9OeLIX/jo3GWw/rZbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4OwPUMEpKUXnHksV5E1h3cHXhk8Q72056NfKPtYjWYYWieZHngWJP46dKconsYzZ
         bx55KiquRNYQES5WMqj65mFd4oOh6ZlcKRV6011+wrYG9xR0Er77QZVVlBl/RKcx/Q
         ugWuFK3QHzYzKalHgVZq9VE2sYfahTadJA7HF11Kqgg32ubc833rBMDdhB+4IWHeGy
         qjQiYTc0CoTgfVhFlfw5xUZ3HsYjFVEBkKZC3Dy5ySbZ5ePRAbm3mKTcbUrImBDiRq
         JgFYIPG83QLuAe9QRsDoXZVx8308Z7Yp1OSXvDUFObjl2oCgV1lf/czmCu7ElHeHIH
         vgQuiLswYUALw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 7/9] sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:56:05 -0400
Message-Id: <20210621175608.736581-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175608.736581-1-sashal@kernel.org>
References: <20210621175608.736581-1-sashal@kernel.org>
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
index 614b83c7ce81..1942264b621b 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2210,7 +2210,7 @@ static void sh_eth_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
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

