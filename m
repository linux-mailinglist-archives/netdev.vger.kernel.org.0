Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639755F932C
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbiJIW4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiJIWzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:55:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DA715A1C;
        Sun,  9 Oct 2022 15:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84EAAB80DE2;
        Sun,  9 Oct 2022 22:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E03C433C1;
        Sun,  9 Oct 2022 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354368;
        bh=m/QdiEsyaqsXyeYZVuoxXTWReCx/204ZsauJ1OlEs0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsw7/NtXq22Kr4qXuua/iBlkHz6h5ofN24IKc0HnnOW4k4wVluPDLUN2nOWpKY6WY
         UENOqSxo2kpxCzeNLiMopu4WYdWIOKzryts+NTgvoY/QMWPkrH0OEKCPFcYFQVQ7x6
         ugmUUK1FKDKJqskp6ojILe0AL9FWH7HofV/TiJjMmmCA4yDUpEXLs1wWqhN37Doxb9
         rGgxHkA1aA6Zp70ecnEIVJsr9p6JWqt4Aas9Xe4ba9wxkzCtzVmjNxGnrGokurxFTc
         NmK+4tZnK/qz6+8MlHOlE7VQga/gtlr47upY3MKNnvZvxF3fUjcmwxtWkFi28ekBLh
         Dtfzgx9mAYhYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+2ca247c2d60c7023de7f@syzkaller.appspotmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/23] wifi: ath9k: avoid uninit memory read in ath9k_htc_rx_msg()
Date:   Sun,  9 Oct 2022 18:25:35 -0400
Message-Id: <20221009222557.1219968-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222557.1219968-1-sashal@kernel.org>
References: <20221009222557.1219968-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit b383e8abed41cc6ff1a3b34de75df9397fa4878c ]

syzbot is reporting uninit value at ath9k_htc_rx_msg() [1], for
ioctl(USB_RAW_IOCTL_EP_WRITE) can call ath9k_hif_usb_rx_stream() with
pkt_len = 0 but ath9k_hif_usb_rx_stream() uses
__dev_alloc_skb(pkt_len + 32, GFP_ATOMIC) based on an assumption that
pkt_len is valid. As a result, ath9k_hif_usb_rx_stream() allocates skb
with uninitialized memory and ath9k_htc_rx_msg() is reading from
uninitialized memory.

Since bytes accessed by ath9k_htc_rx_msg() is not known until
ath9k_htc_rx_msg() is called, it would be difficult to check minimal valid
pkt_len at "if (pkt_len > 2 * MAX_RX_BUF_SIZE) {" line in
ath9k_hif_usb_rx_stream().

We have two choices. One is to workaround by adding __GFP_ZERO so that
ath9k_htc_rx_msg() sees 0 if pkt_len is invalid. The other is to let
ath9k_htc_rx_msg() validate pkt_len before accessing. This patch chose
the latter.

Note that I'm not sure threshold condition is correct, for I can't find
details on possible packet length used by this protocol.

Link: https://syzkaller.appspot.com/bug?extid=2ca247c2d60c7023de7f [1]
Reported-by: syzbot <syzbot+2ca247c2d60c7023de7f@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/7acfa1be-4b5c-b2ce-de43-95b0593fb3e5@I-love.SAKURA.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 43 +++++++++++++++---------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index e37de14bc502..6d69cf69fd86 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -367,33 +367,27 @@ void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
 }
 
 static void ath9k_htc_fw_panic_report(struct htc_target *htc_handle,
-				      struct sk_buff *skb)
+				      struct sk_buff *skb, u32 len)
 {
 	uint32_t *pattern = (uint32_t *)skb->data;
 
-	switch (*pattern) {
-	case 0x33221199:
-		{
+	if (*pattern == 0x33221199 && len >= sizeof(struct htc_panic_bad_vaddr)) {
 		struct htc_panic_bad_vaddr *htc_panic;
 		htc_panic = (struct htc_panic_bad_vaddr *) skb->data;
 		dev_err(htc_handle->dev, "ath: firmware panic! "
 			"exccause: 0x%08x; pc: 0x%08x; badvaddr: 0x%08x.\n",
 			htc_panic->exccause, htc_panic->pc,
 			htc_panic->badvaddr);
-		break;
-		}
-	case 0x33221299:
-		{
+		return;
+	}
+	if (*pattern == 0x33221299) {
 		struct htc_panic_bad_epid *htc_panic;
 		htc_panic = (struct htc_panic_bad_epid *) skb->data;
 		dev_err(htc_handle->dev, "ath: firmware panic! "
 			"bad epid: 0x%08x\n", htc_panic->epid);
-		break;
-		}
-	default:
-		dev_err(htc_handle->dev, "ath: unknown panic pattern!\n");
-		break;
+		return;
 	}
+	dev_err(htc_handle->dev, "ath: unknown panic pattern!\n");
 }
 
 /*
@@ -414,16 +408,26 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 	if (!htc_handle || !skb)
 		return;
 
+	/* A valid message requires len >= 8.
+	 *
+	 *   sizeof(struct htc_frame_hdr) == 8
+	 *   sizeof(struct htc_ready_msg) == 8
+	 *   sizeof(struct htc_panic_bad_vaddr) == 16
+	 *   sizeof(struct htc_panic_bad_epid) == 8
+	 */
+	if (unlikely(len < sizeof(struct htc_frame_hdr)))
+		goto invalid;
 	htc_hdr = (struct htc_frame_hdr *) skb->data;
 	epid = htc_hdr->endpoint_id;
 
 	if (epid == 0x99) {
-		ath9k_htc_fw_panic_report(htc_handle, skb);
+		ath9k_htc_fw_panic_report(htc_handle, skb, len);
 		kfree_skb(skb);
 		return;
 	}
 
 	if (epid < 0 || epid >= ENDPOINT_MAX) {
+invalid:
 		if (pipe_id != USB_REG_IN_PIPE)
 			dev_kfree_skb_any(skb);
 		else
@@ -435,21 +439,30 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 
 		/* Handle trailer */
 		if (htc_hdr->flags & HTC_FLAGS_RECV_TRAILER) {
-			if (be32_to_cpu(*(__be32 *) skb->data) == 0x00C60000)
+			if (be32_to_cpu(*(__be32 *) skb->data) == 0x00C60000) {
 				/* Move past the Watchdog pattern */
 				htc_hdr = (struct htc_frame_hdr *)(skb->data + 4);
+				len -= 4;
+			}
 		}
 
 		/* Get the message ID */
+		if (unlikely(len < sizeof(struct htc_frame_hdr) + sizeof(__be16)))
+			goto invalid;
 		msg_id = (__be16 *) ((void *) htc_hdr +
 				     sizeof(struct htc_frame_hdr));
 
 		/* Now process HTC messages */
 		switch (be16_to_cpu(*msg_id)) {
 		case HTC_MSG_READY_ID:
+			if (unlikely(len < sizeof(struct htc_ready_msg)))
+				goto invalid;
 			htc_process_target_rdy(htc_handle, htc_hdr);
 			break;
 		case HTC_MSG_CONNECT_SERVICE_RESPONSE_ID:
+			if (unlikely(len < sizeof(struct htc_frame_hdr) +
+				     sizeof(struct htc_conn_svc_rspmsg)))
+				goto invalid;
 			htc_process_conn_rsp(htc_handle, htc_hdr);
 			break;
 		default:
-- 
2.35.1

