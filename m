Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37EC215DA2C
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgBNPD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:29 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34876 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729534AbgBNPD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:27 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF02LJ019060;
        Fri, 14 Feb 2020 07:03:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Fjl84OuBNGmLQcRJXWcUt6yiLH0dwaKu3ZjGMn1oQGk=;
 b=jS9I5sIgO/SBJRazrkBoZt3IUENFFQL2b3UadBArUeTgw1bhB9AJpRdOwQ0WFUUSvhQq
 O3XcSwwIE9DHGT+0JCt7qnYAUlO9Rb7bYgPBr3xIzJLW9XaTf9o1t1a29LGQ4MmhKxRg
 oQ5Z8odq1C60r21nGdwSx5r1CvpUFt/SPpWyE5HrYiWn/K6cWZUAwKvOlkKFPaYQyyLl
 skPgJWgXTYyZuAv51eafFuRbqLs+evoipI+FVLGDr5a7GDMET8qasVbx09jTqPPuuLNP
 MqMqxCJvcJTj25l2mweOzvbS/2OUzsryTFVK7Z3/QY5Sw+6SL8YhXqseCcYA58Bap/22 +w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2n5m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:24 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:23 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:23 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 9AA483F7043;
        Fri, 14 Feb 2020 07:03:21 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 07/18] net: macsec: allow multiple macsec devices with offload
Date:   Fri, 14 Feb 2020 18:02:47 +0300
Message-ID: <20200214150258.390-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214150258.390-1-irusskikh@marvell.com>
References: <20200214150258.390-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
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
index 973b09401099..066d61238b11 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2394,11 +2394,10 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
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
@@ -2426,28 +2425,6 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
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

