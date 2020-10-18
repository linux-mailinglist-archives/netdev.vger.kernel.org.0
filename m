Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B1F291BD5
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731725AbgJRT0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731701AbgJRT03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9839C222C8;
        Sun, 18 Oct 2020 19:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049188;
        bh=ENhYOI+QU7ybTUoEpjs1AxbjjXkfmaC7fwvl73sHl0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdVjnDCV7vIJSBS2fzXxCSL1yhJUMsxxxFvNhPeJ32ssWrVJtJoZmD/aZhxRC+Qk7
         bkVRMBZuvClxDJpEHxiPD+smRBsETGqbE8X8KZIxzDck03fobj66g8Y94UZqjF1UYW
         PsNSuRqE4acjSh1W7mESp//Juh/Bau1kibMK+/jY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 48/52] mwifiex: don't call del_timer_sync() on uninitialized timer
Date:   Sun, 18 Oct 2020 15:25:25 -0400
Message-Id: <20201018192530.4055730-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 621a3a8b1c0ecf16e1e5667ea5756a76a082b738 ]

syzbot is reporting that del_timer_sync() is called from
mwifiex_usb_cleanup_tx_aggr() from mwifiex_unregister_dev() without
checking timer_setup() from mwifiex_usb_tx_init() was called [1].

Ganapathi Bhat proposed a possibly cleaner fix, but it seems that
that fix was forgotten [2].

"grep -FrB1 'del_timer' drivers/ | grep -FA1 '.function)'" says that
currently there are 28 locations which call del_timer[_sync]() only if
that timer's function field was initialized (because timer_setup() sets
that timer's function field). Therefore, let's use same approach here.

[1] https://syzkaller.appspot.com/bug?id=26525f643f454dd7be0078423e3cdb0d57744959
[2] https://lkml.kernel.org/r/CA+ASDXMHt2gq9Hy+iP_BYkWXsSreWdp3_bAfMkNcuqJ3K+-jbQ@mail.gmail.com

Reported-by: syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>
Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc: Brian Norris <briannorris@chromium.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200821082720.7716-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 50890cab8807b..44d5005188c93 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -1335,7 +1335,8 @@ static void mwifiex_usb_cleanup_tx_aggr(struct mwifiex_adapter *adapter)
 				skb_dequeue(&port->tx_aggr.aggr_list)))
 				mwifiex_write_data_complete(adapter, skb_tmp,
 							    0, -1);
-		del_timer_sync(&port->tx_aggr.timer_cnxt.hold_timer);
+		if (port->tx_aggr.timer_cnxt.hold_timer.function)
+			del_timer_sync(&port->tx_aggr.timer_cnxt.hold_timer);
 		port->tx_aggr.timer_cnxt.is_hold_timer_set = false;
 		port->tx_aggr.timer_cnxt.hold_tmo_msecs = 0;
 	}
-- 
2.25.1

