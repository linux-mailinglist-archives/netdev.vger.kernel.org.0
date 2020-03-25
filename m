Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 098781928EC
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgCYMxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:53:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9848 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727400AbgCYMxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:53:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCp3N3009882;
        Wed, 25 Mar 2020 05:53:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=9fs6nDV5mQA+2KJYT5Mllt00nd4z3LNGfsgoCjG2Wao=;
 b=IqdKhpP+Ppmc2rAXKIs3PTc6YU8JqKg+XipqMjCAeVTLNVzVb6SIXGJ5zcQhvSqtEiq9
 c+gpq8c8lYiacIrOtqH7f2JEjq1zpZk9XjOFjnW2BLTuOx7cqmYmxWzQj0YHeGp7tcMh
 85sdJORBwbaIWVs1M/oy1TA4Bm5hirdhDREpynfvAEdtPigIa9dB6pPM0mC00UYTOadw
 7qw4to6Ed6vdHv9ks0IiZ0pZgOcCgBVaBD4J297un7XPi9MmDljqBWLpg8pR0pgIy6bA
 PhZ1wI59D8IoiZzQSPEp9iBg4LlRY3blYk2H+c1WTxDJD26GdfXEiCVUUNxyWcGEQH5i 2Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nrgfu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:53:00 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:52:59 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 05:52:59 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id D05AB3F7040;
        Wed, 25 Mar 2020 05:52:57 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 03/17] net: macsec: allow to reference a netdev from a MACsec context
Date:   Wed, 25 Mar 2020 15:52:32 +0300
Message-ID: <20200325125246.987-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325125246.987-1-irusskikh@marvell.com>
References: <20200325125246.987-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

This patch allows to reference a net_device from a MACsec context. This
is needed to allow implementing MACsec operations in net device drivers.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 include/net/macsec.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/macsec.h b/include/net/macsec.h
index 2e4780dbf5c6..71de2c863df7 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -220,7 +220,10 @@ struct macsec_secy {
  * struct macsec_context - MACsec context for hardware offloading
  */
 struct macsec_context {
-	struct phy_device *phydev;
+	union {
+		struct net_device *netdev;
+		struct phy_device *phydev;
+	};
 	enum macsec_offload offload;
 
 	struct macsec_secy *secy;
-- 
2.17.1

