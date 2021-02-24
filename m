Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D6A323DCF
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbhBXNTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 08:19:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235271AbhBXNLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 08:11:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 436CB64FA8;
        Wed, 24 Feb 2021 12:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171322;
        bh=/j09jF9iEYwjdNIhhom79bvw1/WY5jtlDWpLUvx87Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsLyeOUIlKyuRqWl8xIpJFLRlzMJQ8o7cGyuVOGWnY8Jn4uEDBkxwFiG0LMQdU+2G
         nbzWhg9z1afp8iFoKs2z/06GqgQsQEn8RBkwooNLwIi8jKbkBZ/BWCrJLfOwVfLCKq
         jA2KjMPTkf8Q3sXwseNq3ik0MLdc0ZgSccObXI5HsEyq6TTPx+sSV3pld5aYwlax9A
         qmvEM4nSH8NQXwJfqCBQG0O+YkNOJl3yrrOsVUKuQ+zZ6/1ihC3moY6mw1+NtFyB+p
         rKrfch4J2n8J0m4J4p5rNiKiQCIZyjz4oyE2Vu4f2EFxIrHgfMfTxIVREfQFQnnzMc
         1/M/E1fPlD9VA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/16] ath10k: fix wmi mgmt tx queue full due to race condition
Date:   Wed, 24 Feb 2021 07:55:03 -0500
Message-Id: <20210224125514.483935-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125514.483935-1-sashal@kernel.org>
References: <20210224125514.483935-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit b55379e343a3472c35f4a1245906db5158cab453 ]

Failed to transmit wmi management frames:

[84977.840894] ath10k_snoc a000000.wifi: wmi mgmt tx queue is full
[84977.840913] ath10k_snoc a000000.wifi: failed to transmit packet, dropping: -28
[84977.840924] ath10k_snoc a000000.wifi: failed to submit frame: -28
[84977.840932] ath10k_snoc a000000.wifi: failed to transmit frame: -28

This issue is caused by race condition between skb_dequeue and
__skb_queue_tail. The queue of ‘wmi_mgmt_tx_queue’ is protected by a
different lock: ar->data_lock vs list->lock, the result is no protection.
So when ath10k_mgmt_over_wmi_tx_work() and ath10k_mac_tx_wmi_mgmt()
running concurrently on different CPUs, there appear to be a rare corner
cases when the queue length is 1,

  CPUx (skb_deuque)			CPUy (__skb_queue_tail)
					next=list
					prev=list
  struct sk_buff *skb = skb_peek(list);	WRITE_ONCE(newsk->next, next);
  WRITE_ONCE(list->qlen, list->qlen - 1);WRITE_ONCE(newsk->prev, prev);
  next       = skb->next;		WRITE_ONCE(next->prev, newsk);
  prev       = skb->prev;		WRITE_ONCE(prev->next, newsk);
  skb->next  = skb->prev = NULL;	list->qlen++;
  WRITE_ONCE(next->prev, prev);
  WRITE_ONCE(prev->next, next);

If the instruction ‘next = skb->next’ is executed before
‘WRITE_ONCE(prev->next, newsk)’, newsk will be lost, as CPUx get the
old ‘next’ pointer, but the length is still added by one. The final
result is the length of the queue will reach the maximum value but
the queue is empty.

So remove ar->data_lock, and use 'skb_queue_tail' instead of
'__skb_queue_tail' to prevent the potential race condition. Also switch
to use skb_queue_len_lockless, in case we queue a few SKBs simultaneously.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1.c2-00033-QCAHLSWMTPLZ-1

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1608618887-8857-1-git-send-email-miaoqing@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index be4420ff52b8a..aa5bec5a36761 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3545,23 +3545,16 @@ bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
 static int ath10k_mac_tx_wmi_mgmt(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct sk_buff_head *q = &ar->wmi_mgmt_tx_queue;
-	int ret = 0;
-
-	spin_lock_bh(&ar->data_lock);
 
-	if (skb_queue_len(q) == ATH10K_MAX_NUM_MGMT_PENDING) {
+	if (skb_queue_len_lockless(q) >= ATH10K_MAX_NUM_MGMT_PENDING) {
 		ath10k_warn(ar, "wmi mgmt tx queue is full\n");
-		ret = -ENOSPC;
-		goto unlock;
+		return -ENOSPC;
 	}
 
-	__skb_queue_tail(q, skb);
+	skb_queue_tail(q, skb);
 	ieee80211_queue_work(ar->hw, &ar->wmi_mgmt_tx_work);
 
-unlock:
-	spin_unlock_bh(&ar->data_lock);
-
-	return ret;
+	return 0;
 }
 
 static enum ath10k_mac_tx_path
-- 
2.27.0

