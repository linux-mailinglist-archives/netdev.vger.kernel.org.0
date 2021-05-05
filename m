Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC29374583
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238581AbhEERGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:32778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237803AbhEERBo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA0A961A14;
        Wed,  5 May 2021 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232865;
        bh=dPx9z9fKQJ6K4YmTJcUomZVJhoMxNaHdCoO5HYefZCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iy2wrkcmlxpG9jzRr0pIFiYGPHeHhmjsexChVXQPsg/xpAEdYT3qYJmoX0Qs3PaMS
         m+X63OFAz3sRZym+4yDK3e5iEWr9vNgKeZeNH26ya9JPNUoGq/L7Cdm+2Xrf+Ylbbi
         zCNGMbt/ddDgneEh8jJJJ0kINeyjUp4xvXHZZsIZSNIwpuCdk9cBVCIg8L68JyQiyV
         o9qMpvER7ijblKXm841dalck+vYUm2oRt2R92y63Kfqsc74HDSdaqTJNR41PAVCtIc
         zdE5HMw3qMxtqKkiZL9n9hkOH8udUxvmEw24n4I6Y8EZ9qDYh85YAWECyiIKThRWgD
         3QzHXwarTInww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/25] Bluetooth: initialize skb_queue_head at l2cap_chan_create()
Date:   Wed,  5 May 2021 12:40:35 -0400
Message-Id: <20210505164051.3464020-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164051.3464020-1-sashal@kernel.org>
References: <20210505164051.3464020-1-sashal@kernel.org>
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
index b5a7d04066ec..460401349255 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -445,6 +445,8 @@ struct l2cap_chan *l2cap_chan_create(void)
 	if (!chan)
 		return NULL;
 
+	skb_queue_head_init(&chan->tx_q);
+	skb_queue_head_init(&chan->srej_q);
 	mutex_init(&chan->lock);
 
 	/* Set default lock nesting level */
-- 
2.30.2

