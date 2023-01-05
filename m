Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEFB65E3AF
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 04:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjAEDn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 22:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAEDnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 22:43:22 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3658D48818;
        Wed,  4 Jan 2023 19:43:21 -0800 (PST)
Received: from localhost.localdomain (unknown [123.112.69.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C664D423FE;
        Thu,  5 Jan 2023 03:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1672890199;
        bh=QcyeiMxc53xNRUmehRoDhSrVpTlqeIkwOCpN4UX0Mvs=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=Y9pmU28lw/bl7EvlkVyOgCAQ9smvSSwBk99jbljBsAe04c7UKnFNBDYsmm3B+0vJB
         cL45pPLjbXrLy8crENWuyHkZQPABPWr4cMc1lcTYsMrOb5HnljzO6+VZOoEibV4ywD
         cNWXTbEqI+lAlsMTPPRV/gt/Ek/kweQZzoDue7+NWbkrhMjBWtovwTC8aJMs+GhueM
         9PCN1XFvbqy/aL1WrH5SDXrwtX+sOyFr1VNhXLvfzjWH4hL8vB99meSkCKaLGcriOX
         dbsV6lnRLhoI6mjTgXoV5r9aIHXNVaV226x/80278BVtJP0g3D+d5cP7dxlpE13/4a
         M1qbSC3juMGHw==
From:   Hui Wang <hui.wang@canonical.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        davem@davemloft.net, oliver@neukum.org, kuba@kernel.org
Cc:     hui.wang@canonical.com
Subject: [PATCH] net: usb: cdc_ether: add support for Thales Cinterion PLS62-W modem
Date:   Thu,  5 Jan 2023 11:42:49 +0800
Message-Id: <20230105034249.10433-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This modem has 7 interfaces, 5 of them are serial interfaces and are
driven by cdc_acm, while 2 of them are wwan interfaces and are driven
by cdc_ether:
If 0: Abstract (modem)
If 1: Abstract (modem)
If 2: Abstract (modem)
If 3: Abstract (modem)
If 4: Abstract (modem)
If 5: Ethernet Networking
If 6: Ethernet Networking

Without this change, the 2 network interfaces will be named to usb0
and usb1, our QA think the names are confusing and filed a bug on it.

After applying this change, the name will be wwan0 and wwan1, and
they could work well with modem manager.

Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/net/usb/cdc_ether.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 8911cd2ed534..c140edb4b648 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -1007,6 +1007,12 @@ static const struct usb_device_id	products[] = {
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
+}, {
+	/* Cinterion PLS62-W modem by GEMALTO/THALES */
+	USB_DEVICE_AND_INTERFACE_INFO(0x1e2d, 0x005b, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET,
+				      USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long)&wwan_info,
 }, {
 	/* Cinterion PLS83/PLS63 modem by GEMALTO/THALES */
 	USB_DEVICE_AND_INTERFACE_INFO(0x1e2d, 0x0069, USB_CLASS_COMM,
-- 
2.34.1

