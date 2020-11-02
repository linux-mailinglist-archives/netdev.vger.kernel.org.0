Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614E02A3256
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgKBRyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgKBRyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:54:09 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C39C061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 09:54:09 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id q1so13731097ilt.6
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 09:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2yVM2+cSsEC1ByDwnNPBPLtup/RwymccxagL8bfkbms=;
        b=liY9yaQoXgmxGExwxwR7G24/uux6kd/yUeR+y82X18MFNIwOEzWDscNUWmx0wdHJMr
         SMg8XqP2tIi/4xEDOVcMdIRBBDfY3HheYvGh1mcY5JwxuyP7uc9TIqu8GLLuZGQrhL8K
         lX43UkiqjibTG5TYpdpnQVPI54c7/LKAfSp/p68hg9Hxg5ymW1eQ3QudwYnBIH8W3JN7
         dyYtPlIyxT9orhkMqbUHt4iVV9+wuJzAAqMQTrFkzykmdzAGewIeCECKBIqwDbigwGrH
         ySeEbJeFtqjbPjRpwlgnVmJYgu5YAxc3t48mE2dH4miBv+F72CthNvAqeNK9eT/85Bzz
         1DvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2yVM2+cSsEC1ByDwnNPBPLtup/RwymccxagL8bfkbms=;
        b=ZFNz14v7DVns5ajnhYzM6Jgtl5U45pwVXUWJRCxx9XBqoZ8EvHX7jgveG4CjPDVqZH
         omgItGqIqCAkJUxRETVSLU/uOeL+PRG1tGevOjQScXYZw0fHjAVG0+0ufo0vAxoOaoju
         JmWvPLeMsATqKX6/FIU1Go/elVUI0bJfb6NY9013Jt6BcCDea7MC3heKvMRGTldviTan
         yKeEHaSKP3hTlXVZQRiDl+2+wdu2KrOpKulT1B196LtF76j6FP6uaNjquz0e7OJGKdn+
         QTeaXZOMTPpbZCCn0G9crJB++s74KNaUD8n4Uq4NVxmAu4l/0pdTH+CxDR+s76PNHqKQ
         9rgw==
X-Gm-Message-State: AOAM532JMRu7YreNQmQlwLgvlcI+mCf85Y1ENPzE3SIZneKyc7EI1M6z
        ofMRkG7NeEvhvAVu+BCbywNNzg==
X-Google-Smtp-Source: ABdhPJzUF9WSsk8ngQVb45lMN20lGBuz3G6eQQq/up+SA4DbYAVGC/t/5NrONH++nf8ZMiXhLgoQjA==
X-Received: by 2002:a92:da92:: with SMTP id u18mr11971550iln.266.1604339648566;
        Mon, 02 Nov 2020 09:54:08 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r4sm11089591ilj.43.2020.11.02.09.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 09:54:07 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: use version in gsi_channel_init()
Date:   Mon,  2 Nov 2020 11:53:57 -0600
Message-Id: <20201102175400.6282-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201102175400.6282-1-elder@linaro.org>
References: <20201102175400.6282-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A quirk of IPA v4.2 requires the AP to allocate the GSI channels
that are owned by the modem.

Rather than pass a flag argument to gsi_channel_init(), use the
IPA version directly in that function to determine whether modem
channels need to be allocated.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 178d6ec2699eb..eae8ed83c1004 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1894,12 +1894,15 @@ static void gsi_channel_exit_one(struct gsi_channel *channel)
 
 /* Init function for channels */
 static int gsi_channel_init(struct gsi *gsi, u32 count,
-			    const struct ipa_gsi_endpoint_data *data,
-			    bool modem_alloc)
+			    const struct ipa_gsi_endpoint_data *data)
 {
+	bool modem_alloc;
 	int ret = 0;
 	u32 i;
 
+	/* IPA v4.2 requires the AP to allocate channels for the modem */
+	modem_alloc = gsi->version == IPA_VERSION_4_2;
+
 	gsi_evt_ring_init(gsi);
 
 	/* The endpoint data array is indexed by endpoint name */
@@ -1961,14 +1964,10 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 	struct resource *res;
 	resource_size_t size;
 	unsigned int irq;
-	bool modem_alloc;
 	int ret;
 
 	gsi_validate_build();
 
-	/* IPA v4.2 requires the AP to allocate channels for the modem */
-	modem_alloc = version == IPA_VERSION_4_2;
-
 	gsi->dev = dev;
 	gsi->version = version;
 
@@ -2014,7 +2013,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 		goto err_free_irq;
 	}
 
-	ret = gsi_channel_init(gsi, count, data, modem_alloc);
+	ret = gsi_channel_init(gsi, count, data);
 	if (ret)
 		goto err_iounmap;
 
-- 
2.20.1

