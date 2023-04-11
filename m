Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA666DE5A2
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjDKUVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjDKUVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FAB359F
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681244436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=duEXMDyF/EtgpxnHO/bBxdC6yz9S9tmp+T6Qy1WmeS4=;
        b=TFf6n/vQaaGCKGMUhgleuC28LLIwho1QNG4x3bnC8V8z+IHBqcPOEfqUUNGiCHlVQOY/li
        itaCgd/GXGdSvbqOlaD+lVZM8IW0/+rFB7anGk3Or+rr/c5BGAMP6aWlm+w78zUwwWtLmw
        GpJhdYVDwSk2vrCWMMO/lL7lJrNiY0g=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-EwMi6wrKO-eaG9Ajcnj-uA-1; Tue, 11 Apr 2023 16:20:35 -0400
X-MC-Unique: EwMi6wrKO-eaG9Ajcnj-uA-1
Received: by mail-oi1-f200.google.com with SMTP id q206-20020acad9d7000000b00389899548dbso9033030oig.22
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681244434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=duEXMDyF/EtgpxnHO/bBxdC6yz9S9tmp+T6Qy1WmeS4=;
        b=djzjjkx5ecMScXVSB7DwoPOCqD+ruQvLYKfOMTzWsQQ7J2eXsiI1ACMRzdngOyIIlx
         0shilJ8FO2w/gIQ5SkjOFu3r9bg3TgsEJTsHLa1j5DSio2Vout61l8l6ZdSnnOGN0s8e
         6ANSOnxjG3pPPiqc79DssPIDyGyoTbxoxBzejpnyU+5pFmYid5mjxDORTHfo9CdARwG5
         enUw8DDvsk9bu/0JKTnkyDFqsi89Q5sEJ8pCcxL7CMLhYIGGVyJi5CFIifSULWyieu4X
         8glAx3UiB6mxIK0Ai1KMSOVKE67iH9xo3yXQfbtKa6hHCgMcQzpHI/tKLzFTNdl4czcC
         LqEQ==
X-Gm-Message-State: AAQBX9frSN5GPxf65Wu1qchrL38S2rISfmygldIicK/L0HK99Q6PFTGW
        2MR+dwgFCCDVim8lrIIJtdkTp5XwCzA97CrNG1R1qWzWEa6zgXiu8Ng3lc9FJAW7IIFHKpPPIrf
        NqmwyZfAsx51/Kfsm
X-Received: by 2002:aca:6747:0:b0:389:9288:10d2 with SMTP id b7-20020aca6747000000b00389928810d2mr76534oiy.16.1681244434172;
        Tue, 11 Apr 2023 13:20:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zc96doUcjOMfzOi3ZogSaGPPBtELzM3DJb9RQUve+/jbfBfj22kPzUHaF6DBtl7f0+EtBgZA==
X-Received: by 2002:aca:6747:0:b0:389:9288:10d2 with SMTP id b7-20020aca6747000000b00389928810d2mr76514oiy.16.1681244433884;
        Tue, 11 Apr 2023 13:20:33 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id a6-20020a056808120600b003874631e249sm5976710oil.36.2023.04.11.13.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:20:33 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org,
        richardcochran@gmail.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        netdev@vger.kernel.org, bmasney@redhat.com, echanude@redhat.com,
        ncai@quicinc.com, jsuraj@qti.qualcomm.com, hisunil@quicinc.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v4 2/3] arm64: dts: qcom: sc8280xp: Add ethernet nodes
Date:   Tue, 11 Apr 2023 15:20:08 -0500
Message-Id: <20230411202009.460650-3-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411202009.460650-1-ahalaney@redhat.com>
References: <20230411202009.460650-1-ahalaney@redhat.com>
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

This platform has 2 MACs integrated in it, go ahead and describe them.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v3:
    * Order soc node via unit address (Konrad)
    * Add Reviewed-by (Konrad)

Changes since v2:
    * Fix spacing (Konrad)

Changes since v1:
    * None

 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 59 ++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 42bfa9fa5b96..fdac7f0b05ee 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -761,6 +761,35 @@ soc: soc@0 {
 		ranges = <0 0 0 0 0x10 0>;
 		dma-ranges = <0 0 0 0 0x10 0>;
 
+		ethernet0: ethernet@20000 {
+			compatible = "qcom,sc8280xp-ethqos";
+			reg = <0x0 0x00020000 0x0 0x10000>,
+			      <0x0 0x00036000 0x0 0x100>;
+			reg-names = "stmmaceth", "rgmii";
+
+			clocks = <&gcc GCC_EMAC0_AXI_CLK>,
+				 <&gcc GCC_EMAC0_SLV_AHB_CLK>,
+				 <&gcc GCC_EMAC0_PTP_CLK>,
+				 <&gcc GCC_EMAC0_RGMII_CLK>;
+			clock-names = "stmmaceth",
+				      "pclk",
+				      "ptp_ref",
+				      "rgmii";
+
+			interrupts = <GIC_SPI 946 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 936 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "macirq", "eth_lpi";
+			iommus = <&apps_smmu 0x4c0 0xf>;
+			power-domains = <&gcc EMAC_0_GDSC>;
+
+			snps,tso;
+			snps,pbl = <32>;
+			rx-fifo-depth = <4096>;
+			tx-fifo-depth = <4096>;
+
+			status = "disabled";
+		};
+
 		gcc: clock-controller@100000 {
 			compatible = "qcom,gcc-sc8280xp";
 			reg = <0x0 0x00100000 0x0 0x1f0000>;
@@ -4681,6 +4710,36 @@ dispcc1: clock-controller@22100000 {
 
 			status = "disabled";
 		};
+
+		ethernet1: ethernet@23000000 {
+			compatible = "qcom,sc8280xp-ethqos";
+			reg = <0x0 0x23000000 0x0 0x10000>,
+			      <0x0 0x23016000 0x0 0x100>;
+			reg-names = "stmmaceth", "rgmii";
+
+			clocks = <&gcc GCC_EMAC1_AXI_CLK>,
+				 <&gcc GCC_EMAC1_SLV_AHB_CLK>,
+				 <&gcc GCC_EMAC1_PTP_CLK>,
+				 <&gcc GCC_EMAC1_RGMII_CLK>;
+			clock-names = "stmmaceth",
+				      "pclk",
+				      "ptp_ref",
+				      "rgmii";
+
+			interrupts = <GIC_SPI 929 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 919 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "macirq", "eth_lpi";
+
+			iommus = <&apps_smmu 0x40 0xf>;
+			power-domains = <&gcc EMAC_1_GDSC>;
+
+			snps,tso;
+			snps,pbl = <32>;
+			rx-fifo-depth = <4096>;
+			tx-fifo-depth = <4096>;
+
+			status = "disabled";
+		};
 	};
 
 	sound: sound {
-- 
2.39.2

