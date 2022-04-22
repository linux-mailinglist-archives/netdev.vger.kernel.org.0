Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428A550AE7D
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 05:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443733AbiDVD1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 23:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443780AbiDVD1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 23:27:37 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA4C4D623;
        Thu, 21 Apr 2022 20:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1650597885;
  x=1682133885;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bDkBpCp5feiSpGjQLvuWHjxX6inrI6WZw2ly5p4/hyc=;
  b=N9pLSulflr/MM0RUc0XqBOIWnAq6kiaaQJGofAMCTLKAoGcBQnW34b+y
   zOzr2jQPzLv7RecuQxmwQjsxKsc4QBUnXXVgvzJryKJe2qdmS3LgbWbIX
   7Yb299Gqh+z/D43Fam19M/W/l1D4X2i0f8WtsbIi5VXt/qKH8wIT2Yj7w
   D8A8XuiqaIkYVz81hoO1FrOBfFyfEnOX2zLOqKQtvVIcMCFlSiqI06I2g
   j2FVpsLg6vZCUkmLKPEzu+cPZ4TvOUpyxOz9tfLwT4lGQpcBqXpq03xDf
   rHMOEISXg5ZKO+NBDoPrMLHfnNjNQYUc9j9ULhX/F6Z3U9JDFZdY8eE62
   w==;
From:   Hermes Zhang <chenhui.zhang@axis.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     <kernel@axis.com>, Hermes Zhang <chenhuiz@axis.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] brcmfmac: of: introduce new property to allow disable PNO
Date:   Fri, 22 Apr 2022 11:24:28 +0800
Message-ID: <20220422032428.3404284-1-chenhui.zhang@axis.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hermes Zhang <chenhuiz@axis.com>

The PNO feature need to be disable for some scenario in different
product. This commit introduce a new property to allow the
product-specific toggling of this feature.

Signed-off-by: Hermes Zhang <chenhuiz@axis.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 8623bde5eb70..15f190368a8b 100644
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
 
+	if (of_find_property(np, "pno-disable", NULL))
+		settings->feature_disable |= BIT(BRCMF_FEAT_PNO);
+
 	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
 		sdio->drive_strength = val;
 
-- 
2.30.2

