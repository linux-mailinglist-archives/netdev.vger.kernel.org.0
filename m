Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50368309D14
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhAaOlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:41:25 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30526 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232018AbhAaOhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 09:37:22 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VEZqoC024782;
        Sun, 31 Jan 2021 06:36:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=89cYthI6p8YgZOgHST1mybkKYWQ6iaqPy4nSaOo2Y+Y=;
 b=fN7B8T32o/rBBBwGbok7PgFsTF5kd0nTn5mfdc/EPXJJUW0zSrTK93oPWpEM1nm31r/w
 4JKnRxjfY3wjp68HXi4tmy0TnyTZgEBlIFBEY+897vNNAQ02W44NM1d2TO3LXU+QbySW
 /PreOBgzCWdoqf0JysQxsRqMVQvYY5JLNf+fLCKoyzYCMb1CwzWOlU59mbKUXSuG4FKa
 5lz5jbyOa6Z4cNzbE8Wayf8OkcnImEoq0ayjrfI1+0adlj3T3bA9Bzgf3BwjPScP1D/Y
 8GXptudBWZy6Yu0K1otthWHaowAoaH3f2YKVEPVEYxVa37CyQS+vOboPxzh5D5SRh+kt AA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq1q1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 06:36:33 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:36:31 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:36:31 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 06:36:31 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 5E3343F703F;
        Sun, 31 Jan 2021 06:36:28 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v7 net-next 06/15] net: mvpp2: increase BM pool and RXQ size
Date:   Sun, 31 Jan 2021 16:33:49 +0200
Message-ID: <1612103638-16108-7-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
References: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

BM pool and RXQ size increased to support Firmware Flow Control.
Minimum depletion thresholds to support FC are 1024 buffers.
BM pool size increased to 2048 to have some 1024 buffers
space between depletion thresholds and BM pool size.

Jumbo frames require a 9888B buffer, so memory requirements
for data buffers increased from 7MB to 24MB.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 89b3ede..cac9885 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -715,8 +715,8 @@
 #define MVPP2_PORT_MAX_RXQ		32
 
 /* Max number of Rx descriptors */
-#define MVPP2_MAX_RXD_MAX		1024
-#define MVPP2_MAX_RXD_DFLT		128
+#define MVPP2_MAX_RXD_MAX		2048
+#define MVPP2_MAX_RXD_DFLT		1024
 
 /* Max number of Tx descriptors */
 #define MVPP2_MAX_TXD_MAX		2048
@@ -851,8 +851,8 @@ enum mvpp22_ptp_packet_format {
 #define MVPP22_PTP_TIMESTAMPQUEUESELECT	BIT(18)
 
 /* BM constants */
-#define MVPP2_BM_JUMBO_BUF_NUM		512
-#define MVPP2_BM_LONG_BUF_NUM		1024
+#define MVPP2_BM_JUMBO_BUF_NUM		2048
+#define MVPP2_BM_LONG_BUF_NUM		2048
 #define MVPP2_BM_SHORT_BUF_NUM		2048
 #define MVPP2_BM_POOL_SIZE_MAX		(16*1024 - MVPP2_BM_POOL_PTR_ALIGN/4)
 #define MVPP2_BM_POOL_PTR_ALIGN		128
-- 
1.9.1

