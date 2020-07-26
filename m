Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B774A22E354
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 01:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgGZXe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 19:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgGZXe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 19:34:58 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2D5C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 16:34:58 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id b25so15255189ljp.6
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 16:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0NGy/9klYfszmbekc26ZLsPZ67iMjoQFTEnntnN7sDw=;
        b=oxzlIgENYFcYEpBd6AK3b87691hiV5Nvedr6ayi7wOf62xXA7zkiDEB6LrDy4Y1ZHJ
         ITgYYBSaM22ZAOqpFbJ8TmfAvucTqgTlRSjeFrXkfSP2zyoRqFtiH6kNW18snwk73nj4
         vxd00uvd3TT+ojAt8lXE/FmeArq3pUxConVy9aDGzCcvWhAk8GuNlFmrY04+FSRB5pRT
         WKRkmWbR4Sy/hUIf26CHyA44hF/TGpB9D/6tHDWEeVj5WJVq1cqJgjWPKxB1g3uKUR74
         7UZ5h82j1sbGETMXy6OCmK8j/J87PGIxHwmpBw0P/wKHPZIPSjzm1AJiEvmVkOXEDPlZ
         ND8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0NGy/9klYfszmbekc26ZLsPZ67iMjoQFTEnntnN7sDw=;
        b=bFxMnKEt4qrsS3ll72g5GbWSzNIxvqEAWdNq5gQj6tRQEyWug2DLfwxK7vdAe+y1Lh
         EnUsYefeXfTOeS92TrTLvYfS5hlWE4un9OoZaSuSfBV2ccvT4mNRf+wc6qAXm9oiCkh0
         GS149x1YLEEAIqYnCHGbrBw3mQNPS+uM3Ziy1DLtY/oFzaazFTKLhoU7uZPH9n96V76k
         l2z6PqzihjEKLPCB+AL0tGnwoB+GtB6abm/syepyX1xV035nCbvBP03SV1eh8qpctWzX
         nRh40Cf+rDKtSMUsorCDaua5LdoMNo1NrUvLOZZa7RGJ7DoIO5D6Mko7gH40ZusNvhKH
         t36Q==
X-Gm-Message-State: AOAM5326vxzdi6XPDucv3ll1u8IJyK3XVU31yEi2v/lOLMgVVgN0KMSj
        nNh7cudBLz6zmN48Po5f5smKvQ==
X-Google-Smtp-Source: ABdhPJx8SYcePoJF0x/lC3zBf78M++V5OcaR1py5OS525vFx0Wpi8uKRPtBKJ99JRRHAMrg9DAVZhQ==
X-Received: by 2002:a2e:9ed8:: with SMTP id h24mr8579896ljk.126.1595806496622;
        Sun, 26 Jul 2020 16:34:56 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id v25sm2028605ljg.95.2020.07.26.16.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 16:34:55 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 2/2 v2] net: dsa: rtl8366: Fix VLAN set-up
Date:   Mon, 27 Jul 2020 01:34:40 +0200
Message-Id: <20200726233440.374390-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200726233440.374390-1-linus.walleij@linaro.org>
References: <20200726233440.374390-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alter the rtl8366_vlan_add() to call rtl8366_set_vlan()
inside the loop that goes over all VIDs since we now
properly support calling that function more than once.
Augment the loop to postincrement as this is more
intuitive.

The loop moved past the last VID but called
rtl8366_set_vlan() with the port number instead of
the VID, assuming a 1-to-1 correspondence between
ports and VIDs. This was also a bug.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Collect Florian's Review-tag
---
 drivers/net/dsa/rtl8366.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 2997abeecc4a..8f40fbf70a82 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -397,7 +397,7 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		dev_err(smi->dev, "port is DSA or CPU port\n");
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		int pvid_val = 0;
 
 		dev_info(smi->dev, "add VLAN %04x\n", vid);
@@ -420,13 +420,13 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 			if (ret < 0)
 				return;
 		}
-	}
 
-	ret = rtl8366_set_vlan(smi, port, member, untag, 0);
-	if (ret)
-		dev_err(smi->dev,
-			"failed to set up VLAN %04x",
-			vid);
+		ret = rtl8366_set_vlan(smi, vid, member, untag, 0);
+		if (ret)
+			dev_err(smi->dev,
+				"failed to set up VLAN %04x",
+				vid);
+	}
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_add);
 
-- 
2.26.2

