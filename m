Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19DB3016CB
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 17:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbhAWQXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 11:23:06 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:16215 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhAWQVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 11:21:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611418867; x=1642954867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JtMgqDe1zRCwojD2fE9vIKSHA/7JaMFfOoLeN1LILIs=;
  b=XCFTVQ4CLLw2rSQMFi31sorDg6vof4cpCTr3GP9IVaoVodyCyD137KbO
   98rfNqRV5oJp2O23G1vxtPC7gEpFGH5GVIZD2Z+dO1G8w4tjKAPhGd+5c
   k7h3bqzcONUDYISTl3xJKrJsSafXwATCNPC7Gsl/Qz7bvTELKLo7QRaOE
   30uFddKOv0saFSDEKM2D7C6bkgW9SwC4O4sHnuDbK9UE4DxzNp/HYAVA6
   xa4nBXg4yiEtH6uRFm2KTjdHE/7A+BHtCMU5NiE8dwJp/Y6tx/dYA6IQj
   P09O+LwqLyLuDQRz1WE4/33Bh51HdoW1u84uvUWHk3i3H621Gp5y3BBoM
   Q==;
IronPort-SDR: LletkaEVGePO8dDcAeN6jDgwdlPomY8sWh0P1bwUOCwQAfEWlSBplcCrk+H6RGKvvBBAtSWhH2
 oKeVt0xDY0tKjKQnnSreJk1YlY0Zsdo+Xjo6Lz5L73448JRsYFFsr4fskCHav0iLc/cMobYl8H
 DeKVDBN9Juq4B+SpeH7L0mTUGCsuiGwewCuFrrXhf/0+imqak3qKlWZnbOUYn8rFGdZVgi2abx
 dIY0+qGdv88yRtM/qHB543KhXeaOZEFz6f73v86++j5e93JQ5bry7o3VyI0ExvGwcu4pcOBlYu
 7hQ=
X-IronPort-AV: E=Sophos;i="5.79,369,1602572400"; 
   d="scan'208";a="103958997"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jan 2021 09:19:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 23 Jan 2021 09:19:51 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sat, 23 Jan 2021 09:19:49 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/4] switchdev: mrp: Extend ring_role_mrp and in_role_mrp
Date:   Sat, 23 Jan 2021 17:18:09 +0100
Message-ID: <20210123161812.1043345-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123161812.1043345-1-horatiu.vultur@microchip.com>
References: <20210123161812.1043345-1-horatiu.vultur@microchip.com>
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
index 88fcac140966..3f236eaa4f3e 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -132,6 +132,7 @@ struct switchdev_obj_ring_role_mrp {
 	struct switchdev_obj obj;
 	u8 ring_role;
 	u32 ring_id;
+	u8 sw_backup;
 };
 
 #define SWITCHDEV_OBJ_RING_ROLE_MRP(OBJ) \
@@ -166,6 +167,7 @@ struct switchdev_obj_in_role_mrp {
 	u32 ring_id;
 	u16 in_id;
 	u8 in_role;
+	u8 sw_backup;
 };
 
 #define SWITCHDEV_OBJ_IN_ROLE_MRP(OBJ) \
-- 
2.27.0

