Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A91305A54
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 12:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbhA0Lu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 06:50:29 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46144 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237177AbhA0LrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 06:47:00 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10RBdsvW000705;
        Wed, 27 Jan 2021 03:44:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=+glgT6FVsi4OmmKSyjeV/VrzDu/aaNjDQWcVzzEJcgc=;
 b=OhFQeBcWNcFPBdMmziANXaMfZ/yLT/E6ftkzjHLCz7lzNVpPI1Ueg/hPuJfrTsOoe6IT
 uFZt+ynCnNDXnLThhrRJOkr6ahgvuN75yP4djDOdkkiFznP5Pxw7D+kGDRAEMtHEszxA
 bQyp9+RnYNfEGg+8zgdaU0517Cz7HpCz71DzxGQfcOpKY04aoGIPKN4BQaINTu+tuKoD
 tux+fRKMH0bU/nv/Y2nG8Ym30VSqniMfZp3FBqbkTzlQ3Z3iE0rnkAyT3K+8ncEzCUhP
 l95bkDaMQt4Zmopigdw5uT93CbnD/bhN9QbkuNoTcqTp2iZN3hOJQBriFKWMt1NzcUGe 1g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1ube7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 03:44:12 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 03:44:11 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 03:44:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 27 Jan 2021 03:44:10 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 9AD843F7041;
        Wed, 27 Jan 2021 03:44:07 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v4 net-next 07/19] net: mvpp2: increase BM pool size to 2048 buffers
Date:   Wed, 27 Jan 2021 13:43:23 +0200
Message-ID: <1611747815-1934-8-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

BM pool size increased to support Firmware Flow Control.
Minimum depletion thresholds to support FC is 1024 buffers.
BM pool size increased to 2048 to have some 1024 buffers
space between depletion thresholds and BM pool size.

Jumbo frames require a 9888B buffer, so memory requirements
for data buffers increased from 7MB to 24MB.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 89b3ede..8dc669d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
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

