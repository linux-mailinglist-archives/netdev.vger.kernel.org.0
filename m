Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BC731C3D1
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBOVzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhBOVzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 16:55:18 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851D6C061756
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:54:38 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id n14so8233279iog.3
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1EldVEtv82k+1DGG2yBJItkY1oY+VNbmcIspFv6IrKA=;
        b=CZ0VswQQw1iEfvcYnsFioiTTqHsghXWT72LXLlgEKfitDlrBqbrQETNf6oucUVVFSd
         ynQDa4qNtAlyxAekTcj9XKd/Bgq7vq+KEcBsJP8EkWsL5ouycovXYt620KV4089IvYou
         gBz5lsknQmTocX1ABmGGoE00XAhdY/IIavv+GCaHVI5+1YA3IkrlbqN+KEyGnEb791MT
         GmHVEJkRTXq98cKF20KnmeNSoMohWk+rA8/GeCXG+GNXI9fVCxhLlYvpRHkDMkpONNhz
         LhkHdNS26XYv2Y8lfLuwb3I6s3SeIKrrtzuSUppOxqR1Is1FSyJn66i2hu06QTiEl3vI
         gnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1EldVEtv82k+1DGG2yBJItkY1oY+VNbmcIspFv6IrKA=;
        b=Lkum2k6gZJYRgGIxwgNxQwfVHohFcVLuED/KkTSZjwelHfivfKM87AjT9BAn0QL7kG
         Lz6U1wOsBGGpNBtxtbywHB4hFAKkMLdFs0QDyCzbDD8dGSfIBo5htH7Ra7rZV4k7KOP6
         rghSr+QuT9HFZ36wDRAbe2HDWxfUUTDUiHO9gx0knXQDz6Ptqd9ldtGxZvcXf6ouHrK6
         wsQ7KrnPrzFVBpkAzIFxJhNEtp6hB/13x8psp2xvfjy3FkCiBxaV0N7k31IBh/ToBIUo
         9m0/ZU1ZpyEI6dsZCfg3jdMCkqy5Y3RK3Z9T5+/8Kr+DzdtGNIdNXoDaflQT8p3DX+Wx
         dS1w==
X-Gm-Message-State: AOAM533fj54pN8/OM3Aon+0bA2wGQSUrXXzJcEE5o9VMcRWkdyhGyXUe
        fJuCqnglIT4EQRlAKfIqrTXzCw==
X-Google-Smtp-Source: ABdhPJxGgtoVEbjT5Cr0YRfiCYFUfUFmMhQ0Pj14oXd+O/YqLgbr8gRxYVxdHfGKDEhWtIEIIRNhYg==
X-Received: by 2002:a5d:8483:: with SMTP id t3mr14794765iom.35.1613426077978;
        Mon, 15 Feb 2021 13:54:37 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e14sm2600250ils.49.2021.02.15.13.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 13:54:37 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: ipa: initialize all resources
Date:   Mon, 15 Feb 2021 15:54:34 -0600
Message-Id: <20210215215434.3225-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We configure the minimum and maximum number of various types of IPA
resources in ipa_resource_config().  It iterates over resource types
in the configuration data and assigns resource limits to each
resource group for each type.

Unfortunately, we are repeatedly initializing the resource data for
the first type, rather than initializing each of the types whose
limits are specified.

Fix this bug.

Fixes: 4a0d7579d466e ("net: ipa: avoid going past end of resource group array")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 84bb8ae927252..eb1c8396bcdd9 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -581,10 +581,10 @@ ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
 		return -EINVAL;
 
 	for (i = 0; i < data->resource_src_count; i++)
-		ipa_resource_config_src(ipa, data->resource_src);
+		ipa_resource_config_src(ipa, &data->resource_src[i]);
 
 	for (i = 0; i < data->resource_dst_count; i++)
-		ipa_resource_config_dst(ipa, data->resource_dst);
+		ipa_resource_config_dst(ipa, &data->resource_dst[i]);
 
 	return 0;
 }
-- 
2.20.1

