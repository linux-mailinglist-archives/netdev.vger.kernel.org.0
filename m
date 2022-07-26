Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7551581B92
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbiGZVDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239832AbiGZVDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:03:33 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EA62CE2D
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:03:31 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id z23so28033746eju.8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aNGQLRTnPxlP6A96D7J1ivHff8xTlXOO4TAacZru318=;
        b=KECnBmgqIAt05NhVOP7rOcoZ3GX1Rgo9FMzMDQUFPRBWamVIalBGJXkBxMF1ljKl/x
         VfTmGxVlppiIeRodycyrkpksqUK1EtDqYzeWmrZy1C3E8PK6qf2gXxLwVNB3BUvXyYrV
         EInTtznQ8iYeLZk7/yagV2umvWf2ZWXSX6q00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aNGQLRTnPxlP6A96D7J1ivHff8xTlXOO4TAacZru318=;
        b=zlp8P9TJ1szemzoeCriW7fHckIRVIg4kasTE7HXlfM7lSlofW+8wQHN+zHnDC/1r33
         WBJX5vxCDKLv3BuyEBmLA0OVF1lpiKODLVU8ordU7DGqCnN/+cTZcHGS6boQIvGuHrVp
         /92zHXg10H74tKrK9EzChbFDahm2svRFRV9OteAocSBbIUY1IsE0COv5hrbT5xh5Ys48
         931kdck5U9tUgpXkRhmCm5565lg5MYKH0Imjves4aSjhWg5Soh3PkXjP3kS8VX0lW6od
         LLzc6VfCnsVTriEeXA1h5sy1NGl8GiC68lb9q1BTwUsXB2fKF2bgJKO6TQHS8FSwz+o1
         A27Q==
X-Gm-Message-State: AJIora9vM2d1w69u/LLcmGjSbxzrevjPvbF2DZ+THOmYURX6VyV78hRZ
        MyV6KbjZCHzHhFoUXcr/hUhf+36i2546yw==
X-Google-Smtp-Source: AGRyM1t+InpFB1jgLKc7ZMEi3BQwy6b/qxSpP+DL9S00Ravpayp4aI7dQnTnjinto4kAzFne6jGuAw==
X-Received: by 2002:a17:906:ef8b:b0:72b:4a67:8ae5 with SMTP id ze11-20020a170906ef8b00b0072b4a678ae5mr15506155ejb.763.1658869410261;
        Tue, 26 Jul 2022 14:03:30 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-14-98-67.retail.telecomitalia.it. [87.14.98.67])
        by smtp.gmail.com with ESMTPSA id y19-20020aa7d513000000b0043a7293a03dsm9092849edq.7.2022.07.26.14.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 14:03:29 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [RFC PATCH v3 5/9] can: slcan: use the generic can_change_mtu()
Date:   Tue, 26 Jul 2022 23:02:13 +0200
Message-Id: <20220726210217.3368497-6-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
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
index bd8e84ded051..d12d98426f37 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -742,16 +742,11 @@ static int slcan_netdev_open(struct net_device *dev)
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

