Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEB330288E
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 18:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbhAYRNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 12:13:53 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49116 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730566AbhAYRNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 12:13:06 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10PGpMBF017885;
        Mon, 25 Jan 2021 09:10:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=km1SSvkjcFlecBnfqs0aQMqb68jUv/dgma5LuQzQjKM=;
 b=PMT0V927lFLK0MoTpBS0FjqgwOhxB5GeaRWj1a/d+d/XUCUdXYB9nn9XAiR/f/Htzbls
 gIe93bDjT+LyXAxtEd8F0TeIaoXl9Njukn3rcwJ+WLsximf/Jh0nXjlF2r5R3Obzm0nc
 DSgHNDX2084cTh987gqNqyJpA9JUJpWDmw9lr5+FaWbbeH4FCy3yPrOneEbUF9CNY+yo
 DSuys+q0uU/wucq68QDuLzFfiZEOtFB+4TVap8mhG8tRxpJXKQ5/VShXUilQsvnJFeav
 CDKLzKZsjBvakbz2OxKo2QO7Mwai4gZbe409MqqFM/x4OZ0ulT4zMGH6YkCoutb4bS2R uw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1u5ajm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 09:10:20 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 09:10:19 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 09:10:18 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 25 Jan 2021 09:10:18 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id C19FB3F7040;
        Mon, 25 Jan 2021 09:10:15 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v3 RFC net-next 18/19] net: mvpp2: limit minimum ring size to 1024 descriptors
Date:   Mon, 25 Jan 2021 19:08:05 +0200
Message-ID: <1611594486-29431-19-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611594486-29431-1-git-send-email-stefanc@marvell.com>
References: <1611594486-29431-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_07:2021-01-25,2021-01-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

To support Flow Control ring size should be at least 1024 descriptors.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 55138c7..bb7dfed 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4545,6 +4545,8 @@ static int mvpp2_check_ringparam_valid(struct net_device *dev,
 
 	if (ring->rx_pending > MVPP2_MAX_RXD_MAX)
 		new_rx_pending = MVPP2_MAX_RXD_MAX;
+	else if (ring->rx_pending < MSS_THRESHOLD_START)
+		new_rx_pending = MSS_THRESHOLD_START;
 	else if (!IS_ALIGNED(ring->rx_pending, 16))
 		new_rx_pending = ALIGN(ring->rx_pending, 16);
 
-- 
1.9.1

