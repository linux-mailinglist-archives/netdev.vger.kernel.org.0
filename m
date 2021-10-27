Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F5943CF5D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243174AbhJ0RFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243163AbhJ0RFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:05:51 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17368C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:03:25 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id e144so4568094iof.3
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vaPyuXgzdhcUygDHuVBiwmyWLmrU49F/hn5Fj5Aw+O8=;
        b=aXzVstfY7UcSdP01SZvPDxDrls3KrMPQKnbf1eTnc+8YsLE+dYGzIrIwZTzH0ZFx99
         hgGMHBpmbZGAT6TJqGrLqB8E6fSMCd9sRXuMseOWpE0hHCQdigDbNJBULqLhyTnvuusB
         bpXKG2ESL07UpsFCFSET5SoVsf3Tl8Y+YUWWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vaPyuXgzdhcUygDHuVBiwmyWLmrU49F/hn5Fj5Aw+O8=;
        b=NfSBKyAOkQgiV+sgAtLzvoQjxonBw1j/7vmhaAydrkqdhcZWVcLzkR5p6/6OM8w+fS
         EaG423YkeOmKHn6RnfNkMKPMHs/ceOKe9+PMpPAEOKAHYIeZrp3bMHHevgfmooA/Rh6G
         eBuRl0EpV4ypbQ//0G3seKkHRvP/14csWqxsFKU7O99Kl4712DT4uzCCQ3NDfo+U7HAa
         x9fRo4glpSeAWql0+0JQWbGw5azLRw8JPqM304/Xvk3F0I/1/BLgD2q+F8Feouic8kUB
         20YDftryEKwJZTouAOAip86qG9imdmdUE/6lzcx9i0ns5bP3SNOFGK59SWY9pYcrtVbw
         pTqw==
X-Gm-Message-State: AOAM530Q/lc2E4vVQ8JEwIrpzdYy5dy8DAlRmwaMrJYuHJKqy+BPk/+t
        VxfyGBkpn/GTMqAi+LtwzdmnEg==
X-Google-Smtp-Source: ABdhPJzzIhbqMKW+hp7YtVcRRVcHpjWWW0Rf8aHGSISSXjTmDUgcIfhcNqpM1kP9VA12nMQs5p3hzA==
X-Received: by 2002:a02:7105:: with SMTP id n5mr21099107jac.64.1635354204420;
        Wed, 27 Oct 2021 10:03:24 -0700 (PDT)
Received: from localhost ([2600:6c50:4d00:cd01::382])
        by smtp.gmail.com with ESMTPSA id q205sm254086ioq.41.2021.10.27.10.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 10:03:23 -0700 (PDT)
From:   Benjamin Li <benl@squareup.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Joseph Gates <jgates@squareup.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] wcn36xx: implement flush op to speed up connected scan
Date:   Wed, 27 Oct 2021 10:03:04 -0700
Message-Id: <20211027170306.555535-3-benl@squareup.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211027170306.555535-1-benl@squareup.com>
References: <20211027170306.555535-1-benl@squareup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without ieee80211_ops->flush implemented to empty HW queues, mac80211 will
do a 100ms dead wait after stopping SW queues, before leaving the operating
channel to resume a software connected scan[1].
(see ieee80211_scan_state_resume)

This wait is correctly included in the calculation for whether or not
we've exceeded max off-channel time, as it occurs after sending the null
frame with PS bit set. Thus, with 125 ms max off-channel time we only
have 25 ms of scan time, which technically isn't even enough to scan one
channel (although mac80211 always scans at least one channel per off-
channel window).

Moreover, for passive probes we end up spending at least 100 ms + 111 ms
(IEEE80211_PASSIVE_CHANNEL_TIME) "off-channel"[2], which exceeds the listen
interval of 200 ms that we provide in our association request frame. That's
technically out-of-spec.

