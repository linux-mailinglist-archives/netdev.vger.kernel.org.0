Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E803AF39F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhFUSCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233567AbhFUSAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D29613ED;
        Mon, 21 Jun 2021 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298076;
        bh=IvfwO7W+m151QZkIJivbN4TRV5E5e7WHbaY6qjOWgaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jqwzipw5ZbANrJu8pb6qbpFj/xH9WV36snQV9T31YzA6zBS4gVTuJ2SfdgOhK4KQF
         c4YBvHy1DCsxMVVDbEcBl9RQPByj3UHpqUfPaFVF5NP6DqOQnVwwEPC8acGQFRD98y
         78kfPGq9+9pNWfxiXoF/f4hCIC0QU4AWN0M5lGS5HeoW5NYFCFenZZZU37zwfxjk2X
         /UlKzojQDt3xpPmRvMWSyVezgQP+gWBk//WA/UzCMgRujPDaiChwjZBIOh2K3y4shn
         BxFnpG59d5NO8WjsFrkC2N3g9L4TEZHaIA88uCEZO3BEaxQnlfbkxU5rROiUrZKs9F
         DZhv5i0EMcHdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/26] r8169: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:53:53 -0400
Message-Id: <20210621175400.735800-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
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
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8ff178fc2670..661202e85412 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1801,7 +1801,7 @@ static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
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

