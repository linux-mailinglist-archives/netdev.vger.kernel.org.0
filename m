Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03552363040
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 15:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbhDQNYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 09:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236313AbhDQNYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 09:24:13 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DF5C061574;
        Sat, 17 Apr 2021 06:23:46 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id f15so21647476iob.5;
        Sat, 17 Apr 2021 06:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R0yqZql1vKkxThXF3GXg2OlgKCVAh2PdzD5jZt7wsq4=;
        b=fIeYTmsrYBi4Jr0kbAS6isiYz0oBI9TzHRhNlr+mjdAMckX3UfJorwWdcMfklKXNe5
         TpU5JvoUCmY9/qKJ9CBGCflC7kjWeA0jRHph4rodcbJT2nfFE0yQjPjoO+xrUO0aceQu
         Q7EAqmmt+tBGMBvZlZ47wFkPdbXfYy2qISzN3yyGvYAvPPkp8aQmHTR+HB50dq4zD3Xb
         pzidpofY51yH7wwHTD/kYiV2c6oIVB/C27D8Sn4Z9uL+op+g6PZl1NiM4OaMve/6rzRc
         RQ8n0CBvChQMQNlTAifFAwk9kDSuTuq3cunD6RSdsRK3Lfpr5Hl3ucHM8bRSYo2v2WKT
         Gx5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R0yqZql1vKkxThXF3GXg2OlgKCVAh2PdzD5jZt7wsq4=;
        b=MTMaZs3fw44CoIo7gQcC/YZwpDIcPAaFLVew7Sad4U6LhuHiFnDlkrZ/iM9inHE4R7
         XzJUP5gejz6Jzl+UNCSfHDckpxQQBHiTS8I1UVSktZPwaiOwGFkrEH0EKoJslMArVvt+
         EBy0/lE6u4tZmcYPmRNAP9olklTLiCm3JdgiEFLX3fN4shM4V4FDyH7N96UTPOgsgvio
         7soC0BN+wEOt5+Z7uVuCMtokN+IS50sW0Iu+KyqOKwO+PhWyxLYrUZJyQcHtAY0Ax56v
         BiEIN4pkTQocoTJcjWnJHYLdeNqg+o3tOpLnCKz2tTuty1fvKQNzGxEXwHpPZJBnUWK+
         WcEg==
X-Gm-Message-State: AOAM532j+6BixkQOOBkd4bh0fT7WkSkYwjXw+Q1mWdI2Du30N036VIAG
        3OAzm+z1F/m2hnF9IE/EgKd6AuVUCpHkAw==
X-Google-Smtp-Source: ABdhPJyi/F3ASPZBK4nvb6CbGDWNsUg83cjk8DtdA9WOg40MWvuMfVxwLjQL1Tw5PyqBkTPdoBrDwQ==
X-Received: by 2002:a02:c912:: with SMTP id t18mr8390142jao.100.1618665824897;
        Sat, 17 Apr 2021 06:23:44 -0700 (PDT)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:fad6:9931:94b:38ee])
        by smtp.gmail.com with ESMTPSA id f4sm2523723ioh.41.2021.04.17.06.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 06:23:44 -0700 (PDT)
From:   Adam Ford <aford173@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, geert@linux-m68k.org,
        Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: ravb: Fix release of refclk
Date:   Sat, 17 Apr 2021 08:23:29 -0500
Message-Id: <20210417132329.6886-1-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call to clk_disable_unprepare() can happen before priv is
initialized. This means moving clk_disable_unprepare out of
out_release into a new label.

Fixes: 8ef7adc6beb2("net: ethernet: ravb: Enable optional refclk")
Signed-off-by: Adam Ford <aford173@gmail.com>

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 8c84c40ab9a0..64a545c98ff2 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2173,7 +2173,7 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Set GTI value */
 	error = ravb_set_gti(ndev);
 	if (error)
-		goto out_release;
+		goto out_unprepare_refclk;
 
 	/* Request GTI loading */
 	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
@@ -2192,7 +2192,7 @@ static int ravb_probe(struct platform_device *pdev)
 			"Cannot allocate desc base address table (size %d bytes)\n",
 			priv->desc_bat_size);
 		error = -ENOMEM;
-		goto out_release;
+		goto out_unprepare_refclk;
 	}
 	for (q = RAVB_BE; q < DBAT_ENTRY_NUM; q++)
 		priv->desc_bat[q].die_dt = DT_EOS;
@@ -2252,8 +2252,9 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Stop PTP Clock driver */
 	if (chip_id != RCAR_GEN2)
 		ravb_ptp_stop(ndev);
-out_release:
+out_unprepare_refclk:
 	clk_disable_unprepare(priv->refclk);
+out_release:
 	free_netdev(ndev);
 
 	pm_runtime_put(&pdev->dev);
-- 
2.25.1

