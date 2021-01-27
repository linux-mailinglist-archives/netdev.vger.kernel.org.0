Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B663E305A86
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbhA0L7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 06:59:39 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34478 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237207AbhA0Lrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 06:47:37 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10RBeLHB000957;
        Wed, 27 Jan 2021 03:44:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=km1SSvkjcFlecBnfqs0aQMqb68jUv/dgma5LuQzQjKM=;
 b=Pj3Gj2DhiZpCh6b1yLCUIWsnDoCYd8i7n32FrtQ6k+E0ejr6eUv5rHJVf2Siew0WX/1i
 mLa2xyl/KAjvVg9rWq09TIt19kc1Ceez5dEpoFN0mwXjSN+zZHWKQdp4DQ+nesvM3BUj
 8T7yUwH4ADrAQAzbI+ZcGatXDUH8WnVDxv7RlBUdaMV2UoGXzJNCks4LEs65vATS1W1j
 DWktyNKIBKHS92dZDbQrGZuEBNjzR0l2BjRQshxtwFtoembHUzQSkTHwpr4VrWeA3ljG
 Onkg6znsyoPoqSS5NRwfacbNafUrTjKNCU9gzCgiepJy3wAKcTy+8eRMK4Am/cp1gVqF EA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1ube91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 03:44:49 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 03:44:48 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 03:44:47 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 27 Jan 2021 03:44:47 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id C2A243F703F;
        Wed, 27 Jan 2021 03:44:44 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v4 net-next 18/19] net: mvpp2: limit minimum ring size to 1024 descriptors
Date:   Wed, 27 Jan 2021 13:43:34 +0200
Message-ID: <1611747815-1934-19-git-send-email-stefanc@marvell.com>
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

