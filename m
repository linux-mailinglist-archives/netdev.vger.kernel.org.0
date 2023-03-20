Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED556C0820
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 02:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjCTBGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 21:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbjCTBEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 21:04:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E1E241C3;
        Sun, 19 Mar 2023 17:57:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CBD36120C;
        Mon, 20 Mar 2023 00:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AD8C433EF;
        Mon, 20 Mar 2023 00:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273820;
        bh=rGOylEbBdtLBRqjtOZfHT8fiSLOclytQL9tB5qiDpNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqkedQ7a2EZ14khfPz7F2sb28WOTuHfV0sCRHVJBmnmAPt9UyhCNX4XjIa/o58PZa
         +/PidVDhXuwpkkELovJTsrOIwBjnfG/9iP3Vy0nQLGd+V1xc4V07kTqx3Bny98KGjh
         pGQi1VTra2Xq5IAkyQVXOp0mPmChQpwwxNOKvyWbS2LeIspI2Zp8NzfZbU+Z2GbYZo
         WBKQ8Q85iojgmXy5hFQ93/V49kvi2EV5XwXJIgK6WJUA4tNwEP3zozMoH+OryFYtva
         v025XpRdUTG11KL+AzeNYyNXrJWK1AyH/ru27CLZqJtw+TMSYHO6rQ05bK/SaZ2dKF
         gFLDEUyK3iFpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enrico Sau <enrico.sau@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, oliver@neukum.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/12] net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
Date:   Sun, 19 Mar 2023 20:56:33 -0400
Message-Id: <20230320005636.1429242-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005636.1429242-1-sashal@kernel.org>
References: <20230320005636.1429242-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Sau <enrico.sau@gmail.com>

[ Upstream commit 418383e6ed6b4624a54ec05c535f13d184fbf33b ]

Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit FE990
0x1081 composition in order to avoid bind error.

Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
Link: https://lore.kernel.org/r/20230306115933.198259-1-enrico.sau@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_mbim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 414341c9cf5ae..6ad1fb00a35cd 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -663,6 +663,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit FE990 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1081, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
-- 
2.39.2

