Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0670131E12E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhBQVSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbhBQVSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 16:18:47 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90D8C061786
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 13:18:06 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id s17so7220204ioj.4
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 13:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pu/HI7/j8/NKE5Uf3Em92mkrENvyIcE8armO8V6c6ao=;
        b=L/TMDPONNuR6kUr29jUZByLEQ2KHg3DzccfhS3GwX7i3vLuyz9YIjtOGPglVEA7kpd
         p8+8dw82wrxsB2jvCvoEOvQ0bKdDtd3sjXK/TbH1NE9jVTMBY7G85w4lhZBYBX6G8owP
         prdAbzD6dfQBlBoTRjdqnqoFX1zDrvPRulV3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pu/HI7/j8/NKE5Uf3Em92mkrENvyIcE8armO8V6c6ao=;
        b=dEGDbApm/q5p84u5qA/WFdEHTPmGFOS54Y/tOLJI+/dfuHYF5sjhbJBZHEWr4VxfB6
         h0CwjydmiB7hFhs8kgkPPeJHk8GyakL+38CUHBxzenIEfYQnW/ce9zCmUM0FxYSJ7PPD
         TwX5kIMDafc+BN2lsA923+Y5/OST6S/tjT4DdZ0HyD7F16MIt2RQ65/kQD6nQg6csvvm
         7OQrav5vzpKhC8PAlLCU7kkiVoBT3moX8ZiOORw/O72we5LN/1HZdTp3KNud9uS1QO1b
         zxMBw/IP3cJ6JUOu4O6idItaZT2dByfRr2mJFil0nc8HqgkPBvMG2AEKfLulKhHKXAMZ
         3wmw==
X-Gm-Message-State: AOAM530PRBKRWiUV0Lbgm1+d8Sd70VobwqM4moiprDRqEf7V7pWyTwef
        te45UcLohSmg/xg1lVVJezWRqQ==
X-Google-Smtp-Source: ABdhPJxBxAJV5Lcl83v5gQoAcF+DqQnaPwDph8xWGoWJGWtWK9vbGPFkOBexJTdZonFywNRn9R2ZxQ==
X-Received: by 2002:a02:74a:: with SMTP id f71mr1367543jaf.30.1613596685786;
        Wed, 17 Feb 2021 13:18:05 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s9sm1885100ilt.77.2021.02.17.13.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 13:18:05 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        nbd@nbd.name
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "ath9k: fix ath_tx_process_buffer() potential null ptr dereference"
Date:   Wed, 17 Feb 2021 14:18:01 -0700
Message-Id: <20210217211801.22540-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath_tx_process_buffer() doesn't dereference or check sta and passes it
to ath_tx_complete_aggr() and ath_tx_complete_buf().

ath_tx_complete_aggr() checks the pointer before use. No problem here.

ath_tx_complete_buf() doesn't check or dereference sta and passes it on
to ath_tx_complete(). ath_tx_complete() doesn't check or dereference sta,
but assigns it to tx_info->status.status_driver_data[0]

ath_tx_complete_buf() is called from ath_tx_complete_aggr() passing
null ieee80211_sta pointer.

There is a potential for dereference later on, if and when the
tx_info->status.status_driver_data[0]is referenced. In addition, the
rcu read lock might be released before referencing the contents.

ath_tx_complete_buf() should be fixed to check sta perhaps? Worth
looking into.

Reverting this patch because it doesn't solve the problem and introduces
memory leak by skipping buffer completion if the pointer (sta) is NULL.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 28 ++++++++++++---------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 735858144e3a..1d36aae3f7b6 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -711,24 +711,20 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 		ath_tx_count_airtime(sc, sta, bf, ts, tid->tidno);
 		if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 			tid->clear_ps_filter = true;
+	}
 
-		if (!bf_isampdu(bf)) {
-			if (!flush) {
-				info = IEEE80211_SKB_CB(bf->bf_mpdu);
-				memcpy(info->control.rates, bf->rates,
-				       sizeof(info->control.rates));
-				ath_tx_rc_status(sc, bf, ts, 1,
-						 txok ? 0 : 1, txok);
-				ath_dynack_sample_tx_ts(sc->sc_ah,
-							bf->bf_mpdu, ts, sta);
-			}
-			ath_tx_complete_buf(sc, bf, txq, bf_head, sta,
-					    ts, txok);
-		} else {
-			ath_tx_complete_aggr(sc, txq, bf, bf_head, sta,
-					     tid, ts, txok);
+	if (!bf_isampdu(bf)) {
+		if (!flush) {
+			info = IEEE80211_SKB_CB(bf->bf_mpdu);
+			memcpy(info->control.rates, bf->rates,
+			       sizeof(info->control.rates));
+			ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
+			ath_dynack_sample_tx_ts(sc->sc_ah, bf->bf_mpdu, ts,
+						sta);
 		}
-	}
+		ath_tx_complete_buf(sc, bf, txq, bf_head, sta, ts, txok);
+	} else
+		ath_tx_complete_aggr(sc, txq, bf, bf_head, sta, tid, ts, txok);
 
 	if (!flush)
 		ath_txq_schedule(sc, txq);
-- 
2.27.0

