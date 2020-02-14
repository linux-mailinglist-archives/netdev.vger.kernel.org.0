Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870D115DA28
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgBNPDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:21 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14052 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729412AbgBNPDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:21 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF05ox019148;
        Fri, 14 Feb 2020 07:03:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=n7IUqKEkW+78aMyA0NFeZvPaUHMP0ZP4Oj7F5fBOsI8=;
 b=O7q3PIBDNGj50Z8LZgvB8QGXo4TUZz1fHddZR0meh0C9/aTO9htYDJgEgvgylCIMDkW+
 ZHy4d+38mHhqQroqWSUiqt4Cs4kYtD7dqLUKWrtdhgHgoc4Ym76ld1K9FtFx0Ssq68f3
 85vESlZGY5atSYXkExx+mWVbChtOvlc2uC5bWlY9uLWyRH92Dtpw+mu0wPAZZRlChB8O
 9Ka9jIjLN51rEEoODYZ6Iruc7nWilFusw028QaiZUt102OQXUE8u5sRt4bkSuNjvDM2c
 GVMdW2FEs/+QRVc/9j3gQLsBlgKqUnSoGf3YU1A9fRntrYB390I/fqfuoja7tlV7CQjF ww== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2n5kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:18 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:16 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:16 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 2FF443F7043;
        Fri, 14 Feb 2020 07:03:14 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 04/18] net: macsec: add support for offloading to the MAC
Date:   Fri, 14 Feb 2020 18:02:44 +0300
Message-ID: <20200214150258.390-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214150258.390-1-irusskikh@marvell.com>
References: <20200214150258.390-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
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
index 024af2d1d0af..771371d5b996 100644
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

