Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6C2119A57
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfLJVwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:52:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727549AbfLJVHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:07:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29E0724687;
        Tue, 10 Dec 2019 21:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012067;
        bh=haEPsc2yk+K9gE7Q79DHnfLRnG8eqSnhALg/2VZ68rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDSbtHDcb5PUAx59sI1U+1ftHFouuLji+F9FdnMLwOl8k05sPzJaQwH8RM+iDvJsg
         HQy2A+hF6qZQQubYshddlfW1TjBc6uSQFmSbelVF5P2op3AzU8b8jRdqd0rsz1fHjJ
         1WbxoZq/F2Vtji1H3ITwbLMFdKXzqlYJ9+BEL8xM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>,
        Antonio Quartulli <antonio.quartulli@kaiwoo.ai>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 048/350] ath10k: fix offchannel tx failure when no ath10k_mac_tx_frm_has_freq
Date:   Tue, 10 Dec 2019 16:02:33 -0500
Message-Id: <20191210210735.9077-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit cc6df017e55764ffef9819dd9554053182535ffd ]

Offchannel management frames were failing:

[18099.253732] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
[18102.293686] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
[18105.333653] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
[18108.373712] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
[18111.413687] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e36c0
[18114.453726] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3f00
[18117.493773] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e36c0
[18120.533631] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3f00

This bug appears to have been added between 4.0 (which works for us),
and 4.4, which does not work.

I think this is because the tx-offchannel logic gets in a loop when
ath10k_mac_tx_frm_has_freq(ar) is false, so pkt is never actually
sent to the firmware for transmit.

This patch fixes the problem on 4.9 for me, and now HS20 clients
can work again with my firmware.

Antonio: tested with 10.4-3.5.3-00057 on QCA4019 and QCA9888

Signed-off-by: Ben Greear <greearb@candelatech.com>
Tested-by: Antonio Quartulli <antonio.quartulli@kaiwoo.ai>
[kvalo@codeaurora.org: improve commit log, remove unneeded parenthesis]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 40889b79fc70d..a40e1a998f4cd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3708,7 +3708,7 @@ static int ath10k_mac_tx(struct ath10k *ar,
 			 struct ieee80211_vif *vif,
 			 enum ath10k_hw_txrx_mode txmode,
 			 enum ath10k_mac_tx_path txpath,
-			 struct sk_buff *skb)
+			 struct sk_buff *skb, bool noque_offchan)
 {
 	struct ieee80211_hw *hw = ar->hw;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -3738,10 +3738,10 @@ static int ath10k_mac_tx(struct ath10k *ar,
 		}
 	}
 
-	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
+	if (!noque_offchan && info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
 		if (!ath10k_mac_tx_frm_has_freq(ar)) {
-			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %pK\n",
-				   skb);
+			ath10k_dbg(ar, ATH10K_DBG_MAC, "mac queued offchannel skb %pK len %d\n",
+				   skb, skb->len);
 
 			skb_queue_tail(&ar->offchan_tx_queue, skb);
 			ieee80211_queue_work(hw, &ar->offchan_tx_work);
@@ -3803,8 +3803,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		mutex_lock(&ar->conf_mutex);
 
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac offchannel skb %pK\n",
-			   skb);
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac offchannel skb %pK len %d\n",
+			   skb, skb->len);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		peer_addr = ieee80211_get_DA(hdr);
@@ -3850,7 +3850,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 		txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
 
-		ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb);
+		ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb, true);
 		if (ret) {
 			ath10k_warn(ar, "failed to transmit offchannel frame: %d\n",
 				    ret);
@@ -3860,8 +3860,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		time_left =
 		wait_for_completion_timeout(&ar->offchan_tx_completed, 3 * HZ);
 		if (time_left == 0)
-			ath10k_warn(ar, "timed out waiting for offchannel skb %pK\n",
-				    skb);
+			ath10k_warn(ar, "timed out waiting for offchannel skb %pK, len: %d\n",
+				    skb, skb->len);
 
 		if (!peer && tmp_peer_created) {
 			ret = ath10k_peer_delete(ar, vdev_id, peer_addr);
@@ -4097,7 +4097,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		spin_unlock_bh(&ar->htt.tx_lock);
 	}
 
-	ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb);
+	ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb, false);
 	if (unlikely(ret)) {
 		ath10k_warn(ar, "failed to push frame: %d\n", ret);
 
@@ -4378,7 +4378,7 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 		spin_unlock_bh(&ar->htt.tx_lock);
 	}
 
-	ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb);
+	ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb, false);
 	if (ret) {
 		ath10k_warn(ar, "failed to transmit frame: %d\n", ret);
 		if (is_htt) {
-- 
2.20.1

