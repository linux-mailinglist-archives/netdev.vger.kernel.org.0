Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A94450CE6D
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 04:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbiDXCZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 22:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiDXCZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 22:25:30 -0400
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BD8237FD;
        Sat, 23 Apr 2022 19:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1650766950;
  x=1682302950;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QDh0au46jwGUKNxxZkaZpw8h8HU6jf4Ztj+mwSJXuEk=;
  b=hoRItIIpXJVMNqiT1T4kGsVH4TPcT9U+AlvzuxlBZUFSWIEfP4BfnK76
   ZCQ/m7PB5udbTK5mjIW7hfSJyxI8tBfNjM9+EmY+CXnGdvhikq6O3OHaE
   /pIq+4Mi9PAarSBEjoAtbOE3u7YOl9eSRA41qgOxO7mgTCb1gUdQZu7zt
   bCreesVyHjovGu7mZO/rlQbc85G/rwxQQL5nTknWaTph6xVGxZRfqQFgJ
   QyRRYUvB7vTntHFRGZcE00Hz7khDoQUx3Yl6GfuNBzL2XTZHHhMRTwvz7
   4ZpV25h/tj+PXPuGxO1k/OxuGa+HkNiV1ahslMYh6bxu5VBRVYszAKzhg
   w==;
From:   Hermes Zhang <chenhui.zhang@axis.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <kernel@axis.com>, Hermes Zhang <chenhuiz@axis.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] brcmfmac: of: introduce new property to allow disable PNO
Date:   Sun, 24 Apr 2022 10:22:24 +0800
Message-ID: <20220424022224.3609950-1-chenhui.zhang@axis.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hermes Zhang <chenhuiz@axis.com>

Some versions of the Broadcom firmware for this chip seem to hang
if the PNO feature is enabled when connecting to a dummy or
non-existent AP.
Add a new property to allow the disabling of PNO for devices with
this specific firmware.

Signed-off-by: Hermes Zhang <chenhuiz@axis.com>
---

Notes:
    Comments update

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 8623bde5eb70..121a195e4054 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -11,6 +11,7 @@
 #include "core.h"
 #include "common.h"
 #include "of.h"
+#include "feature.h"
 
 static int brcmf_of_get_country_codes(struct device *dev,
 				      struct brcmf_mp_device *settings)
@@ -102,6 +103,9 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	if (bus_type != BRCMF_BUSTYPE_SDIO)
 		return;
 
+	if (of_find_property(np, "brcm,pno-disable", NULL))
+		settings->feature_disable |= BIT(BRCMF_FEAT_PNO);
+
 	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
 		sdio->drive_strength = val;
 
-- 
2.30.2

