Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A1E366D91
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243263AbhDUOFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbhDUOFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 10:05:49 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B25C06174A;
        Wed, 21 Apr 2021 07:05:16 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id b17so35010414ilh.6;
        Wed, 21 Apr 2021 07:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdeaFJmr4R41Y4E4yOhKBfoqcgTi2vEOzTdmvFZZ1W4=;
        b=RcoadoWUmxnJ5L8BlTXlGBhA4FNExzqGlIz7mByRLnBOKRZRwuRPCcrRUgNhrfX+1s
         noqMbB3gBPbwuPBGSsiy/XCeAR/VfWH5wb99GJ17BhnMt7lmylH8iplFm1HbPAhDNUYi
         hy+RpBYJqznTyBRWP6Z3cBbHNaWoNMC1bFlKe8m6lpbr/lMS7oNakgqos3vN1G3ji5QR
         /zebHGIxKxdjYQlgCUMlalJ0rz2ogiXQ1Z4SBjpGpQgspq5Glayg4HED9LkcTPmUkxVs
         VRRNxF0fuEBN5BmI+z0t/mI7Q2m2lAg1hgL5GePNn9TQqZm7XlIHBe7qWmjeZpybPI0q
         kPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdeaFJmr4R41Y4E4yOhKBfoqcgTi2vEOzTdmvFZZ1W4=;
        b=Zit1uBzex0+mOocrnntsSou4u1OVkvECesye4d3WiXz+cMX+a85Vzc3ejq5eX8BGxB
         GkjC32JUbv2nG1cKteZmjuO6hp4nNuDbefHsjl7BcnzomTV/0F2zVBVPCt4TBJsumAv4
         YGy0/yWHeCEDkjqwQfoIIbcA5YMQnGDSN8v/EoyjW4JP3DKBoDMrsKBcyo5V+7CD/8IC
         Q7Wx7Qb3f6Hf+8uDaVjLXhIuCwDsTPuO6sUzpxIfdecZFid6jJwW7hMEXtXVInSyo46r
         ThEqUqkBYmhg+qVWVMGOAiaDu+yszAOEhunfYxigBQoOnPv0ECT1gwa96r60goq1sdcu
         FJgw==
X-Gm-Message-State: AOAM530nAw1yvwVmHDlnp6XMhvVJ1UhacVOTTppcc9ggEFMgAyt75f74
        4bf6Cc59EMvYFJJE0t4kMNJjAtAMvtgh4A==
X-Google-Smtp-Source: ABdhPJwLodEVa6Czgm9eQIHN2PN0CF/mqTMydiUl0kBlWBvDLygFW2dpIfawdzmbN7hw6gtjwbmshw==
X-Received: by 2002:a92:d70c:: with SMTP id m12mr26807944iln.216.1619013915515;
        Wed, 21 Apr 2021 07:05:15 -0700 (PDT)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:1b3b:2123:669a:3ca8])
        by smtp.gmail.com with ESMTPSA id x8sm1133302iov.7.2021.04.21.07.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 07:05:14 -0700 (PDT)
From:   Adam Ford <aford173@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: ravb: Fix release of refclk
Date:   Wed, 21 Apr 2021 09:05:05 -0500
Message-Id: <20210421140505.30756-1-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call to clk_disable_unprepare() can happen before priv is
initialized. This means moving clk_disable_unprepare out of
out_release into a new label.

Fixes: 8ef7adc6beb2 ("net: ethernet: ravb: Enable optional refclk")
Signed-off-by: Adam Ford <aford173@gmail.com>
---
V2:  Rebase on net-next/master, fix fixes tag, change name of label
     from out_unprepare_refclk to out_disable_refclk

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 8c84c40ab9a0..9e5dad41cdc9 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2173,7 +2173,7 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Set GTI value */
 	error = ravb_set_gti(ndev);
 	if (error)
-		goto out_release;
+		goto out_disable_refclk;
 
 	/* Request GTI loading */
 	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
@@ -2192,7 +2192,7 @@ static int ravb_probe(struct platform_device *pdev)
 			"Cannot allocate desc base address table (size %d bytes)\n",
 			priv->desc_bat_size);
 		error = -ENOMEM;
-		goto out_release;
+		goto out_disable_refclk;
 	}
 	for (q = RAVB_BE; q < DBAT_ENTRY_NUM; q++)
 		priv->desc_bat[q].die_dt = DT_EOS;
@@ -2252,8 +2252,9 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Stop PTP Clock driver */
 	if (chip_id != RCAR_GEN2)
 		ravb_ptp_stop(ndev);
-out_release:
+out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
+out_release:
 	free_netdev(ndev);
 
 	pm_runtime_put(&pdev->dev);
-- 
2.25.1

