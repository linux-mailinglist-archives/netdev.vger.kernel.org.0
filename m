Return-Path: <netdev+bounces-11746-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A457734257
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 18:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D77E21C20A68
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 16:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94398BA4F;
	Sat, 17 Jun 2023 16:57:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8861D79EC
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 16:57:23 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C85A1999
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 09:57:21 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9829a5ae978so291844166b.2
        for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 09:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687021040; x=1689613040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SApWG7ViMWJvCzoOl336TbaVolfomzcROxDi+nk82RE=;
        b=yBVR5wz9KmiqLKq0XWprugXY4kG8itegBn3oHUXWqQQT0AJhdFtAVJPJ+yc3vVgbp/
         aneq6PsQlQhBvwrO7xTyAZk8QkrsTF4FWaVjtkKkIV/j71pUU7zS+x0kOa5VlFuuLqMR
         Rf46r0cPfgh/97hIMcVajBtXWyIsLDvRk9wLwXo68WtLEHHSLRILunis/2rxerxFwdev
         VUIYbAju5LQu2RRMFRpva/UwAFxoqukgvZ2y1ybcBoBd2YexK5XQvUId4tl9VbnUgVhX
         zLeOPgXybkzT9vf6ucWwt1/1bDy0MlpgQRdvvRc5He+4V/zjx0uV8TYRFYw6vIvIl1Yx
         2OCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687021040; x=1689613040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SApWG7ViMWJvCzoOl336TbaVolfomzcROxDi+nk82RE=;
        b=XORkLh087DUR09JUwDkLy+sGSrQ+H53CFZYS5aLDACs4BnXp5sezx1H2KlktloCxUl
         YxZFFTwnMca1NxEBn6gRk91NB8WtSBIXfDys00YqR99gidILsIsp8um8ukDidLwDELP/
         O2s7130dX+B8Kn78jnKZP5Nkzth95+cVoXUx5d23CKOZTvmN2zdsZuH1rx9ughkIFnpD
         wxiUda3oKn22FBjnEPHEzVN9bTNbBjMLAb+r66mttFpd6Ml960B7icAfDZMMmleWjDcy
         p6vHicFXaNQBbpGe/f53Fr+IJMmztXhJZY2OSR4pG+2kj4ZXIejZFlVwInG2yMn7tPKF
         Ig2A==
X-Gm-Message-State: AC+VfDxW4TCO0MdUWYbV/cmPHqODKJxoBOzaFX+bNdQCo+VEbUVAnOrs
	IpVWXK6EDzKkfG0YN8o5iOc3TQ==
X-Google-Smtp-Source: ACHHUZ57X2+ydR3mHcPYdCgEjBVpw+J0EnKnU7lZAnkZuvejj4C13bGLtiyW9IBmPRyhKS+pMZTD8g==
X-Received: by 2002:a17:907:c10:b0:973:fe5d:ef71 with SMTP id ga16-20020a1709070c1000b00973fe5def71mr6173723ejc.14.1687021039975;
        Sat, 17 Jun 2023 09:57:19 -0700 (PDT)
Received: from krzk-bin.. ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id e10-20020a170906044a00b009845c187bdcsm2603430eja.137.2023.06.17.09.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 09:57:19 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Balakrishna Godavarthi <bgodavar@codeaurora.org>,
	Rocky Liao <rjliao@codeaurora.org>,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH net-next] dt-bindings: net: bluetooth: qualcomm: document VDD_CH1
Date: Sat, 17 Jun 2023 18:57:16 +0200
Message-Id: <20230617165716.279857-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

WCN3990 comes with two chains - CH0 and CH1 - where each takes VDD
regulator.  It seems VDD_CH1 is optional (Linux driver does not care
about it), so document it to fix dtbs_check warnings like:

  sdm850-lenovo-yoga-c630.dtb: bluetooth: 'vddch1-supply' does not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml  | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
index e3a51d66527c..2735c6a4f336 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
@@ -52,6 +52,9 @@ properties:
   vddch0-supply:
     description: VDD_CH0 supply regulator handle
 
+  vddch1-supply:
+    description: VDD_CH1 supply regulator handle
+
   vddaon-supply:
     description: VDD_AON supply regulator handle
 
-- 
2.34.1


