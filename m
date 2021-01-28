Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DAF307E23
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhA1Shc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:37:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32892 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232047AbhA1SfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 13:35:17 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10SI5sfS020032;
        Thu, 28 Jan 2021 10:32:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NCKf5ZgnSrIWPXx0HhVLtblWXDlmyMzkkzVWLJrrAyg=;
 b=RrvOpNbEZAqqXlYYD++b2+1C0N9mZzJjTujwDoiStxVTFR5GRQov5lmIhs6dZ88O+6cY
 CsMZiswIv6PXfOH9iCtCb+Xw2pKThmOkW5NpOiBjHvh4WoH+YHpSGPZVf1g6gDlVIF1c
 war/mrLvjlgiHgUtC21FFrdKXJ2cNdndxGH9V1CSqavqZwTIvgQLIQJJcP4wb2I2jufK
 LFeNggvb6Ip1hYFdXF/4HNGAEENVl9jqoCacCDuEarRpTlpH8SrJe0bW6GeEm33N1nBE
 iYAMXWYPcBXrf6aZNcbqLfgqjnN++U18limSfoBrFai5b/O+ryg2OEsVhmZWhPhJyBqr MA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1ufxgp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 10:32:31 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jan
 2021 10:32:30 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jan
 2021 10:32:29 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 28 Jan 2021 10:32:28 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id E635A3F703F;
        Thu, 28 Jan 2021 10:32:25 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v5 net-next 17/18] net: mvpp2: limit minimum ring size to 1024 descriptors
Date:   Thu, 28 Jan 2021 20:31:21 +0200
Message-ID: <1611858682-9845-18-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
References: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_12:2021-01-28,2021-01-28 signatures=0
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
index 7632810..98849b0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4543,6 +4543,8 @@ static int mvpp2_check_ringparam_valid(struct net_device *dev,
 
 	if (ring->rx_pending > MVPP2_MAX_RXD_MAX)
 		new_rx_pending = MVPP2_MAX_RXD_MAX;
+	else if (ring->rx_pending < MSS_THRESHOLD_START)
+		new_rx_pending = MSS_THRESHOLD_START;
 	else if (!IS_ALIGNED(ring->rx_pending, 16))
 		new_rx_pending = ALIGN(ring->rx_pending, 16);
 
-- 
1.9.1

