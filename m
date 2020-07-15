Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A850221464
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgGOSl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgGOSlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:41:25 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED08C08C5DE;
        Wed, 15 Jul 2020 11:41:24 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 06FIfLqG016725
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 15 Jul 2020 20:41:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1594838481; bh=O6NGNUTrDmAPLM5aIYNRzBtOHhnhqhtarfs2QFZbUqw=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=nuP9VuaaXzi+IaPkQ/Rq3jhUXORCKFe1ramEdAoiTZf89aua46tgVP0Btzn8DRjbH
         LRFywMgxaEnMH/skyWBUYozJWsV+P3c3uxaIOyuLcG5DZqjpxSU2mP31irDbMkuPE/
         exjZUDLKK0KOuWf760jkd1GHq27lGpvG6vtLqcnQ=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1jvmLI-000SSf-Ih; Wed, 15 Jul 2020 20:41:20 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, wxcafe@wxcafe.net, oliver@neukum.org,
        =?UTF-8?q?Miguel=20Rodr=C3=ADguez=20P=C3=A9rez?= 
        <miguel@det.uvigo.gal>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v5 net-next 5/5] net: cdc_ncm: hook into set_rx_mode to admit multicast traffic
Date:   Wed, 15 Jul 2020 20:41:00 +0200
Message-Id: <20200715184100.109349-6-bjorn@mork.no>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200715184100.109349-1-bjorn@mork.no>
References: <20200715184100.109349-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>

We set set_rx_mode to usbnet_cdc_update_filter provided
by cdc_ether that simply admits all multicast traffic
if there is more than one multicast filter configured.

Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/cdc_ncm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index f5d7b933792b..e04f588538cc 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1896,6 +1896,7 @@ static const struct driver_info cdc_ncm_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
+	.set_rx_mode = usbnet_cdc_update_filter,
 };
 
 /* Same as cdc_ncm_info, but with FLAG_WWAN */
@@ -1909,6 +1910,7 @@ static const struct driver_info wwan_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
+	.set_rx_mode = usbnet_cdc_update_filter,
 };
 
 /* Same as wwan_info, but with FLAG_NOARP  */
@@ -1922,6 +1924,7 @@ static const struct driver_info wwan_noarp_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
+	.set_rx_mode = usbnet_cdc_update_filter,
 };
 
 static const struct usb_device_id cdc_devs[] = {
-- 
2.27.0

