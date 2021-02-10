Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609833162D2
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhBJJyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:54:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36452 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230000AbhBJJwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:52:06 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11A9eJ4T004754;
        Wed, 10 Feb 2021 01:51:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=YyJXkIQMp5qbfuiiSaJE+CSG0i2d7aawRmMsgk1siTI=;
 b=QW/wxnPv0AXHy4lmz7fYRRFJb6UIAHxBzsfUgSA8N/c25RMWGx5zXvKAihNziZ54u8QT
 ry/24cvaqH3jgq/vmWaxC6i+kKSTh4XqFPlaKJK80vpWvpXD9BkuM6XMzTopMB+qKItj
 f2jafS2dB0yELAP3T8/8avamBMF0suV/a30TDLcTWEBLTlnB0iD7bQ45Y5PkpFdcoRfN
 i26Ww5j87SJAP2vD/NwLj/vsm+vODGJGsqG3V7rxlixlozMoGPPZDZtXnaKjxcpfUmAo
 a9fBWh0EDFYohoXwJdN9f8mLp6sGnXFOY0nSanSyuusUZ0CpKmH3ZaF5nLaAooO/lOEe mg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrkghd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 01:51:02 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 01:51:00 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 01:51:00 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 01:51:00 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 6B4683F7040;
        Wed, 10 Feb 2021 01:50:56 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <sebastian.hesselbarth@gmail.com>,
        <gregory.clement@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v12 net-next 06/15] net: mvpp2: increase BM pool and RXQ size
Date:   Wed, 10 Feb 2021 11:48:11 +0200
Message-ID: <1612950500-9682-7-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
References: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_03:2021-02-09,2021-02-10 signatures=0
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
Acked-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index ce08086..e7bbf0a 100644
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
@@ -848,8 +848,8 @@ enum mvpp22_ptp_packet_format {
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

