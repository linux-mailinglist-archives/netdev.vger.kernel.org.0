Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B99F42A133
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 11:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhJLJhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 05:37:09 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20520 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232657AbhJLJhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 05:37:09 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C9NUoh017600;
        Tue, 12 Oct 2021 09:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=eE5Sp0cDVe4/GifXOgOehqR1Epg5xlkrdK+O9AF8WjQ=;
 b=s1SkA6UlRUCRMEhT4RIaXsOcOImX9/3zRiJceJT3/+YsumeudnG9Cu/biZfg417+IVbs
 xtcshGt8mBlj7uO23qZDdOOd4OpDk+LzsoF7/JrPU3CxuMDyeHhy5y1Uk5wXZVmv7wBa
 gg4nlCq30fMbYIqXbweboTtD8SxkcpaGKZmNeB5MzVVBdoz6A7OMz7A+nLXrZBsUERPF
 346xhfbJyiNdnGRoFDNVcQKdrHQkqH+7t88Svx7iGjaS5O8RfoCx5h5cVZvUpJH7/+uf
 o2rXAeCsIe9HgNEr6KHqTwthWzrokft+6YW9+XzRkVPdT6SHg1MUTA28dXkGT/MvTb/l 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk4ncn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 09:35:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19C9GOMj002992;
        Tue, 12 Oct 2021 09:35:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bkyxrd38w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 09:35:01 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19C9Z0oQ071579;
        Tue, 12 Oct 2021 09:35:00 GMT
Received: from t460.home (dhcp-10-175-26-251.vpn.oracle.com [10.175.26.251])
        by aserp3030.oracle.com with ESMTP id 3bkyxrd367-1;
        Tue, 12 Oct 2021 09:35:00 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Beniamino Galvani <b.galvani@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] net: arc: select CRC32
Date:   Tue, 12 Oct 2021 11:34:46 +0200
Message-Id: <20211012093446.1575-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.23.0.718.g5ad94255a8
In-Reply-To: <20211012091552.32403-1-vegard.nossum@oracle.com>
References: <20211012091552.32403-1-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Uwm2zmYffT5-_2ZpLp-eJF2_kibW9BZk
X-Proofpoint-ORIG-GUID: Uwm2zmYffT5-_2ZpLp-eJF2_kibW9BZk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following build/link error by adding a dependency on the CRC32
routines:

  ld: drivers/net/ethernet/arc/emac_main.o: in function `arc_emac_set_rx_mode':
  emac_main.c:(.text+0xb11): undefined reference to `crc32_le'

The crc32_le() call comes through the ether_crc_le() call in
arc_emac_set_rx_mode().

[v2: moved the select to ARC_EMAC_CORE; the Makefile is a bit confusing,
but the error comes from emac_main.o, which is part of the arc_emac module,
which in turn is enabled by CONFIG_ARC_EMAC_CORE. Note that arc_emac is
different from emac_arc...]

Fixes: 775dd682e2b0ec ("arc_emac: implement promiscuous mode and multicast filtering")
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 drivers/net/ethernet/arc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/arc/Kconfig b/drivers/net/ethernet/arc/Kconfig
index 37a41773dd435..92a79c4ffa2c7 100644
--- a/drivers/net/ethernet/arc/Kconfig
+++ b/drivers/net/ethernet/arc/Kconfig
@@ -21,6 +21,7 @@ config ARC_EMAC_CORE
 	depends on ARC || ARCH_ROCKCHIP || COMPILE_TEST
 	select MII
 	select PHYLIB
+	select CRC32
 
 config ARC_EMAC
 	tristate "ARC EMAC support"
-- 
2.23.0.718.g5ad94255a8

