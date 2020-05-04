Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DF71C34E7
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgEDIvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728399AbgEDIvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:11 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F17C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:11 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a32so3495663pje.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7sta9v+U1plCsk4+OjGX/PaU6f7OTLTWW95Xf2K3yQ8=;
        b=IhCNQijXwI2WxhJvZkSYG3lQc7cF5/Qh4WN0AoVDCCn/UcVi3c6etz9Vy/ONVqmnsa
         BkAuFjYIFYDi29UvTmC5RvhvXszVSh31ckzeFJ5NaH8Px9X6DZvyTzSFoI4ntqMwPH4N
         Oj9H1U5Q9a7N/6LGVka/0wFlccGD7IS0u1lcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7sta9v+U1plCsk4+OjGX/PaU6f7OTLTWW95Xf2K3yQ8=;
        b=HcBEENIYYNtbWG3JiLG5EofVrHVS9a1oLV/0+vikq0Io9Vwt9RBbIgvmc3T9NPSd5e
         gX4kFng10jRu8kKhQo2JdMC265ST0/kEIOpIyM1vL4DsURH1bar0W4p0uvCXkcRwf9yN
         jTWc9XvZJJbSKTKeSNhe7IstKqT9OrdZ3Kg740pmFUgyL2G8RlyzO88Ic7i/2e8F4Fed
         qn6ldI2u/ReM3eMwnIikXAvZkDHFUWEoOD79A4uXjRl/G4nrRZfw4RZDKs7TbM585afX
         Mm8QgZNA0+/gbpTbC0joIL4yhv/FKHq64qsEku9QU37+WxpuvxXDMSzG1e7aT5XdSBAB
         VFGg==
X-Gm-Message-State: AGi0Puam5rIWUHfnA09kI1Bw1n5EwQRuDnrkv9YSY9DHAxp22wP2VR+7
        pUbendd/r8xCEql4Mazsw8hP287Sn/U=
X-Google-Smtp-Source: APiQypIL/4GkS5+ArvlE+qevjHLjqV7W33x5+dq/6uTsht1udMNlelXaHeGtDHWheCzSLv+I/0ikPA==
X-Received: by 2002:a17:902:8b86:: with SMTP id ay6mr4388076plb.338.1588582270659;
        Mon, 04 May 2020 01:51:10 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:10 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next 07/15] bnxt_en: fix ethtool_reset_flags ABI violations
Date:   Mon,  4 May 2020 04:50:33 -0400
Message-Id: <1588582241-31066-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

The ethtool ABI specifies that the reset operation should only clear
the flags that were actually reset. Setting the flags to zero after
a chip reset violates this because it does not include resetting the
application processor complex. Similarly, components that are not yet
defined are also not necessarily being reset.

The fact that chip reset does not cover the AP also means that it is
inappropriate to treat these two components exclusively of one another.
The ABI provides a mechanism to report a failure to reset independent
components via the returned bitmask, so it is also wrong to fail hard
if one of a set of independent resets is not possible.

It is incorrect to rely on the passed by reference flags in bnxt_reset(),
which are being updated as components are reset. The initially requested
value should be used instead so that hard errors do not propagate if any
earlier components could have been reset successfully.

Note, AP and chip resets are global in nature. Dedicated resets are
thus not currently supported.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 47 ++++++++++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  8 +++-
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index d99da82..9937c21 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2999,7 +2999,10 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 static int bnxt_reset(struct net_device *dev, u32 *flags)
 {
 	struct bnxt *bp = netdev_priv(dev);
-	int rc = 0;
+	u32 req = *flags;
+
+	if (!req)
+		return -EINVAL;
 
 	if (!BNXT_PF(bp)) {
 		netdev_err(dev, "Reset is not supported from a VF\n");
@@ -3013,33 +3016,33 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 		return -EBUSY;
 	}
 
-	if (*flags == ETH_RESET_ALL) {
+	if ((req & BNXT_FW_RESET_CHIP) == BNXT_FW_RESET_CHIP) {
 		/* This feature is not supported in older firmware versions */
-		if (bp->hwrm_spec_code < 0x10803)
-			return -EOPNOTSUPP;
-
-		rc = bnxt_firmware_reset_chip(dev);
-		if (!rc) {
-			netdev_info(dev, "Reset request successful.\n");
-			if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET))
-				netdev_info(dev, "Reload driver to complete reset\n");
-			*flags = 0;
+		if (bp->hwrm_spec_code >= 0x10803) {
+			if (!bnxt_firmware_reset_chip(dev)) {
+				netdev_info(dev, "Firmware reset request successful.\n");
+				if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET))
+					netdev_info(dev, "Reload driver to complete reset\n");
+				*flags &= ~BNXT_FW_RESET_CHIP;
+			}
+		} else if (req == BNXT_FW_RESET_CHIP) {
+			return -EOPNOTSUPP; /* only request, fail hard */
 		}
-	} else if (*flags == ETH_RESET_AP) {
-		/* This feature is not supported in older firmware versions */
-		if (bp->hwrm_spec_code < 0x10803)
-			return -EOPNOTSUPP;
+	}
 
-		rc = bnxt_firmware_reset_ap(dev);
-		if (!rc) {
-			netdev_info(dev, "Reset Application Processor request successful.\n");
-			*flags = 0;
+	if (req & BNXT_FW_RESET_AP) {
+		/* This feature is not supported in older firmware versions */
+		if (bp->hwrm_spec_code >= 0x10803) {
+			if (!bnxt_firmware_reset_ap(dev)) {
+				netdev_info(dev, "Reset application processor successful.\n");
+				*flags &= ~BNXT_FW_RESET_AP;
+			}
+		} else if (req == BNXT_FW_RESET_AP) {
+			return -EOPNOTSUPP; /* only request, fail hard */
 		}
-	} else {
-		rc = -EINVAL;
 	}
 
-	return rc;
+	return 0;
 }
 
 static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg, int msg_len,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index 3576d95..ce7585ff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -77,8 +77,12 @@ struct hwrm_dbg_cmn_output {
 #define BNXT_LED_DFLT_ENABLES(x)			\
 	cpu_to_le32(BNXT_LED_DFLT_ENA << (BNXT_LED_DFLT_ENA_SHIFT * (x)))
 
-#define BNXT_FW_RESET_AP	0xfffe
-#define BNXT_FW_RESET_CHIP	0xffff
+#define BNXT_FW_RESET_AP	(ETH_RESET_AP << ETH_RESET_SHARED_SHIFT)
+#define BNXT_FW_RESET_CHIP	((ETH_RESET_MGMT | ETH_RESET_IRQ |	\
+				  ETH_RESET_DMA | ETH_RESET_FILTER |	\
+				  ETH_RESET_OFFLOAD | ETH_RESET_MAC |	\
+				  ETH_RESET_PHY | ETH_RESET_RAM)	\
+				 << ETH_RESET_SHARED_SHIFT)
 
 extern const struct ethtool_ops bnxt_ethtool_ops;
 
-- 
2.5.1

