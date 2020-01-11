Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72607138292
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 18:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730521AbgAKRQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 12:16:19 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40974 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730423AbgAKRQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 12:16:18 -0500
Received: by mail-pf1-f194.google.com with SMTP id w62so2715871pfw.8;
        Sat, 11 Jan 2020 09:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Li992Inl6qlK9dLbIXMHvdL8lIRzO4/rvMMlJnBSYOA=;
        b=aaVHG5LZLJzn9bL5nsMjFha4VHzpuAjs6cHT4gm680uONrLp1NjmAcnK2gbfgXZWWD
         g9ZkOxjqGHvx0UYYTRKOnTYx0aM9So0HAirKrWrqu+H3OlJgHO0MInLT2j5JsNRyT97C
         H79SF6PvxoMrFwSiprsxRAyAo99s7AZ6t8kKgmze+k0doLozIZ4lHAk7vxS0Tshp0G7d
         fNhOgxHoI3o5yQo5tNzbYVheQYYbhOsDaiGQHlwnXa1+iWiVzUUIKwtF72kMnH2lav7r
         i4oaBufB8y5kK5QVN+n06cJ3S1FfO1VlHrqgnErgAdQdfSi16TCEVPnn7FMhPHX9BODu
         B2YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Li992Inl6qlK9dLbIXMHvdL8lIRzO4/rvMMlJnBSYOA=;
        b=pJdmu/sokonlQjqPtlfMQrWHgxjHm+M8EN+g6g1tfWsIk5eejOt48RKLVOyDLQ1A4Q
         cQeiC2uLvC+8uSy/0xbrfMNTGLJSV385UcG42m8dOIWeYFHLjiID9U0NyESEvX/YXHil
         LC9ypXKqZnBI8I8eFnqSCyHfucL/hZ0nzueygnvmr9uRn21zDThxcE/lYlnLKzoD10Fq
         MI/DqqtwHzPQjf5fqwldx4l4HlSs4XFVVh6c1vMOhwiKXNn+pXTwHpduSBCFYojbBWcs
         vHYT2lYxTwCtlObLpzaCgJsXKO59D7EhPTDAQk1BERp7G7aNE2oZB9s3WY2iMm3etLcr
         y6ZQ==
X-Gm-Message-State: APjAAAWEWOrgWApMEzLjrYUzyfIaf/pMmfXFQEqiXraByUeyY/2tytJK
        aRVo/quu+82QJKaP1KAnGNk=
X-Google-Smtp-Source: APXvYqyZ9MxvudC4km4COLPCC/MGFZZRHwBHvfuCzm+d+wi8wQx/9swWuz5czVpRsj7St4CMLTgwxQ==
X-Received: by 2002:a63:1853:: with SMTP id 19mr11774376pgy.170.1578762977781;
        Sat, 11 Jan 2020 09:16:17 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.172])
        by smtp.gmail.com with ESMTPSA id o184sm6997015pgo.62.2020.01.11.09.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 09:16:17 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] ath9k: Fix possible data races in ath_set_channel()
Date:   Sun, 12 Jan 2020 01:15:28 +0800
Message-Id: <20200111171528.7053-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions ath9k_config() and ath_ani_calibrate() may be concurrently
executed.

A variable survey->filled is accessed with holding a spinlock
common->cc_lock, through:
ath_ani_calibrate()
    spin_lock_irqsave(&common->cc_lock, flags);
    ath_update_survey_stats()
        ath_update_survey_nf()
            survey->filled |= SURVEY_INFO_NOISE_DBM;

The identical variables sc->cur_survey->filled and 
sc->survey[pos].filled is accessed without holding this lock, through:
ath9k_config()
    ath_chanctx_set_channel()
        ath_set_channel()
            sc->cur_survey->filled &= ~SURVEY_INFO_IN_USE;
            sc->cur_survey->filled |= SURVEY_INFO_IN_USE;
            else if (!(sc->survey[pos].filled & SURVEY_INFO_IN_USE))
            ath_update_survey_nf
                survey->filled |= SURVEY_INFO_NOISE_DBM;

Thus, possible data races may occur.

To fix these data races, in ath_set_channel(), these variables are
accessed with holding the spinlock common->cc_lock.

These data races are found by the runtime testing of our tool DILP-2.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index fd61ae4782b6..b16f7f65e9c6 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -54,6 +54,7 @@ static int ath_set_channel(struct ath_softc *sc)
 	 * Reset the survey data for the new channel, unless we're switching
 	 * back to the operating channel from an off-channel operation.
 	 */
+	spin_lock_irqsave(&common->cc_lock, flags);
 	if (!sc->cur_chan->offchannel && sc->cur_survey != &sc->survey[pos]) {
 		if (sc->cur_survey)
 			sc->cur_survey->filled &= ~SURVEY_INFO_IN_USE;
@@ -65,6 +66,7 @@ static int ath_set_channel(struct ath_softc *sc)
 	} else if (!(sc->survey[pos].filled & SURVEY_INFO_IN_USE)) {
 		memset(&sc->survey[pos], 0, sizeof(struct survey_info));
 	}
+	spin_unlock_irqrestore(&common->cc_lock, flags);
 
 	hchan = &sc->sc_ah->channels[pos];
 	r = ath_reset(sc, hchan);
@@ -75,8 +77,11 @@ static int ath_set_channel(struct ath_softc *sc)
 	 * channel is only available after the hardware reset. Copy it to
 	 * the survey stats now.
 	 */
-	if (old_pos >= 0)
+	if (old_pos >= 0) {
+		spin_lock_irqsave(&common->cc_lock, flags);
 		ath_update_survey_nf(sc, old_pos);
+		spin_unlock_irqrestore(&common->cc_lock, flags);
+	}
 
 	/* Enable radar pulse detection if on a DFS channel. Spectral
 	 * scanning and radar detection can not be used concurrently.
-- 
2.17.1