[1]: Until recently, wcn36xx performed software (rather than FW-offloaded)
scanning when 5GHz channels are requested. This apparent limitation is now
resolved -- see commit 1395f8a6a4d5 ("wcn36xx: Enable hardware scan offload
for 5Ghz band").
[2]: in quotes because about 100 ms of it is still on-channel but with PS
set

Signed-off-by: Benjamin Li <benl@squareup.com>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c  | 47 +++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/dxe.h  |  1 +
 drivers/net/wireless/ath/wcn36xx/main.c | 11 ++++++
 3 files changed, 59 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index aff04ef662663..fd627c9f3d409 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -834,6 +834,53 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 	return ret;
 }
 
+static bool _wcn36xx_dxe_tx_channel_is_empty(struct wcn36xx_dxe_ch *ch)
+{
+	unsigned long flags;
+	struct wcn36xx_dxe_ctl *ctl_bd_start, *ctl_skb_start;
+	struct wcn36xx_dxe_ctl *ctl_bd, *ctl_skb;
+	bool ret = true;
+
+	spin_lock_irqsave(&ch->lock, flags);
+
+	/* Loop through ring buffer looking for nonempty entries. */
+	ctl_bd_start = ch->head_blk_ctl;
+	ctl_bd = ctl_bd_start;
+	ctl_skb_start = ctl_bd_start->next;
+	ctl_skb = ctl_skb_start;
+	do {
+		if (ctl_skb->skb) {
+			ret = false;
+			goto unlock;
+		}
+		ctl_bd = ctl_skb->next;
+		ctl_skb = ctl_bd->next;
+	} while (ctl_skb != ctl_skb_start);
+
+unlock:
+	spin_unlock_irqrestore(&ch->lock, flags);
+	return ret;
+}
+
+int wcn36xx_dxe_tx_flush(struct wcn36xx *wcn)
+{
+	int i = 0;
+
+	/* Called with mac80211 queues stopped. Wait for empty HW queues. */
+	do {
+		if (_wcn36xx_dxe_tx_channel_is_empty(&wcn->dxe_tx_l_ch) &&
+		    _wcn36xx_dxe_tx_channel_is_empty(&wcn->dxe_tx_h_ch)) {
+			return 0;
+		}
+		/* This ieee80211_ops callback is specifically allowed to
+		 * sleep.
+		 */
+		usleep_range(1000, 1100);
+	} while (++i < 100);
+
+	return -EBUSY;
+}
+
 int wcn36xx_dxe_init(struct wcn36xx *wcn)
 {
 	int reg_data = 0, ret;
diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.h b/drivers/net/wireless/ath/wcn36xx/dxe.h
index 31b81b7547a32..26a31edf52e99 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.h
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.h
@@ -466,5 +466,6 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 			 struct wcn36xx_tx_bd *bd,
 			 struct sk_buff *skb,
 			 bool is_low);
+int wcn36xx_dxe_tx_flush(struct wcn36xx *wcn);
 void wcn36xx_dxe_tx_ack_ind(struct wcn36xx *wcn, u32 status);
 #endif	/* _DXE_H_ */
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 0b0f8ce729dd1..18383d0fc0933 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1278,6 +1278,16 @@ static void wcn36xx_ipv6_addr_change(struct ieee80211_hw *hw,
 }
 #endif
 
+static void wcn36xx_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  u32 queues, bool drop)
+{
+	struct wcn36xx *wcn = hw->priv;
+
+	if (wcn36xx_dxe_tx_flush(wcn)) {
+		wcn36xx_err("Failed to flush hardware tx queues\n");
+	}
+}
+
 static const struct ieee80211_ops wcn36xx_ops = {
 	.start			= wcn36xx_start,
 	.stop			= wcn36xx_stop,
@@ -1305,6 +1315,7 @@ static const struct ieee80211_ops wcn36xx_ops = {
 #if IS_ENABLED(CONFIG_IPV6)
 	.ipv6_addr_change	= wcn36xx_ipv6_addr_change,
 #endif
+	.flush			= wcn36xx_flush,
 
 	CFG80211_TESTMODE_CMD(wcn36xx_tm_cmd)
 };
-- 
2.25.1

