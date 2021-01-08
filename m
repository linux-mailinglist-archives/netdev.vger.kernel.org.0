Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB932EEF22
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbhAHJIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbhAHJIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:08:21 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F133BC0612F9
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:07:40 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id b9so13686878ejy.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z5d4Wq24eFSaaginkRNTjN0txnMxYO4bJxyMlTjODSA=;
        b=HEdHUPC2kQpJGQ0oYz5P+m2vPJx8FfDFps3HLZ80SaXbiupUm5XG11lwttdgfKKAV0
         1w2DPNhEeTornca95ODdVIgqlYCs3Kwo4eWQu3bq0LeE2KHm1EioGI5N703wjdFcryrc
         jQTHs/4hh8zbQ3F46c/G4WAeD8MKVgYmQJB4Rish1i6gFmMMVDRc3u6xePibMfTUCSne
         01GfD8aMncjfVOTfS42NYwRFePa/4D9FQfKdR/ty13RyAcvids+Rg/e0bDD4FCEbmzmu
         WHhAP5mb5vYIarPWIzASzuS/RSLNJewl6UZzmixIcyCkM0YAKUPkNqLIjh+4BghMTanP
         bLQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z5d4Wq24eFSaaginkRNTjN0txnMxYO4bJxyMlTjODSA=;
        b=H7qUEC6herizmFxIqJLuzhnG3cxAwMaZuZIQ2pcpc3YOBLnfdSAWEkYFl36lpmn/oX
         f/6GcPijz/2PS0zMlbr2GPetC9pwecxO86u8BCzAHvsrb1X87P1iFXIPGXDXLNtQwuzT
         bHFEZ2rOmolHQGAqGfB0cFEfV54/N4JpP01G4/QlgQ+pUcW1xDRi8I3k78uR0bqsG9dD
         OW05n7rwQGlUDkgCWUAh50dZcf/xYPdC6tDGvJpkf7egUXbfrV2HbovzT74d9VvbgjlL
         lFUWCPzAns6rSVE8ShRsVSvkp69ocYKqopDuP23JmPYXnmDMFWkyT4mqAX8w5CTLjNhY
         A5BA==
X-Gm-Message-State: AOAM531SPwxesM2NjtKBOKh7EZyAKHo7H5UoggQLUrH1mi1POqn1tXxe
        VSQfogdMFDp2LGzvStCJqUU=
X-Google-Smtp-Source: ABdhPJytTItuIDHASTqWfaysKULFaAqgJSw2+7+OleYMh5yf/Z78K8L5dOfMb3muDBTKfakdcRtnzg==
X-Received: by 2002:a17:907:435c:: with SMTP id oc20mr2130001ejb.286.1610096859700;
        Fri, 08 Jan 2021 01:07:39 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k16sm3307132ejd.78.2021.01.08.01.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 01:07:39 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 4/6] dpaa2-eth: retry the probe when the MAC is not yet discovered on the bus
Date:   Fri,  8 Jan 2021 11:07:25 +0200
Message-Id: <20210108090727.866283-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108090727.866283-1-ciorneiioana@gmail.com>
References: <20210108090727.866283-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The fsl_mc_get_endpoint() function now returns -EPROBE_DEFER when the
dpmac device was not yet discovered by the fsl-mc bus. When this
happens, pass the error code up so that we can retry the probe at a
later time.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - replaced IS_ERR_OR_NULL() by IS_ERR()

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f3f53e36aa00..a8c98869e484 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4042,7 +4042,11 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
 	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
 	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
-	if (IS_ERR_OR_NULL(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
+
+	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER)
+		return PTR_ERR(dpmac_dev);
+
+	if (IS_ERR(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
 		return 0;
 
 	mac = kzalloc(sizeof(struct dpaa2_mac), GFP_KERNEL);
-- 
2.29.2

