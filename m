Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36066C07C8
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 02:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjCTBBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 21:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjCTBA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 21:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE1B22C99;
        Sun, 19 Mar 2023 17:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 747A561204;
        Mon, 20 Mar 2023 00:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65EFC4339C;
        Mon, 20 Mar 2023 00:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273701;
        bh=jgqAc7iZHAa0GR2DPbVeeL1gHqNdIY3gDSJ9wzC7zxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kk7f2wHLi4A1Qr2Qew/nxoVS+qxcXaubiYBwOeBXvqJ+kAdj3tOHLeN6XauJSBxJ7
         eiEsn752TfSP/tJRAHAS33D1fK7mWlxVnHMZcXIIHT09k4Habd6ZP1lnmes1vElsNC
         9GeS+NXRo/ahuKAdWOBwPLiCC6HWXyEGgXX0SSKC7IwwGe2hrX+8JMLCiFApSJXdf7
         FkL7rot2sK+tlC22vlnZbjFrrPr8aQ0xWYLT55IHIvhQY6J+V7kOAGfqU7anpj8QoV
         j1xZK66RcNqavjx0CYR1LxfTwXdPwgcUJumyaEh43WbVWxRfCxkfMeW07kbKCE1EhD
         RTnXEDgvjBduw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enrico Sau <enrico.sau@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, oliver@neukum.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 24/29] net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
Date:   Sun, 19 Mar 2023 20:54:06 -0400
Message-Id: <20230320005413.1428452-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005413.1428452-1-sashal@kernel.org>
References: <20230320005413.1428452-1-sashal@kernel.org>
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
index c89639381eca3..cd4083e0b3b9e 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -665,6 +665,11 @@ static const struct usb_device_id mbim_devs[] = {
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

