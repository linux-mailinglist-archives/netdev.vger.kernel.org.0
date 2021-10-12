Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7488A42A0E0
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 11:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhJLJUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 05:20:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49976 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232502AbhJLJUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 05:20:18 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C9G5oF017601;
        Tue, 12 Oct 2021 09:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=+aJDxyPICxWH3pewjoI7IFtcJBOOKilVtl3Z+efFcuM=;
 b=sQ/pl7XnP8n07NJVzRhZ6VaoB2ftjWWNcZfZ6mRKgj7MgQOr0vjmIFMPOEo34TAQvrXf
 aAjGCKVH9EtUxjtkhlB+f/wUXDoqyjMXl46rXtbxQaulP0OUDRSKtJv/WQqbGRTrqxdq
 7sJrFSQ1HRTj0Fegtrd+hLuSY5xmbnUDgbCekjLFsThnUWy1zRJWiymefN6ysBPaSwVJ
 lxmVOg9YBYoTYc1nJLo84TJ/rQvgXatiVmOfafpgoOjg+c5O7l4WJO7hTf4xKNqEUPKX
 E3SLnqh+wkg/nxsf2ffWuPSA+XLDoySXK7xB2xtyo4+ADlbl91+5NNiRTb7uh55Sdxfn sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk4j8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 09:18:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19C9EhYO059809;
        Tue, 12 Oct 2021 09:18:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3bmadxpbqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 09:18:11 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19C9Gu75067017;
        Tue, 12 Oct 2021 09:18:10 GMT
Received: from t460.home (dhcp-10-175-26-251.vpn.oracle.com [10.175.26.251])
        by aserp3020.oracle.com with ESMTP id 3bmadxpbpd-1;
        Tue, 12 Oct 2021 09:18:10 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Beniamino Galvani <b.galvani@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] net: arc: select CRC32
Date:   Tue, 12 Oct 2021 11:15:52 +0200
Message-Id: <20211012091552.32403-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.23.0.718.g5ad94255a8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: XPkU9uvITsR9rFUeVwQtcM5Xo4aQ3ISk
X-Proofpoint-ORIG-GUID: XPkU9uvITsR9rFUeVwQtcM5Xo4aQ3ISk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following build/link error by adding a dependency on the CRC32
routines:

  ld: drivers/net/ethernet/arc/emac_main.o: in function `arc_emac_set_rx_mode':
  emac_main.c:(.text+0xb11): undefined reference to `crc32_le'

The crc32_le() call comes through the ether_crc_le() call in
arc_emac_set_rx_mode().

Fixes: 775dd682e2b0ec ("arc_emac: implement promiscuous mode and multicast filtering")
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 drivers/net/ethernet/arc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/arc/Kconfig b/drivers/net/ethernet/arc/Kconfig
index 37a41773dd435..330185b624d03 100644
--- a/drivers/net/ethernet/arc/Kconfig
+++ b/drivers/net/ethernet/arc/Kconfig
@@ -6,6 +6,7 @@
 config NET_VENDOR_ARC
 	bool "ARC devices"
 	default y
+	select CRC32
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
-- 
2.23.0.718.g5ad94255a8

