Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748502ED3A2
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 16:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbhAGPi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 10:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbhAGPiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 10:38:25 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF3BC0612F9
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 07:37:44 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id x16so10254167ejj.7
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 07:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TCxzvGRbgdBxPdypTtsZODIieRrBvW9w1PjIUGFgh4s=;
        b=SrOZv+6LIg/ixcfcApkTH5OzAfSh6ZTkvHE/1kxjx9F7LN81bNgVuvf+JXJz0idtBU
         KIbK0FidQYAYiFL0A5K3soelgBugdj8bW8aUOg3vUWQ39AJSJETZB3F0WMNxXq9/8EHa
         Fi9vkVfVDC5b9kpUQHh+UU7hOChzD8ETAVFckZkuOFXBe9xL5dIfvEHpxidgMRc7X2cq
         rQnNSRmermRWA94FDIJpAQfoKlEQjDWvngmn2GpOKaKkkuQZtgE7XWCUfSMb6jovJCDX
         EGEMU93yFnwegmQ9CRJK3kZ4J9wsycoYSAN7fc7Hw1N7cE581zyanpQxt7dG0xPkivME
         vkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TCxzvGRbgdBxPdypTtsZODIieRrBvW9w1PjIUGFgh4s=;
        b=FOWHdxb59iOPC8XUiRO+LMNqcToRLU8JGvzApOaAnvxhI5PEvhICVKOcj8A2z027R7
         7uSXfu9QcYEAn6dCPJ95pd+pGhpzUz1xOHtfvYpr2ct73HDF3A7GCPnHnGonFpUxHxTh
         xEvT5EgXSQpgxFTYjIo3cKoFminhbXmP9FArAOuewZJPaxqGLnLBi8cBCXZYYMrCj6zF
         8wK1LEJZFd/jMD9pPO2x+ABobMYLEj9bDCYipQKKcXexLm1GCFD6ERQfVvmxZTrHshsT
         Sb+LGtZYP8F6wb9PdBUUK6VkgqcoUlPeQ7fGxFq4yGZU7fYjSepKXvwtJjPbslDxIuuY
         oT+Q==
X-Gm-Message-State: AOAM532WLBPxF+I9/CwlLFdeEXvgjQDTkm4dBe2c0TmN2YP86xbI0HCd
        VGPElMIh+xn2HsAmq1pS6mc=
X-Google-Smtp-Source: ABdhPJwBSI/UQ9yk55R06dia0e+2Z4+kPPd/9wpFULAHmfB79J5cyEXuadpzQTwM1aISYyN06OjXIA==
X-Received: by 2002:a17:906:3513:: with SMTP id r19mr6559246eja.445.1610033863543;
        Thu, 07 Jan 2021 07:37:43 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z9sm2574898eju.123.2021.01.07.07.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 07:37:43 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 3/6] bus: fsl-mc: return -EPROBE_DEFER when a device is not yet discovered
Date:   Thu,  7 Jan 2021 17:36:35 +0200
Message-Id: <20210107153638.753942-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107153638.753942-1-ciorneiioana@gmail.com>
References: <20210107153638.753942-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The fsl_mc_get_endpoint() should return a pointer to the connected
fsl_mc device, if there is one. By interrogating the MC firmware, we
know if there is an endpoint or not so when the endpoint device is
actually searched on the fsl-mc bus and not found we are hitting the
case in which the device has not been yet discovered by the bus.

Return -EPROBE_DEFER so that callers can differentiate this case.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 34811db074b7..28d5da1c011c 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -936,6 +936,15 @@ struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev)
 	endpoint_desc.id = endpoint2.id;
 	endpoint = fsl_mc_device_lookup(&endpoint_desc, mc_bus_dev);
 
+	/*
+	 * We know that the device has an endpoint because we verified by
+	 * interrogating the firmware. This is the case when the device was not
+	 * yet discovered by the fsl-mc bus, thus the lookup returned NULL.
+	 * Differentiate this case by returning EPROBE_DEFER.
+	 */
+	if (!endpoint)
+		return ERR_PTR(-EPROBE_DEFER);
+
 	return endpoint;
 }
 EXPORT_SYMBOL_GPL(fsl_mc_get_endpoint);
-- 
2.29.2

