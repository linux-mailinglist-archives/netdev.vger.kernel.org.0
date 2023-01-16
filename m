Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551A466C0C7
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 15:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjAPOEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 09:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjAPODl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 09:03:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E1522DDD;
        Mon, 16 Jan 2023 06:02:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 195F960FD4;
        Mon, 16 Jan 2023 14:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A942C433EF;
        Mon, 16 Jan 2023 14:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877772;
        bh=jMRHxHdq1QhiQ06HFdAzk5pUhUEEHqamDP94hK7sxw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGVGSyYnR2yBiMSNbPMQjJu5ZfW7orhlbvGdZKMpgFHGwkvF65qktdpihZ1QBbA7y
         pMdkTydOfhHB9hgZLGZK4vUKYdc1pFp8dmTV6l8UL3ZdQPT8WWd/ZNkFophepLJ/aO
         0+axvUkbCdRZoIWXdQGgJImUj+8EmZtJ0Qim8SCLzWcjYD0vhwsj7D+F7b9ZErAa22
         oYQXP8JcRPvuEd3omFY01t4igu6AREiSN/xdrrdgBFAXUoZvJnW0NnIlUkotCWKLkh
         8JiVwx5nAwG94KeSEABAPOdr0HnJrPjKFLCDOCafMGZxIsH3+SbuCVKnV7XGWr3gYX
         6QQhXtEuTTPbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Wang <hui.wang@canonical.com>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oliver@neukum.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 17/53] net: usb: cdc_ether: add support for Thales Cinterion PLS62-W modem
Date:   Mon, 16 Jan 2023 09:01:17 -0500
Message-Id: <20230116140154.114951-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
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

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit eea8ce81fbb544e3caad1a1c876ba1af467b3d3c ]

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
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20230105034249.10433-1-hui.wang@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ether.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index e11f70911acc..fb5f59d0d55d 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -1001,6 +1001,12 @@ static const struct usb_device_id	products[] = {
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
2.35.1

