Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A5A15C71
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfEGFfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfEGFfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:35:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4232087F;
        Tue,  7 May 2019 05:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207300;
        bh=ifEQPmsUCOHDvFEbi5HY2ksclEgvKvioGnD9ciCML8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Llo+5NuJpRJvzclmJk0aqv3bwhmUUV9kNIlYeHUw4VCVqKBPGrE2AIMy3azvc0I6
         X8d3p/d9dzi2Iu02uyW72YtNPs37cUi5PQPz2+Fg7g5aSAFpDZ743qQv0L2MADX20Q
         HszajeLXYh20w8NlOU4MMSrhGGObPCBnB1JoEDes=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 71/99] of_net: Fix residues after of_get_nvmem_mac_address removal
Date:   Tue,  7 May 2019 01:32:05 -0400
Message-Id: <20190507053235.29900-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Štetiar <ynezz@true.cz>

[ Upstream commit 36ad7022536e0c65f8baeeaa5efde11dec44808a ]

I've discovered following discrepancy in the bindings/net/ethernet.txt
documentation, where it states following:

 - nvmem-cells: phandle, reference to an nvmem node for the MAC address;
 - nvmem-cell-names: string, should be "mac-address" if nvmem is to be..

which is actually misleading and confusing. There are only two ethernet
drivers in the tree, cadence/macb and davinci which supports this
properties.

This nvmem-cell* properties were introduced in commit 9217e566bdee
("of_net: Implement of_get_nvmem_mac_address helper"), but
commit afa64a72b862 ("of: net: kill of_get_nvmem_mac_address()")
forget to properly clean up this parts.

So this patch fixes the documentation by moving the nvmem-cell*
properties at the appropriate places.  While at it, I've removed unused
include as well.

Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Fixes: afa64a72b862 ("of: net: kill of_get_nvmem_mac_address()")
Signed-off-by: Petr Štetiar <ynezz@true.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/net/davinci_emac.txt | 2 ++
 Documentation/devicetree/bindings/net/ethernet.txt     | 2 --
 Documentation/devicetree/bindings/net/macb.txt         | 4 ++++
 drivers/of/of_net.c                                    | 1 -
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/davinci_emac.txt b/Documentation/devicetree/bindings/net/davinci_emac.txt
index 24c5cdaba8d2..ca83dcc84fb8 100644
--- a/Documentation/devicetree/bindings/net/davinci_emac.txt
+++ b/Documentation/devicetree/bindings/net/davinci_emac.txt
@@ -20,6 +20,8 @@ Required properties:
 Optional properties:
 - phy-handle: See ethernet.txt file in the same directory.
               If absent, davinci_emac driver defaults to 100/FULL.
+- nvmem-cells: phandle, reference to an nvmem node for the MAC address
+- nvmem-cell-names: string, should be "mac-address" if nvmem is to be used
 - ti,davinci-rmii-en: 1 byte, 1 means use RMII
 - ti,davinci-no-bd-ram: boolean, does EMAC have BD RAM?
 
diff --git a/Documentation/devicetree/bindings/net/ethernet.txt b/Documentation/devicetree/bindings/net/ethernet.txt
index cfc376bc977a..2974e63ba311 100644
--- a/Documentation/devicetree/bindings/net/ethernet.txt
+++ b/Documentation/devicetree/bindings/net/ethernet.txt
@@ -10,8 +10,6 @@ Documentation/devicetree/bindings/phy/phy-bindings.txt.
   the boot program; should be used in cases where the MAC address assigned to
   the device by the boot program is different from the "local-mac-address"
   property;
-- nvmem-cells: phandle, reference to an nvmem node for the MAC address;
-- nvmem-cell-names: string, should be "mac-address" if nvmem is to be used;
 - max-speed: number, specifies maximum speed in Mbit/s supported by the device;
 - max-frame-size: number, maximum transfer unit (IEEE defined MTU), rather than
   the maximum frame size (there's contradiction in the Devicetree
diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 3e17ac1d5d58..1a914116f4c2 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -26,6 +26,10 @@ Required properties:
 	Optional elements: 'tsu_clk'
 - clocks: Phandles to input clocks.
 
+Optional properties:
+- nvmem-cells: phandle, reference to an nvmem node for the MAC address
+- nvmem-cell-names: string, should be "mac-address" if nvmem is to be used
+
 Optional properties for PHY child node:
 - reset-gpios : Should specify the gpio for phy reset
 - magic-packet : If present, indicates that the hardware supports waking
diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 810ab0fbcccb..d820f3edd431 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -7,7 +7,6 @@
  */
 #include <linux/etherdevice.h>
 #include <linux/kernel.h>
-#include <linux/nvmem-consumer.h>
 #include <linux/of_net.h>
 #include <linux/phy.h>
 #include <linux/export.h>
-- 
2.20.1

