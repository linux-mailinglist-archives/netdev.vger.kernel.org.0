Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A708D38EF
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 07:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfJKFxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 01:53:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2448 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbfJKFxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 01:53:18 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9B5psw6008514
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 01:53:17 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vjbndv829-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 01:53:15 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <clg@kaod.org>;
        Fri, 11 Oct 2019 06:53:08 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 11 Oct 2019 06:53:07 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9B5r4P245875388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Oct 2019 05:53:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FAC24C04E;
        Fri, 11 Oct 2019 05:53:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 594AC4C044;
        Fri, 11 Oct 2019 05:53:04 +0000 (GMT)
Received: from smtp.tls.ibm.com (unknown [9.101.4.1])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Oct 2019 05:53:04 +0000 (GMT)
Received: from yukon.kaod.org.com (sig-9-145-63-191.uk.ibm.com [9.145.63.191])
        by smtp.tls.ibm.com (Postfix) with ESMTP id 844492200D8;
        Fri, 11 Oct 2019 07:53:03 +0200 (CEST)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     Juliet Kim <julietk@linux.vnet.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     John Allen <jallen@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH] net/ibmvnic: Fix EOI when running in XIVE mode.
Date:   Fri, 11 Oct 2019 07:52:54 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19101105-4275-0000-0000-0000037112B8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101105-4276-0000-0000-000038841C94
Message-Id: <20191011055254.8347-1-clg@kaod.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-11_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=624 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910110055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pSeries machines on POWER9 processors can run with the XICS (legacy)
interrupt mode or with the XIVE exploitation interrupt mode. These
interrupt contollers have different interfaces for interrupt
management : XICS uses hcalls and XIVE loads and stores on a page.
H_EOI being a XICS interface the enable_scrq_irq() routine can fail
when the machine runs in XIVE mode.

Fix that by calling the EOI handler of the interrupt chip.

Fixes: f23e0643cd0b ("ibmvnic: Clear pending interrupt after device reset")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2b073a3c0b84..f59d9a8e35e2 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2878,12 +2878,10 @@ static int enable_scrq_irq(struct ibmvnic_adapter *adapter,
 
 	if (test_bit(0, &adapter->resetting) &&
 	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
-		u64 val = (0xff000000) | scrq->hw_irq;
+		struct irq_desc *desc = irq_to_desc(scrq->irq);
+		struct irq_chip *chip = irq_desc_get_chip(desc);
 
-		rc = plpar_hcall_norets(H_EOI, val);
-		if (rc)
-			dev_err(dev, "H_EOI FAILED irq 0x%llx. rc=%ld\n",
-				val, rc);
+		chip->irq_eoi(&desc->irq_data);
 	}
 
 	rc = plpar_hcall_norets(H_VIOCTL, adapter->vdev->unit_address,
-- 
2.21.0

