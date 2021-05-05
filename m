Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6155B37425A
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbhEEQqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235487AbhEEQl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 607DC6186A;
        Wed,  5 May 2021 16:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232489;
        bh=nlRjb1u7hSZ9ilo4vAun6ueLqcGnriYGmhd3kAeYos4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZabK5x5EAiHoKxcM/YPU98UunKB5UFm9DK7izbl5o9fYsvAjB7ViYAYqO+Z8PNl4O
         hU6vAJz4jrqwQcnP2asNZ/d7OzAH5B3pDyRpBt4O4A4vXH11O1FA1f+GL/I9txANMx
         iomD+2KlK1MWO8sSsxNp/X2cnhjgHQgqNG+WcSG2uFk9GIvrn6xixnL1NFJVY2L+en
         OKwJskXqyIMi5CAcTDY2h5FLKV2OstiWoj1CmxDRYJQb9zMdzQdKSroNoAzlEJGrsV
         YoecCSxYFS4lEfwZLcHFZ9nrY8AujyA2OgUnFDF17JPGtq61CkMAzV11kx3JlYpOBp
         k8Hy2BH5txD6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 025/104] Bluetooth: initialize skb_queue_head at l2cap_chan_create()
Date:   Wed,  5 May 2021 12:32:54 -0400
Message-Id: <20210505163413.3461611-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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
index 46da4c1d0177..78776d0782c5 100644
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

