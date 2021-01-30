Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166A3309430
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhA3KPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:15:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233068AbhA3BUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 20:20:23 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10U13DrH171403
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 20:19:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tkaIDOga2JZk1EyUATyD22AV+hht6R/VbZDmojwqq1I=;
 b=Zeg/Vsg8pMdO6qUrnexcqY2kiSNc/i8/u2UyATB4qAa8oKTD6MQOX6bj5x8WecEUb3L8
 GSOTVM6KOMOgOYolIcuAysFFasXC9UrvVDW88T/z5IA99/w94FG2W1/Jsd2o3t6gfeBM
 Z3jYkSxkrYNtgtvP7cufKlZG0SnD39BRBDG0YUjjFdBjSfYrsJgfYRyHU68blIn5vBQ5
 TS6v7odNsVr9+q7Fo2BKKRPDUjznxgn+0HcNz4FJUjYHKSkgoMg5PJAl8CIgsHB5+SvV
 ZRBaXV91LgSWtkj4dcwyPodDIiwgU46oEENgacOMPvVhhxnMI4qhSGh0Tnkdu2Qsngzf 1w== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36csf057sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 20:19:14 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10U1GAI2029717
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 01:19:13 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01wdc.us.ibm.com with ESMTP id 36a8uhx86d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 01:19:13 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10U1JAMO24314338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 01:19:10 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F09AFBE051;
        Sat, 30 Jan 2021 01:19:09 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE83BBE053;
        Sat, 30 Jan 2021 01:19:08 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.192.149])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 30 Jan 2021 01:19:08 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        brking@linux.vnet.ibm.com, dnbanerg@us.ibm.com,
        tlfalcon@linux.ibm.com, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next v2 2/2] ibmvnic: remove unnecessary rmb() inside ibmvnic_poll
Date:   Fri, 29 Jan 2021 19:19:05 -0600
Message-Id: <20210130011905.1485-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20210130011905.1485-1-ljp@linux.ibm.com>
References: <20210130011905.1485-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-29_12:2021-01-29,2021-01-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 adultscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=901 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101300001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rmb() can be removed since:
1. pending_scrq() has dma_rmb() at the function end;
2. dma_rmb(), though weaker, is enough here.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Acked-by: Dwip Banerjee <dnbanerg@us.ibm.com>
Acked-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 331ebca2f57a..0ed169ef1cfc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2510,7 +2510,6 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 		if (napi_complete_done(napi, frames_processed)) {
 			enable_scrq_irq(adapter, rx_scrq);
 			if (pending_scrq(adapter, rx_scrq)) {
-				rmb();
 				if (napi_reschedule(napi)) {
 					disable_scrq_irq(adapter, rx_scrq);
 					goto restart_poll;
-- 
2.23.0

