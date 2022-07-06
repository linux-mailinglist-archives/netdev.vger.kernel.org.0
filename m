Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FDD568972
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbiGFN2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbiGFN2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:28:53 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCF81D324;
        Wed,  6 Jul 2022 06:28:52 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id y18so7604883ljj.6;
        Wed, 06 Jul 2022 06:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pNEUfwqlplOIfsxU8BPJxwIb+d3FuNgNfWoTeCpOydg=;
        b=PmNCrbN7c8HPxMFp+CQbVyc5YHM5VjvUmmJnN+UDExiG0SnTmUuE19ch1Bnauk6crH
         d2UADWJGRS0PhutnignyTGUtDKIzgLb2RqM0scFcV8jQUl9w7reI25ti5yipwvjqNPg2
         P4NBnDwqtIB8g10MlQQzOSe0zgbioSzVBjKSS4vOpUv5piYYxs0gZ2atgciXTmLRPuG6
         CNCemWzNZ5+NCvTLH8cB02kXwCaBawgrp9BaaLvDWkPpBj0ruMGz7ml4O2vK2s5ho7C1
         HtwLlnpMOmJqyWk/NhVDBYmMxu598k3j+Qj0goC5MQyBWTcQbta51KCb9OtQzNmuIdy/
         kdmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pNEUfwqlplOIfsxU8BPJxwIb+d3FuNgNfWoTeCpOydg=;
        b=X4C1X5FD1tWgfXKxsCGbeYpc8B+FVyn/CFsIo9OXYoXZ7hAjm/lqp8OS57ZMQ82VAO
         noPAuvtPg3mjZEqwdVCN5UcHCfKRJ43LVu0zlzjd3MUQ14t2AAenzXOpvZMHjs0A1aJ3
         2bPPRY9jZsQFfBw7uc/Uh7PBOIuploFv+K5l0+05UGfni22inm3qlFVADbT7uXMPmU6x
         tdFwG6cfgbH0V2rr6L8Kj1O9NPLUkfjma79KK2xmrGHyemP+xV70KRjeKvC90yqa3wrZ
         I3kiuNYCeWtAaMaBrvA0+wmtpAcsQkgDn1wOjsQqCGxy4qA9M42pgd5PQ84P0F7KKsCk
         eNTQ==
X-Gm-Message-State: AJIora8v1iBHmI328CyeeBZ9NVWOr1voZM/j8mB6dUBoq72qyCaiEEFu
        h8VS90awGZMkx30z4/2Zabs=
X-Google-Smtp-Source: AGRyM1uzHwsLtc7qLG2FlHbK/8tmuLefiJ6bqjdcr67nrW+FVY6/CnEGih4z0vHF3UztWuLySJIdbQ==
X-Received: by 2002:a2e:b8c2:0:b0:25b:6b0c:34e with SMTP id s2-20020a2eb8c2000000b0025b6b0c034emr14212226ljp.397.1657114130193;
        Wed, 06 Jul 2022 06:28:50 -0700 (PDT)
Received: from fedora.. ([46.235.67.63])
        by smtp.gmail.com with ESMTPSA id b17-20020a196711000000b004875a37b7b7sm105941lfc.159.2022.07.06.06.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 06:28:49 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     clement.leger@bootlin.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4] net: ocelot: fix wrong time_after usage
Date:   Wed,  6 Jul 2022 16:28:45 +0300
Message-Id: <20220706132845.27968-1-paskripkin@gmail.com>
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

Changes since v3:
	- Aligned the arguments to the open bracket

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
index 083fddd263ec..8e3894cf5f7c 100644
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
+					 safe & BIT(chan), 0,
+					 OCELOT_FDMA_CH_SAFE_TIMEOUT_US);
 }
 
 static void ocelot_fdma_dcb_set_data(struct ocelot_fdma_dcb *dcb,
-- 
2.36.1

