Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D9B3AF40E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhFUSGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231792AbhFUSD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:03:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C88E613F0;
        Mon, 21 Jun 2021 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298138;
        bh=2IKbnHxMDnVBoUTL2DIlZzBwzV8l8nQCh3hScq+Pc10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dv/NxrWETX5VRRJNo93b8qLhMU1cgAwzz9eUzuzYCuFGwy2sU2k+Rxnv13NctFAN7
         fiqh0x4pc/zEkRxF+l27hvqu2CrWf1mNc9Tu32qqpTCF95G9/7KBuu0dU5TgAInLPI
         cSWemUGOurigjuTXHBjIsUsLuoly6tmmCtxc9nsR8vmQpZWYXuCpuOYGnBL4s1RjDf
         xz9BhCzlIghqmerfyecaysK0d2Vyoyuwm2z8depITfHOcyD9W2UPQES7sOjv446qWf
         5SjVuIGT39k6GAYPyz6YZBT1/0+ZyrztPHgcDp1lXJ+KopYevMhFjr7nqg+o093v17
         ZwDL5GdDh/ETA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/13] r8169: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:55:17 -0400
Message-Id: <20210621175519.736255-11-sashal@kernel.org>
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

[ Upstream commit da5ac772cfe2a03058b0accfac03fad60c46c24d ]

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
 drivers/net/ethernet/realtek/r8169.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 530b8da11960..191531a03415 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -2355,7 +2355,7 @@ static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 {
 	switch(stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, *rtl8169_gstrings, sizeof(rtl8169_gstrings));
+		memcpy(data, rtl8169_gstrings, sizeof(rtl8169_gstrings));
 		break;
 	}
 }
-- 
2.30.2

