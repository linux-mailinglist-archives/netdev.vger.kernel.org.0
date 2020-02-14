Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1B2915DA2B
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgBNPD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:27 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29792 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729412AbgBNPD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:26 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF15kR013947;
        Fri, 14 Feb 2020 07:03:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=4sL5ykB1W7SzdvhrAWCyQB4dP14eFi9ymg3NYGhJsAs=;
 b=RpB6ZR3qujtuC2eLFswupGclX41GLB2nGt/03+3KCMvbti/VxiGVZtDjYi5JmykIPpL0
 FleM6l7CCqcZGw0Hsn8FnWJbtB8jihRTBqz4uL8BFtOhwmM6K673es6tFByRstKXwndX
 IhOMZlAw2pJVbe4ZOHSjZ8yiymOHpa1en1AFtTFx2t0BvZAbJIjRCAa3CQisAfnmNIVL
 cqS9+B69m/ve4OTFR3ZX0M+9csTaaDLiBvI3U1aAngO8BKG/iyS7feBQnMzbYaAhznFK
 ww1GzQQTe3f6u0EnWLV+gvDo55FtztgZGsDJv64MTyLepeHcoEIr5oaSKboBezb8UUfU 3g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5k3grt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:23 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:21 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:21 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 78F643F7040;
        Fri, 14 Feb 2020 07:03:19 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 06/18] net: macsec: invoke mdo_upd_secy callback when mac address changed
Date:   Fri, 14 Feb 2020 18:02:46 +0300
Message-ID: <20200214150258.390-7-irusskikh@marvell.com>
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

Change SCI according to the new MAC address, because it must contain MAC
in its first 6 octets.
Also notify the offload engine about MAC address change to reconfigure it
accordingly.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index af41887d9a1e..973b09401099 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -433,6 +433,11 @@ static struct macsec_eth_header *macsec_ethhdr(struct sk_buff *skb)
 	return (struct macsec_eth_header *)skb_mac_header(skb);
 }
 
+static sci_t dev_to_sci(struct net_device *dev, __be16 port)
+{
+	return make_sci(dev->dev_addr, port);
+}
+
 static void __macsec_pn_wrapped(struct macsec_secy *secy,
 				struct macsec_tx_sa *tx_sa)
 {
@@ -3291,6 +3296,21 @@ static int macsec_set_mac_address(struct net_device *dev, void *p)
 
 out:
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
+
+	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
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
 
@@ -3615,11 +3635,6 @@ static bool sci_exists(struct net_device *dev, sci_t sci)
 	return false;
 }
 
-static sci_t dev_to_sci(struct net_device *dev, __be16 port)
-{
-	return make_sci(dev->dev_addr, port);
-}
-
 static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
-- 
2.17.1

