Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE71429316
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhJKP0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:26:01 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26532 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235157AbhJKPZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:25:58 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BEfCTH004408;
        Mon, 11 Oct 2021 15:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=tyQgh/yubP6cLWd9DKrqD5GkKWUKE7V9UYHMsUJeP00=;
 b=nJmru8fIzwsK4SJ9nGnHtgViONQB8OphrBSP3WfB6ytZAPHWgPPVbAOobzqwiLXhnMgt
 YNZoCh14RIhWRyV0wI9sxVLFER0aykdREz6jFwtZSmsnm7dPXYYj9e2Umjjfvhww6OHe
 RWYOpF2S4egcL4pvzvIspg6CrimPWnv9pHO9Zp0/EtZEKOIhym9XcgpQK788bkupoIf9
 IPp6bGDSUQG/b99breA/X0kjsO9S7L4lKeHyLlp3iI9R+t+AnyMiUSArRz46xQs40e2S
 4mlrYO0+o/w7wlapsTtx4kkrAJRVTRxbhbINsoIUBgPsW099ubTjVo25pJmn7ISvZU7w Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmq3b8c1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 15:23:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BFGMmH063350;
        Mon, 11 Oct 2021 15:23:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bkyxq2yyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 15:23:03 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19BFN3dK099566;
        Mon, 11 Oct 2021 15:23:03 GMT
Received: from t460.home (dhcp-10-175-30-45.vpn.oracle.com [10.175.30.45])
        by aserp3030.oracle.com with ESMTP id 3bkyxq2yuc-1;
        Mon, 11 Oct 2021 15:23:02 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hayes Wang <hayeswang@realtek.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256
Date:   Mon, 11 Oct 2021 17:22:49 +0200
Message-Id: <20211011152249.12387-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.23.0.718.g5ad94255a8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: C5N-hGrLiFscdboN5_hTJ_rQkinGmt1w
X-Proofpoint-ORIG-GUID: C5N-hGrLiFscdboN5_hTJ_rQkinGmt1w
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following build/link errors by adding a dependency on
CRYPTO, CRYPTO_HASH, CRYPTO_SHA256 and CRC32:

  ld: drivers/net/usb/r8152.o: in function `rtl8152_fw_verify_checksum':
  r8152.c:(.text+0x2b2a): undefined reference to `crypto_alloc_shash'
  ld: r8152.c:(.text+0x2bed): undefined reference to `crypto_shash_digest'
  ld: r8152.c:(.text+0x2c50): undefined reference to `crypto_destroy_tfm'
  ld: drivers/net/usb/r8152.o: in function `_rtl8152_set_rx_mode':
  r8152.c:(.text+0xdcb0): undefined reference to `crc32_le'

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 drivers/net/usb/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 4c5d69732a7e1..f87f175033731 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -99,6 +99,10 @@ config USB_RTL8150
 config USB_RTL8152
 	tristate "Realtek RTL8152/RTL8153 Based USB Ethernet Adapters"
 	select MII
+	select CRC32
+	select CRYPTO
+	select CRYPTO_HASH
+	select CRYPTO_SHA256
 	help
 	  This option adds support for Realtek RTL8152 based USB 2.0
 	  10/100 Ethernet adapters and RTL8153 based USB 3.0 10/100/1000
-- 
2.23.0.718.g5ad94255a8

