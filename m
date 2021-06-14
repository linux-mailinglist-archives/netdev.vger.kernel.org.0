Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987C33A6850
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhFNNsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:48:20 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:45823 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbhFNNsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:48:18 -0400
Received: by mail-ej1-f44.google.com with SMTP id k7so16774471ejv.12
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Ts50fnE/tCIfiSguG3xBKowkdguDptHLAm3c2fP9Co=;
        b=nIjW8I6R+5Vay5SzFHKqfjXFUSeVrzWNlHS/Y0DXiyDy6Rsuu2eANLevx7Lv1zC5p+
         vbLw2ow0FQx/Y4eFRJnBBSr9onOMV0KpwCLmSDKdKm7XzXLjKxMA2JXxruJLh8MHzDcG
         nkuQCc0ftnP1lH4nY72mQI3nD4WTnn8ovVQXTCjQpCAdxckILEyYYt4Xurob+eE71QHA
         rjczoRN7DSL7LEt4I4gqd8W110TSWVYB7hBo8FOVcUSToV2qKS/4YaWS/PHv/anVvU2a
         0UCUwlCDUR7YGAWhQWOJBwzqVtOnOvdS4t/LR/FqViYOYoTaX9JNoIts4HCuhNicbhx8
         NYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Ts50fnE/tCIfiSguG3xBKowkdguDptHLAm3c2fP9Co=;
        b=P4EwO8R1fbslERjY2OfNnUpuqqm5Cbv/vZiX+IZFuEgqaLn0UjJKvqRZ5SY6YPH/L/
         xfzXQquksY4LcXC4nwqb3s5tc9jgEUi+zXROKmWRkKnuvBI6BjRr0+jDwvaNnnRx/3Wp
         5iwkLEmn2h465G/JUJpNPpJ4PoZDMyDYbsAYNvlV65IrH7w1tmrlq0rzHThZCiowevy6
         JyeZqIjo/D1pN7ZfpCW5v+R4Iwg3IVWiUdGWdzoudP7UmAzdPMylBAlzvSWsnUCzscMW
         BEbATKLjsMoqtx2cfWyKNY0ssFB7NrQm9X7Fw0PauYHwYm6hKu0F12dJ9inD4aZNXPKV
         CbIA==
X-Gm-Message-State: AOAM532QebMwLci6aRrDzjJKxtih/AOp/FEZjhx95SCwSVG+b8KL3ya8
        QElqar1AKT5EvHAYPsYxG/Q=
X-Google-Smtp-Source: ABdhPJwqGtj5z44vZessRmIoRVaLjZZ7DgBqTrGEnXh8nZq9rFGDJm11Zrc6Hk/Uj6qXMjqg17yQvw==
X-Received: by 2002:a17:906:9883:: with SMTP id zc3mr15488410ejb.530.1623678301934;
        Mon, 14 Jun 2021 06:45:01 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id q20sm7626891ejb.71.2021.06.14.06.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 06:45:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v3 net-next 2/4] net: phy: nxp-c45-tja11xx: express timestamp wraparound interval in terms of TS_SEC_MASK
Date:   Mon, 14 Jun 2021 16:44:39 +0300
Message-Id: <20210614134441.497008-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210614134441.497008-1-olteanv@gmail.com>
References: <20210614134441.497008-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

nxp_c45_reconstruct_ts() takes a partial hardware timestamp in @hwts,
with 2 bits of the 'seconds' portion, and a full PTP time in @ts.

It patches in the lower bits of @hwts into @ts, and to ensure that the
reconstructed timestamp is correct, it checks whether the lower 2 bits
of @hwts are not in fact higher than the lower 2 bits of @ts. This is
not logically possible because, according to the calling convention, @ts
was collected later in time than @hwts, but due to two's complement
arithmetic it can actually happen, because the current PTP time might
have wrapped around between when @hwts was collected and when @ts was,
yielding the lower 2 bits of @ts smaller than those of @hwts.

To correct for that situation which is expected to happen under normal
conditions, the driver subtracts exactly one wraparound interval from
the reconstructed timestamp, since the upper bits of that need to
correspond to what the upper bits of @hwts were, not to what the upper
bits of @ts were.

Readers might be confused because the driver denotes the amount of bits
that the partial hardware timestamp has to offer as TS_SEC_MASK
(timestamp mask for seconds). But it subtracts a seemingly unrelated
BIT(2), which is in fact more subtle: if the hardware timestamp provides
2 bits of partial 'seconds' timestamp, then the wraparound interval is
2^2 == BIT(2).

But nonetheless, it is better to express the wraparound interval in
terms of a definition we already have, so replace BIT(2) with
1 + GENMASK(1, 0) which produces the same result but is clearer.

Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: Patch is new

 drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 902fe1aa7782..afdcd6772b1d 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -325,7 +325,7 @@ static void nxp_c45_reconstruct_ts(struct timespec64 *ts,
 {
 	ts->tv_nsec = hwts->nsec;
 	if ((ts->tv_sec & TS_SEC_MASK) < (hwts->sec & TS_SEC_MASK))
-		ts->tv_sec -= BIT(2);
+		ts->tv_sec -= TS_SEC_MASK + 1;
 	ts->tv_sec &= ~TS_SEC_MASK;
 	ts->tv_sec |= hwts->sec & TS_SEC_MASK;
 }
-- 
2.25.1

