Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9FF12B81D
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfL0Rmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:42:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbfL0Rmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7064820CC7;
        Fri, 27 Dec 2019 17:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468565;
        bh=2m/b3YaV30WQP7EmUHqtvR2SDpsnEF7V/wpRmsP9GRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQH5xtv/RBtjysZbBeFwn+eqBUqmgy/mYSKNHHZB96vtayuNbc8yf4KnrLmQ181/O
         /kEAaAwQRMsKv/L8wAwlJrtyDGJmH7WYGqdhd2QGQxfqG85ZLHd0mIvCzs5LYBZtL2
         g5AZCr0+qHu+RKabSUtogPaw3DVllBFGp0i4k3k0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fredrik Olofsson <fredrik.olofsson@anyfinetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 090/187] mac80211: fix TID field in monitor mode transmit
Date:   Fri, 27 Dec 2019 12:39:18 -0500
Message-Id: <20191227174055.4923-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fredrik Olofsson <fredrik.olofsson@anyfinetworks.com>

[ Upstream commit 753ffad3d6243303994227854d951ff5c70fa9e0 ]

Fix overwriting of the qos_ctrl.tid field for encrypted frames injected on
a monitor interface. While qos_ctrl.tid is not encrypted, it's used as an
input into the encryption algorithm so it's protected, and thus cannot be
modified after encryption. For injected frames, the encryption may already
have been done in userspace, so we cannot change any fields.

Before passing the frame to the driver, the qos_ctrl.tid field is updated
from skb->priority. Prior to dbd50a851c50 skb->priority was updated in
ieee80211_select_queue_80211(), but this function is no longer always
called.

Update skb->priority in ieee80211_monitor_start_xmit() so that the value
is stored, and when later code 'modifies' the TID it really sets it to
the same value as before, preserving the encryption.

Fixes: dbd50a851c50 ("mac80211: only allocate one queue when using iTXQs")
Signed-off-by: Fredrik Olofsson <fredrik.olofsson@anyfinetworks.com>
Link: https://lore.kernel.org/r/20191119133451.14711-1-fredrik.olofsson@anyfinetworks.com
[rewrite commit message based on our discussion]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1fa422782905..cbd273c0b275 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2263,6 +2263,15 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 						    payload[7]);
 	}
 
+	/*
+	 * Initialize skb->priority for QoS frames. This is put in the TID field
+	 * of the frame before passing it to the driver.
+	 */
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		u8 *p = ieee80211_get_qos_ctl(hdr);
+		skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
+	}
+
 	memset(info, 0, sizeof(*info));
 
 	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-- 
2.20.1

