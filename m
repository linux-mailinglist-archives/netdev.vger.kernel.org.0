Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEC867FC54
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 03:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjA2C1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 21:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjA2C1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 21:27:03 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205A923339;
        Sat, 28 Jan 2023 18:27:03 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso11054975pju.0;
        Sat, 28 Jan 2023 18:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hy9KvguFc2gDUCrzkC+qChu1ABG5IuB/NXRbpfk20C0=;
        b=WvbT2tInonx13nAi6GfeETQXmxg2vbMEdJEaGo/kXSVJPGaaMvTnEIUqJ567lFGDEt
         ddbMsrGUybFe7ewIczVzJ16c9uX2DSEbihjh4TWqiVyZjoXO44hpAMWIcuo3HfZAOg7O
         Sw2F2h4ZDP9dUm3FcQZLUimDNETpb4x2T1/LIS99zdJoJtvMoD93psRbjc1SNyVUtjxK
         FtoFaFLop+2PeCTwmK43LPCwdvYsHuJzmGpYxWIronqZe+mTx6jWF+hdJbL15qjmfYfo
         pIfLTEq8x4ahJZQ8DqoFaKdVxCYGo9Y0uf0UDhbma6Zqt+ejV53pZBE3IUkRpbOmbUAr
         AqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hy9KvguFc2gDUCrzkC+qChu1ABG5IuB/NXRbpfk20C0=;
        b=7RCUp36xYhxjYGGKApcUd498dgDBk2xMpI0Es7TD2kM7p/v38QsS49xndwMVz+s27y
         TTGJKCD6TYVESwAzCjguUJSrmwM8uzx6snl5YRWKEJxfwJ3MQdcxts4wQYob2TbYcoH7
         jbOGGIC7GXcZ2nYZzlWTQTaX/IFFtI23wVz0Rht2Bj3qK1Hg0SWmqWCRUvXDYQaULS4l
         XYj90L521sAvWtlWTJzDSywEW1bUEFKmHTTRVMlNA4YcE0hd+8Kkdo4My2R1RoXs/Zu3
         hSGLdQgFSEBZKgUD6/KthK68sk5pTjSXpq+VfKGlF7Zdc0DKZZ8n7ZztdWXMt+x7DIvJ
         Hjcg==
X-Gm-Message-State: AFqh2kopQTUJWaMuGTCHMJ4xtYcAzLWjmkOJLdjrk6jsZNqtqRvc7u3c
        lxt35wQFINQKRRg4CiO8gVEWp9+OzvE53Q==
X-Google-Smtp-Source: AMrXdXuvaM36unwlhcOHxtKzhidkbEqTMEzaTXPGrTe4vG4g0hG0lWMeXsNIxWaEYuYqw5wjJN87GA==
X-Received: by 2002:a05:6a21:3294:b0:a4:414c:84c5 with SMTP id yt20-20020a056a21329400b000a4414c84c5mr61940516pzb.12.1674959222534;
        Sat, 28 Jan 2023 18:27:02 -0800 (PST)
Received: from localhost.localdomain.com (2603-8001-4200-6311-92a0-3d53-9224-b276.res6.spectrum.com. [2603:8001:4200:6311:92a0:3d53:9224:b276])
        by smtp.gmail.com with ESMTPSA id t1-20020aa79461000000b0058da7e58008sm4904189pfq.36.2023.01.28.18.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 18:27:02 -0800 (PST)
From:   Chris Healy <cphealy@gmail.com>
To:     cphealy@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com
Cc:     Chris Healy <healych@amazon.com>
Subject: [PATCH 1/1] net: phy: meson-gxl: Add generic dummy stubs for MMD register access
Date:   Sat, 28 Jan 2023 18:26:15 -0800
Message-Id: <20230129022615.379711-1-cphealy@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Healy <healych@amazon.com>

The Meson G12A Internal PHY does not support standard IEEE MMD extended
register access, therefore add generic dummy stubs to fail the read and
write MMD calls. This is necessary to prevent the core PHY code from
erroneously believing that EEE is supported by this PHY even though this
PHY does not support EEE, as MMD register access returns all FFFFs.

Signed-off-by: Chris Healy <healych@amazon.com>
---
 drivers/net/phy/meson-gxl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index c49062ad72c6..5e41658b1e2f 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -271,6 +271,8 @@ static struct phy_driver meson_gxl_phy[] = {
 		.handle_interrupt = meson_gxl_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
 	},
 };
 
-- 
2.39.1

