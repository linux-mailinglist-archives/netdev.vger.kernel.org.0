Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE64662D2F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbjAIRqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237060AbjAIRpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:45:42 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F07237380
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:45:39 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d17so9015298wrs.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NKOIr4cEj4c+hw/JZsvoHyIaYMugNurg6Goja8+q9K8=;
        b=2HZhYwMN1DpxpbW0ButVMB7Q9XSXXHV6dN9DhyVWbRwv+ljG6jK06IKMsgjAJt85hu
         BqDOnRhrQ7W5gdvcJ3U2R7E0vfq55Rz2wkc+o2W3PQzU/MgzhkjIBORQUEKUPxM5nj2t
         3pBtyrBorMWxebOGFjzX6fTI1FwM/7OlU/Qkj1XJ5FD6UWKP+JMrkkUeySKVZvb0yHQs
         2Ozw5rA0f2akEt3D0AA/q8+289GEkXi53BX2xTtchVJ7djHCYuAMOks65BEyrISkh5Qk
         w8A+lU9FfbG+rhkfzwNqn9Tg6gRWShn8TqHKRmWxlNh3lz2sMpqCNvTukLvCKJIDmseO
         8y5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NKOIr4cEj4c+hw/JZsvoHyIaYMugNurg6Goja8+q9K8=;
        b=J0eDGaoRNqnqz8wz6dMpb76fbYKqvMVoxy9rHNxp4y5U5atxN73kSsEzBTKWYX5t6+
         KTJTw4ttt1Yd+I6JaIBoIoXJXxYUAxUPVlSJkihg5W/osKx9q11tTyZmObtAxFcZcFIq
         QyLxNBjA7TQchR9pJRUb1q+Yu18pxBXADWh3WuMxljgLJyvMIXicDC/katLG5u+IkBDH
         Z84hePEz7i1lWCFviE3Or8Aj+9RoyVRZRjiN4Q/63v7cdo2VesLakUD6IA5MNiyAzBZH
         q/B284FZrWzExRIK6UkooSV9dd6SWu3Ehl3xL+c6TxdFpEPYv7soEQ5GYxyat3LohPce
         9kQQ==
X-Gm-Message-State: AFqh2kqVECt1d8faokgzQhOZbCQDixOmMrXR+8aVC0KH1/ADVqE8g1ma
        n6GumuKniArNAdrrVnl6OW3+qQ==
X-Google-Smtp-Source: AMrXdXsHrU5A1cVD96VWtZCmclwxzYTJLg6sI+sNVXacEHJeVBd6Bl6fQTsn7vfRS3HxNB55hX5tZw==
X-Received: by 2002:a5d:5910:0:b0:27c:7c2a:f700 with SMTP id v16-20020a5d5910000000b0027c7c2af700mr28716841wrd.8.1673286337817;
        Mon, 09 Jan 2023 09:45:37 -0800 (PST)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:c88:901e:c74c:8e80])
        by smtp.gmail.com with ESMTPSA id m1-20020a5d6241000000b002bbdaf21744sm6142902wrv.113.2023.01.09.09.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:45:37 -0800 (PST)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 04/18] dt-bindings: clock: qcom-rpmhcc: document the clock for sa8775p
Date:   Mon,  9 Jan 2023 18:44:57 +0100
Message-Id: <20230109174511.1740856-5-brgl@bgdev.pl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230109174511.1740856-1-brgl@bgdev.pl>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add a new compatible for SA8775P platforms.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml b/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
index cf25ba0419e2..ffc89489d14d 100644
--- a/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
@@ -18,6 +18,7 @@ properties:
   compatible:
     enum:
       - qcom,qdu1000-rpmh-clk
+      - qcom,sa8775p-rpmh-clk
       - qcom,sc7180-rpmh-clk
       - qcom,sc7280-rpmh-clk
       - qcom,sc8180x-rpmh-clk
-- 
2.37.2

