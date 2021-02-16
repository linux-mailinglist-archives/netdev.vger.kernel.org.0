Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D8831D248
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhBPVoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:44:39 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:61417 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbhBPVo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:44:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613511869; x=1645047869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=toNEZFJJYd5FgfnhWtjPWmHGIkQV7vwszU+NWqwwudI=;
  b=nOhwOHG0oNzfk3FiiAMpAW5fYq3Ku8B7aizn3ywfmZsS3nWMdi2M/NU4
   ZwCZ4QH5pipEV10YGz0Xp4/L/FhOHSzFaNoEQJC5yM3IcCogo01KAs2KN
   lV0O6/h8qSH8+i9BLCOmE7MOFw8fHsvNIRyJ187B32mbDZvXuLFaOTVEh
   m+97px205z01o4Zi7FgPEclRG9OYW3XB6KZGeKSYrbvsMZrra97EInQzU
   3iJcR/SSPaquq1zzFHvdaHXy5K/EbIc2lEZ5ivE8NfBYA1kBRZMJtp8ST
   k2BO29ovGcE1QvsJGH1PoJzps8OicDHh+wQd6Ub5y4J1EK/Fd4rIjZN/c
   Q==;
IronPort-SDR: b0zLDWUHjEvUgiw3w7f8O2hbeXxYYe4e0cdQBfwktt3ItbTUeaxYI/3nT1v3lPmXGIqN1ztZr/
 UIU8dLw3RNPLHqISe9imU9lTlQbXWgt0aCWDJ4Z7rDJmQDpRVfEwAGAPjwm4mCcDpmPFcHskAO
 8ByIDm9gwbeV2fwq5SB8Ml3IlFDu0oP0dlm00SSAEHUFL0sVXpE/lHb7qRmU1Dny62GADbdU4V
 P+NI2D7UAWPGw7a0ZjrXX9W9FDVbUGEbKsNtg6eXYhX+uSn+nHzTo/Fh21OA1Ci1330CFMKhd3
 U24=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="44324933"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 14:43:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 14:43:06 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 16 Feb 2021 14:43:03 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jiri@resnulli.us>, <ivecera@redhat.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <rasmus.villemoes@prevas.dk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 2/8] switchdev: mrp: Extend ring_role_mrp and in_role_mrp
Date:   Tue, 16 Feb 2021 22:41:59 +0100
Message-ID: <20210216214205.32385-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216214205.32385-1-horatiu.vultur@microchip.com>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the member sw_backup to the structures switchdev_obj_ring_role_mrp
and switchdev_obj_in_role_mrp. In this way the SW can call the driver in
2 ways, once when sw_backup is set to false, meaning that the driver
should implement this completely in HW. And if that is not supported the
SW will call again but with sw_backup set to true, meaning that the
HW should help or allow the SW to run the protocol.

For example when role is MRM, if the HW can't detect when it stops
receiving MRP Test frames but it can trap these frames to CPU, then it
needs to return -EOPNOTSUPP when sw_backup is false and return 0 when
sw_backup is true.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/net/switchdev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 465362d9d063..b7fc7d0f54e2 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -127,6 +127,7 @@ struct switchdev_obj_ring_role_mrp {
 	struct switchdev_obj obj;
 	u8 ring_role;
 	u32 ring_id;
+	u8 sw_backup;
 };
 
 #define SWITCHDEV_OBJ_RING_ROLE_MRP(OBJ) \
@@ -161,6 +162,7 @@ struct switchdev_obj_in_role_mrp {
 	u32 ring_id;
 	u16 in_id;
 	u8 in_role;
+	u8 sw_backup;
 };
 
 #define SWITCHDEV_OBJ_IN_ROLE_MRP(OBJ) \
-- 
2.27.0

