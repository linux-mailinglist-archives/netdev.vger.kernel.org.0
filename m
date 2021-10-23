Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F24D43810A
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 02:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhJWAme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 20:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbhJWAmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 20:42:32 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1EDC061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 17:40:14 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id j3so6065113ilr.6
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 17:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RpFO/O8OJtCCTXoNPY6I7vBtlJtuEAebpHNwcVp0mrs=;
        b=eGRxqCs470PqWufr+LBwbmCqk4jplUIcjZEiiDcmwk7hfArmQOqmBx96+lfQjRUBkT
         WpFxJwYG0oFHv7Jk5Em6LZ5YClfBy3gxaxY0Mhh//4RpLRXl7pwYsVDL5xFre1LGf1f4
         AVV4Z8kjcITfXwgMd/aeO9IXNyydC1L6aND/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RpFO/O8OJtCCTXoNPY6I7vBtlJtuEAebpHNwcVp0mrs=;
        b=6AMTt6IdxV76Ziyylv+M8hAiqpwhmDYWl6eo+3rotKkGad+rouKl5+r/u8+lDEFJSS
         ofGnWYfCoipAxwzSdRIsDqNZpy3wLfg7FBT/iRbal6mycZRo8KcNRFw62bYEad6HNgfa
         RSXDXMH8No+Dq+/BDZKc+murkwEIOV9j/RECy12ujKkLnMOpYS+Rl9TZQ/op99cZhpEv
         bemY3VUK+Rlu8aNkUOK8ncBmRMTqXA7OlkA8qn6sYPHF2Ibvwd+gxzdZ+9MW+qSMqedM
         yucn3QJ0ehgz9u8Rh3xBhDxxT/MkeLc7lwF5cdlEaKQSsspBIsRe2/aheh3AWCGoOGaE
         AoqA==
X-Gm-Message-State: AOAM5300F9oeQFgE5IA4kqXmaJDzwm0VpRABzqOjYkO5xXkH+wdTaNIo
        JtnvQ1yRdj5CtF0bLdY0qepn9A==
X-Google-Smtp-Source: ABdhPJwdXiQmYkDN0aV5a+y49XXFI/iSmA+a2vItLSezpw39bYgk/Le3YtZnTauxjBQ1DbydkOX2uQ==
X-Received: by 2002:a92:c56c:: with SMTP id b12mr1870927ilj.45.1634949613566;
        Fri, 22 Oct 2021 17:40:13 -0700 (PDT)
Received: from localhost ([2600:6c50:4d00:cd01::382])
        by smtp.gmail.com with ESMTPSA id y6sm4689189iol.11.2021.10.22.17.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 17:40:13 -0700 (PDT)
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
Subject: [PATCH 2/3] wcn36xx: implement flush op to speed up connected scan
Date:   Fri, 22 Oct 2021 17:39:47 -0700
Message-Id: <20211023003949.3082900-3-benl@squareup.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211023003949.3082900-1-benl@squareup.com>
References: <20211023003949.3082900-1-benl@squareup.com>
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
index 8e1dbfda65386..c4e9e939d7d6d 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -831,6 +831,53 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 	return ret;
 }
 
+static bool _wcn36xx_dxe_tx_channel_is_empty(struct wcn36xx_dxe_ch *ch)
+{
+	int flags;
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
index 81ac86eeaf60b..24bfb30a30f31 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1275,6 +1275,16 @@ static void wcn36xx_ipv6_addr_change(struct ieee80211_hw *hw,
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
@@ -1302,6 +1312,7 @@ static const struct ieee80211_ops wcn36xx_ops = {
 #if IS_ENABLED(CONFIG_IPV6)
 	.ipv6_addr_change	= wcn36xx_ipv6_addr_change,
 #endif
+	.flush			= wcn36xx_flush,
 
 	CFG80211_TESTMODE_CMD(wcn36xx_tm_cmd)
 };
-- 
2.25.1

