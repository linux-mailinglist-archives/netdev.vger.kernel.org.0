Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E755B2F0814
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbhAJPeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:34:36 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30956 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbhAJPef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:34:35 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AFPqND022814;
        Sun, 10 Jan 2021 07:31:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=aTdMa86zjmpdqXC5/JL8cy/sUVLo5BB2PTgocQ5zJMU=;
 b=kTr1bJBj0oydnnsU0mfb8He1utVCAUoo9aMfATYOxlahVZPwdWyeffcDuca4CmopBnYM
 klM3W57phMWC1KXVbW3EylDZNn3uF7b9+KDXsW7PPd9sqFj6hGRfGPwbfQSpkjzBW2l0
 ig6dlu6DdwP2X/E+JpviIMi28UVEKBa4gNZfDR9QwiajGkK4HGFHcp0p5UG/qfHchiWA
 gjzsC7udC9v83TEmzln2jgAtluXxt22qE5zl08BJ1c7Lp6mZh096reqxSe8c0eXx+SLH
 T2JqHVS3Pbscd8GfdMPIIBSVnqnPOa1df152V8ABL72xKu0+RQOpyOWVjOPESfBY0V+y +A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvphve4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 07:31:47 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:44 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 07:31:43 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id D56A53F7040;
        Sun, 10 Jan 2021 07:31:40 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH RFC net-next  13/19] net: mvpp2: add RXQ flow control configurations
Date:   Sun, 10 Jan 2021 17:30:17 +0200
Message-ID: <1610292623-15564-14-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch add RXQ flow control configurations.
Patch do not enable flow control itself, flow control
disabled by default.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 3 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index e6bab52..57f7bbc 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1234,6 +1234,9 @@ struct mvpp2_port {
 	bool rx_hwtstamp;
 	enum hwtstamp_tx_types tx_hwtstamp_type;
 	struct mvpp2_hwtstamp_queue tx_hwtstamp_queue[2];
+
+	/* Firmware TX flow control */
+	bool tx_fc;
 };
 
 /* The mvpp2_tx_desc and mvpp2_rx_desc structures describe the
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b7ea94f..3b85aec 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3176,6 +3176,9 @@ static void mvpp2_cleanup_rxqs(struct mvpp2_port *port)
 
 	for (queue = 0; queue < port->nrxqs; queue++)
 		mvpp2_rxq_deinit(port, port->rxqs[queue]);
+
+	if (port->tx_fc)
+		mvpp2_rxq_disable_fc(port);
 }
 
 /* Init all Rx queues for port */
@@ -3188,6 +3191,10 @@ static int mvpp2_setup_rxqs(struct mvpp2_port *port)
 		if (err)
 			goto err_cleanup;
 	}
+
+	if (port->tx_fc)
+		mvpp2_rxq_enable_fc(port);
+
 	return 0;
 
 err_cleanup:
-- 
1.9.1

