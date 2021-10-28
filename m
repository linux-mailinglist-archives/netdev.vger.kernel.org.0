Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059D643F2CF
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 00:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhJ1Wev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 18:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbhJ1Wer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 18:34:47 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F7FC061745
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 15:32:19 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id h81so1368781iof.6
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 15:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pC/0QFm2QzspTuRJ5yjxkysn3z8wLWR4jueB5J/ETjE=;
        b=OK4UvN1PFVnQ7ZqAaWMvjxl6f7xFPo/WdrepEpveyZyfCFeRz+Ni4rxQmxPOX/GmwE
         6eJcmt2ubu+LBVfQE2YgpeZDQNT5xKmmNxU1xHKYbiNnBfs8k8mSUxVnD4+/UHpO9Pno
         qW8MizQJ9ZoLJHFTKIxaX7BbBB5dDRLHpOLzQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pC/0QFm2QzspTuRJ5yjxkysn3z8wLWR4jueB5J/ETjE=;
        b=0C8/DJeO3On8F6LHTzQClaVE8eBRBNmD6YjBU9yT9QTPVHeR5Vgpp+XYSBmkVcn9jE
         UD2riYcBEsN1OCHv5C2Fev2GxTpat4Rc43RhznW4uOZZti21bIzshD6yUwVDWS+YOH3/
         zxmap/4MvXTLvtIT4WJp+KqLiSbbCrKgpWilx4KrklApbzsGsPuZl1bJ4D//LPWmks8d
         25XjOM77P+CLbsR7ZUQ+zXFpjFH9t2JvrQy7YS0UeOiwZKhbUSvu9bOo+JIfeU6RxkUS
         qUlkOUTUkXMjMmCzNBbuMjoLYDy0q5DwjcLrx+5MZwXk8WbYEgn1k5d8X1RIAvIBZCoT
         pdNg==
X-Gm-Message-State: AOAM53022zE7u/g/byhG9KRNvZoIZrzAIZG5TKUIrEEONY+02vycE0iV
        IiZM8l5WfTtwq70v0Wn3AeIN5w==
X-Google-Smtp-Source: ABdhPJw2rOVxKCKteaEQK9fJgPGVsuycReds7y3Sz5m+YsMEX2sj7cWWo0nO3JGAapxqApdiBvnRvA==
X-Received: by 2002:a05:6602:1651:: with SMTP id y17mr4947907iow.82.1635460339241;
        Thu, 28 Oct 2021 15:32:19 -0700 (PDT)
Received: from localhost ([2600:6c50:4d00:cd01::382])
        by smtp.gmail.com with ESMTPSA id r13sm2142520ilh.80.2021.10.28.15.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 15:32:18 -0700 (PDT)
From:   Benjamin Li <benl@squareup.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wcn36xx: fix RX BD rate mapping for 5GHz legacy rates
Date:   Thu, 28 Oct 2021 15:31:30 -0700
Message-Id: <20211028223131.897548-2-benl@squareup.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211028223131.897548-1-benl@squareup.com>
References: <20211028223131.897548-1-benl@squareup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The linear mapping between the BD rate field and the driver's 5GHz
legacy rates table (wcn_5ghz_rates) does not only apply for the latter
four rates -- it applies to all eight rates.

Fixes: 6ea131acea98 ("wcn36xx: Fix warning due to bad rate_idx")
Signed-off-by: Benjamin Li <benl@squareup.com>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index f0a9f069a92a9..b4a36acdaca74 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -354,8 +354,7 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 		status.nss = 1;
 
 		if (status.band == NL80211_BAND_5GHZ &&
-		    status.encoding == RX_ENC_LEGACY &&
-		    status.rate_idx >= sband->n_bitrates) {
+		    status.encoding == RX_ENC_LEGACY) {
 			/* no dsss rates in 5Ghz rates table */
 			status.rate_idx -= 4;
 		}
-- 
2.25.1

