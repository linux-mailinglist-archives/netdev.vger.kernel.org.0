Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1BF3743DC
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbhEEQww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236422AbhEEQtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 336686143F;
        Wed,  5 May 2021 16:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232638;
        bh=Q7GsfxgLu5IRzYcfD4p0g4gAFfBtZx/hFLn1I5CeNYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ge32eN2x2QWVcjHLF51LzNuWMjnbl4JWSniEIAD0zfV3Dnk1iQVcoTc2QPYZXLJHr
         KM1aq9gMrfRHCqYBPyP+nuLLb6HiAT3DCrBjvs4BvmESmSSi2iVlb9nVk+UVBCyeyC
         iio/S3zw4DknfolrNo05yijRgHyxB3ONNzrSeKe/ED1E5BnEquBlhUdTst88VJirFy
         zImNKSToWnNaN7ttu6FFGR3fAIBKJas9FWoSZayU+GAoF+x2D6BI3bZ8yn+ZgjW1lk
         L4yL5kG9VJyhy0QMTqd74AqLmyZM2JcDeznAyQvV/os+0dexEtOq7/0ItKBiYhnXsQ
         /gUx4HvFYUudA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/85] Bluetooth: initialize skb_queue_head at l2cap_chan_create()
Date:   Wed,  5 May 2021 12:35:43 -0400
Message-Id: <20210505163648.3462507-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit be8597239379f0f53c9710dd6ab551bbf535bec6 ]

syzbot is hitting "INFO: trying to register non-static key." message [1],
for "struct l2cap_chan"->tx_q.lock spinlock is not yet initialized when
l2cap_chan_del() is called due to e.g. timeout.

Since "struct l2cap_chan"->lock mutex is initialized at l2cap_chan_create()
immediately after "struct l2cap_chan" is allocated using kzalloc(), let's
as well initialize "struct l2cap_chan"->{tx_q,srej_q}.lock spinlocks there.

[1] https://syzkaller.appspot.com/bug?extid=fadfba6a911f6bf71842

Reported-and-tested-by: syzbot <syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 3e18cddfbcc5..cdc386337173 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -451,6 +451,8 @@ struct l2cap_chan *l2cap_chan_create(void)
 	if (!chan)
 		return NULL;
 
+	skb_queue_head_init(&chan->tx_q);
+	skb_queue_head_init(&chan->srej_q);
 	mutex_init(&chan->lock);
 
 	/* Set default lock nesting level */
-- 
2.30.2

