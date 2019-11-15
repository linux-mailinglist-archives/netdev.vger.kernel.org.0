Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CF4FDBCE
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 11:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfKOK4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 05:56:35 -0500
Received: from mail.aperture-lab.de ([138.201.29.205]:33618 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfKOK4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 05:56:35 -0500
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1573815392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uBJc7hcajP8FEHgdeBWBaFOQbOLebSdyenmlOi0uYxA=;
        b=O8JtRdntbEJURgpdD6MrUYkKYQYwyHbUNpMTSGs9rE8JbGfernDCI6mD8fKb2qukSC1FV+
        ZBXt7Q/srnvMlQgQjZJgpve874drG5Y+k+G4+PVDhmURl/Jo+jaSTMbMrD0KjtuUDHEYHh
        ZKetoahkmkKWGOetJK43EZreuRZdLVY11wn4wRwkDOllSrY9PB1JiuwiqcSNLiiOUskzQX
        rMLmWk488ReuJm3Pd94UBJO6jGQxQU+IPi/pZvXUcujJHMd975fmw/U8JCBCyFsOZTta1S
        s4AqP3D9GqvllPahTJ5SjYTu8+2trJeD+SfM4rbfGhKFPwgy6uqwDqLIhUZAiw==
To:     ath10k@lists.infradead.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>
Subject: [PATCH net-next v2] ath10k: fix RX of frames with broken FCS in monitor mode
Date:   Fri, 15 Nov 2019 11:56:12 +0100
Message-Id: <20191115105612.8531-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue;
        s=2018; t=1573815392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uBJc7hcajP8FEHgdeBWBaFOQbOLebSdyenmlOi0uYxA=;
        b=MMfU0F89mh6EF+HRdjK7Qm9SsszXQXVQH8OEu8xiT+nDw+d9FYqeftHJDPdGVEAMmGhtXn
        DYZYpjaQBlvZQOq2ue58DttUqGzKqsRIzNVf/lhFFxwBO3OCfbJQ2MgyCPeS+OqRLEvINB
        q6b9N+hiNtFCKSZBAeMZDqgwkskCfB818bY/9SpdlaWg7m3CEmOXde+8CPyGqgGv5Alfwh
        2kxFDq4STya73izPJ4XvnJTDwvpE8X/dTpQgYT9EmlGbwWknIJHDg3NATzVGwI6KdVnt1C
        ImvCic5cn0NWp9LGRtcwkGcOt9QwEmR7dCPqu/ciBtlxnU3q8enPdY7NliXA6Q==
ARC-Seal: i=1; s=2018; d=c0d3.blue; t=1573815392; a=rsa-sha256; cv=none;
        b=KUUWM6vRn3AtzkRE3UM7xMjLNEdf9BrkiLXVJ5fDdPnyYR20R+KkU3mtbapdbMrLqKNQ+A
        rrKNIglcXVdWorWhmSnuQExegzNsHXPerTiTBPPkBxgvieE5NtfSCVRwMua7qRYMf2iapg
        M2xPM2k46UdQvoNDdSpT6DOLj+d7RD7wRlwrRGKjbaglBmUiGKwGfHrtLPsnK07nPvY/BI
        ChcGcHcCDTRAawEBP1Y1hl5I2CI0K3dj0m3xwFsmAKyocvesfLDAwROkvcozB0I0KYVLsS
        qxp6SrGcWbPYl1J1jpTveKCJ6wkVR9D4tmtvghVtEw69M8HxfE4rLzpenq5GHQ==
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

Changelog v2:

* removed the spinlock as only a 32 bit statistics counter is
  incremented

Changelog RFC->v1:

* removed "ar->monitor" check
* added a debug counter

---

 drivers/net/wireless/ath/ath10k/core.h   | 1 +
 drivers/net/wireless/ath/ath10k/debug.c  | 2 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 7 +++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index af68eb5d0776..d445482fa945 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1180,6 +1180,7 @@ struct ath10k {
 
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
index 9f0e7b4943ec..8139c9cea1d8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1285,6 +1285,13 @@ static void ath10k_process_rx(struct ath10k *ar, struct sk_buff *skb)
 
 	status = IEEE80211_SKB_RXCB(skb);
 
+	if (!(ar->filter_flags & FIF_FCSFAIL) &&
+	    status->flag & RX_FLAG_FAILED_FCS_CRC) {
+		ar->stats.rx_crc_err_drop++;
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
 	ath10k_dbg(ar, ATH10K_DBG_DATA,
 		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
 		   skb,
-- 
2.24.0.rc2

