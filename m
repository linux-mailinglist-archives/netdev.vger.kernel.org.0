Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14587583932
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbiG1HDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbiG1HDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:03:13 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AAC5F99A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:11 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z22so1003145edd.6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aNGQLRTnPxlP6A96D7J1ivHff8xTlXOO4TAacZru318=;
        b=NixWIxUerULCg3FM+cnzFFOF13OA6uqtP9jW5CJygFwUBq6CkojjWu3Ex8IMlgKxPg
         e47d34vcuwDsFDJm3JWApkUUIPvEBe5EKLPqbtsImbdiBwY9Lf5/JidqqrNnDg6LR1XH
         Se0Mlb3kDA68wzj4aX6IKP8edThjDkhrYgsoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aNGQLRTnPxlP6A96D7J1ivHff8xTlXOO4TAacZru318=;
        b=HUkdmDOH2n6eLyuhujWyTT27UliFvhINkyj9k78VjCHFVjlFI5kwux6uYh9T0T3uik
         hzJp6CXtHY3lDB3t4g/x/wjIdEhwGNfpq5MrGvLE7MgQ5ajXm6HtKjgZHzc0vZLRzDha
         8YuMMTZY04V8Pmo3+Dku/7LN0jpA0R2KzXIXt9ivBWXA3IQ1tIsooaiWFfqs2T3f2HUK
         OjJ6a5goxhl3HP5Vfkpbi3YucNE9jLHwlF6PV7zpSZcCCgzpPVgvJtpAGJGOZeJbv31Y
         pyfv7Am/rr6/s33HKqmA4xe9Hy2AKxvy+8TkrOlocIFLu+CD9Y48Z9Kal1/thtMYy/nP
         FlDA==
X-Gm-Message-State: AJIora/HpGRP8FCWJsS1A2Vh0uDxHNK5nbGgtGFtaWw8y7EI5MplsuDV
        qbA0Xoj7HtTzRieJwn9gULOL+Q==
X-Google-Smtp-Source: AGRyM1sW5lx3Slj726RXZEGv5WZ7pNAuYrxHGJowrHZRoGZVE59uH/w0nSGFMTcUJpW2vMINSFhH7Q==
X-Received: by 2002:a05:6402:2b88:b0:43a:6c58:6c64 with SMTP id fj8-20020a0564022b8800b0043a6c586c64mr27065401edb.348.1658991790073;
        Thu, 28 Jul 2022 00:03:10 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id r18-20020aa7d152000000b0042de3d661d2sm154742edo.1.2022.07.28.00.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 00:03:09 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [PATCH v4 5/7] can: slcan: use the generic can_change_mtu()
Date:   Thu, 28 Jul 2022 09:02:52 +0200
Message-Id: <20220728070254.267974-6-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
References: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
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

