Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8865652DE88
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244766AbiESUkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244712AbiESUkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:40:23 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE75985A8;
        Thu, 19 May 2022 13:40:21 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id e4so7014462ljb.13;
        Thu, 19 May 2022 13:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BgKHPZFZkX1keDz+vV/kymxRnGTruz8H3lBNU7pTNfs=;
        b=ovnqcE0VKz1g7pMzW4VX9VXubz8TXRJvpEolR0D3INYtMPHJDsg1adbQPWIk5ughAU
         28bi6qaedeapoSsE9Vv/Xf6hV9ZV3UILP/+oV0gmFwWW0tvPbvHow6ld3Wo1PhebSyzh
         Wr6KsAK5T2PpC+RqFHnMDMrG/RFMXBz3X1cdiAcHRgK/79tjQtwHbgOWnG6BS105mHDZ
         3qTtZS+OzgGO0Jo6Af6nchndv91MkyhuHpeHIxJPf2VCLjQyskXM4cBKfWWnMJyIj4sZ
         mekBtnr0vkKhn9gaft1gZ93D331pk3444aeWbsFjRZLWbPagavYOO/paUt7uwPEFYUIn
         gpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BgKHPZFZkX1keDz+vV/kymxRnGTruz8H3lBNU7pTNfs=;
        b=ZJwvWLk0fHAhHXEjGzA1LE7YSdIFMxwrkPGAeFz0oXuiCSkQcRufBcaMWtXVdPDxH+
         Rqz0vTFwDGBvHY66px1SidaH6U27NDTaUXYZ0uNd9pBpTqa/hTJE7f2Nx/O4zaKqtP2d
         XmvzS4Yrz9PPp085AyC6PA+0ciyShzYBtKStDhLocFn1OJJHenYxtSWks84nYbVo8JNA
         C/qyQNMUbm/Mv9g4iBvX9WHjhNCD9jlIs2no1I8iISJs5gsWUYJ/Ry+7LOSrDQChB09t
         zjGjDh3IXaP+w1e2I2bdSVJnQyndxNUQ55CYJN/cteZ5WgmJ0CEb5QINiX3+T+KqjB+u
         AyKQ==
X-Gm-Message-State: AOAM530i2RHsfTtwMwiLRpuK+qQh9UfGtekQ5bMyNucEfPRvAYi4Ir8q
        in9LJW4loccm/ZtUCjPD5S0=
X-Google-Smtp-Source: ABdhPJyMl05hAqXLfEDskvA2Jercr6evZtF13mcYnrmx+6Gca9Kg6RTBkG7TDoEJCiNl4iYXbqwPHg==
X-Received: by 2002:a2e:a801:0:b0:24a:ff0b:ae7a with SMTP id l1-20020a2ea801000000b0024aff0bae7amr3544106ljq.287.1652992819964;
        Thu, 19 May 2022 13:40:19 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.4])
        by smtp.gmail.com with ESMTPSA id b9-20020a056512024900b0047255d21148sm394048lfo.119.2022.05.19.13.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 13:40:19 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: ocelot: fix wront time_after usage
Date:   Thu, 19 May 2022 23:40:17 +0300
Message-Id: <20220519204017.15586-1-paskripkin@gmail.com>
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
while (timer_after(jiffies...)).

It looks like typo, because likely this while loop will finish after 1st
iteration, because time_after() returns true when 1st argument _is after_
2nd one.

Fix it by negating time_after return value inside while loops statement

Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot_fdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
index dffa597bffe6..4500fed3ce5c 100644
--- a/drivers/net/ethernet/mscc/ocelot_fdma.c
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
@@ -104,7 +104,7 @@ static int ocelot_fdma_wait_chan_safe(struct ocelot *ocelot, int chan)
 		safe = ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
 		if (safe & BIT(chan))
 			return 0;
-	} while (time_after(jiffies, timeout));
+	} while (!time_after(jiffies, timeout));
 
 	return -ETIMEDOUT;
 }
-- 
2.36.1

