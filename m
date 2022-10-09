Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815425F92B8
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiJIWud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiJIWtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A423AB17;
        Sun,  9 Oct 2022 15:25:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F1C360C95;
        Sun,  9 Oct 2022 22:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF7FC433B5;
        Sun,  9 Oct 2022 22:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354307;
        bh=rNP+Al6u5YeMGaU/bAoWFB6k46B24myAjYk+sEp9nMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/InbRKTTXSC/j9PYj3nX8vcXdH1TUjTrpU4/O03YTQDFg/EFeetCyj39eetBsORz
         PiHl/yCjZWYpIXX9ndCoVFRW/UyZFIGXRD6nq/wUPs8SR4Y5+46llu7hkHRR3bNt9z
         oKFLdxoJok2LzSukXViCDxLeQU+Kvxtn9F9ZNLinAPEVX9yyw+dCb983+DccmNYitl
         JF2OV1yhUyhyrcjJ8aN6yf4sm/yUf26/aaUcBrKiOLuVvFo0u6iX2+EsEjcQEMzeQZ
         an9Vsm53SHGGbXotTrqxlhlD5o4XVNCzlcMYxVMFndWnRq/bo+xklFMsCVImqjSRMP
         CBYD5IWfkjO5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+83672956c7aa6af698b3@syzkaller.appspotmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/25] Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()
Date:   Sun,  9 Oct 2022 18:24:16 -0400
Message-Id: <20221009222436.1219411-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222436.1219411-1-sashal@kernel.org>
References: <20221009222436.1219411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 2d2cb3066f2c90cd8ca540b36ba7a55e7f2406e0 ]

syzbot is reporting cancel_delayed_work() without INIT_DELAYED_WORK() at
l2cap_chan_del() [1], for CONF_NOT_COMPLETE flag (which meant to prevent
l2cap_chan_del() from calling cancel_delayed_work()) is cleared by timer
which fires before l2cap_chan_del() is called by closing file descriptor
created by socket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_L2CAP).

l2cap_bredr_sig_cmd(L2CAP_CONF_REQ) and l2cap_bredr_sig_cmd(L2CAP_CONF_RSP)
are calling l2cap_ertm_init(chan), and they call l2cap_chan_ready() (which
clears CONF_NOT_COMPLETE flag) only when l2cap_ertm_init(chan) succeeded.

l2cap_sock_init() does not call l2cap_ertm_init(chan), and it instead sets
CONF_NOT_COMPLETE flag by calling l2cap_chan_set_defaults(). However, when
connect() is requested, "command 0x0409 tx timeout" happens after 2 seconds
 from connect() request, and CONF_NOT_COMPLETE flag is cleared after 4
seconds from connect() request, for l2cap_conn_start() from
l2cap_info_timeout() callback scheduled by

  schedule_delayed_work(&conn->info_timer, L2CAP_INFO_TIMEOUT);

in l2cap_connect() is calling l2cap_chan_ready().

Fix this problem by initializing delayed works used by L2CAP_MODE_ERTM
mode as soon as l2cap_chan_create() allocates a channel, like I did in
commit be8597239379f0f5 ("Bluetooth: initialize skb_queue_head at
l2cap_chan_create()").

Link: https://syzkaller.appspot.com/bug?extid=83672956c7aa6af698b3 [1]
Reported-by: syzbot <syzbot+83672956c7aa6af698b3@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 65d20bdff023..7c280fcdcaa0 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -63,6 +63,9 @@ static void l2cap_send_disconn_req(struct l2cap_chan *chan, int err);
 
 static void l2cap_tx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 		     struct sk_buff_head *skbs, u8 event);
+static void l2cap_retrans_timeout(struct work_struct *work);
+static void l2cap_monitor_timeout(struct work_struct *work);
+static void l2cap_ack_timeout(struct work_struct *work);
 
 static inline u8 bdaddr_type(u8 link_type, u8 bdaddr_type)
 {
@@ -470,6 +473,9 @@ struct l2cap_chan *l2cap_chan_create(void)
 	write_unlock(&chan_list_lock);
 
 	INIT_DELAYED_WORK(&chan->chan_timer, l2cap_chan_timeout);
+	INIT_DELAYED_WORK(&chan->retrans_timer, l2cap_retrans_timeout);
+	INIT_DELAYED_WORK(&chan->monitor_timer, l2cap_monitor_timeout);
+	INIT_DELAYED_WORK(&chan->ack_timer, l2cap_ack_timeout);
 
 	chan->state = BT_OPEN;
 
@@ -3154,10 +3160,6 @@ int l2cap_ertm_init(struct l2cap_chan *chan)
 	chan->rx_state = L2CAP_RX_STATE_RECV;
 	chan->tx_state = L2CAP_TX_STATE_XMIT;
 
-	INIT_DELAYED_WORK(&chan->retrans_timer, l2cap_retrans_timeout);
-	INIT_DELAYED_WORK(&chan->monitor_timer, l2cap_monitor_timeout);
-	INIT_DELAYED_WORK(&chan->ack_timer, l2cap_ack_timeout);
-
 	skb_queue_head_init(&chan->srej_q);
 
 	err = l2cap_seq_list_init(&chan->srej_list, chan->tx_win);
-- 
2.35.1

