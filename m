Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8871642F1BB
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbhJONKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:10:31 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44558 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239256AbhJONK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 09:10:29 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19FCx1Tm007385;
        Fri, 15 Oct 2021 13:08:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=5HiMwcak6Fmpj6WRmUR1Pdxweyd3dBzOlejvpHt0vww=;
 b=aPt0R47T/QHcDyY/4nPD4RXQJkWP8+nnnw+YDjgjWjMxFkM2s9unYkPxJRRku38gB/pM
 9tVkcSoh9yoBAZHIccuUMrbIr1JzkrWPgKnzxHl92bIR3t47XHjec+Fo+J9IivKmJ+8E
 msjVuqFHVP+fxMV4VAFUeKSaRzWYKqgKIFYYuRuW1+V4HzzTERaegEj87BFyI1teflHQ
 nD63S5hBIgOXTeuO5KqimlLDDoyV4ZMXueqJYSB3zFBAY1mFYlcVyi6FE9G7tpCDgJ1a
 B4ohnTPt4by4urYbzJrq/oCYjS4aoXkHB878KJccqMD532CwJ1fW44w0zMq8Z0fDFFY1 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bpfsyrtg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Oct 2021 13:08:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19FD4sWa005247;
        Fri, 15 Oct 2021 13:08:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3bmae46k0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Oct 2021 13:08:17 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19FD8G58020291;
        Fri, 15 Oct 2021 13:08:16 GMT
Received: from t460.home (dhcp-10-175-9-30.vpn.oracle.com [10.175.9.30])
        by aserp3020.oracle.com with ESMTP id 3bmae46jxq-1;
        Fri, 15 Oct 2021 13:08:16 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] lan78xx: select CRC32
Date:   Fri, 15 Oct 2021 15:07:54 +0200
Message-Id: <20211015130754.12283-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.23.0.718.g5ad94255a8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: oft2zsSFztGteDHkGwKZWiravcqIXUYm
X-Proofpoint-GUID: oft2zsSFztGteDHkGwKZWiravcqIXUYm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following build/link error by adding a dependency on the CRC32
routines:

  ld: drivers/net/usb/lan78xx.o: in function `lan78xx_set_multicast':
  lan78xx.c:(.text+0x48cf): undefined reference to `crc32_le'

The actual use of crc32_le() comes indirectly through ether_crc().

Fixes: 55d7de9de6c30 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 drivers/net/usb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index f87f175033731..b554054a7560a 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -117,6 +117,7 @@ config USB_LAN78XX
 	select PHYLIB
 	select MICROCHIP_PHY
 	select FIXED_PHY
+	select CRC32
 	help
 	  This option adds support for Microchip LAN78XX based USB 2
 	  & USB 3 10/100/1000 Ethernet adapters.
-- 
2.23.0.718.g5ad94255a8

