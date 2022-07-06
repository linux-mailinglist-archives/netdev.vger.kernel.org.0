Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D8856861F
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiGFKuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiGFKuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:50:50 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFD6240A3;
        Wed,  6 Jul 2022 03:50:49 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id i18so25218789lfu.8;
        Wed, 06 Jul 2022 03:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+q827ZniPXycxKLiM0xPTvpKaI1JDTtDjXCsRL3qZQ=;
        b=gT714tFHkXoTKMfbUpgxKkW2K2oYW4ONVyvMufPlhqJsrJd2NYI7eGtvOq3XgGn8MY
         YMAqMtOP9H18zowv26OC9D0u/yR/8qsE8HbCu1Q/EkauLM6UlW6iZvjsW3utodTU/hwS
         hO62kLvaquWMMTigi14HG1C5yOaDWs8yZRwRBqZBrBVg+dpcR4rS/f79WNZyj9C/H52U
         e/npQzHqmVmberjrmYkiXkyBpXaO7vw7NGPc76YGu57yDFtziKOzEJs4slM/hjyZnbPa
         Poxv7bBmGeU+qFQVZZJjzcQzm02CwYgCbksFT5sQRBe3DgkIcGGHQHQdMA7xJ2RiBa7I
         jV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+q827ZniPXycxKLiM0xPTvpKaI1JDTtDjXCsRL3qZQ=;
        b=mW0DD2irnHpET4FzM6HG3L6MKWhuxJVzHLQfBf3rLWC+TDDl2HLQVLMs0MLTKLvzZQ
         6Hg2JraRuMvtV3oWcF60QP7gFWMzTb0GH13Mxe4e/RaR9lXZgfyOXht7lnpwHt9eYf7y
         jktHCSwExI/JnNXR0jS4hEejiCJ8Fr567SWJ5QB8H/bRm4zKHLG52Hou7LpJukSl+dmz
         raXyL1S1XdMilnDyzgeHmzeg/VdWpz3a0WOB0rOsPzzpwUf5xi/gsiiIxe991YYeCRgw
         484GpxKnK4RykbgczE8AzXaybIACA/gEESt+dLwJbfGFI4C1Tbfh81DWKiCrtiNfJnJr
         Hxcw==
X-Gm-Message-State: AJIora/mqShfNQp6xr9GpeMwxtWqDzQH7SofAt2jZvELY7CKtPLtg+Py
        iuvrodTvd36bYobk1UpR4WU=
X-Google-Smtp-Source: AGRyM1t3BP1zL2SviM6NZwsEF2DrMu5o2khwV2zQFTx8V3ANhcBijGqTTLavEM7tcWOFReHlcu2Mgg==
X-Received: by 2002:a05:6512:a96:b0:485:6bfa:e346 with SMTP id m22-20020a0565120a9600b004856bfae346mr2760031lfu.52.1657104648054;
        Wed, 06 Jul 2022 03:50:48 -0700 (PDT)
Received: from fedora.. ([46.235.67.63])
        by smtp.gmail.com with ESMTPSA id q17-20020a0565123a9100b0047f70a14c95sm6219403lfu.42.2022.07.06.03.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 03:50:47 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     clement.leger@bootlin.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3] net: ocelot: fix wrong time_after usage
Date:   Wed,  6 Jul 2022 13:50:44 +0300
Message-Id: <20220706105044.8071-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Accidentally noticed, that this driver is the only user of
while (time_after(jiffies...)).

It looks like typo, because likely this while loop will finish after 1st
iteration, because time_after() returns true when 1st argument _is after_
2nd one.

There is one possible problem with this poll loop: the scheduler could put
the thread to sleep, and it does not get woken up for
OCELOT_FDMA_CH_SAFE_TIMEOUT_US. During that time, the hardware has done
its thing, but you exit the while loop and return -ETIMEDOUT.

Fix it by using sane poll API that avoids all problems described above

Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes since v2:
	- Use _atomic variant of readx_poll_timeout

Changes since v1:
	- Fixed typos in title and commit message
	- Remove while loop and use readx_poll_timeout as suggested by
	  Andrew

---
 drivers/net/ethernet/mscc/ocelot_fdma.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
index 083fddd263ec..c93fba0a2a7d 100644
--- a/drivers/net/ethernet/mscc/ocelot_fdma.c
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
@@ -94,19 +94,18 @@ static void ocelot_fdma_activate_chan(struct ocelot *ocelot, dma_addr_t dma,
 	ocelot_fdma_writel(ocelot, MSCC_FDMA_CH_ACTIVATE, BIT(chan));
 }
 
+static u32 ocelot_fdma_read_ch_safe(struct ocelot *ocelot)
+{
+	return ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
+}
+
 static int ocelot_fdma_wait_chan_safe(struct ocelot *ocelot, int chan)
 {
-	unsigned long timeout;
 	u32 safe;
 
-	timeout = jiffies + usecs_to_jiffies(OCELOT_FDMA_CH_SAFE_TIMEOUT_US);
-	do {
-		safe = ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
-		if (safe & BIT(chan))
-			return 0;
-	} while (time_after(jiffies, timeout));
-
-	return -ETIMEDOUT;
+	return readx_poll_timeout_atomic(ocelot_fdma_read_ch_safe, ocelot, safe,
+				  safe & BIT(chan), 0,
+				  OCELOT_FDMA_CH_SAFE_TIMEOUT_US);
 }
 
 static void ocelot_fdma_dcb_set_data(struct ocelot_fdma_dcb *dcb,
-- 
2.35.1

