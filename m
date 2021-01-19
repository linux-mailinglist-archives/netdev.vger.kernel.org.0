Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C08D2FC485
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbhASXNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbhASXJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:09:05 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5645FC061794
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:14 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id r12so19536418ejb.9
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AIdParNk1Bd+j3i7SFF4oov2pJIQA2uNY8WMxLWwkdk=;
        b=hyJQA0r+zzltPJYPEQ0YL63EI78pyHxw377TE7yBPwWG0LtsElun1RNcN87n5GL0J8
         dJnz/dIUNLt3lT98XJYJnVZQc5Rxy6LdwMn/BDWx2oKdd/qupfnYgPGvDBBtzjkHcGnA
         J67t6ewuYb8Row2Y8uNtgwMJSOcG+XqOWJPyhgphwvvCNQsD6OqQzMaLWzXMQpgd7bw0
         GwRDG96tUKcNck2zALKNTJqKCCYwlB53Oypfm0pAF4dlE8IOejWP/gc5qP+ipsGuCClM
         B6D8kLTw31WzEggd9XRDZZ/qIdJrzbMYAhJ9iJPIR5WjmbuFG0pXJTPGTGh+fBO6oW8z
         yX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AIdParNk1Bd+j3i7SFF4oov2pJIQA2uNY8WMxLWwkdk=;
        b=Kg45LULrtNYY/aNisDrwZscF5djxYejvnwqMPfB2E4Ztenm2pNcpxfkEACPpO39Oek
         zTrUe5K3AUwgMTTY+FYqkR1c+heYu791/p8G5FfCnFg00526Vj5Vb1GZkE43sVZfa2hR
         h8ZqqeBvUmjMAJXrSEts5J4T449Sz0kev0o7TtrhaaGpZe4cg+KFixSSWl9Dw9hH02wx
         D43CQBhx0HuK83GETlP4UNWIgRnRtgy1qIVR5l1ZQX5jzYidBQLyzNLmk0l1sMIywmQj
         ijQ0a+XOxcJs2Qkj0D9WDqyh9MrGHBehlN1hpT9RTOfg6RQSU5IDmNv12ofNivYQJ8Go
         Rwxw==
X-Gm-Message-State: AOAM5334sEpQLpqB4WDa0ETImdW9kxd+oRMkUFTg+kv1RXYInnTpUeb7
        JhPDQJZfrYAuRpxJscUQEp+oZpunsCk=
X-Google-Smtp-Source: ABdhPJwn40Rk34gZTQDksygYLoN1ec1ympCxhMtnOkJx6LZZEGZzoYgfAlhwR/u1ZFPefmKn5IBm7Q==
X-Received: by 2002:a17:906:68d0:: with SMTP id y16mr4697136ejr.128.1611097693112;
        Tue, 19 Jan 2021 15:08:13 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:12 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 09/16] net: mscc: ocelot: only drain extraction queue on error
Date:   Wed, 20 Jan 2021 01:07:42 +0200
Message-Id: <20210119230749.1178874-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It appears that the intention of this snippet of code is to not exit
ocelot_xtr_irq_handler() while in the middle of extracting a frame.
The problem in extracting it word by word is that future extraction
attempts are really easy to get desynchronized, since the IRQ handler
assumes that the first 16 bytes are the IFH, which give further
information about the frame, such as frame length.

But during normal operation, "err" will not be 0, but 4, set from here:

		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
			if (err != 4)
				break;
		}

		if (err != 4)
			break;

In that case, draining the extraction queue is a no-op. So explicitly
make this code execute only on negative err.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 5140639910a6..49089a014dda 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -701,7 +701,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		dev->stats.rx_packets++;
 	}
 
-	if (err)
+	if (err < 0)
 		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
 			ocelot_read_rix(ocelot, QS_XTR_RD, grp);
 
-- 
2.25.1

