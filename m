Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A70E1801B2
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgCJPWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:22:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48568 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgCJPWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:22:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AFJM6w008718;
        Tue, 10 Mar 2020 08:22:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=5T3Dp9eTMWz71EoXDgMqXhwxb7Os3GmXXJjdX1sSLr4=;
 b=J4Lu05wUih1UBhOPIgaqWv/+6oI2NNqYwG/ZXcLdIASpjNy8RFHt/QgxuyxgpDheduY5
 aWL6MEyxFhlg3MCqtkZ1cOf47VVnnHUCgJTfwfejQGS4GoZajkwb+NiHGXlJpT9vJebg
 KHk1hn+iQanK463/KhBM8y0+Nx88Yqpt58zsEkyzcmMk7p4Yps6pFw4PMTFROdmQrJNL
 3Tr95N9FIAJnhVHemgRKoS7wcbTGI7Yf8CTOkiXcDmXEUOL8TN3I4ADuAxWvjCicsZmA
 bgcd/+8FIUmJaH0iP1fAwuGzaHXtSsYXxXEJ6R+fChVP9iFIoeRrEs7sHUzbAp3ZwYVW zA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwpqsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:22:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:22:49 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:22:48 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:22:48 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id D0BEB3F703F;
        Tue, 10 Mar 2020 08:22:46 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH net 2/2] net: macsec: invoke mdo_upd_secy callback when mac address changed
Date:   Tue, 10 Mar 2020 18:22:25 +0300
Message-ID: <20200310152225.2338-3-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310152225.2338-1-irusskikh@marvell.com>
References: <20200310152225.2338-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_10:2020-03-10,2020-03-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

Notify the offload engine about MAC address change to reconfigure it
accordingly.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index d8e1d9290c47..9fda72de761c 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3274,6 +3274,19 @@ static int macsec_set_mac_address(struct net_device *dev, void *p)
 out:
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
 	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
+
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(macsec, &ctx);
+		if (ops) {
+			ctx.secy = &macsec->secy;
+			macsec_offload(ops->mdo_upd_secy, &ctx);
+		}
+	}
+
 	return 0;
 }
 
-- 
2.17.1

