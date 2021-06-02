Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB4A3984B0
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhFBI6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:58:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15780 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230523AbhFBI6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:58:23 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1528YoAK072958;
        Wed, 2 Jun 2021 04:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xK5C9rkhUyyZ4LlxzTQ619vIgQzyfvH3whUEq27Zw5g=;
 b=afStHo/d/vz2eltcS0T4gyDIVRG94Um1hJI2s3k07uWKv67brcbFCkWuDLBkphaOPneT
 LB5PGaQe+TX9bcra5u1WJkIV5FHvJTk8aF6xohzoidpJ7Fwj9Fwls/khn1Hzu35Z75It
 Xp5XJkr2VYe5EA0pNqpQGw/VGjOKlCvEeaQKTGMY1xRypOmh652riOl349jHZ9M237RC
 TPcdLSt8kT9F8Z7QHmYLC138N2ENTFxC8LH3kbJ8vefglOA6uh4Uez+CI8LegIdJx1nI
 U7OXC/iZR1XSXHQ+cCS6Cc3Th/CkB7MiSVqqJurfRyx5LZjpyA2ykt9+5l3kOb7fkMh4 wA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38x6abh1m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 04:56:38 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1528uYrq002590;
        Wed, 2 Jun 2021 08:56:36 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 38ud8817c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 08:56:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1528uXTf17039842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Jun 2021 08:56:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AEDFA4054;
        Wed,  2 Jun 2021 08:56:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09132A4067;
        Wed,  2 Jun 2021 08:56:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Jun 2021 08:56:32 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next 2/2] net/smc: no need to flush smcd_dev's event_wq before destroying it
Date:   Wed,  2 Jun 2021 10:56:26 +0200
Message-Id: <20210602085626.2877926-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210602085626.2877926-1-kgraul@linux.ibm.com>
References: <20210602085626.2877926-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ALMBSJ8y__zClC2eF0NutB7s3MRQWqE2
X-Proofpoint-GUID: ALMBSJ8y__zClC2eF0NutB7s3MRQWqE2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_05:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

destroy_workqueue() already calls drain_workqueue(), which is a stronger
variant of flush_workqueue().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_ism.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 9c6e95882553..4dcc236d562e 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -460,7 +460,6 @@ void smcd_unregister_dev(struct smcd_dev *smcd)
 	mutex_unlock(&smcd_dev_list.mutex);
 	smcd->going_away = 1;
 	smc_smcd_terminate_all(smcd);
-	flush_workqueue(smcd->event_wq);
 	destroy_workqueue(smcd->event_wq);
 
 	device_del(&smcd->dev);
-- 
2.25.1

