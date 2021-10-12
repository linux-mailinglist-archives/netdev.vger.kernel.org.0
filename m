Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DDF42A835
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhJLP1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:27:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45366 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229633AbhJLP1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 11:27:40 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CEf8ZC006877;
        Tue, 12 Oct 2021 15:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=t4aJCS6LYqnsi9zO49w4xshmVZghae5OieHodkULBvw=;
 b=BzSRQ89NAhOxoCEeWWp1VynQ5yMSOAKxuOk5hWLGLfR8znbJM7hsDpLGac/B2uEgt2vT
 Tu9TnkKBqHWEopZTb1Koigkbb+ecT/GhjVNFtqIab/QMr1QinFFgiP/SgNeHejpkHJss
 DReU3mn+4gLtlj882CifZFUGns7n2WhI99JLHBNLy6KfdfNuDxNFiQi3j3HVvGiCEC/W
 0jod+GkNHl1xoGie8IncDEbKuZYzEAWPStlPefvgO4xt7YIpfeTXTw2O6faOejPaRkX+
 StQElo5342Rpcz5ScWvN7LMzRbPa7XP02Smn2uHbw3XamkKk0cn8YPj4l+8HwQhskJkq Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmv41pcvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 15:25:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CFAkh3194429;
        Tue, 12 Oct 2021 15:25:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3bmady654m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 15:25:32 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19CFPVJo075308;
        Tue, 12 Oct 2021 15:25:31 GMT
Received: from t460.home (dhcp-10-175-26-251.vpn.oracle.com [10.175.26.251])
        by aserp3020.oracle.com with ESMTP id 3bmady652d-1;
        Tue, 12 Oct 2021 15:25:31 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] net: korina: select CRC32
Date:   Tue, 12 Oct 2021 17:25:09 +0200
Message-Id: <20211012152509.21771-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.23.0.718.g5ad94255a8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: KtO-051QlbXOLYVwy5kDu5yeAHbKWcNu
X-Proofpoint-GUID: KtO-051QlbXOLYVwy5kDu5yeAHbKWcNu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following build/link error by adding a dependency on the CRC32
routines:

  ld: drivers/net/ethernet/korina.o: in function `korina_multicast_list':
  korina.c:(.text+0x1af): undefined reference to `crc32_le'

Fixes: ef11291bcd5f9 ("Add support the Korina (IDT RC32434) Ethernet MAC")
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 drivers/net/ethernet/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index d796684ec9ca0..412ae3e43ffb7 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -100,6 +100,7 @@ config JME
 config KORINA
 	tristate "Korina (IDT RC32434) Ethernet support"
 	depends on MIKROTIK_RB532 || COMPILE_TEST
+	select CRC32
 	select MII
 	help
 	  If you have a Mikrotik RouterBoard 500 or IDT RC32434
-- 
2.23.0.718.g5ad94255a8

