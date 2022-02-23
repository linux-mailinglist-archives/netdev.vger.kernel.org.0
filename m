Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400DA4C08E1
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbiBWCdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237589AbiBWCdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:33:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1475E744;
        Tue, 22 Feb 2022 18:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B5716158A;
        Wed, 23 Feb 2022 02:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286A0C340F1;
        Wed, 23 Feb 2022 02:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583477;
        bh=n5T1+I/pmeyijBxU7FOIfuJEcV3dxvkqCaFuwww8pfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaaMVG+c0WqCz/jd4d/wfiYzh12XHTi57HeW18L1GEGlbopQAr74JcQuo0HUQ6m1h
         vF+8PYgTQCxgEOxE+PABZpUSObkW3nBnDB4osp8vL1/R6g0rfK4BAQNznugdYZR7OS
         d20mYVF+xH50xikzwQfprwfcg6n+jouKNvHIrxwsKrcDv2fXKlz4s6rfCM1+fFkxq2
         jgRipkdayNw2IsRj/WXhj7MyU0gZi4YTs1J6dfcQqsHsvH7Vzg6c/ywUQTawzj6+3b
         JzQp7cWf4oPu19jCqP4mjRaDH0CTS9VZPRgVvZLdKrlt0NT9AgpXM/PhwaQkBAKbEw
         TiqNdlhNrdzoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, oliver@neukum.org,
        kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/18] net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990
Date:   Tue, 22 Feb 2022 21:30:35 -0500
Message-Id: <20220223023035.241551-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023035.241551-1-sashal@kernel.org>
References: <20220223023035.241551-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 21e8a96377e6b6debae42164605bf9dcbe5720c5 ]

Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit FN990
0x1071 composition in order to avoid bind error.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_mbim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 77ac5a721e7b6..414341c9cf5ae 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -658,6 +658,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit FN990 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1071, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
-- 
2.34.1

