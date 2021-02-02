Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBD730C34B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhBBPNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:13:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235191AbhBBPL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:11:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFCF064F6C;
        Tue,  2 Feb 2021 15:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278402;
        bh=cLcsa51PyK+Y+1DrJUenXnA+a2UDeaAi47p99Do7Sq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuDJOEI1oR/CrOjRkTX5Yuh7wmPYFIewi6nbm0zGlYUA+9+SWgonNChgaTGnoAge/
         wR+0UJbYODjzih3rW3zVVpTZZmCzpCAG5sTY/F2zeXeB0vSN1AtkSg9iLW8RfKduKP
         CF8zxxy+8e3cBv5rQpX0eJ57jyyyjeprwQkJtCFPjYOBzrosk0n5ZtnHkGZ7AXXUPe
         Pv6t1gMt6JkYxlwe0TrP5F13ns6SgoCLoex/NgoRgjRtBaGuEIlJd2LO+DotaYa8Vu
         937ehMSk+rLsKxBjyC7kLnGKUd/f2UdBiAxw6ew3gPllh6/UhtmniuWmeW5lum8i0q
         MpCyZ53lKDZ1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/25] iwlwifi: queue: bail out on invalid freeing
Date:   Tue,  2 Feb 2021 10:06:10 -0500
Message-Id: <20210202150615.1864175-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0bed6a2a14afaae240cc431e49c260568488b51c ]

If we find an entry without an SKB, we currently continue, but
that will just result in an infinite loop since we won't increment
the read pointer, and will try the same thing over and over again.
Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210122144849.abe2dedcc3ac.Ia6b03f9eeb617fd819e56dd5376f4bb8edc7b98a@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/queue/tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index af0b27a68d84d..9181221a2434d 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -887,10 +887,8 @@ void iwl_txq_gen2_unmap(struct iwl_trans *trans, int txq_id)
 			int idx = iwl_txq_get_cmd_index(txq, txq->read_ptr);
 			struct sk_buff *skb = txq->entries[idx].skb;
 
-			if (WARN_ON_ONCE(!skb))
-				continue;
-
-			iwl_txq_free_tso_page(trans, skb);
+			if (!WARN_ON_ONCE(!skb))
+				iwl_txq_free_tso_page(trans, skb);
 		}
 		iwl_txq_gen2_free_tfd(trans, txq);
 		txq->read_ptr = iwl_txq_inc_wrap(trans, txq->read_ptr);
-- 
2.27.0

