Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869233157E9
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhBIUoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:44:46 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:13289 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbhBIUgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:36:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612902978; x=1644438978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IhUdd2jlbfwy16e6uNnfyIi6STcN4Cush5DPbsaIFTY=;
  b=yPGUIlssDtUqVU9XlsVQ8cqDT0FjacjLaOUYK0O9u5BYxiIHPEJSdEp9
   z3TO6ZnOGpkO48eYPSJ6Sc0ZJPKnFkEM7+AtRzli6Oc5qrL4FnJ/oA4qt
   DKihTOgzhzw0Z6ry5xqz6trBGqMBdJNz9etmPE+i7en4xuwxGX76nVeQf
   qWUBFo0LXmt5SWtf8yqJV3U4ZG1/aMxGqucfYTLNRSWnpSalosEQkeveU
   hbPZ/gCm3M4i556jyQQcTT643LUJFdYjvMMud2KCxlcD/22IZ3hZMyrME
   K84Lni87aZDefH7Kahdk84Jkk/1go6W81Mo1dXzzp59t9L8QXcBFkOEXy
   w==;
IronPort-SDR: O/2fqCzSvt06FAhn1bRmmaudCFo6rtgtKGyugMyzBemGzVfnpoQIZPn+WHQfDJ2Rsu4OJ2PMf6
 ILStXzz4o7pMsZSUv2LqqpG58GSMHSom9P/mDU40qQL0R887zeMey0TtZBH+DDqBmGdf8hJCeS
 r1j1R61aFGcA6hnpS8mKmxlODOpVqoYSOI0JjftaD8UPrI/2REd1ehIGQOKHMIcawzk2VuT0dj
 KXy1QEOWVoS8Ao9ysEal2HXBk+AI46q6RYmaXFe99K9P6+blPDQ3ZAIv/VLi7g0JLisYdyrrEO
 a7Y=
X-IronPort-AV: E=Sophos;i="5.81,166,1610434800"; 
   d="scan'208";a="106029120"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2021 13:24:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 13:24:19 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 9 Feb 2021 13:24:16 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 1/5] switchdev: mrp: Extend ring_role_mrp and in_role_mrp
Date:   Tue, 9 Feb 2021 21:21:08 +0100
Message-ID: <20210209202112.2545325-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210209202112.2545325-1-horatiu.vultur@microchip.com>
References: <20210209202112.2545325-1-horatiu.vultur@microchip.com>
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
index 6dcfc4c51a6e..067f259279e1 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -130,6 +130,7 @@ struct switchdev_obj_ring_role_mrp {
 	struct switchdev_obj obj;
 	u8 ring_role;
 	u32 ring_id;
+	u8 sw_backup;
 };
 
 #define SWITCHDEV_OBJ_RING_ROLE_MRP(OBJ) \
@@ -164,6 +165,7 @@ struct switchdev_obj_in_role_mrp {
 	u32 ring_id;
 	u16 in_id;
 	u8 in_role;
+	u8 sw_backup;
 };
 
 #define SWITCHDEV_OBJ_IN_ROLE_MRP(OBJ) \
-- 
2.27.0

