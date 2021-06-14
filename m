Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A40B3A66C5
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhFNMlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:41:37 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:37746 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhFNMlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:41:35 -0400
Received: by mail-ed1-f44.google.com with SMTP id b11so46297254edy.4
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hgFkwjcJJLaBU8nE16Qln3qRxVwMomFvhqvRMqMhxus=;
        b=OCcTvZHPcXTl2AJYDO1QFoNIs47QkqawY2WsLpMbZobgWz1IkqvuQEfpwPxq9XtuxV
         uil26lz823dpwLSdSFFtsWhVyfX7uvXZnJHvi6QEoO3Wnx5wqMhiV2XYvnmwCH6fkEQA
         Rot49P1/pmdI/ATKXmSXddAuZQ6PtLAHTHuBFwBqwwIB/D8N2xZNTQUT/c+SnUSA+axc
         XPzdOnngC7heIbVenSdDpZK3fTDDrb3gclAFaQVgT4/XeAFdV9FTLDAfmxue9RW4SsuF
         WL9w825v4yZ778qEYLpEtTRWEWjJ+xyDwcx2asjofV/LKQ6jPSSwznHcICXJJF/g2/u+
         MFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hgFkwjcJJLaBU8nE16Qln3qRxVwMomFvhqvRMqMhxus=;
        b=V9UMVbwGmBWz6j5xQOq22kGNSNv7f57cxzSPxJN8/T7iZNSDSpvv4opInCe5GOSOOE
         BShP/7tFnyKUIub86D/0BMUZtUHLIuaxWNMEmuBBh6YqpDvWAJbDtwEhnPK9hyd/yMCi
         tNiwoAdYgB10TsJ7m7a3podU/5rCX8r1qUCGTOXY5cdxLM1oF2P7mZPA3xjsUgaABH3v
         FvRTt3+RYqJ1N0aTAbnDua0HptfpQca/tcdcDpsu/rpYVIySKHrJNavKa9BK0/YS847V
         l3PPqeJHm6lz/ErljCgbW48JC+oMDBOffzMRnP3uhWxd0p2AxazeKwOuR8hN0JWKGYh/
         lMdQ==
X-Gm-Message-State: AOAM530FF+oRsSR9TQXbIe2LdKxkG3NN1S0ajre5svuPJLXD9vyYlklZ
        uyKLfWzcTJuab4OD5LAtyGs=
X-Google-Smtp-Source: ABdhPJxFMG6f3Z2+GzabkVyxw4VJ2lLHLZe9Kju99XOI6Hwte4u8nWkaB4fobXTkSEqEh90G5LyKbw==
X-Received: by 2002:a05:6402:31f3:: with SMTP id dy19mr16673100edb.153.1623674311770;
        Mon, 14 Jun 2021 05:38:31 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id f6sm7157965eja.108.2021.06.14.05.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 05:38:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v2 net-next 2/3] net: phy: nxp-c45-tja11xx: fix potential RX timestamp wraparound
Date:   Mon, 14 Jun 2021 15:38:14 +0300
Message-Id: <20210614123815.443467-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210614123815.443467-1-olteanv@gmail.com>
References: <20210614123815.443467-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The reconstruction procedure for partial timestamps reads the current
PTP time and fills in the low 2 bits of the second portion, as well as
the nanoseconds portion, from the actual hardware packet timestamp.
Critically, the reconstruction procedure works because it assumes that
the current PTP time is strictly larger than the hardware timestamp was:
it detects a 2-bit wraparound of the 'seconds' portion by checking whether
the 'seconds' portion of the partial hardware timestamp is larger than
the 'seconds' portion of the current time. That can only happen if the
hardware timestamp was captured by the PHY during the last phase of a
'modulo 4 seconds' interval, and the current PTP time was read by the
driver during the initial phase of the next 'modulo 4 seconds' interval.

The partial RX timestamps are added to priv->rx_queue in
nxp_c45_rxtstamp() and they are processed potentially in parallel by the
aux worker thread in nxp_c45_do_aux_work(). This means that it is
possible for nxp_c45_do_aux_work() to process more than one RX timestamp
during the same schedule.

There is one premature optimization that will cause issues: for RX
timestamping, the driver reads the current time only once, and it uses
that to reconstruct all PTP RX timestamps in the queue. For the second
and later timestamps, this will be an issue if we are processing two RX
timestamps which are to the left and to the right, respectively, of a
4-bit wraparound of the 'seconds' portion of the PTP time, and the
current PTP time is also pre-wraparound.

 0.000000000        4.000000000        8.000000000        12.000000000
 |..................|..................|..................|............>
                 ^ ^ ^ ^                                            time
                 | | | |
                 | | | process hwts 1 and hwts 2
                 | | |
                 | | hwts 2
                 | |
                 | read current PTP time
                 |
                 hwts 1

What will happen in that case is that hwts 2 (post-wraparound) will use
a stale current PTP time that is pre-wraparound.
But nxp_c45_reconstruct_ts will not detect this condition, because it is
not coded up for it, so it will reconstruct hwts 2 with a current time
from the previous 4 second interval (i.e. 0.something instead of
4.something).

This is solvable by making sure that the full 64-bit current time is
always read after the PHY has taken the partial RX timestamp. We do this
by reading the current PTP time for every timestamp in the RX queue.

Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 902fe1aa7782..118b393b1cbb 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -427,8 +427,8 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 		nxp_c45_process_txts(priv, &hwts);
 	}
 
-	nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);
 	while ((skb = skb_dequeue(&priv->rx_queue)) != NULL) {
+		nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);
 		ts_raw = __be32_to_cpu(NXP_C45_SKB_CB(skb)->header->reserved2);
 		hwts.sec = ts_raw >> 30;
 		hwts.nsec = ts_raw & GENMASK(29, 0);
-- 
2.25.1

