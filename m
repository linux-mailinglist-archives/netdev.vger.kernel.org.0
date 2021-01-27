Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE89306575
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhA0UzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:55:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10890 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbhA0UzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:55:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611780918; x=1643316918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JtMgqDe1zRCwojD2fE9vIKSHA/7JaMFfOoLeN1LILIs=;
  b=R4ceCRhNVKN1qG8ZQsMVFqy23ux8UPPrTgSidAT1fGP1pAEeA14TUzTL
   HL1jIGotX5Rj5shZdtdbYCawXURQYlb/hHzuuITCcVMla9GpSNlKmm9hM
   NVEt+Qq34vXShQR+OlLUlfILO1aZv4KHtgf8fvJ241GwbgFxfdNRUIHSv
   2ue4akS3SSuAkwLXwOewNsDDY+mB4+KwFT1xD+AePzCPpNWct2QmnAyhE
   IN1kTWJmM9a+z+jFqfFlQCMV/Va24Qy0o54PuWunBaULAXsZfNq48AfrK
   7IiWImmWGe/qgqG+WiSk/8k6O4B5Q/lyn9qsBhvkrNPmCSa4+i4C8YrPh
   A==;
IronPort-SDR: j6w/evZ1JD38/FZJnED65iU497UCYoxDINl1htVZpPW5Vht9Pu3nn48Tzs/8aRORFsLp3HG2CF
 eWlblq6xs9cXfGOGF0QR1UCsi04MMQBKQrQ6m4btsWfozLwoU1U112ZbkpIfglp8c1FfTr1zfS
 szpHJ8eV1ANkb8k+Z04Wfj7suQDVTa26PsYH1qDHIYbp31BoZiNhRVZyQFl6kCiMumv1t/A3pj
 /IP3Y/RRaiKf9FbLQPTFTR8eUGd/XfpBebNh94U2sMuhdRmFiw0hHN6BHQhuRqrI+Xl8BukK6T
 hWE=
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="107026819"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 13:54:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 13:54:01 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 13:53:59 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/4] switchdev: mrp: Extend ring_role_mrp and in_role_mrp
Date:   Wed, 27 Jan 2021 21:52:38 +0100
Message-ID: <20210127205241.2864728-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
References: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
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

