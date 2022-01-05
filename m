Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1216C485594
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbiAEPPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:15:01 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:55758
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236895AbiAEPO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:14:59 -0500
Received: from localhost.localdomain (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 567A141956;
        Wed,  5 Jan 2022 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641395692;
        bh=jEhTx+5dXw4m5tKE7W3cRqAYGHANY0YdE7tGhPAYpTs=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ccu6+Sqo5rVd24pj4A7He5epkO3TTKbMIBEo4gLaM8kMPOM/Vz7vXFPyzxYAhANB/
         cq6TdpYGglXmz12T5aLuJ6RM6ETwZjqV8qh9nB0gtmAV8H2D67AHboYQPlFGyfTUWc
         wt+12ZBYb3Xr+0Ea+5IJBa+qFxFwEHCiiPdcVYW2Oddc/xP8Refq67Yn8iyuPHIkU0
         vKAOYRy6rQzb3CN9cJDZZaskxWSca3fWb6Y9/Ng9LjUB/LLihLW5NIfYjGjxieUlqH
         EM+k4GdBa/VfF/H9uBQ3piaBbIb6EBF/jG4j51w2Ugiv5+v/CxmhzE413zUaT1vFXO
         aPEgbjbd8RJOQ==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: [PATCH 2/3] net: usb: r8152: Set probe mode to sync
Date:   Wed,  5 Jan 2022 23:14:26 +0800
Message-Id: <20220105151427.8373-2-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105151427.8373-1-aaron.ma@canonical.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid the race of get passthrough MAC,
set probe mode to sync to check the used MAC address.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/usb/r8152.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2483dc421dff..7cf2faf8d088 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -29,6 +29,8 @@
 #include <crypto/hash.h>
 #include <linux/usb/r8152.h>
 
+static struct usb_driver rtl8152_driver;
+
 /* Information for net-next */
 #define NETNEXT_VERSION		"12"
 
@@ -9546,6 +9548,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 	struct r8152 *tp;
 	struct net_device *netdev;
 	int ret;
+	struct device_driver *rtl8152_drv = &rtl8152_driver.drvwrap.driver;
+
+	rtl8152_drv->probe_type = PROBE_FORCE_SYNCHRONOUS;
 
 	if (version == RTL_VER_UNKNOWN)
 		return -ENODEV;
-- 
2.30.2

