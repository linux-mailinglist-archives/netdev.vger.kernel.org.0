Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0A43126D8
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 19:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhBGSoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 13:44:10 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28428 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229992AbhBGSnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 13:43:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117IcYQK021733;
        Sun, 7 Feb 2021 10:40:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Z+f0d37uesmDP0+y3HpvCSl9s9Y4PX1qxt3JxKGneCM=;
 b=BRpErK6pNspiSmYxZ94Ku57Z9gVM4w7ms2spUhc3OkyHR+yKC6u82eUCd/e4wMYHLg11
 fcdhKqGv78Qg33S30MEI5R9LGzPTrjk/aA9oKCiXj147Oibr6VckyI/QzPqN/GusjoaM
 0YgMQsud3lhpLa/QVXbAfsDvysrieF7t/T5tIIePgoMsLnkaeKicMxKVZqqLwWpu7+kW
 NxsYjVCw0Q/vc7zHGZgTNkFKn/D3BLZo4DyFM7zkQFIUJysib4JWUPp6Wng5Ue11n/XU
 E3sfj79ZjHxjA2zaoO2Fqy/VGUmcKT4MCrAO0OQG3F5uvMtvzgo+sG7TRF6+RO1mch6s oQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbramms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 10:40:51 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:40:50 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:40:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 7 Feb 2021 10:40:49 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 928453F7040;
        Sun,  7 Feb 2021 10:40:45 -0800 (PST)
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
Subject: [PATCH v9 net-next 06/15] net: mvpp2: increase BM pool and RXQ size
Date:   Sun, 7 Feb 2021 20:38:48 +0200
Message-ID: <1612723137-18045-7-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612723137-18045-1-git-send-email-stefanc@marvell.com>
References: <1612723137-18045-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_10:2021-02-05,2021-02-07 signatures=0
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

