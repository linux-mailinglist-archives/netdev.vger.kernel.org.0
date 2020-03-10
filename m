Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A80A1801B1
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgCJPWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:22:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41942 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgCJPWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:22:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AFJLm5008710;
        Tue, 10 Mar 2020 08:22:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=IuEiUeioqUJFZXxjCV8B/9e8ydnxY9fCJY6KwqIcy+8=;
 b=cHjSf9QApFzKp9Yo16kmr2QJY5OPQn4vDliaKys3jLyvH+1hS5+XF6fiaxocQ48e/Tip
 58qooZOOSCysX4gqwonGnJoC8Ozl3n/yYp+Py3epwIWo6X7IAhR8BD/l14CxQDhvgqk0
 fA6e+TMm2SF5dMgPhtJV2bri2urLiTDoaTACzKv5slRaUsDyma/dqNtYYE6mXMKvUuV7
 aWMZE6FMvTizNSLFAlu5AVTqbYp1K05fwhru7UDgzq/MGvUTA3Yj9xTyAqEf8eX2O/vg
 CLKE7J2vqj33Jt2dsiWvrBRf6Kci/p6ue4fLjNKI5SV+xHUtsA7q2xoA2cvF2eA2l2lb XA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwpqse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:22:47 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:22:46 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:22:45 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id 802573F7040;
        Tue, 10 Mar 2020 08:22:44 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH net 1/2] net: macsec: update SCI upon MAC address change.
Date:   Tue, 10 Mar 2020 18:22:24 +0300
Message-ID: <20200310152225.2338-2-irusskikh@marvell.com>
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

SCI should be updated, because it contains MAC in its first 6 octets.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 45bfd99f17fa..d8e1d9290c47 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -424,6 +424,11 @@ static struct macsec_eth_header *macsec_ethhdr(struct sk_buff *skb)
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
@@ -3268,6 +3273,7 @@ static int macsec_set_mac_address(struct net_device *dev, void *p)
 
 out:
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
 	return 0;
 }
 
@@ -3592,11 +3598,6 @@ static bool sci_exists(struct net_device *dev, sci_t sci)
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

