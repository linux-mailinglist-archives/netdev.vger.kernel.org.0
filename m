Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5203B2F7AB2
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732992AbhAOMxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388434AbhAOMwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:52:16 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667A6C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:51:00 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id y19so17882636iov.2
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KhAlEdXMThb5bBjxNUO0atbOyb0X5NmtnPbjigJcPX0=;
        b=XcbVNYnFm0Q9tvSFgVmPHnqvdtAxNA22pBZ5BXkb2H+gC5jMUcWwpP5qeY4iklbQHf
         CTt4VBlYHS+mu7cVqsu4OU71L3kgcUfIdcjpeF9/X3L0P/qHpETRfcH8j87OewHV5o0t
         m8Va+Ma8b+yJTHUt42VHWxho9bcQoPeVHVcawWx+uxC9R2fewQgolehSuDVaedVa4Cik
         VNU2InwbKumw0SsC9Bc6je3etvuCZLxXyY90SWPA+qhEbKhfL3pNOlGRg7qTaHkUr0T2
         bdDm+fbT1+MYYpXrQsy7auKMO4DyIN8hVJAsaF1FMGxAKQs9GQEvX7tXI0/x3FSTiteR
         APEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KhAlEdXMThb5bBjxNUO0atbOyb0X5NmtnPbjigJcPX0=;
        b=EU9CVHu+7TJeh6pfCzDTT+KRfMDczsgicoSgrFN3xYMmnGght5gFLzar7+hM9mTubw
         Q6Kvo6LtyphZn7vZRHDbUl6ek2Ok7qdS9ZBw3yEXV3fGkcf5qyktVbhIuL1w9THiCguq
         EtElfybQ53LjaImkAkpUNtDwxemvF9wN5wLJBAB0XWsqbu8usHM8E9tqBt6PThLpLrJf
         kQFmcpXiVqf/Npdnd5C7ulYbrFkhezlWme+nJAsJohugEqy7PtIAz6eqsT4ZUZATqlIx
         UXUD6dgCko5ODAut0ibMWI17jyYNx/7dRbe9gN/aZhfC5VlZenSG//w0xGycpysizonz
         8CSw==
X-Gm-Message-State: AOAM531W4gTS8rs4Iss+aqSq+GBXy9OKlcvTvF3o4617AQGzH86fhOHR
        dUySt9lRfad3uSgCsnD6EWpaHQ==
X-Google-Smtp-Source: ABdhPJzKNuhVY7M0oRkC1Tz5ZwgRD4935+9kSx5M5/DiP8+KV/R8CnFcT5MBzeQ/78v7rwou8bPavQ==
X-Received: by 2002:a92:c006:: with SMTP id q6mr10812282ild.115.1610715059855;
        Fri, 15 Jan 2021 04:50:59 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f13sm3952450iog.18.2021.01.15.04.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:50:59 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/7] net: ipa: clean up interconnect initialization
Date:   Fri, 15 Jan 2021 06:50:49 -0600
Message-Id: <20210115125050.20555-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210115125050.20555-1-elder@linaro.org>
References: <20210115125050.20555-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass an the address of an IPA interconnect structure and its
configuration data to ipa_interconnect_init_one() and have that
function initialize all the structure's fields.  Change the function
to simply return an error code.

Introduce ipa_interconnect_exit_one() to encapsulate the cleanup of
an IPA interconnect structure.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 83 +++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 07069dbc6d033..fbe42106fc2a8 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -56,17 +56,33 @@ struct ipa_clock {
 	struct ipa_interconnect interconnect[IPA_INTERCONNECT_COUNT];
 };
 
-static struct icc_path *
-ipa_interconnect_init_one(struct device *dev, const char *name)
+static int ipa_interconnect_init_one(struct device *dev,
+				     struct ipa_interconnect *interconnect,
+				     const struct ipa_interconnect_data *data)
 {
 	struct icc_path *path;
 
-	path = of_icc_get(dev, name);
-	if (IS_ERR(path))
-		dev_err(dev, "error %d getting %s interconnect\n",
-			(int)PTR_ERR(path), name);
+	path = of_icc_get(dev, data->name);
+	if (IS_ERR(path)) {
+		int ret = PTR_ERR(path);
 
-	return path;
+		dev_err(dev, "error %d getting %s interconnect\n", ret,
+			data->name);
+
+		return ret;
+	}
+
+	interconnect->path = path;
+	interconnect->average_bandwidth = data->average_bandwidth;
+	interconnect->peak_bandwidth = data->peak_bandwidth;
+
+	return 0;
+}
+
+static void ipa_interconnect_exit_one(struct ipa_interconnect *interconnect)
+{
+	icc_put(interconnect->path);
+	memset(interconnect, 0, sizeof(*interconnect));
 }
 
 /* Initialize interconnects required for IPA operation */
@@ -74,51 +90,46 @@ static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev,
 				 const struct ipa_interconnect_data *data)
 {
 	struct ipa_interconnect *interconnect;
-	struct icc_path *path;
+	int ret;
 
-	path = ipa_interconnect_init_one(dev, data->name);
-	if (IS_ERR(path))
-		goto err_return;
 	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
-	interconnect->path = path;
-	interconnect->average_bandwidth = data->average_bandwidth;
-	interconnect->peak_bandwidth = data->peak_bandwidth;
-	data++;
+	ret = ipa_interconnect_init_one(dev, interconnect, data++);
+	if (ret)
+		return ret;
 
-	path = ipa_interconnect_init_one(dev, data->name);
-	if (IS_ERR(path))
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
+	ret = ipa_interconnect_init_one(dev, interconnect, data++);
+	if (ret)
 		goto err_memory_path_put;
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
-	interconnect->path = path;
-	interconnect->average_bandwidth = data->average_bandwidth;
-	interconnect->peak_bandwidth = data->peak_bandwidth;
-	data++;
 
-	path = ipa_interconnect_init_one(dev, data->name);
-	if (IS_ERR(path))
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
+	ret = ipa_interconnect_init_one(dev, interconnect, data++);
+	if (ret)
 		goto err_imem_path_put;
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_CONFIG];
-	interconnect->path = path;
-	interconnect->average_bandwidth = data->average_bandwidth;
-	interconnect->peak_bandwidth = data->peak_bandwidth;
-	data++;
 
 	return 0;
 
 err_imem_path_put:
-	icc_put(clock->interconnect[IPA_INTERCONNECT_IMEM].path);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
+	ipa_interconnect_exit_one(interconnect);
 err_memory_path_put:
-	icc_put(clock->interconnect[IPA_INTERCONNECT_MEMORY].path);
-err_return:
-	return PTR_ERR(path);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
+	ipa_interconnect_exit_one(interconnect);
+
+	return ret;
 }
 
 /* Inverse of ipa_interconnect_init() */
 static void ipa_interconnect_exit(struct ipa_clock *clock)
 {
-	icc_put(clock->interconnect[IPA_INTERCONNECT_CONFIG].path);
-	icc_put(clock->interconnect[IPA_INTERCONNECT_IMEM].path);
-	icc_put(clock->interconnect[IPA_INTERCONNECT_MEMORY].path);
+	struct ipa_interconnect *interconnect;
+
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_CONFIG];
+	ipa_interconnect_exit_one(interconnect);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
+	ipa_interconnect_exit_one(interconnect);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
+	ipa_interconnect_exit_one(interconnect);
 }
 
 /* Currently we only use one bandwidth level, so just "enable" interconnects */
-- 
2.20.1

