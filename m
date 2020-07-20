Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD18226DC9
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgGTSJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:09:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14000 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729029AbgGTSI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:08:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqI6024225;
        Mon, 20 Jul 2020 11:08:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=DFDzUdDk0aHOGhfw7QO/TyfMEtyrZJIH/S5p8+Dvbk0=;
 b=eAWLYzB2UAMtOQuwgSwVit4okAEONym4Z/oSCdhhwFwE96APwSxKE6fQjNBO8bEv8fQT
 tPFdNfW7BXJnB+T7GTmtGEkUdNWWR1+cuedY9NSW4xYE57CboTtc5XSbn+4jvOkgiv9F
 vPG4BttBA+6RGJHxrEAThdsD4cAkj05FT0rlP4qEzHblVL4v7htMNmstVyuMmskP7GIe
 yc5q4FusN7by2zgKpUamdl3ftYfB+FY/uMSRa7Mv04131YffpWaaIJmoyCMvofhHFRtn
 h3OrOMPwXfvK/solMH+QtdwHCdo5IAcskFa6vP/cgWmRNWC7HH0fnD5LdpK+3UwZ56q5 cg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf8u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:08:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:08:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:08:51 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 53F343F7043;
        Mon, 20 Jul 2020 11:08:47 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 01/16] linkmode: introduce linkmode_intersects()
Date:   Mon, 20 Jul 2020 21:08:00 +0300
Message-ID: <20200720180815.107-2-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720180815.107-1-alobakin@marvell.com>
References: <20200720180815.107-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new helper to find intersections between Ethtool link modes,
linkmode_intersects(), similar to the other linkmode helpers.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 include/linux/linkmode.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/linkmode.h b/include/linux/linkmode.h
index c664c27a29a0..f8397f300fcd 100644
--- a/include/linux/linkmode.h
+++ b/include/linux/linkmode.h
@@ -82,6 +82,12 @@ static inline int linkmode_equal(const unsigned long *src1,
 	return bitmap_equal(src1, src2, __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
+static inline int linkmode_intersects(const unsigned long *src1,
+				      const unsigned long *src2)
+{
+	return bitmap_intersects(src1, src2, __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
 static inline int linkmode_subset(const unsigned long *src1,
 				  const unsigned long *src2)
 {
-- 
2.25.1

