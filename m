Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D92C91928ED
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgCYMxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:53:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20148 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727400AbgCYMxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:53:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCp3N4009882;
        Wed, 25 Mar 2020 05:53:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=IdMCmaJnDKkIakFOXzBU+6P4oakB1zWNKkAdKQJQYRY=;
 b=CcJp2MM/DlzsPwUGJZihTYxw9zPkl/wkp7flFkV3Ph0tDICVRgII00v+00N4mOhu1tN9
 AVM/qBSG3pSF8Z965Mv5oHm4n7ERYAoC4mnj4RC0TTMOP9T01rA5b5jbR2oiR7wDt79D
 twGF9sFeq2wxfIT3Gje90wEw/blWlaPkTKOPFFk/D42VoggU94x6X21NjDznEwtiwXce
 xHlzuqazAn4vYFtq3MVFZnYTgQzStarO1cDSSJ8VmqrT0RBSQdp4oDIUFvtF4V2Q/RRp
 TOOApd425YEusWK60z0+AfPmT41QvdOgbPUp2qHYsVGb4c1iRZd8J/p6mJFVYawZfFQs RQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nrgg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:53:03 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:53:01 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:53:01 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 05:53:00 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id C56DA3F703F;
        Wed, 25 Mar 2020 05:52:59 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 04/17] net: macsec: add support for offloading to the MAC
Date:   Wed, 25 Mar 2020 15:52:33 +0300
Message-ID: <20200325125246.987-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325125246.987-1-irusskikh@marvell.com>
References: <20200325125246.987-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
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
index 49b138e7aeac..c4d5f609871e 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -338,7 +338,8 @@ static void macsec_set_shortlen(struct macsec_eth_header *h, size_t data_len)
 /* Checks if a MACsec interface is being offloaded to an hardware engine */
 static bool macsec_is_offloaded(struct macsec_dev *macsec)
 {
-	if (macsec->offload == MACSEC_OFFLOAD_PHY)
+	if (macsec->offload == MACSEC_OFFLOAD_MAC ||
+	    macsec->offload == MACSEC_OFFLOAD_PHY)
 		return true;
 
 	return false;
@@ -354,6 +355,9 @@ static bool macsec_check_offload(enum macsec_offload offload,
 	if (offload == MACSEC_OFFLOAD_PHY)
 		return macsec->real_dev->phydev &&
 		       macsec->real_dev->phydev->macsec_ops;
+	else if (offload == MACSEC_OFFLOAD_MAC)
+		return macsec->real_dev->features & NETIF_F_HW_MACSEC &&
+		       macsec->real_dev->macsec_ops;
 
 	return false;
 }
@@ -368,9 +372,14 @@ static const struct macsec_ops *__macsec_get_ops(enum macsec_offload offload,
 
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

