Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DDD6D2A7E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbjCaV7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbjCaV7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:59:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF8F23FFA
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680299905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCiyg9dGBB6UNsno9U8qc2bm6rLIrDesgavseN/0KQA=;
        b=MphePYqVzunN0IIh48DSki9QkeoqZKkqnPnmpIWZOfG8oUcq9FTA3VE72z0Fw7JVk6HIJZ
        dC7+893N4ga9Omo+KlJtnFRM84R9hgAdJ7oH8sJoqO9CijUst0Mcl2WGkiOwfDNk+r4GbN
        UxMizQzfiAb5WxjKUzNqngrpi+2BgIo=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-6SDanuQlOXuce51pn_HALQ-1; Fri, 31 Mar 2023 17:58:23 -0400
X-MC-Unique: 6SDanuQlOXuce51pn_HALQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-17abfe9fd10so11958979fac.0
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680299903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rCiyg9dGBB6UNsno9U8qc2bm6rLIrDesgavseN/0KQA=;
        b=0OaKWa7yWqLbI+BBxl4QBcSV2DiC683/2aHyj0WO/d3QjdzcBPJjUf4HZqubXB3bNq
         PSqCNJtFQ6UtcL7Iil8EzGZiD1koQrggY6VdvKgdIBVNV131t5EmSvWNZZKMrnvqQJFH
         j+OZF8nGvIhcc6CW8qnBCfkFcd9aIoo0K1FeSY17aZnEpDvXODeOb1vKXbshuq2o9gqt
         oZYqQ2NQgYEA55/kIKwwB/1AQxL5CqwbHj+9Lalo32jR4MQXznbTZ1xeMU8GyqpW3FVp
         2BW3c+MN6I0VFpDdgBbSdpLdj/rLO7v0/IhiQnU8NwYCtKQjCH6pKviCL9mamlQKAMeF
         KQUw==
X-Gm-Message-State: AAQBX9cy966VoIN9w/TBf+lh9K5o1JAayirX1GqiAkzAdGpjQJaGOKCn
        pNZg8TqTEj7OXk0If+2fs+1Ez5enCfLiz7y55FbwPK7UtW9CydkPp1mZBBigVogrbR+py0exjtc
        UIi+/tFAKEDLqSSUM
X-Received: by 2002:aca:2102:0:b0:389:7b6b:7a3d with SMTP id 2-20020aca2102000000b003897b6b7a3dmr3094796oiz.45.1680299903094;
        Fri, 31 Mar 2023 14:58:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350YHcYwEaPVb0PTs80nVmJ1lYDlQIT7UZ7m71p1JiRK2YwqEicxxTtQZwuTV/I6TW/X77Zlb9Q==
X-Received: by 2002:aca:2102:0:b0:389:7b6b:7a3d with SMTP id 2-20020aca2102000000b003897b6b7a3dmr3094773oiz.45.1680299902865;
        Fri, 31 Mar 2023 14:58:22 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id g11-20020a4a894b000000b0053bb2ae3a78sm1299277ooi.24.2023.03.31.14.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 14:58:22 -0700 (PDT)
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
Subject: [PATCH v3 1/3] clk: qcom: gcc-sc8280xp: Add EMAC GDSCs
Date:   Fri, 31 Mar 2023 16:58:02 -0500
Message-Id: <20230331215804.783439-2-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331215804.783439-1-ahalaney@redhat.com>
References: <20230331215804.783439-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the EMAC GDSCs to allow the EMAC hardware to be enabled.

Acked-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v2:
    * Add Konrad's Reviewed-by

Changes since v1:
    * Add Stephen's Acked-by
    * Explicitly tested on x13s laptop with no noticeable side effect (Konrad)

 drivers/clk/qcom/gcc-sc8280xp.c               | 18 ++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-sc8280xp.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sc8280xp.c b/drivers/clk/qcom/gcc-sc8280xp.c
index b3198784e1c3..04a99dbaa57e 100644
--- a/drivers/clk/qcom/gcc-sc8280xp.c
+++ b/drivers/clk/qcom/gcc-sc8280xp.c
@@ -6873,6 +6873,22 @@ static struct gdsc usb30_sec_gdsc = {
 	.pwrsts = PWRSTS_RET_ON,
 };
 
+static struct gdsc emac_0_gdsc = {
+	.gdscr = 0xaa004,
+	.pd = {
+		.name = "emac_0_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+};
+
+static struct gdsc emac_1_gdsc = {
+	.gdscr = 0xba004,
+	.pd = {
+		.name = "emac_1_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+};
+
 static struct clk_regmap *gcc_sc8280xp_clocks[] = {
 	[GCC_AGGRE_NOC_PCIE0_TUNNEL_AXI_CLK] = &gcc_aggre_noc_pcie0_tunnel_axi_clk.clkr,
 	[GCC_AGGRE_NOC_PCIE1_TUNNEL_AXI_CLK] = &gcc_aggre_noc_pcie1_tunnel_axi_clk.clkr,
@@ -7351,6 +7367,8 @@ static struct gdsc *gcc_sc8280xp_gdscs[] = {
 	[USB30_MP_GDSC] = &usb30_mp_gdsc,
 	[USB30_PRIM_GDSC] = &usb30_prim_gdsc,
 	[USB30_SEC_GDSC] = &usb30_sec_gdsc,
+	[EMAC_0_GDSC] = &emac_0_gdsc,
+	[EMAC_1_GDSC] = &emac_1_gdsc,
 };
 
 static const struct clk_rcg_dfs_data gcc_dfs_clocks[] = {
diff --git a/include/dt-bindings/clock/qcom,gcc-sc8280xp.h b/include/dt-bindings/clock/qcom,gcc-sc8280xp.h
index cb2fb638825c..721105ea4fad 100644
--- a/include/dt-bindings/clock/qcom,gcc-sc8280xp.h
+++ b/include/dt-bindings/clock/qcom,gcc-sc8280xp.h
@@ -492,5 +492,7 @@
 #define USB30_MP_GDSC					9
 #define USB30_PRIM_GDSC					10
 #define USB30_SEC_GDSC					11
+#define EMAC_0_GDSC					12
+#define EMAC_1_GDSC					13
 
 #endif
-- 
2.39.2

