Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497A257F9BA
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 08:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiGYGzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 02:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiGYGzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 02:55:06 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFE910FEC
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 23:54:43 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ss3so18743190ejc.11
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 23:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WtIlfV0TRfMwcTJkeyhrUYfoxrMyuEr0LUCaeLfKOGs=;
        b=eMTP8obKLxAXQt5xnsDW4v+x9tBv4EwYSyNchPAH3P0UIyQvQFTNaXPhkutw6uB3Zk
         u9+cGI2Lm63FNRYheuipBTljqPAHvbJoaCua49D8YCxrSIy2aU8Et0ed98iF4uHvH3cY
         SUjfhRYUxAp8jBBlLAqk6ZnlbIk5X442/75cI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WtIlfV0TRfMwcTJkeyhrUYfoxrMyuEr0LUCaeLfKOGs=;
        b=2YKaZX1EBRInRyZMhpaRrBrwQA9Svvq8RAGTYCG63r9OYzkdKq6pnT5OJPLWDfDK86
         qWh2bm9sOij/erEM28QIMWHSPZcm5q9DiubpjYk6ibUXtaXDyiJTmbFGBt6PT8oUTPy5
         Lq4j/ObSesCEfqVyGb/iP6K3J/PWTc0oRz0mJGLQuKrxjW4KX/KWnhaSNczGM9+TKmy0
         +5fUHepWGPpN/fC4tXm5V4eyK80c7VX24yOofPjtkpEXlgXkoCayGNQKZaFMxB4XX71Y
         PW0IUM51D8zvO4kbNDcZeisgsw8vRlTnwnjkF6xWy8EWJYl3BW5Llxu83uMdUZtsr+0D
         HgjQ==
X-Gm-Message-State: AJIora8a9Vgjl5TCuFmftePNu5dKU/pQADU1D6vIvqwc6PjaNzb/9IAI
        XTdmFhCBwO1sm3Hb7PJB0xXJnA==
X-Google-Smtp-Source: AGRyM1uCFwgwAlh/8Q2w7NsXL5N7D0o4L6UMaDO7HEEYdidMdgTZqg4vkPY8gcdBpB23KukOVh3JLQ==
X-Received: by 2002:a17:907:7638:b0:72d:f11b:5ebb with SMTP id jy24-20020a170907763800b0072df11b5ebbmr8846038ejc.647.1658732069630;
        Sun, 24 Jul 2022 23:54:29 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-14-98-67.retail.telecomitalia.it. [87.14.98.67])
        by smtp.gmail.com with ESMTPSA id r2-20020a1709060d4200b00722e57fa051sm4967711ejh.90.2022.07.24.23.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 23:54:29 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 4/6] can: slcan: use the generic can_change_mtu()
Date:   Mon, 25 Jul 2022 08:54:17 +0200
Message-Id: <20220725065419.3005015-5-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is useless to define a custom function that does nothing but always
return the same error code. Better to use the generic can_change_mtu()
function.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

(no changes since v1)

 drivers/net/can/slcan/slcan-core.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 09d4abbbd9f4..919311890d2c 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -740,16 +740,11 @@ static int slcan_netdev_open(struct net_device *dev)
 	return err;
 }
 
-static int slcan_netdev_change_mtu(struct net_device *dev, int new_mtu)
-{
-	return -EINVAL;
-}
-
 static const struct net_device_ops slcan_netdev_ops = {
 	.ndo_open               = slcan_netdev_open,
 	.ndo_stop               = slcan_netdev_close,
 	.ndo_start_xmit         = slcan_netdev_xmit,
-	.ndo_change_mtu         = slcan_netdev_change_mtu,
+	.ndo_change_mtu         = can_change_mtu,
 };
 
 /******************************************
-- 
2.32.0

