Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290A1302947
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 18:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbhAYRsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 12:48:12 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6906 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730532AbhAYRND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 12:13:03 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10PGpMBC017885;
        Mon, 25 Jan 2021 09:09:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=iDGO9e6WjFQdtKXBQtrCl6dwPG3F4+zdg7fmYSpDeKc=;
 b=k049cDx4hr3YFwjSjF/D8xAFIWOhc5Hb1Utf3g0UOv3mdJN5iNglkxLDYuANPaAp6xvK
 2+N6cOUrXAitVUZE8oTpqYfpEXXwQ0V/V1Gs9Ns9w+bO74hUCkBWxdiXD1X/mgoDOn82
 i3wnqbIDKY+xHjBOF2LfUufU5sLxbYVl2iXhc6hviQg0vNNkXCYRIgFpteVzYGXhI4yW
 7um/HoK1hLETl1HwszaHR8W6mlHVPzwqfjM9hwn5e2Zm4mQ1iR5ERrO3u77Mb5ZGtv7P
 tdQti9zvkpGveBn3fz5g7JiUatZvvYdnIStN1Y9TjOZwH9vaDexl5Gc9HnMLpPM1M1BL dA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1u5ah6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 09:09:56 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 09:09:55 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 09:09:54 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 25 Jan 2021 09:09:54 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id E1C413F7040;
        Mon, 25 Jan 2021 09:09:51 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v3 RFC net-next 11/19] net: mvpp2: add spinlock for FW FCA configuration path
Date:   Mon, 25 Jan 2021 19:07:58 +0200
Message-ID: <1611594486-29431-12-git-send-email-stefanc@marvell.com>
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

Spinlock added to MSS shared memory configuration space.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 5 +++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 9d8993f..f34e260 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1021,6 +1021,11 @@ struct mvpp2 {
 
 	/* CM3 SRAM pool */
 	struct gen_pool *sram_pool;
+
+	bool custom_dma_mask;
+
+	/* Spinlocks for CM3 shared memory configuration */
+	spinlock_t mss_spinlock;
 };
 
 struct mvpp2_pcpu_stats {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a4933c4..64534f0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7163,6 +7163,9 @@ static int mvpp2_probe(struct platform_device *pdev)
 			priv->hw_version = MVPP23;
 	}
 
+	/* Init mss lock */
+	spin_lock_init(&priv->mss_spinlock);
+
 	/* Initialize network controller */
 	err = mvpp2_init(pdev, priv);
 	if (err < 0) {
-- 
1.9.1

