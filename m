Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C42F3AF410
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbhFUSGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231797AbhFUSD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:03:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0552961411;
        Mon, 21 Jun 2021 17:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298136;
        bh=Kd9a3ZNmyTVW0IOsoOLCiBjQhKEGktUcBWuBImjJLo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oa6BgyKuvUVM3VNqAR+DGLkMytYy+pR7+ReQAmfxITROhrSyWkP9G+69e3IwBJSOz
         cjT1qAqvOUxSOZUzQldHLBaQmFQIwewzMT0jxSwXaEUN4AasfuHKoAL/iGRMiNKWnZ
         bMsWuR1ffQmyc3B7oCGyBh+0DvdS3/igb6mgzHNKl/XMbg51OukuhJJxUzfj7ZWubo
         XFUI9TvDBXURkY/kr7e5HEPLerG2n98bqvguQcI1jwhhcSfFoDJdY76hqpXN0tl4Lx
         h56uysn1k1iTu5kpjffb58F6wcw8eMUVcFA9r/oaxXfsPRVV6jD9U6VoZwj08hHuZJ
         Mby22R17+6cKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/13] sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:55:16 -0400
Message-Id: <20210621175519.736255-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175519.736255-1-sashal@kernel.org>
References: <20210621175519.736255-1-sashal@kernel.org>
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
index dab1597287b9..36f1019809ea 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2197,7 +2197,7 @@ static void sh_eth_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
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

