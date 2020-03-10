Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A448180106
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgCJPEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:04:13 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30918 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727682AbgCJPEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:04:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AF1eWU007670;
        Tue, 10 Mar 2020 08:04:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Nip/TeKWG8TPAEfH1Zvuq66z9dZjVCFARRyUqNTG9XU=;
 b=Om4AYGf31JBnsocc5pa65pkisKGUC3hvqboOJjHh2cjXM0CmQnLCtqbYl3bIc/v4Z5Va
 gkfZG3283COluZcWYjEXO7XYtQVw+SNeQHuslqSeaCn0OvyiIZvq25tmS+TyNVLKzUFb
 Dnl+mIcnCNYfwevzUpOx2VrngVnq61Ru+5j7EVELZ1M4sMBOR2LaEvD/zuJbczmO8C0g
 6QN5s9HZ0WICMAaxwi4wLfd7+KcsZsqVVRypqH0by4wFwNn13leIf8xmW6pmvGCDZDMs
 sjLW1hzoPfHmsBUx8SWSuVc58SQYD4JMX+KkoLQTVemeG6iwhyeCA4eK0fHjtO0SKnaI Tw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwpm6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:04:08 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:04:06 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:04:06 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id 6251C3F7043;
        Tue, 10 Mar 2020 08:04:05 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [RFC v2 06/16] net: macsec: allow multiple macsec devices with offload
Date:   Tue, 10 Mar 2020 18:03:32 +0300
Message-ID: <20200310150342.1701-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310150342.1701-1-irusskikh@marvell.com>
References: <20200310150342.1701-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_08:2020-03-10,2020-03-10 signatures=0
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
index af41887d9a1e..45ede40692f8 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2389,11 +2389,10 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
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
@@ -2421,28 +2420,6 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
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

