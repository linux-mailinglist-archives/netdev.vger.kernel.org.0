Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C352E695312
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 22:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjBMVcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 16:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjBMVcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 16:32:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA132196A
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 13:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676323877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DOJWQgK0El7j4eURl5McfS3atvuUactc703LqDtB0l4=;
        b=KMUPhhWwDd4PA+y7uu3P6ewVD+9M62c5lsp3v/LkW4+vMqChTW3tAKWow9m8goxcOaJrRF
        aKOKhfWj9h7zZEgewCErOtSIOMq0tEsKLaNMDa1OG30TATeyOKPY/i8fjVdZbDjgs/dcjH
        foK/+/C24+J1mwkCAlFOgqEkUfLWiRk=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-556--r-j3QKzO_CNgUoTS6H_eg-1; Mon, 13 Feb 2023 16:31:16 -0500
X-MC-Unique: -r-j3QKzO_CNgUoTS6H_eg-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-16df7d9c780so2200787fac.3
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 13:31:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DOJWQgK0El7j4eURl5McfS3atvuUactc703LqDtB0l4=;
        b=JbWpmmygkCrvmWZv7zOGCsORlGIc6x6zx0JbI37VSgl7sR6nlNxJJMB+fvNJw3H4OI
         o2xad8vvFXncuDFb2x12T43EnxAsUedJKjuely0EvXxc0gNB/Vulj1+gr9XzlYyFJNUh
         z13ln4PorXFxlHN4ICs9oPkPpGqG8jPYN9uZIS251RBvBndXbJTNm655KHX7DIwdRrfU
         gNhXxucWdC2q/kpzONnOfYftrqUG69x+Ox9fzSwwClC3DsH3c/cVhSAV7XwzkQHtgzXS
         QFUuMeJBvDgFRlrTr7Vvxm2jz78x0zwqT5+4lAyvc1ZlqWEAv4S600n1yuRzKBO+LtwN
         rVfw==
X-Gm-Message-State: AO0yUKWuh9GnuH02TVDFVYlnzxyorortbvfVorLiADC7knafnvTTDV0r
        uuX7GddW3GN9QqX0Rc2K6gSxT0TehiLVDl4HHNiA+r76JTcvMyVRmRAKUYipKlUMpLZrzmgvv1p
        L+KlwE+IenXtxr10i
X-Received: by 2002:a05:6870:3484:b0:16a:a81f:263d with SMTP id n4-20020a056870348400b0016aa81f263dmr10196330oah.21.1676323875622;
        Mon, 13 Feb 2023 13:31:15 -0800 (PST)
X-Google-Smtp-Source: AK7set8es8huWxHFgDWxt4YNTypK6yBKCWRGYW1vG1mos90OjBzQZeLzaN5aCznYq3OxEoSvRx7qGw==
X-Received: by 2002:a05:6870:3484:b0:16a:a81f:263d with SMTP id n4-20020a056870348400b0016aa81f263dmr10196313oah.21.1676323875351;
        Mon, 13 Feb 2023 13:31:15 -0800 (PST)
Received: from halaney-x13s.redhat.com ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id xl6-20020a0568709f0600b00163263f84dasm5169880oab.12.2023.02.13.13.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 13:31:14 -0800 (PST)
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
Subject: [PATCH 2/2] arm64: dts: imx8dxl-evk: Fix eqos phy reset gpio
Date:   Mon, 13 Feb 2023 15:31:04 -0600
Message-Id: <20230213213104.78443-2-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213213104.78443-1-ahalaney@redhat.com>
References: <20230213213104.78443-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The property is named snps,reset-gpio. Update the name accordingly so
the corresponding phy is reset.

Fixes: 8dd495d12374 ("arm64: dts: freescale: add support for i.MX8DXL EVK board")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
index 1bcf228a22b8..b6d7c2526131 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -121,7 +121,7 @@ &eqos {
 	phy-handle = <&ethphy0>;
 	nvmem-cells = <&fec_mac1>;
 	nvmem-cell-names = "mac-address";
-	snps,reset-gpios = <&pca6416_1 2 GPIO_ACTIVE_LOW>;
+	snps,reset-gpio = <&pca6416_1 2 GPIO_ACTIVE_LOW>;
 	snps,reset-delays-us = <10 20 200000>;
 	status = "okay";
 
-- 
2.39.1

