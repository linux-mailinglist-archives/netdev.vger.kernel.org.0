Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90242A3255
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgKBRyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgKBRyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:54:07 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250E8C061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 09:54:06 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id t13so5786026ilp.2
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 09:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jmjVYy285nrY064kTbgnLlqLx5ORT9uOKTs5XvuM26I=;
        b=aa9HrT4KFzTRTl/TvhwLmu5Bar+f6KQX4ZtYjdg062aEHcu/cXYKt0YkzcAehApQEV
         BKsf1xL2RNn/7D7Cw9ZKNngfTSr9qzsAgQ4OOLlrAJtZedGnPWetWY0rq12/iI/GNMt2
         OIiBcFmIi9cNg90DtpvNGC44ayWbCYB5eiLKJG4p1o3vKf5CpUH6zv3KFeicl7QJAgfw
         eIzYyWV4iO1YxiEM/2NdUf2Zkb1VL8AcLdlrcSqF4vLjQNAwmG2PxASHYUTtt+AXsU/T
         Q/ggyS+WwWgsLEAK3/uWl9HBRyJbDP1uS4wAbTXsgG1n+B0/6+qnWsXFpUNLjCFxu1oy
         7Gww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jmjVYy285nrY064kTbgnLlqLx5ORT9uOKTs5XvuM26I=;
        b=lx54uf5x62ShPhJ+RJw0loHglZmP+accMCg+LjBDAO5U0/xHr7kbQfw99Onb5RuTCW
         uR/TMsxNqBpy2dxqC2XhkWuEl+js19sqnTZ43d9nezZNwu0hKevxfG/cbpuV44W6geLU
         oXcZ5QzkA4vCm+45xHvYYVCg2a/dT7hUGS1zGwMM9kRUTXJTbKSZkjTL3bIoCGvz2LCD
         8mmD4h+erN8a/0wouzRaRGA0O7nM6C3MNCaFd6TBSeaW1ferqhII8hFQ7JUxab21MN6K
         1h/Mk+pDr4HvaUfoPjozntHco9OW6SgradUQa3Vp+QrcEdWAcDHhMyScAEhTlpMlnPyZ
         uYRQ==
X-Gm-Message-State: AOAM533GDge/IKw09OtH9zEwtbbPRhtcHr3mittMJ5uiLc54u0xQRQV8
        nTOzFCVZxh8qQ8YvQshUFUXGeg==
X-Google-Smtp-Source: ABdhPJz3qED4+mO8Wcgds1VbIstJ9djidzGpnlWjBjj4l+Mvk9I1suRiRZDmG/0QAGqBHZf0dzyXIA==
X-Received: by 2002:a92:bb8d:: with SMTP id x13mr11699971ilk.225.1604339645362;
        Mon, 02 Nov 2020 09:54:05 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r4sm11089591ilj.43.2020.11.02.09.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 09:54:04 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: expose IPA version to the GSI layer
Date:   Mon,  2 Nov 2020 11:53:55 -0600
Message-Id: <20201102175400.6282-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201102175400.6282-1-elder@linaro.org>
References: <20201102175400.6282-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although GSI is integral to IPA, it is a separate hardware component
and the IPA code supporting it has been structured to avoid explicit
dependence on IPA details.  An example of this is that gsi_init() is
passed a number of Boolean flags to indicate special behaviors,
whose values are dependent on the IPA hardware version.  Looking
ahead, newer hardware versions would require even more such special
behaviors.

For any given version of IPA hardware (like 3.5.1 or 4.2), the GSI
hardware version is fixed (in this case, 1.3 and 2.2, respectively).
So the IPA version *implies* the GSI version, and the IPA version
can be used as effectively the equivalent of the GSI hardware version.

Rather than proliferating new special behavior flags, just provide
the IPA version to the GSI layer when it is initialized.  The GSI
code can then use that directly to determine whether special
behaviors are required.  The IPA version enumerated type is already
isolated to its own header file, so the exposure of this IPA detail
is very limited.

