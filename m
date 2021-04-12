Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9475635CD8B
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245256AbhDLQhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244994AbhDLQdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:33:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33331613CF;
        Mon, 12 Apr 2021 16:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244799;
        bh=8HpKkNSRru0z8WcDe7S90lfAhdtFVrp/8hrFMhRpK2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRvmP+zSHkgmswk9ZXjJDHpDsyBD8qkOR1h+n5kmfft0k9anLCxOUj98vBwGwugDI
         o8X3k+QEbYr8RGN0x/aENiJvz0jc2DzlrZqAySyom7rbYdeLZYcz2+a1nt0Ip2FYa+
         QI93/oi9leQd7heUsTu+VtOy2a9Z0Rm9+7iud+JL/Z4dgptKRwH5X7NElp3qLBLHSO
         XuP4gyFGZcV2O8orfk2mvp/FciKKy44oxzErwPwbmZPlXX0n3gmJZz2hlaIj28nZmT
         eEhJ17ydmribk3NVYy9kAVfojhbd0SFn/WlKxBznjwt/smH8znX3VALyXxztcTEZS1
         S51wxatEt42WA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+28a246747e0a465127f3@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/25] drivers: net: fix memory leak in atusb_probe
Date:   Mon, 12 Apr 2021 12:26:11 -0400
Message-Id: <20210412162630.315526-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162630.315526-1-sashal@kernel.org>
References: <20210412162630.315526-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 6b9fbe16955152626557ec6f439f3407b7769941 ]

syzbot reported memory leak in atusb_probe()[1].
The problem was in atusb_alloc_urbs().
Since urb is anchored, we need to release the reference
to correctly free the urb

backtrace:
    [<ffffffff82ba0466>] kmalloc include/linux/slab.h:559 [inline]
    [<ffffffff82ba0466>] usb_alloc_urb+0x66/0xe0 drivers/usb/core/urb.c:74
    [<ffffffff82ad3888>] atusb_alloc_urbs drivers/net/ieee802154/atusb.c:362 [inline][2]
    [<ffffffff82ad3888>] atusb_probe+0x158/0x820 drivers/net/ieee802154/atusb.c:1038 [1]

Reported-by: syzbot+28a246747e0a465127f3@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/atusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 8e2cbc88df98..2c4274453c15 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -346,6 +346,7 @@ static int atusb_alloc_urbs(struct atusb *atusb, int n)
 			return -ENOMEM;
 		}
 		usb_anchor_urb(urb, &atusb->idle_urbs);
+		usb_free_urb(urb);
 		n--;
 	}
 	return 0;
-- 
2.30.2

