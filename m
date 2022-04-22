Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFE150AF3D
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 06:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443975AbiDVEry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 00:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbiDVErx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 00:47:53 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F58B3A;
        Thu, 21 Apr 2022 21:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1650602701;
  x=1682138701;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ToZPNNcFICAl5kNbjhROOShmc9lRKbW7VGDIpg6Onc0=;
  b=mKVCfG8m+RiEOZudWI1wsw+PYV7sSVFJALuIGiJWp0cTtOQZh+46BZgq
   fUhlBasLgoTOyMTUv8BSuI15eLtmCoqimaOTBV/PVlo9EeIRWx+245IIg
   KlIziBqfT/3wo1S07gv60hhnknCPbizRp8oD7A1kEcb3EqiN6vaF8O1VD
   jV5WkR9cEwCW1NVO/pkzc59mxGTqvQqcoOqSxqhGOe8SZKhCSfmyapCwU
   EMvB5DBu5WZMEb90jUgGoGX2NMZrvjPxFeg2TZbEdwdV3bLlVR0trEFUB
   2czQSZyt9l4kEumjV4P1q9tSwgHZm7lDbvG0pLzX8BoUYiEnpi1UjvFYN
   A==;
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
Subject: [PATCH v2] brcmfmac: of: introduce new property to allow disable PNO
Date:   Fri, 22 Apr 2022 12:44:18 +0800
Message-ID: <20220422044419.3415842-1-chenhui.zhang@axis.com>
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

Notes:
    Change property name to brcm,pno-disable

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

