Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3DF3AF3D8
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhFUSFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233533AbhFUSCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91794613FA;
        Mon, 21 Jun 2021 17:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298107;
        bh=V8wVtzYXxX7ZY1kfeeRnGHt+Q4QO/IFJYN+Y6g7FpIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTJIKIYbyK/dkLwuIzr9F4B6W8eggVBmGcO9y1l3knURkSrGMFxnsuV3wSbKWyv5u
         xKflnmLilpxmUMkE3/fKxHh5aDFLJi8gxM2MNabgg3EmHe4ceMlYu7wDAI7o2Qiu0O
         KwX8h9L2Wcrr0AU5uWdrIYGkXAiyULVB/ag4m7oZ8+g+lOLGCHpdd0k9W8tHDYuHng
         fBXUKGl/xPoeg2hcFQIGksVSKMFFXmqAgQKqVcPTLzh5zLuG/hayBuV2qLvr9Xw4Km
         OkGD3FGkd6GtK8qYddd9p2nHqu0KjJTp4K75EYm93ApHTKRuNMrHsGp3AAtDs5MICZ
         aH5m9mNf1Phgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/16] r8152: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:54:44 -0400
Message-Id: <20210621175450.736067-10-sashal@kernel.org>
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

[ Upstream commit 99718abdc00e86e4f286dd836408e2834886c16e ]

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
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a27ea04cfa6c..726fb5561a0f 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4649,7 +4649,7 @@ static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 {
 	switch (stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, *rtl8152_gstrings, sizeof(rtl8152_gstrings));
+		memcpy(data, rtl8152_gstrings, sizeof(rtl8152_gstrings));
 		break;
 	}
 }
-- 
2.30.2

