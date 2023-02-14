Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3C4696B3D
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjBNRSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbjBNRRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:17:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539AD2FCFF
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676394916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n5Xftcuk/SSD+V/l0GWpcX6zdIVXO92U2DSCgVqWJgE=;
        b=c0WmU3W8GF6U72BgqoPvALKyJffKCtAOEvtmrjphfSzJwoTcgty/WAHZnQxKue83ydm+Q6
        RuEOAbWr5l9pLKd3f/IM/1JGziuIb5+u/mQpvqv4LTY9iwOrkErzyKPPNjmH8hozY9uhvP
        s+RdWtfL1j1933EIHYaJbAShaic9Do0=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-na3fshbtP1KkPiZMlsDptg-1; Tue, 14 Feb 2023 12:15:15 -0500
X-MC-Unique: na3fshbtP1KkPiZMlsDptg-1
Received: by mail-oi1-f198.google.com with SMTP id s4-20020a05680810c400b0037890be175fso3189138ois.14
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:15:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n5Xftcuk/SSD+V/l0GWpcX6zdIVXO92U2DSCgVqWJgE=;
        b=pDu0/D2G4Yt4PcL1I52rcUcL6zr/4x99QzVayumRAAjK6LE9Z6ZUmwLsAxcvATtKxl
         FA+LDLZV5+b6H8U7yiHRliU164zebbgreRz6zeffl7ILQN6u7cxjxU9uB/YcXNWKPjng
         rq4CpsJZyo9vSOI963S+E0CbPBLfK7FSaiEjPPXmjrR2fUuO8Z0KGWoHG1lz9WJ0x88j
         /yX005NSI8YVSGPtVIjS9/jMBDmSIFCBM4YFEuk+pRwFJGnnRwu9QGR0Zp84C1BrwDAZ
         n4W/bcTds6pdSK8RVqkBINcTDIO9XYUFlJMVhE5IhVXdwsGW6OKBF6euuGHXUtl0l0fU
         Dnrw==
X-Gm-Message-State: AO0yUKUOvalELkXqckIdLWFCBchlWCacR77E4qa0QoZr7eZMNlwDMtRx
        BAXHvR1hKGJp59RdKibZSVE8Ug1ad0I3kSU0N81wOcpliRGK8xabbuulP2wEP25g7VVhlffiR6m
        S2yd53FGxqg+nA7tG
X-Received: by 2002:a05:6870:9a1e:b0:16e:23e5:5b65 with SMTP id fo30-20020a0568709a1e00b0016e23e55b65mr1210900oab.7.1676394914502;
        Tue, 14 Feb 2023 09:15:14 -0800 (PST)
X-Google-Smtp-Source: AK7set8MrMmgViCnPoo/Cyzeh/QLl1zgh3Dd4LDFZA4q8Hj6ALu8f1u78rAjAarpF/d1TfQ/qvZVrw==
X-Received: by 2002:a05:6870:9a1e:b0:16e:23e5:5b65 with SMTP id fo30-20020a0568709a1e00b0016e23e55b65mr1210882oab.7.1676394914258;
        Tue, 14 Feb 2023 09:15:14 -0800 (PST)
Received: from halaney-x13s.redhat.com ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id h18-20020a9d6a52000000b00688449397d3sm6581786otn.15.2023.02.14.09.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 09:15:13 -0800 (PST)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     devicetree@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com, mripard@kernel.org,
        shenwei.wang@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v2 2/2] arm64: dts: imx8dxl-evk: Fix eqos phy reset gpio
Date:   Tue, 14 Feb 2023 11:15:05 -0600
Message-Id: <20230214171505.224602-2-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214171505.224602-1-ahalaney@redhat.com>
References: <20230214171505.224602-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The deprecated property is named snps,reset-gpio, but this devicetree
used snps,reset-gpios instead which results in the reset not being used
and the following make dtbs_check error:

    ./arch/arm64/boot/dts/freescale/imx8dxl-evk.dtb: ethernet@5b050000: 'snps,reset-gpio' is a dependency of 'snps,reset-delays-us'
        From schema: ./Documentation/devicetree/bindings/net/snps,dwmac.yaml

Use the preferred method of defining the reset gpio in the phy node
itself. Note that this drops the 10 us pre-delay, but prior this wasn't
used at all and a pre-delay doesn't make much sense in this context so
it should be fine.

Fixes: 8dd495d12374 ("arm64: dts: freescale: add support for i.MX8DXL EVK board")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v1:
    * Moved the reset into the ethernet-phy node itself instead of
      fixing the deprecated usage (for that reason I did not collect
      Fabio's review tag)

 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
index 1bcf228a22b8..852420349c01 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -121,8 +121,6 @@ &eqos {
 	phy-handle = <&ethphy0>;
 	nvmem-cells = <&fec_mac1>;
 	nvmem-cell-names = "mac-address";
-	snps,reset-gpios = <&pca6416_1 2 GPIO_ACTIVE_LOW>;
-	snps,reset-delays-us = <10 20 200000>;
 	status = "okay";
 
 	mdio {
@@ -136,6 +134,9 @@ ethphy0: ethernet-phy@0 {
 			eee-broken-1000t;
 			qca,disable-smarteee;
 			qca,disable-hibernation-mode;
+			reset-gpios = <&pca6416_1 2 GPIO_ACTIVE_LOW>;
+			reset-assert-us = <20>;
+			reset-deassert-us = <200000>;
 			vddio-supply = <&vddio0>;
 
 			vddio0: vddio-regulator {
-- 
2.39.1

