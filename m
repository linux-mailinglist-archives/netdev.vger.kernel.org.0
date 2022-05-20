Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431A752F525
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 23:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352082AbiETVbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 17:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiETVbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 17:31:24 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC116CA91;
        Fri, 20 May 2022 14:31:23 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id v9so1717799lja.12;
        Fri, 20 May 2022 14:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ArP+iLFbfbU7iI3ZFUMYd+mcaGbbogq4chB/Nd9xLc=;
        b=cEtIFS0FehIai+vyJ381oLLGRThutuTc6qikAo7tD0sdf5FD+3ag072+8O46yotM7e
         tBIpfvH+mS8pBIRUue3QX+sMkDudM7pUKmjzoM+DF/qCp9Xz3PDPPW4eW+I9+1o2SfP5
         mZ0Ruxr6r+MCz6iLH86BH6qFDf7E4q4LF2FneFkV1nnGVU6gMb8jVqxOyZW01QYydefi
         x9bmVt1rz4lwVlF23uBly+3cTcknNg4w5OD+jsZeEF6XEZxxQKeLe3GrI0eYsMJXcyAH
         ZRA5ulp0sSGUvcxpOVGIpmaUgXUu07A+lj331o0hjAaORNavu5yX6GyVfNLtdeovAecj
         et6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ArP+iLFbfbU7iI3ZFUMYd+mcaGbbogq4chB/Nd9xLc=;
        b=Lfi9VOJnFDIM0j0Mp0Qtr/6Il4SrZVGcZ35xRKdZ169eFCACqJOtvRL4p9Ef6WW1KM
         dqmliyfPYAZ//KA7iYvci/RAMdytK5KmJDbMlFEJEoeVHa+1kk3rVl0QeBUNy/h3MswT
         xxd9zVQ+9hHXptBlI00+T4Hxdlxu3krPcXIj+X5inAMCK+FUc6f/zrEwPf2E42I+Xrnq
         Jj7c1MNemmumGZXsitYExxDFlYiUqd0Gs7Rs9juqVqQMWO0eVp75IY7u3UKBZZQNHlyQ
         d6uTJLmuqSNRzbsBy2EO3xvmBthqR7caIKI6aqUocO6nPVIFOLQVHkS6XTu9sDTQj2DU
         e0fg==
X-Gm-Message-State: AOAM5316GuxgHya8X+SoYE/40+bpvdWVkvt9lAvnEz+GMzQlVlSrivgk
        GQCicq9kcsLVk0OjfYNVpo4=
X-Google-Smtp-Source: ABdhPJwC1buK1NeuZmzjXGf138VM+t9aUuv1h9c4NUzGtdYB0kUfhbJAWR7luB0FILwJ0MXxxELUuw==
X-Received: by 2002:a2e:824b:0:b0:24d:c247:c928 with SMTP id j11-20020a2e824b000000b0024dc247c928mr6561582ljh.68.1653082281536;
        Fri, 20 May 2022 14:31:21 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.4])
        by smtp.gmail.com with ESMTPSA id n22-20020a195516000000b0047255d21130sm793150lfe.95.2022.05.20.14.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 14:31:21 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, clement.leger@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2] net: ocelot: fix wrong time_after usage
Date:   Sat, 21 May 2022 00:31:15 +0300
Message-Id: <20220520213115.7832-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <YoeMW+/KGk8VpbED@lunn.ch>
References: <YoeMW+/KGk8VpbED@lunn.ch>
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

I can't say if 0 is a good choise for 5th readx_poll_timeout() argument,
so this patch is build-tested only.

Testing and suggestions are welcomed!

Changes since v1:
	- Fixed typos in title and commit message
	- Remove while loop and use readx_poll_timeout as suggested by
	  Andrew

---
 drivers/net/ethernet/mscc/ocelot_fdma.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
index dffa597bffe6..82abfa8394c8 100644
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
+	return readx_poll_timeout(ocelot_fdma_read_ch_safe, ocelot, safe,
+				  safe & BIT(chan), 0,
+				  OCELOT_FDMA_CH_SAFE_TIMEOUT_US);
 }
 
 static void ocelot_fdma_dcb_set_data(struct ocelot_fdma_dcb *dcb,
-- 
2.36.1

