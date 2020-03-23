Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A69318F56E
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgCWNPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:15:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59648 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728240AbgCWNO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:14:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ND60gF010448;
        Mon, 23 Mar 2020 06:14:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=LGHAe7/enz9me2vEW0hbX8i3qEJ3Pta9KLhuY2SE+V8=;
 b=hLg3uvYZuIqaSWB7N5lS2H2L3sHfBNTXDiVB88ZYMThVyl4BqvoPuJ8vGR8MGbjCcszG
 VxRDpUAkfcaPtM64QDRTNwz+DTwvUpg/pdNH3jl7NRgpjSIrGs7U4AnSQJDuh5jlYDIF
 7M2NmHGrvDJ3zlTbK3PWKBfSN2FohRJlz6Y6kDPeTtS/DytcpQpF7DNRTouWCen2oLN8
 YgJTzKCi0xmNjsiXPBkmRZIJ6townZ/BV0uMmZhZUBQng9MQAHTfqd8t4TJB2f9te0j/
 u0hYyw0WKEohwXL1qomKyYAw8snUYb2sgcJXHTj2oPvfLRvYJK4tBb/JJIYXvJwv3Dzn uw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nefqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 06:14:54 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 06:14:53 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Mar 2020 06:14:53 -0700
Received: from localhost.localdomain (unknown [10.9.16.91])
        by maili.marvell.com (Postfix) with ESMTP id 6C0E93F703F;
        Mon, 23 Mar 2020 06:14:51 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 06/17] net: macsec: allow multiple macsec devices with offload
Date:   Mon, 23 Mar 2020 16:13:37 +0300
Message-ID: <20200323131348.340-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323131348.340-1-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_04:2020-03-21,2020-03-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

Offload engine can setup several SecY. Each macsec interface shall have
its own mac address. It will filter a traffic by dest mac address.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 0f6808f3ff91..5d1564cda7fe 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2552,11 +2552,10 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	enum macsec_offload offload, prev_offload;
 	int (*func)(struct macsec_context *ctx);
 	struct nlattr **attrs = info->attrs;
-	struct net_device *dev, *loop_dev;
+	struct net_device *dev;
 	const struct macsec_ops *ops;
 	struct macsec_context ctx;
 	struct macsec_dev *macsec;
-	struct net *loop_net;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -2584,28 +2583,6 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	    !macsec_check_offload(offload, macsec))
 		return -EOPNOTSUPP;
 
-	if (offload == MACSEC_OFFLOAD_OFF)
-		goto skip_limitation;
-
-	/* Check the physical interface isn't offloading another interface
-	 * first.
-	 */
-	for_each_net(loop_net) {
-		for_each_netdev(loop_net, loop_dev) {
-			struct macsec_dev *priv;
-
-			if (!netif_is_macsec(loop_dev))
-				continue;
-
-			priv = macsec_priv(loop_dev);
-
-			if (priv->real_dev == macsec->real_dev &&
-			    priv->offload != MACSEC_OFFLOAD_OFF)
-				return -EBUSY;
-		}
-	}
-
-skip_limitation:
 	/* Check if the net device is busy. */
 	if (netif_running(dev))
 		return -EBUSY;
-- 
2.17.1

