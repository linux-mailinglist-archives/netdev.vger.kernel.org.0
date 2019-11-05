Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F303F037D
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390399AbfKEQzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:55:15 -0500
Received: from mail.aperture-lab.de ([138.201.29.205]:57106 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390060AbfKEQzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:55:15 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Nov 2019 11:55:14 EST
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1572972606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=A4o+TvT+3DU2TuZZZ5Ukyqq2OA7OUrD/LYDeu136xXo=;
        b=eKaM8U5anTeSSbpbTfQEDsinYFx/8JXx6rrdvuxtR33xfv34H1McpU2Iwpo94Ei+126A8k
        29w3ftw7jTj4FJwskOhlMV1Zp03RS+V++a4Mui8gAhhEb9LO8ovQoNv8g/82g036QGF4Az
        ShI3CiJYa+M3ECi5fYdQf5pDH9ymPyn1nTmW+MQ0QtjP30vWFFBF59c6E3GVlsxv6HTN7L
        Zlm/LxHkvZFQPqJadbLcTUc7URlB++HU/AXmZx4pezgnrJYLegJG8orlBQ3cjT9nqFoZdS
        dt5YEzAQe87d1oGQ7tfiGnumm99LM3O3hondz8WEB8NJhgW2QDjxhojEprqQBw==
To:     ath10k@lists.infradead.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>
Subject: [PATCH net-next] ath10k: fix RX of frames with broken FCS in monitor mode
Date:   Tue,  5 Nov 2019 17:49:32 +0100
Message-Id: <20191105164932.11799-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue;
        s=2018; t=1572972606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=A4o+TvT+3DU2TuZZZ5Ukyqq2OA7OUrD/LYDeu136xXo=;
        b=auYd3bMkXFMp2tggRSB3WRF+GpXQmASYI8pWe/jIXmf3bEcxf3hI9StYZsZZUo1s8VaG7X
        WvZ54nJJdXz/5Ewd94d9WU6RykrBkLACXE2m3fxyh/1ofJO8qyvjprMpcbeHzj2SLgqV9M
        gr0FQa5orGMeMDcRXp4Vkp6dyUqbvRx+5qruQW1wgFTp6v3LP0kV4QB32oyGnYMbdN+lDx
        HGy1YD6TTtRFMom80NKpPtmu1oraEKZR46Zv/uktMPvcXY+o6omAa6jpvXI0LWS2HVWC1s
        c4Xd3ApQ2RJp171Vae9iRLNTQUHARIxVdOd6YPoGmiV1A50A4/XoeZXTJ3dJ/g==
ARC-Seal: i=1; s=2018; d=c0d3.blue; t=1572972606; a=rsa-sha256; cv=none;
        b=Qv6YtoEdX4ewk6c7mjveFfqd8SPLQ/pcDdgTLLQMxlaED05U4f0kbgHUwWWraP9psScsOV
        roaGaQ+zFVzlBtJucdQXGBjARGzHED5HdnaJPOjo7Y312D/Xa0Ua0o4pUr4LwQz5NdnIat
        2aSEhx2MiuANhK5np95uLiVzw2XK4bseBYjuNNjX6IR7NaiTO0AFDYlTevck60z48FuWxb
        4kM4c3WjdjHoKm2BW8TitacGo6H9CxnTgG1g++6j9iy73r0UoODtQ9usQ/0zXdsPcHNJHD
        ouF7nomAi3O9LDwqWSNlCwKOeb2JkEPrWFDL3F+MQERU0uCf3cM77zdW5b0sKw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <ll@simonwunderlich.de>

So far, frames were forwarded regardless of the FCS correctness leading
to userspace applications listening on the monitor mode interface to
receive potentially broken frames, even with the "fcsfail" flag unset.

By default, with the "fcsfail" flag of a monitor mode interface
unset, frames with FCS errors should be dropped. With this patch, the
fcsfail flag is taken into account correctly.

Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
---
This was tested on an Open Mesh A41 device, featuring a QCA4019. And
with this firmware:

https://www.candelatech.com/downloads/ath10k-4019-10-4b/firmware-5-ct-full-community-12.bin-lede.011

But from looking at the code it seems that the vanilla ath10k has the
same issue, therefore submitting it here.

Changelog RFC->v1:

* removed "ar->monitor" check
* added a debug counter

---
 drivers/net/wireless/ath/ath10k/core.h   |  1 +
 drivers/net/wireless/ath/ath10k/debug.c  |  2 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 10 ++++++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4d7db07db6ba..787065a9eb3f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1171,6 +1171,7 @@ struct ath10k {
 
 	struct {
 		/* protected by data_lock */
+		u32 rx_crc_err_drop;
 		u32 fw_crash_counter;
 		u32 fw_warm_reset_counter;
 		u32 fw_cold_reset_counter;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index bd2b5628f850..5e4cd2966e6f 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1094,6 +1094,7 @@ static const char ath10k_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"d_rts_good",
 	"d_tx_power", /* in .5 dbM I think */
 	"d_rx_crc_err", /* fcs_bad */
+	"d_rx_crc_err_drop", /* frame with FCS error, dropped late in kernel */
 	"d_no_beacon",
 	"d_tx_mpdus_queued",
 	"d_tx_msdu_queued",
@@ -1193,6 +1194,7 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 	data[i++] = pdev_stats->rts_good;
 	data[i++] = pdev_stats->chan_tx_power;
 	data[i++] = pdev_stats->fcs_bad;
+	data[i++] = ar->stats.rx_crc_err_drop;
 	data[i++] = pdev_stats->no_beacons;
 	data[i++] = pdev_stats->mpdu_enqued;
 	data[i++] = pdev_stats->msdu_enqued;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 53f1095de8ff..149728588e80 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1285,6 +1285,16 @@ static void ath10k_process_rx(struct ath10k *ar, struct sk_buff *skb)
 
 	status = IEEE80211_SKB_RXCB(skb);
 
+	if (!(ar->filter_flags & FIF_FCSFAIL) &&
+	    status->flag & RX_FLAG_FAILED_FCS_CRC) {
+		spin_lock_bh(&ar->data_lock);
+		ar->stats.rx_crc_err_drop++;
+		spin_unlock_bh(&ar->data_lock);
+
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
 	ath10k_dbg(ar, ATH10K_DBG_DATA,
 		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
 		   skb,
-- 
2.24.0.rc2

