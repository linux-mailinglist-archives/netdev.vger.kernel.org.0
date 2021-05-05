Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA1C37456B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbhEERFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237719AbhEERBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:01:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CFA361415;
        Wed,  5 May 2021 16:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232821;
        bh=5svZwSmxyWekTnkLfzuqHjjPRv8iDNLV72IION7ylqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoC0SBemlBbg08SMQr0y1WAuaTJvjM1Z6S8nQYWltqsqcY8ZKmXilUmHMzB0vjNww
         Sf7iIINhN4zUcb5eFEzXMa9WTuM8bKT1YBAaoMtYw8Alt21/KPT2Mzmyhw+JFM13tD
         RW53ZymGaLG3bmAR8XD9Jb7406gxdrXQL3m6aOwS+mvWuCiv49kUeOQetk1UHLd6FA
         0CszmBDZUvNNXtUKbS4ID69P4WhTuCkUdRw6sEnRtY5FCXb/HUK7/XbeijG12wCsnI
         QDZUXMnSLHo+siGS9Zwo33AmvPgNXvjD0D8hJRYHqDFzMb4RGtD78lmAaOw/Rq9mjr
         ri7C+Mh6CBwYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/32] Bluetooth: initialize skb_queue_head at l2cap_chan_create()
Date:   Wed,  5 May 2021 12:39:43 -0400
Message-Id: <20210505164004.3463707-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164004.3463707-1-sashal@kernel.org>
References: <20210505164004.3463707-1-sashal@kernel.org>
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
index 30373d00ab04..c0d64b4144d4 100644
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