For now, just change gsi_init() to pass the version rather than the
Boolean flags, and set the flag values internal to that function.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c      | 14 +++++++++++---
 drivers/net/ipa/gsi.h      | 11 ++++++++---
 drivers/net/ipa/ipa_main.c | 11 ++---------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 6bfac1efe037c..1e19160281dd3 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -21,6 +21,7 @@
 #include "gsi_trans.h"
 #include "ipa_gsi.h"
 #include "ipa_data.h"
+#include "ipa_version.h"
 
 /**
  * DOC: The IPA Generic Software Interface
@@ -1952,18 +1953,25 @@ static void gsi_channel_exit(struct gsi *gsi)
 }
 
 /* Init function for GSI.  GSI hardware does not need to be "ready" */
-int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
-	     u32 count, const struct ipa_gsi_endpoint_data *data,
-	     bool modem_alloc)
+int gsi_init(struct gsi *gsi, struct platform_device *pdev,
+	     enum ipa_version version, u32 count,
+	     const struct ipa_gsi_endpoint_data *data)
 {
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	resource_size_t size;
 	unsigned int irq;
+	bool modem_alloc;
+	bool prefetch;
 	int ret;
 
 	gsi_validate_build();
 
+	/* IPA v4.0+ (GSI v2.0+) uses prefetch for the command channel */
+	prefetch = version != IPA_VERSION_3_5_1;
+	/* IPA v4.2 requires the AP to allocate channels for the modem */
+	modem_alloc = version == IPA_VERSION_4_2;
+
 	gsi->dev = dev;
 
 	/* The GSI layer performs NAPI on all endpoints.  NAPI requires a
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 3f9f29d531c43..2dd8ee78aa8c7 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -20,6 +20,8 @@
 /* Maximum TLV FIFO size for a channel; 64 here is arbitrary (and high) */
 #define GSI_TLV_MAX		64
 
+enum ipa_version;
+
 struct device;
 struct scatterlist;
 struct platform_device;
@@ -236,15 +238,18 @@ int gsi_channel_resume(struct gsi *gsi, u32 channel_id, bool start);
  * gsi_init() - Initialize the GSI subsystem
  * @gsi:	Address of GSI structure embedded in an IPA structure
  * @pdev:	IPA platform device
+ * @version:	IPA hardware version (implies GSI version)
+ * @count:	Number of entries in the configuration data array
+ * @data:	Endpoint and channel configuration data
  *
  * Return:	0 if successful, or a negative error code
  *
  * Early stage initialization of the GSI subsystem, performing tasks
  * that can be done before the GSI hardware is ready to use.
  */
-int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
-	     u32 count, const struct ipa_gsi_endpoint_data *data,
-	     bool modem_alloc);
+int gsi_init(struct gsi *gsi, struct platform_device *pdev,
+	     enum ipa_version version, u32 count,
+	     const struct ipa_gsi_endpoint_data *data);
 
 /**
  * gsi_exit() - Exit the GSI subsystem
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index f4dd14d9550fe..0d3d1a5cf07c1 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -723,10 +723,8 @@ static int ipa_probe(struct platform_device *pdev)
 	const struct ipa_data *data;
 	struct ipa_clock *clock;
 	struct rproc *rproc;
-	bool modem_alloc;
 	bool modem_init;
 	struct ipa *ipa;
-	bool prefetch;
 	phandle ph;
 	int ret;
 
@@ -788,13 +786,8 @@ static int ipa_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_reg_exit;
 
-	/* GSI v2.0+ (IPA v4.0+) uses prefetch for the command channel */
-	prefetch = ipa->version != IPA_VERSION_3_5_1;
-	/* IPA v4.2 requires the AP to allocate channels for the modem */
-	modem_alloc = ipa->version == IPA_VERSION_4_2;
-
-	ret = gsi_init(&ipa->gsi, pdev, prefetch, data->endpoint_count,
-		       data->endpoint_data, modem_alloc);
+	ret = gsi_init(&ipa->gsi, pdev, ipa->version, data->endpoint_count,
+		       data->endpoint_data);
 	if (ret)
 		goto err_mem_exit;
 
-- 
2.20.1

