Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99DC015DA30
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgBNPDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:36 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49840 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729534AbgBNPDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF074D019190;
        Fri, 14 Feb 2020 07:03:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=krO3/rFNUhk9MSSi3yF4dzeMRucA9hY/+ZYq4yKAP9k=;
 b=k7P6X27b48Detp1P8T5hMS1Vg9qz7yJ9Ry+ObVLl05F9xVduW/6Q6Zk+exR7N1m6VWw0
 JPovJtDH13jd997e2iVIBbGdZcCab1xu8Xkp0RIPoxaoGcvzSFOLNJ5mAC85VnffVkDF
 UjZCxdW6pMJLEtNI2tgBqNRSBxrMSWrRN8sgRQ3h6gbESfJU/W9Vo6roF3WgW3XA6CXk
 P2g7OGN/f2NwRTqJK9Z26qCtYh2Z291DMWXGD8AR4koNb0OE3llTglSblTw5Ahulzex4
 3xaaFp0d0Aajwcki18D6P01XxbPhYeVpsTHWWcfh5kN/O7GNZX2KAn7iu6FayBgJePgx jw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2n5n3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:32 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:30 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:30 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:29 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 299F73F703F;
        Fri, 14 Feb 2020 07:03:27 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 10/18] net: macsec: enable HW offloading by default (when available)
Date:   Fri, 14 Feb 2020 18:02:50 +0300
Message-ID: <20200214150258.390-11-irusskikh@marvell.com>
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

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch makes HW offload to be enabled by default (when available).
This patch along with the next one (reporting real_dev features) are
both required to fix the issue described below.

Issue description:
real_dev features are disabled upon macsec creation.

Root cause:
Features limitation (specific to SW MACSec limitation) is being applied
to HW offloaded case as well.
This causes 'set_features' request on the real_dev with reduced feature
set due to chain propagation.
IF SW MACSec limitations are not applied to HW offloading case (see the
next path), then we still face an issue, because SW MACSec is enabled by
default.

Proposed solution:
Enable HW offloading by default (when available).

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 0ee647238996..38403037cea0 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3816,8 +3816,13 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 
 	macsec->real_dev = real_dev;
 
-	/* MACsec offloading is off by default */
-	macsec->offload = MACSEC_OFFLOAD_OFF;
+	/* If h/w offloading is available, enable it by default */
+	if (real_dev->features & NETIF_F_HW_MACSEC && real_dev->macsec_ops)
+		macsec->offload = MACSEC_OFFLOAD_MAC;
+	else if (real_dev->phydev && real_dev->phydev->macsec_ops)
+		macsec->offload = MACSEC_OFFLOAD_PHY;
+	else
+		macsec->offload = MACSEC_OFFLOAD_OFF;
 
 	if (data && data[IFLA_MACSEC_ICV_LEN])
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
@@ -3860,6 +3865,20 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 			goto del_dev;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(macsec, &ctx);
+		if (ops) {
+			ctx.secy = &macsec->secy;
+			err = macsec_offload(ops->mdo_add_secy, &ctx);
+			if (err)
+				goto del_dev;
+		}
+	}
+
 	err = register_macsec_dev(real_dev, dev);
 	if (err < 0)
 		goto del_dev;
-- 
2.17.1

