Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE38695314
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 22:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjBMVdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 16:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjBMVdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 16:33:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3861535A9
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 13:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676323941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S8Jx6cSFIcaW45Hs8sr354ULKB9oTW16m++fk2w9xe0=;
        b=TjEu8dv/xFVfpIqx6TXKVVAlS0zCtuLqCjUJCuojh4JORJ4DodbBgIxrPCNlMVyg4oZXpt
        sjsM8FNzHWPFIpaSKxSQGk0fdoDaM+nilFWvTZJNBa/ZN8jkk1laBYG3eoDLZx4kvZrgTr
        7cpGj1/gAo06CoT4B0k5YFV0x0m7DhI=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-659-xMEqbU3hOAODw600XKZQlQ-1; Mon, 13 Feb 2023 16:32:10 -0500
X-MC-Unique: xMEqbU3hOAODw600XKZQlQ-1
Received: by mail-oi1-f200.google.com with SMTP id s4-20020a05680810c400b0037890be175fso2767537ois.14
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 13:32:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8Jx6cSFIcaW45Hs8sr354ULKB9oTW16m++fk2w9xe0=;
        b=Xn7OqT+hAq4YjOFrA6HG3CrY6lUGEnhtG+TpUPauii+srO10QXM4f3FukdMjti0N+F
         ZHlQ2dkU5+EBqtFLFgEuNwAx0a21sW9pV16t0O2HJzmSu6P5/yE2COceOH1unu9+amSa
         SCR5xXNENfMpD9F+kxtinvMwW8S8g357jKgEcrvhk4KTmxGZVHx2+jqYuhGNBlpKlx+/
         z5b7CcPUDXjzfHGTazql1x+9LmB9k6GThqImxgLojgZ9BVjCdWVdLV1aBuETIXMIwprv
         6dghhgsgTmKoottx5OR72fraq5faqi5juokWhT7EDWINO1/ZRTIyWMfz06Euy6cb70B7
         zZOw==
X-Gm-Message-State: AO0yUKVPwpyzlJvzIZej5Fh5V2KW+SXU7b/+GxT4fA1lpVf93oIh2gDu
        NudmBad0KCpxYx3rmMK5Sf+mTPBj7HJEKRgxB5vTIXDrb/E/Y3JMWxjc/Jq/0AYMCNWKMleqtIE
        R9D8NE4bf1apHN5SE
X-Received: by 2002:a05:6871:54f:b0:163:8b58:ab23 with SMTP id t15-20020a056871054f00b001638b58ab23mr15125905oal.35.1676323870510;
        Mon, 13 Feb 2023 13:31:10 -0800 (PST)
X-Google-Smtp-Source: AK7set8UBE4VIVd2o9PdNKsl3q4pn7Mu5YmJ8E0oL9yKlg3DnN3+1x4FKFROitPge1Hvry3cpiLsIQ==
X-Received: by 2002:a05:6871:54f:b0:163:8b58:ab23 with SMTP id t15-20020a056871054f00b001638b58ab23mr15125883oal.35.1676323870229;
        Mon, 13 Feb 2023 13:31:10 -0800 (PST)
Received: from halaney-x13s.redhat.com ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id xl6-20020a0568709f0600b00163263f84dasm5169880oab.12.2023.02.13.13.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 13:31:09 -0800 (PST)
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
Subject: [PATCH 1/2] dt-bindings: net: snps,dwmac: Fix snps,reset-delays-us dependency
Date:   Mon, 13 Feb 2023 15:31:03 -0600
Message-Id: <20230213213104.78443-1-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.1
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

The schema had snps,reset-delay-us as dependent on snps,reset-gpio. The
actual property is called snps,reset-delays-us, so fix this to catch any
devicetree defining snsps,reset-delays-us without snps,reset-gpio.

Fixes: 7db3545aef5f ("dt-bindings: net: stmmac: Convert the binding to a schemas")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index e88a86623fce..16b7d2904696 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -552,7 +552,7 @@ required:
 
 dependencies:
   snps,reset-active-low: ["snps,reset-gpio"]
-  snps,reset-delay-us: ["snps,reset-gpio"]
+  snps,reset-delays-us: ["snps,reset-gpio"]
 
 allOf:
   - $ref: "ethernet-controller.yaml#"
-- 
2.39.1

