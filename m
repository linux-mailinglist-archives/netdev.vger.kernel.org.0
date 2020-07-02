Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A877A211F69
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgGBJGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:06:14 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:48754 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGBJGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593680770; x=1625216770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=F0v7d59d8CodmqYQV4UE6rEu9k/83Ok33vbIFw5OEbM=;
  b=Cf82vhgHzVRR9AqcR5wgxVdZ8jfDIySvOr42u9jWIkOUkb4mq2q4qSwG
   UMprpbRZ+MpxJkkNeZrPrRLbUgkJHi1rY8lyJRswdu0jEBbh2qFRt3ITS
   Aj/6+qzHfuYszvKUlvGqkPvH4DZreJyOse84AWZ3ikuwdCh84ZzGCjfxl
   x9HuxNeLQjqz9rTYa5F8pI1OFhYEHf+S+RGNmaqL4WZXykubuX69FXJwK
   /wSMTPne4Tny9Yxa0URE2xUAqVKaAGF18/WwRDYCnSABZwz+wiGNb07z6
   OJ5MIQeeO1wHo5RLQf6L7p11IDHMYXtEk1TXFMRu17QPfFfm0Ff4yb5Za
   g==;
IronPort-SDR: s2PO518+dLJWarzg9Asd6m8XEPiXROeFgk3Wt8UGnFt2diiOyL+gEKTqwxqfpFoQ7x8vZlLxCW
 19AeOTB30bcNa/lj7KSR6Jc2lTtyY+d5ccOssqC1h+WWswkGz9ayo3pTHnLJkHY+dEoW6qjQPt
 vCrUS9oK/H/XdpldDO0ZyC6Pv2VooPLSdG2aIh/YzVEW7E8WZVRjqyzTJAfXMno3PbzmdpJzKR
 hAevZSYmJ6d7i7RbJi8xdKcb/DALnZpDIuov5jmqc24YdYCblg3g166kBbYNRiUZT8qr+GVx/i
 ABQ=
X-IronPort-AV: E=Sophos;i="5.75,303,1589266800"; 
   d="scan'208";a="81642859"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 02:06:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 02:06:08 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 02:06:06 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH net-next v2 1/4] net: macb: do not set again bit 0 of queue_mask
Date:   Thu, 2 Jul 2020 12:05:58 +0300
Message-ID: <1593680761-11427-2-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
References: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bit 0 of queue_mask is set at the beginning of
macb_probe_queues() function. Do not set it again after reading
DGFG6 but instead use "|=" operator.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 52582e8ed90e..1bc2810f3dc4 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3497,9 +3497,7 @@ static void macb_probe_queues(void __iomem *mem,
 		return;
 
 	/* bit 0 is never set but queue 0 always exists */
-	*queue_mask = readl_relaxed(mem + GEM_DCFG6) & 0xff;
-
-	*queue_mask |= 0x1;
+	*queue_mask |= readl_relaxed(mem + GEM_DCFG6) & 0xff;
 
 	for (hw_q = 1; hw_q < MACB_MAX_QUEUES; ++hw_q)
 		if (*queue_mask & (1 << hw_q))
-- 
2.7.4

