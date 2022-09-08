Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E77C5B1BFA
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiIHL42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiIHL40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:56:26 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0CDD99C6
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662638185; x=1694174185;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kRMULuNzI37CVUCuzeL3U6IBLgBdiMPBcpKk4yGKDho=;
  b=emLe3MIGXzL/sueFHPT20FP6tezeq9e8bYD5hXGHp6Vf4ElVemxWDBFz
   y3GklI4XQtDy5HcuCZFTfoWJtliOYJpJL/Xjcz66pt40fXyS9Z1yT41MX
   wb1U4Dvbm1rp+do1z3Uxt7aZA6E7Gi8UY+y9NTozQ8oHc2kXDWPBtU2wq
   sVFs0v+Tv4i0B+jB6I9nvvuzHTU6p4GqqOayNGBe91wDHwepIgkKQCVYB
   dXli6ZRFrlrdUOx4f650gvQqrRUN6ltHPB0+yX6rNodm3bon3iuSzK0kN
   gBASEsUEaIX0uL6NpU15V4yW7uDrW3VXSmhlObubOLras3euYtXYnPJgo
   g==;
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="172936346"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Sep 2022 04:56:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 8 Sep 2022 04:56:23 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 8 Sep 2022 04:56:21 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <petrm@nvidia.com>, <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [RFC PATCH net-next 1/2] net: dcb: add new pcp selector to app object
Date:   Thu, 8 Sep 2022 14:04:41 +0200
Message-ID: <20220908120442.3069771-2-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908120442.3069771-1-daniel.machon@microchip.com>
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new PCP selector for the 8021Qaz APP managed object.

The purpose of adding the PCP selector, is to be able to offload
PCP-based queue classification to the 8021Q Priority Code Point table,
see 6.9.3 of IEEE Std 802.1Q-2018.

PCP and DEI is encoded in the protocol field as 8*dei+pcp, so that a
mapping of PCP 2 and DEI 1 to priority 3 is encoded as {255, 10, 3}.

While PCP is not a standard 8021Qaz selector, it seems very convenient
to add it to the APP object, as this is where similar priority mapping
is handled, and it perfectly fits the {selector, protocol, priority}
triplet.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 include/uapi/linux/dcbnl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
index a791a94013a6..8eab16e5bc13 100644
--- a/include/uapi/linux/dcbnl.h
+++ b/include/uapi/linux/dcbnl.h
@@ -217,6 +217,7 @@ struct cee_pfc {
 #define IEEE_8021QAZ_APP_SEL_DGRAM	3
 #define IEEE_8021QAZ_APP_SEL_ANY	4
 #define IEEE_8021QAZ_APP_SEL_DSCP       5
+#define IEEE_8021QAZ_APP_SEL_PCP	255
 
 /* This structure contains the IEEE 802.1Qaz APP managed object. This
  * object is also used for the CEE std as well.
-- 
2.34.1

