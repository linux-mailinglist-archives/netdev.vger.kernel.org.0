Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5008F6B7E95
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCMRAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjCMRAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:00:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77221366A1
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678726640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=t5POBg1qZ82GqoEDaDaIA79xn4Mgw94E10MmvGFG+QA=;
        b=UCSmaXaGHUsmxostezSfNGm2h5CB0G88EFirpB43bzQR9V9vIOplKH1G6lkne+3Lko3CUg
        wzaFSfeD5UmTo4lnW3+ONt2MrfX1mAHN4ub3Cku164pS8RNe+iixDjIhhWmUNalzRQc8Bx
        F2HbHlRiR37JDrhiRt8Nzt9g5Yw52lk=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-np4f9jJJM2m917RDrBVhgA-1; Mon, 13 Mar 2023 12:57:18 -0400
X-MC-Unique: np4f9jJJM2m917RDrBVhgA-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-1777653e2c4so4715481fac.1
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678726638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t5POBg1qZ82GqoEDaDaIA79xn4Mgw94E10MmvGFG+QA=;
        b=IHpc+6diyGBbT8Jc2ebT0QHSfNOSIi7/2L0hR16HsiZR3WZDDEcC5wxzrXsizbyLAP
         JlY+Dke+c0FBO12k3FNbTEtHzS33iBdr+YvZwlJZ4hNNACEYgD/vQEZElBqLyan+FIpr
         kcsanA1JrihiVYXTwb+o3zcym1GY76+29F66OXT2e7PE2Qso3+F+XNUSVj9ZPkWhfQQ8
         +jfVT9SRCe+83108JNZwRhVu1RF5nCHMAIArmnkXc9YzDeq/A7un7M2ygJWfRXvQfkpt
         gdbkNFHYo+DxtzIJO9MIIExhLVlsfinGQLpFPktxvduBAZVEoeOfMUAqtDLw2A/AY7/c
         xHlg==
X-Gm-Message-State: AO0yUKUcE5xAsUQfsVu7E/ZJOn2bF7aYD/d+9jPJ2I7ZjKPr/0oujZDe
        JjLu0eFeNfklnH/b6UMpws8iRD0tGvITh1e+jBrhB8KlhHA0Wj2mAJnCg39PBSHgd1jNtxnWWhI
        Mh6U9hNuiA5QuOEGo
X-Received: by 2002:a05:6808:150:b0:37f:b1d6:9f3c with SMTP id h16-20020a056808015000b0037fb1d69f3cmr17439023oie.46.1678726637932;
        Mon, 13 Mar 2023 09:57:17 -0700 (PDT)
X-Google-Smtp-Source: AK7set/DcZ9ZIOTk8pbqQbIpqBKMFacVCaRW/B1/QFZ8b2XK2GO2nvasDBBZ4a2w0GAU24OnbrYXGg==
X-Received: by 2002:a05:6808:150:b0:37f:b1d6:9f3c with SMTP id h16-20020a056808015000b0037fb1d69f3cmr17438954oie.46.1678726636191;
        Mon, 13 Mar 2023 09:57:16 -0700 (PDT)
Received: from halaney-x13s.attlocal.net ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id o2-20020acad702000000b00384d3003fa3sm3365273oig.26.2023.03.13.09.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:57:15 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next 00/11] Add EMAC3 support for sa8540p-ride
Date:   Mon, 13 Mar 2023 11:56:09 -0500
Message-Id: <20230313165620.128463-1-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
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

This is a forward port / upstream refactor of code delivered
downstream by Qualcomm over at [0] to enable the DWMAC5 based
implementation called EMAC3 on the sa8540p-ride dev board.

From what I can tell with the board schematic in hand,
as well as the code delivered, the main changes needed are:

    1. A new address space layout for /dwmac5/EMAC3 MTL/DMA regs
    2. A new programming sequence required for the EMAC3 base platforms

This series makes those adaptations as well as other housekeeping items
such as converting dt-bindings to yaml, adding clock descriptions, etc.

[0] https://git.codelinaro.org/clo/la/kernel/ark-5.14/-/commit/510235ad02d7f0df478146fb00d7a4ba74821b17

Thanks,
Andrew

Bhupesh Sharma (3):
  dt-bindings: net: snps,dwmac: Update interrupt-names
  dt-bindings: net: snps,dwmac: Add Qualcomm Ethernet ETHQOS compatibles
  dt-bindings: net: qcom,ethqos: Convert bindings to yaml

Brian Masney (1):
  net: stmmac: Add EMAC3 variant of dwmac4

 .../devicetree/bindings/net/qcom,ethqos.txt   |  66 ----
 .../devicetree/bindings/net/qcom,ethqos.yaml  | 113 ++++++
 .../devicetree/bindings/net/snps,dwmac.yaml   |  11 +-
 MAINTAINERS                                   |   2 +-
 arch/arm64/boot/dts/qcom/sa8540p-ride.dts     | 181 ++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi        |  53 +++
 drivers/clk/qcom/gcc-sc8280xp.c               |  18 +
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 161 ++++++---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  32 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 190 ++++++++--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 336 ++++++++++++++----
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  38 ++
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  | 144 ++++++--
 drivers/net/ethernet/stmicro/stmmac/hwif.c    |  29 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   2 +
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   6 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  17 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   9 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |   4 +-
 include/dt-bindings/clock/qcom,gcc-sc8280xp.h |   2 +
 include/linux/stmmac.h                        |   1 +
 21 files changed, 1164 insertions(+), 251 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml

-- 
2.39.2

