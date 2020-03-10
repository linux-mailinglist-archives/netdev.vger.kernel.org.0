Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F8180103
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgCJPEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:04:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18636 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727682AbgCJPEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:04:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AEtvqC011753;
        Tue, 10 Mar 2020 08:04:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=a9X5rCSWtsipPm6jRZxeN6DxB54ZuMGUKolZcZ/0rF8=;
 b=QA460tTRs4jK1ucJErtKvRoeRYIy6+Arc+anQ7F2OsJX98iFWyN47/OdXGFCsU9nPk81
 Mw8c/KXoljIGq2kXHEaZHwMLMTxYtQToOKayBe76JRZmwmmNAMJSwAmhhJEbCqwMgR9p
 3fp24hlmxb+qYYceFv3nxPhLjd1T/bIJwkhZ/t3fd+7CN2lQ6RNFYNXfjM+JT4gnflzP
 vuwXEtTlgIGVUcz2x/a+S09gy8H450Ju2enebc1g7WFdwntYGCFOMzhAaUx9rfxHpbLb
 a38pPXWOv+URECBsRP2AiQ7xMyscR9zMjGmL8ivWVflU9lXI5K9MoFiZ/znosJgT70aU KQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yp04fm0qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:04:04 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:04:03 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:04:02 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id A4C253F703F;
        Tue, 10 Mar 2020 08:04:01 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [RFC v2 04/16] net: macsec: add support for offloading to the MAC
Date:   Tue, 10 Mar 2020 18:03:30 +0300
Message-ID: <20200310150342.1701-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310150342.1701-1-irusskikh@marvell.com>
References: <20200310150342.1701-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_08:2020-03-10,2020-03-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

This patch adds a new MACsec offloading option, MACSEC_OFFLOAD_MAC,
allowing a user to select a MAC as a provider for MACsec offloading
operations.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c               | 13 +++++++++++--
 include/uapi/linux/if_link.h       |  1 +
 tools/include/uapi/linux/if_link.h |  1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 45bfd99f17fa..a88b41a79103 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -325,7 +325,8 @@ static void macsec_set_shortlen(struct macsec_eth_header *h, size_t data_len)
 /* Checks if a MACsec interface is being offloaded to an hardware engine */
 static bool macsec_is_offloaded(struct macsec_dev *macsec)
 {
-	if (macsec->offload == MACSEC_OFFLOAD_PHY)
+	if (macsec->offload == MACSEC_OFFLOAD_MAC ||
+	    macsec->offload == MACSEC_OFFLOAD_PHY)
 		return true;
 
 	return false;
@@ -341,6 +342,9 @@ static bool macsec_check_offload(enum macsec_offload offload,
 	if (offload == MACSEC_OFFLOAD_PHY)
 		return macsec->real_dev->phydev &&
 		       macsec->real_dev->phydev->macsec_ops;
+	else if (offload == MACSEC_OFFLOAD_MAC)
+		return macsec->real_dev->features & NETIF_F_HW_MACSEC &&
+		       macsec->real_dev->macsec_ops;
 
 	return false;
 }
@@ -355,9 +359,14 @@ static const struct macsec_ops *__macsec_get_ops(enum macsec_offload offload,
 
 		if (offload == MACSEC_OFFLOAD_PHY)
 			ctx->phydev = macsec->real_dev->phydev;
+		else if (offload == MACSEC_OFFLOAD_MAC)
+			ctx->netdev = macsec->real_dev;
 	}
 
-	return macsec->real_dev->phydev->macsec_ops;
+	if (offload == MACSEC_OFFLOAD_PHY)
+		return macsec->real_dev->phydev->macsec_ops;
+	else
+		return macsec->real_dev->macsec_ops;
 }
 
 /* Returns a pointer to the MACsec ops struct if any and updates the MACsec
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 61e0801c82df..d6ccd0105c05 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -489,6 +489,7 @@ enum macsec_validation_type {
 enum macsec_offload {
 	MACSEC_OFFLOAD_OFF = 0,
 	MACSEC_OFFLOAD_PHY = 1,
+	MACSEC_OFFLOAD_MAC = 2,
 	__MACSEC_OFFLOAD_END,
 	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
 };
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 024af2d1d0af..771371d5b996 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -489,6 +489,7 @@ enum macsec_validation_type {
 enum macsec_offload {
 	MACSEC_OFFLOAD_OFF = 0,
 	MACSEC_OFFLOAD_PHY = 1,
+	MACSEC_OFFLOAD_MAC = 2,
 	__MACSEC_OFFLOAD_END,
 	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
 };
-- 
2.17.1

