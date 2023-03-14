Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED52A6B98A4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCNPMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjCNPMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:12:20 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AE55F530
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:12:18 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id o7so5294246wrg.5
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678806737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iBdDt0cqpy6mqZcYqnHeD+1brhs0HmWk0OP3dY1LAIs=;
        b=GFfmwFW8xeMH5Re8QwmK4TF3WQrgLb14J2RNNuffrfGixpc2wJEDemqzYA1xuFrAYQ
         n26hInC07plbcBftba/DYI8Uc0JuD1Q+FiFljbmQ2tlCLqmdm5Hx1XkwqMQYbbouD5nt
         pLHbgSADUDrV/ep65O0ceyFvs13IJFpHhIODR5wM0Lx10r7lbWs18irGgQX995MrcjtQ
         hy9rk6MieRxr/+/v6++iEXl8WUnL/S/1lb/4lfLtXacuJPn3bo38/FEGv7U5UyKcnVNb
         N4gZqy35fqjuX+Y1t7cUud0mbRDj0NbcePXJpY90lYejri1sLMN7H6xDNXCwvSnCUrYg
         /eBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678806737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iBdDt0cqpy6mqZcYqnHeD+1brhs0HmWk0OP3dY1LAIs=;
        b=5yj2b19xazKsaxQWkdx5BSxByhXmGIAGHbTR/VSBTNJJUqv/b5rgC8qZjp0ctentX0
         y8e9UPzZPiUvqIgHwmXqtbhWoZq8Hq6jKpoxG1sQAKUfd0IoFkqcijYkLgXa7X4vA5yW
         p+neRIdJPoQD/Dmfl00ZpB8ZYPzsaGh6ARbs8Gb4N4GP6ZNp7OuKUQVJ4gCCkBgUxZZF
         rCEQiJCy5gCHNuw2yhjdz4pyXqDSOrcbziRvz2+G0k9pErtW+8mmIk5oOkE8LbECvRWc
         SBjYHRNjPRqXCS4ymVgrHb6SyC1kyttvrETRo2mMdxgV27N5zI5Qk51KvopqxNedEJPu
         l/fA==
X-Gm-Message-State: AO0yUKWP/pSCjcsjtHy406bEbg1h8aEuNX6D8AAkN9RWOnZw1FX+uzaI
        rDCg4BGH07MAoO4EvrRAk5bAQQ==
X-Google-Smtp-Source: AK7set/jcI3U128cMM2on2zzEwn9NAop4Sg1KGms+6lZ1FGcsl7EH6XsxSK0djTo3abrDjhQNtXGsQ==
X-Received: by 2002:adf:f30d:0:b0:2cf:e445:295f with SMTP id i13-20020adff30d000000b002cfe445295fmr3436047wro.61.1678806737399;
        Tue, 14 Mar 2023 08:12:17 -0700 (PDT)
Received: from blmsp.fritz.box ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id d9-20020a5d4f89000000b002c707b336c9sm2320158wru.36.2023.03.14.08.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:12:17 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 1/5] dt-bindings: can: tcan4x5x: Add tcan4552 and tcan4553 variants
Date:   Tue, 14 Mar 2023 16:11:57 +0100
Message-Id: <20230314151201.2317134-2-msp@baylibre.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314151201.2317134-1-msp@baylibre.com>
References: <20230314151201.2317134-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two new chips do not have state or wake pins.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 .../devicetree/bindings/net/can/tcan4x5x.txt          | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
index e3501bfa22e9..38a2b5369b44 100644
--- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
+++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
@@ -4,7 +4,10 @@ Texas Instruments TCAN4x5x CAN Controller
 This file provides device node information for the TCAN4x5x interface contains.
 
 Required properties:
-	- compatible: "ti,tcan4x5x"
+	- compatible:
+		"ti,tcan4x5x" or
+		"ti,tcan4552" or
+		"ti,tcan4553"
 	- reg: 0
 	- #address-cells: 1
 	- #size-cells: 0
@@ -21,8 +24,10 @@ Optional properties:
 	- reset-gpios: Hardwired output GPIO. If not defined then software
 		       reset.
 	- device-state-gpios: Input GPIO that indicates if the device is in
-			      a sleep state or if the device is active.
-	- device-wake-gpios: Wake up GPIO to wake up the TCAN device.
+			      a sleep state or if the device is active. Not
+			      available with tcan4552/4553.
+	- device-wake-gpios: Wake up GPIO to wake up the TCAN device. Not
+			     available with tcan4552/4553.
 
 Example:
 tcan4x5x: tcan4x5x@0 {
-- 
2.39.2

