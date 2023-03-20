Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851FE6C07AF
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 02:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjCTBAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 21:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjCTBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 21:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2811522A26;
        Sun, 19 Mar 2023 17:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB5E8B80D54;
        Mon, 20 Mar 2023 00:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C83C4339E;
        Mon, 20 Mar 2023 00:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273789;
        bh=rGOylEbBdtLBRqjtOZfHT8fiSLOclytQL9tB5qiDpNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjhH9yeT1C7MQNMLOyyiVEA2vdYk9JiPoo0XAg59sFIEExyc1SGEgUt41KMAooZeO
         RGC7r53DwO79b6TA5YWZycNbyGzL1n0bI68ELiT+OH32/kDf7wlTfCMlRlTKU/QuBt
         C9IqGPI0AHxAuxjpGSrj0Tt2mCyuZJLHrds4wtuqqE1rx3SG20ajRvERvIRezWJmg7
         HwKTRQov98XKLmSHGCkxZMm6/u+Csa0O3QkKKjrg9y70LFbezF/mMpEtNQ5k5pWRHu
         4Gf6ZM/0OENEKbISFKtr8QglzDnMIZtRivGrhFX1YlRTkJ53MYWC1EpnNYEAEtynZd
         ZAQWkPZwn5FKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enrico Sau <enrico.sau@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, oliver@neukum.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/15] net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
Date:   Sun, 19 Mar 2023 20:55:57 -0400
Message-Id: <20230320005559.1429040-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005559.1429040-1-sashal@kernel.org>
References: <20230320005559.1429040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

