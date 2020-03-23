Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483F418F56C
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgCWNOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:14:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11174 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728240AbgCWNOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:14:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ND6MJ4019116;
        Mon, 23 Mar 2020 06:14:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=IdMCmaJnDKkIakFOXzBU+6P4oakB1zWNKkAdKQJQYRY=;
 b=WjRWNtBEKbLBox6KgHsqIIf2I7XQWOsA4+D3koJGSnQESFiuWj/F2kNtiVrIOVT1Bp5F
 xzt4cJ1hifcTR52s2KYnZXyKIyVg/e/n3VMhiwXob0HYuvQLfBOP0sOBFng3tRDffHvu
 4+75QleX/Od8V3muQCRjnrw7PE7j3ot4U8GEFo3/2Z8l7VLUu/9LmxQmH/3V0YbKdr8S
 ru6/QzH0xEGwMmPPcKRJFpARYt/vtSKz6SEvridTj9SQkSk89ETTie/eDRIh8lzCjc7f
 NrtXd00uqlbf5alLUzLACEbjr+YizcQcSmZr6nP6ICAv2ldqQrLdQrlrYucAdIyxpn0Q MQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqmn3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 06:14:50 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 06:14:48 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Mar 2020 06:14:48 -0700
Received: from localhost.localdomain (unknown [10.9.16.91])
        by maili.marvell.com (Postfix) with ESMTP id E44DD3F703F;
        Mon, 23 Mar 2020 06:14:46 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 04/17] net: macsec: add support for offloading to the MAC
Date:   Mon, 23 Mar 2020 16:13:35 +0300
Message-ID: <20200323131348.340-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323131348.340-1-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_04:2020-03-21,2020-03-23 signatures=0
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

