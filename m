Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740126C6806
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjCWMTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjCWMS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:18:56 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D4F2A99B;
        Thu, 23 Mar 2023 05:18:11 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l15-20020a05600c4f0f00b003ed58a9a15eso945208wmq.5;
        Thu, 23 Mar 2023 05:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679573890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0bt+JP2DOH21gHNZBTDd1BfGENNMp2WTPGBmtUQVxWI=;
        b=SmxSpuzqiZJL74k+Jk2g0HQa7UPFI3Qr5T03RyvFqY02lFgUBfNVs2cEa0a2zPNPZe
         RqYDQWJ9khshW4ZrHesp2AVA2wqTT2c5qBVhwbkSHJ6SIoIOSX3FA9DXw0xzFrypoRuv
         /ulKs+vxp4RV+u4XAaxAel2QjfbaOPGk2/OJBwS58Zr4h+9K246GsAocwyhEVn+coAOh
         OBsGIX5tDXbR2Q3D1xzzGSwAjud+Ui9G8XqvvbUtEHtoLscQlRjgwNg81xVJiQ6pxPy7
         c5K5/76MH7rTbN4jBqycCDtKZj1UiOMRnhZ1XJG4q+UbDf2tF4zJgipoOS0BhNCMq+9t
         q1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679573890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0bt+JP2DOH21gHNZBTDd1BfGENNMp2WTPGBmtUQVxWI=;
        b=kDdaW/woKEwfiyJb+Yvy0brkboEgS/WsHOqkVZiSsbp2kcSP40qRfcoGuQbHB+xERE
         nlWy6WsNfOAwH8uMdO9cq/I0477+/0EBGtmGGxFAtktN9GWz4ZOKUJcB2xl7sRDe1uex
         jByzSmXA3DQm4CoL98b5uE6gfsZHR8GImdGcI+GUe4D8CZtSPKhuRPUPoKTjxt5f3UcV
         2fvUilwq4d9eEH7LWmNjyBu4sPHOnk5IenUZ2KlhO05DPrvGi22LmtdinGrucZVxRB1O
         a+ZDnKuGDefpq/wrmAfv7ia0+UVHrQBAOaxJIn22dti3uGFkCGmMTIGnd9oJ8QkHB9DU
         hyYQ==
X-Gm-Message-State: AO0yUKU/1M4lTsFu38HUS7nwnGcGSa48u8pc5cLTM82nI0yN4gNE0uDN
        UHZsdyCq8YgAk3D/BRFsckA=
X-Google-Smtp-Source: AK7set/cIYWAK0BD7gPKB5LnUWR5UEu9sRH9oKbN6MUvSjRMKzTgp/WuC9V7nCtBpb7Edzz7PTdMcQ==
X-Received: by 2002:a1c:4c1a:0:b0:3ea:e4f8:be09 with SMTP id z26-20020a1c4c1a000000b003eae4f8be09mr2102054wmf.30.1679573889667;
        Thu, 23 Mar 2023 05:18:09 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id m5-20020a05600c4f4500b003ebff290a52sm1760211wmq.28.2023.03.23.05.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 05:18:09 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     paul.geurts@prodrive-technologies.com, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 1/2] dt-bindings: net: dsa: b53: add BCM53134 support
Date:   Thu, 23 Mar 2023 13:18:03 +0100
Message-Id: <20230323121804.2249605-2-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230323121804.2249605-1-noltari@gmail.com>
References: <20230323121804.2249605-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM53134 are B53 switches connected by MDIO.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 57e0ef93b134..4c78c546343f 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -19,6 +19,7 @@ properties:
       - const: brcm,bcm53115
       - const: brcm,bcm53125
       - const: brcm,bcm53128
+      - const: brcm,bcm53134
       - const: brcm,bcm5365
       - const: brcm,bcm5395
       - const: brcm,bcm5389
-- 
2.30.2

