Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3692221209
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGOQLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgGOQLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:11:49 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7793C061755;
        Wed, 15 Jul 2020 09:11:48 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f5so3184337ljj.10;
        Wed, 15 Jul 2020 09:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EMJ3AmxIrJx//PWnt8IhX2NqkDjePQpD0K9qH5qgQmc=;
        b=J68iVBHrak/jiQALSLVnH0yu9VJWfTPzLP4EhZrF1tqAqwoo53hNWuiSMjszPnZtlm
         Ui7yapN1No5fNK55QiRgbxzqMarjEIzpYcdldh4P0f/4gSweR5Hn2IBwq2V/uFziyXYA
         8IOSopB/0Ce9jvbn3gzvD9eQkDw+g7mPx1NQqFQNd67asBxA0leZug0/ZIYih+/8K0v/
         zMFnrG15WUg4qWekNEkV45ZgXzO2KLwLlSsgMhqnQHJO6orDVqfQDRSygYAnt+FqZItq
         91kSjSyAKonRVALVgwv0qee/qu7m/QK+28EnHC626/V1HmpkPcRlpP3FORSSC75tHGcL
         x7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EMJ3AmxIrJx//PWnt8IhX2NqkDjePQpD0K9qH5qgQmc=;
        b=Pr/pIWBJMz81FLEpVoE6aM4mIX+kekwufxltN278FT/IwEGYV1VAfhA1Ld4ExQRXAM
         bXDk6zqndy4mT5TMca32GC1xMQOLvYUCIoWEBp6x8nH6OBRjLNPz1ckcQ/CT6pv/ffB4
         Iy2207tP+EWxl9y0+HzgTWzpYXOOv3rf3gcsRUjuklnf1Rnv1doKMGspCrDrfdwnrqsG
         lXBKHvtndn0gACV9HHeOQPtfnM2yDDlWh3vivAXC2KCMKy5I00xPdE4KMYNWipLz10ea
         ANiW3l3XpQ+gwjtWFxVYaprZHcwnw86AwAQcBBe5OHZHfTRZ4hUhvI0QCfes3JIBnmA8
         B3UQ==
X-Gm-Message-State: AOAM530mYRfTyiRxmiC3dG/WLdTLjSfyyjSfFBylbziZGbNz7g0d6yKi
        w5C1AxZZCGwluIRXoz/Gq6iSvXZl
X-Google-Smtp-Source: ABdhPJydnXBv8tnPjJ+RIFdr8QWTZT8KPQU25hJ48hxf7F5gnZjJyS5XV/68WcJzz9+1e5pHdQaqNQ==
X-Received: by 2002:a2e:3619:: with SMTP id d25mr5103685lja.204.1594829506977;
        Wed, 15 Jul 2020 09:11:46 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id e29sm577097lfc.51.2020.07.15.09.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 09:11:45 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH net] net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration
Date:   Wed, 15 Jul 2020 19:10:00 +0300
Message-Id: <20200715161000.14158-1-sorganov@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Documentation/networking/timestamping.txt:

  A driver which supports hardware time stamping shall update the
  struct with the actual, possibly more permissive configuration.

Do update the struct passed when we upscale the requested time
stamping mode.

Fixes: cb646e2b02b2 ("ptp: Added a clock driver for the National Semiconductor PHYTER.")
Signed-off-by: Sergey Organov <sorganov@gmail.com>
---
 drivers/net/phy/dp83640.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index ecbd5e0d685c..acb0aae60755 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1260,6 +1260,7 @@ static int dp83640_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 		dp83640->hwts_rx_en = 1;
 		dp83640->layer = PTP_CLASS_L4;
 		dp83640->version = PTP_CLASS_V1;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
@@ -1267,6 +1268,7 @@ static int dp83640_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 		dp83640->hwts_rx_en = 1;
 		dp83640->layer = PTP_CLASS_L4;
 		dp83640->version = PTP_CLASS_V2;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
@@ -1274,6 +1276,7 @@ static int dp83640_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 		dp83640->hwts_rx_en = 1;
 		dp83640->layer = PTP_CLASS_L2;
 		dp83640->version = PTP_CLASS_V2;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
@@ -1281,6 +1284,7 @@ static int dp83640_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 		dp83640->hwts_rx_en = 1;
 		dp83640->layer = PTP_CLASS_L4 | PTP_CLASS_L2;
 		dp83640->version = PTP_CLASS_V2;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
 		break;
 	default:
 		return -ERANGE;
-- 
2.10.0.1.g57b01a3

