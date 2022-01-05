Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C57348544C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbiAEOYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:24:31 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:38716
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237053AbiAEOYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:24:25 -0500
Received: from localhost.localdomain (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 7E3F53F129;
        Wed,  5 Jan 2022 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641392663;
        bh=kpiR3hGZ1YMl+duakY0dudCeJayHgZbwxzG9jKIogcE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=WkTmsM4/Pymb/UGBegpUrHjrv07RqBTsBJHiMG+zUfJjMOU8Wk7Z2vC//OoA1K7fG
         n3byh/a3wadCMD7Cez59o9Cgdgnf/FgyQ/uGWoSZiJDQNHxZyPikhi6wv2G0DJAC7Y
         mRW9LOW80159v+EOPHjd/kc/95T3kGsPke9cR+dVc3lLjkAHygLweREUb3H3MYC+1d
         qHade1jFnsp4L7N3Zn8mQX2njE92bBGnrwJZqQJYFvd+MWZjzr0aWFQEmtjrzvRij7
         e2LqGESQrVqur7x0bDmlZgdFhUpshm540/cNgxKdn84ZGKY+L98j0s9rgVjg/outwb
         9Bi0DiTgjkI8g==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: [PATCH 2/3] net: usb: r8152: Set probe mode to sync
Date:   Wed,  5 Jan 2022 22:23:50 +0800
Message-Id: <20220105142351.8026-2-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105142351.8026-1-aaron.ma@canonical.com>
References: <20220105142351.8026-1-aaron.ma@canonical.com>
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
index 91f4b2761f8e..3fbce3dbc04d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -29,6 +29,8 @@
 #include <crypto/hash.h>
 #include <linux/usb/r8152.h>
 
+static struct usb_driver rtl8152_driver;
+
 /* Information for net-next */
 #define NETNEXT_VERSION		"12"
 
@@ -9545,6 +9547,9 @@ static int rtl8152_probe(struct usb_interface *intf,
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

