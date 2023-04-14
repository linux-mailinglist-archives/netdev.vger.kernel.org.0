Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3348B6E1E38
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 10:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjDNI15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 04:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjDNI1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 04:27:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB262900C;
        Fri, 14 Apr 2023 01:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681460829; x=1712996829;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=w2+6B68URgmKUVKHyS0K12IEVdDx3OVx3qeOmOW7/u8=;
  b=QOHxlzrQUM2Nz4j8qTFJmw/aWGEObVGFfH7W2bAbUx9RQG91N8z1o1gN
   1pe1Y2kEq///IFZrqElbxrdUwzbfmxuRNCjeNPxFIdE2zJ8HJj3X6DIiD
   E4/MdFbK81zaJW+jpuXm5jaisRqTaMPa3LdpZOt4l9fZhX/T2u7N7Fo8S
   8joCUc1nJt8SPOHDCe0hwzroKjZmjtx9U4xw6v/n6KTSzpFLz3jvuWWTQ
   vXBv3bsssVqfXSJzH6ifjS0aGk968D3HH1q4LivqJLT/+O3ZvgVfEzQ00
   H/AXDLNyeAd4FL93/RoY+EmGTofxoLOoJar0LwogjVXkBrvWGL7/Sq1cg
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,195,1677567600"; 
   d="scan'208";a="220867924"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2023 01:27:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 14 Apr 2023 01:27:03 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 14 Apr 2023 01:27:02 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: phy: micrel: Fix PTP_PF_PEROUT for lan8841
Date:   Fri, 14 Apr 2023 10:26:59 +0200
Message-ID: <20230414082659.1321686-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the 1PPS output was enabled and then lan8841 was configured to be a
follower, then target clock which is used to generate the 1PPS was not
configure correctly. The problem was that for each adjustments of the
time, also the nanosecond part of the target clock was changed.
Therefore the initial nanosecond part of the target clock was changed.
The issue can be observed if both the leader and the follower are
generating 1PPS and see that their PPS are not aligned even if the time
is allined.
The fix consists of not modifying the nanosecond part of the target
clock when adjusting the time. In this way the 1PPS get also aligned.

Fixes: e4ed8ba08e3f ("net: phy: micrel: Add support for PTP_PF_PEROUT for lan8841")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 3fee682603ef5..382144a6306f0 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4025,7 +4025,7 @@ static int lan8841_ptp_update_target(struct kszphy_ptp_priv *ptp_priv,
 				     const struct timespec64 *ts)
 {
 	return lan8841_ptp_set_target(ptp_priv, LAN8841_EVENT_A,
-				      ts->tv_sec + LAN8841_BUFFER_TIME, ts->tv_nsec);
+				      ts->tv_sec + LAN8841_BUFFER_TIME, 0);
 }
 
 #define LAN8841_PTP_LTC_TARGET_RELOAD_SEC_HI(event)	((event) == LAN8841_EVENT_A ? 282 : 292)
-- 
2.38.0

