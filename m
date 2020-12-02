Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1496F2CC1F2
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389075AbgLBQRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389070AbgLBQRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:17:20 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6314C061A47
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 08:16:19 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id 64so4585767wra.11
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 08:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7cVseWE6MIn0vIOshUQxsts71GrP62tJMM0vJ2mEO6M=;
        b=JPMZDn1Q25wUvfxd5NHJUlgs/Y8PdFBXa/MVT0UhCfSDQfXICkj59GPnUm3wuozxG4
         UZ+ZjahG2yZHm8StlaVRYK+lgGj/uTSVF8EBVRoTLCOHYONUqktFbinfdcfvMPQXiXQB
         Fs/eqX57ZpU+WU2wHITndg3sXuIWc4YBUenchkoNPvGD2AAsu1/8l/FCFYUm9odgVGLB
         1AfmO8klAYMdu9+BdSrjmcI3CIVaAAT8apQZTdlJLyYB01vOUnvKTTP+/L78HE6DkqK5
         VI7i96lWnrmSvyHdZXoSxtRgLstxqO9zW0eXwVVgC98IXrcdCdAPPnBjWDYATo89qwDL
         4WbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7cVseWE6MIn0vIOshUQxsts71GrP62tJMM0vJ2mEO6M=;
        b=REI42lGmyeOfqT6RUe85wMaAZ6p1pmNF/e82wWId13HOiC14rp4A5Eo42PnBHNhusC
         7OMti+sBeSmEu55tnERJ3S7mkTF9soWDjTktF33A+AcbeXC1gw3o7sCXAQK5VfUSWv3A
         N6dEYoNmQe9skOpYANDrVpN6rmOX8Qsws+9MWGCFZT6QFheuvaKIuZMwKiWok9kvczg3
         w30Oc+649K5Ubg0GUww53Sai4sUrW8KwvJ0NstB5PCcbIqsrwj8/gWUe3mSic2eHChGt
         TOr87szsT7g2t/QU5UBVrdxhv3X4ohZ6QvTElXRIbMgEldpNUHktrR4ASasWuzQnevI4
         qjkw==
X-Gm-Message-State: AOAM531Y0jSoF9gHoaaDqpfCwDtPf/WOzm8cWNWNO9YUpRhSlZ6PoLCo
        bzMEOTNsueUgHNdeKZgfcJUgLpkAq41V+Q==
X-Google-Smtp-Source: ABdhPJwSjZL1OPGRCTWiQOlBQXtYSorpd0ICSpOhAQ4VJl5WT02dgUIr5pavqow6fS4l9GahL/u1/Q==
X-Received: by 2002:adf:e44d:: with SMTP id t13mr4422657wrm.144.1606925778652;
        Wed, 02 Dec 2020 08:16:18 -0800 (PST)
Received: from belels006.local.ess-mail.com (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id s4sm2644505wru.56.2020.12.02.08.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 08:16:17 -0800 (PST)
From:   Patrick Havelange <patrick.havelange@essensium.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Patrick Havelange <patrick.havelange@essensium.com>
Subject: [PATCH 3/4] net: freescale/fman-mac: remove direct use of __devm_request_region
Date:   Wed,  2 Dec 2020 17:15:59 +0100
Message-Id: <20201202161600.23738-3-patrick.havelange@essensium.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201202161600.23738-1-patrick.havelange@essensium.com>
References: <20201202161600.23738-1-patrick.havelange@essensium.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the main fman driver is no longer reserving the complete fman
memory region, it is no longer needed to use a custom call to
__devm_request_region, so replace it with devm_request_mem_region

Signed-off-by: Patrick Havelange <patrick.havelange@essensium.com>
---
 drivers/net/ethernet/freescale/fman/mac.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 901749a7a318..35ca33335aed 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -690,12 +690,10 @@ static int mac_probe(struct platform_device *_of_dev)
 		goto _return_of_get_parent;
 	}
 
-	mac_dev->res = __devm_request_region(dev,
-					     fman_get_mem_region(priv->fman),
-					     res.start, resource_size(&res),
-					     "mac");
+	mac_dev->res = devm_request_mem_region(dev, res.start,
+					       resource_size(&res), "mac");
 	if (!mac_dev->res) {
-		dev_err(dev, "__devm_request_mem_region(mac) failed\n");
+		dev_err(dev, "devm_request_mem_region(mac) failed\n");
 		err = -EBUSY;
 		goto _return_of_get_parent;
 	}
-- 
2.17.1

