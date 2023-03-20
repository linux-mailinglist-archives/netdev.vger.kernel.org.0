Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CA96C07AC
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 02:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjCTBAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 21:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjCTA7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 20:59:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731EA15892;
        Sun, 19 Mar 2023 17:56:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D871B80D48;
        Mon, 20 Mar 2023 00:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E596DC433A4;
        Mon, 20 Mar 2023 00:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273752;
        bh=SZD2Uqk7lzpzQejhqNU3qpNtjO2T4UECxmKjCx03kz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okbu8MOtFTZXS6rYu8ul+5nFZ3flOdrBIoYHoVOXsGTk8a3doipUIWeyzR8rdsGOE
         z99l77WUuCwD3ADDX3JQgrWQ/0jpi5zfcugsD89isWfFw3Y1DubWA1zc2y+MnvEAOd
         fQzXVPy3ZgJBtUYzVVuN8VUSK0fWVl0C0TiYG/NDFdFtGswMnnzwNVjzvE3EPgCYa1
         jFieundU4NdIXOyBeeriEyUrwO6MevkXarHM9+//SIwQJQ/S15WIxXyqBREMFzvPRH
         IEAc77fW+wgAYwIgfwZQwQv6b4yfZXklPgOSsQgTQhKktm2/IIGwPgjIKweWNubwy+
         ZU5CGy9KfY+Jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enrico Sau <enrico.sau@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, oliver@neukum.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/17] net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
Date:   Sun, 19 Mar 2023 20:55:17 -0400
Message-Id: <20230320005521.1428820-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005521.1428820-1-sashal@kernel.org>
References: <20230320005521.1428820-1-sashal@kernel.org>
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
index c0b8b4aa78f37..a3ccf0cee093c 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -664,6 +664,11 @@ static const struct usb_device_id mbim_devs[] = {
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

