Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4760318EA4
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 16:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhBKPbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 10:31:19 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6904 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231180AbhBKP2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 10:28:02 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BF55bR011612;
        Thu, 11 Feb 2021 07:13:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=bOUPWd7NjerE0DDO/8OeF9/+j6LpVJxLpVk7ndXZwIE=;
 b=eTCzgReFZGVOnm08YKQ47oNagyMvzz2SS4JoVDdztb7+Yx01jgrioTHsQ3S+Bhp6dC53
 mKQffuNw7AFARXcPKtarno3+4h3N9qA4pIP1dHN70/rM8yx+kKoiLCgS8PRFdolbPXdi
 ckIFCvTkISbs+NWRUcD9Ebu96vrV/F2cV7zw0RrrsWlTYhtQbFZEptWj0R1Fp3WEJWnM
 t9SbFBi3LBLHwCZzqU42nk2vJ67T3Ok4hAzX0Q3CCh0wEXrhSnWsJ/uQPjUuPrmal0aw
 0M9Lm9MR4cVIh7vh6qxHxLsW+BF3huSrz6SIZtbR51yyZj3cTijP7bCt7RdnkBt2tpJ8 pw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqf3xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 07:13:43 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:13:41 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:13:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 07:13:40 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id AAE213F7040;
        Thu, 11 Feb 2021 07:13:37 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [net-next] net: mvpp2: fix interrupt mask/unmask skip condition
Date:   Thu, 11 Feb 2021 17:13:19 +0200
Message-ID: <1613056399-18730-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_06:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

The condition should be skipped if CPU ID equal to nthreads.
The patch doesn't fix any actual issue since
nthreads = min_t(unsigned int, num_present_cpus(), MVPP2_MAX_THREADS).
On all current Armada platforms, the number of CPU's is
less than MVPP2_MAX_THREADS.

Fixes: e531f76757eb ("net: mvpp2: handle cases where more CPUs are available than s/w threads")
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a07cf60..74613d3 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1135,7 +1135,7 @@ static void mvpp2_interrupts_mask(void *arg)
 	struct mvpp2_port *port = arg;
 
 	/* If the thread isn't used, don't do anything */
-	if (smp_processor_id() > port->priv->nthreads)
+	if (smp_processor_id() >= port->priv->nthreads)
 		return;
 
 	mvpp2_thread_write(port->priv,
@@ -1153,7 +1153,7 @@ static void mvpp2_interrupts_unmask(void *arg)
 	u32 val;
 
 	/* If the thread isn't used, don't do anything */
-	if (smp_processor_id() > port->priv->nthreads)
+	if (smp_processor_id() >= port->priv->nthreads)
 		return;
 
 	val = MVPP2_CAUSE_MISC_SUM_MASK |
-- 
1.9.1

