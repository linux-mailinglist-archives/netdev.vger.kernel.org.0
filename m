Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F9835CE15
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244311AbhDLQl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344028AbhDLQge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57F97613EE;
        Mon, 12 Apr 2021 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244865;
        bh=qMQjQflva4IqA4iz7UcBFlGLJHKqxssRV5J4IgwLWqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+Y128e6ThLhH73Atsa4qedTpMg0Nrtf6T3vhJMM7aTQx8IwMiCFf6vI2gfAysrEg
         DqI5FqabzBeVCNqOfVYw7PbDaLGMyonQMUIJF1inMxhtq3VTwe2ZQpYLJkHPbGh2JB
         Dy2Le34cHs74axYfxD1G8Cpt0LLtIZU9MwBC5p1iRwkrMgriZSZb9BCB9EwBKkYBeL
         eN+x5wpSQ4FgKaoHsWQZ5qvZgaSeSvqYUHyECt7gchkKdp47Pd6pQYEz9Fr/CR6bPx
         VjbTnohmX2Rt2cSKbu7RnBrwvdhmatOn2BmEAZNAbmHIiQ6nrt+6qZot0/YyJI1leV
         ye1827nixfJDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+28a246747e0a465127f3@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/23] drivers: net: fix memory leak in atusb_probe
Date:   Mon, 12 Apr 2021 12:27:19 -0400
Message-Id: <20210412162736.316026-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
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
index d5e0e2aedc55..9b3ab60c3556 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -340,6 +340,7 @@ static int atusb_alloc_urbs(struct atusb *atusb, int n)
 			return -ENOMEM;
 		}
 		usb_anchor_urb(urb, &atusb->idle_urbs);
+		usb_free_urb(urb);
 		n--;
 	}
 	return 0;
-- 
2.30.2

