Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1171BAB66
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgD0Ree (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:34:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726226AbgD0Ree (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 13:34:34 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RHXZKq079774;
        Mon, 27 Apr 2020 13:34:27 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhd7bqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 13:34:27 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03RHVpS2004142;
        Mon, 27 Apr 2020 17:34:26 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 30mcu72a84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 17:34:26 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03RHYPPs22086130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:34:25 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F4EFC6057;
        Mon, 27 Apr 2020 17:34:25 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24B9EC6055;
        Mon, 27 Apr 2020 17:34:25 +0000 (GMT)
Received: from ltcalpine2-lp17.aus.stglabs.ibm.com (unknown [9.40.195.200])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 27 Apr 2020 17:34:24 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, julietk@linux.vnet.ibm.com,
        tlfalcon@linux.vnet.ibm.com
Subject: [PATCH net] ibmvnic: Fall back to 16 H_SEND_SUB_CRQ_INDIRECT entries with old FW
Date:   Mon, 27 Apr 2020 12:33:43 -0500
Message-Id: <20200427173343.16626-1-julietk@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.18.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_12:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=1
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=986
 malwarescore=0 impostorscore=0 clxscore=1011 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The maximum entries for H_SEND_SUB_CRQ_INDIRECT has increased on
some platforms from 16 to 128. If Live Partition Mobility is used
to migrate a running OS image from a newer source platform to an
older target platform, then H_SEND_SUB_CRQ_INDIRECT will fail with
H_PARAMETER if 128 entries are queued.

Fix this by falling back to 16 entries if H_PARAMETER is returned
from the hcall().

Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4bd33245bad6..b66c2f26a427 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1656,6 +1656,17 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		lpar_rc = send_subcrq_indirect(adapter, handle_array[queue_num],
 					       (u64)tx_buff->indir_dma,
 					       (u64)num_entries);
+
+		/* Old firmware accepts max 16 num_entries */
+		if (lpar_rc == H_PARAMETER && num_entries > 16) {
+			tx_crq.v1.n_crq_elem = 16;
+			tx_buff->num_entries = 16;
+			lpar_rc = send_subcrq_indirect(adapter,
+						       handle_array[queue_num],
+						       (u64)tx_buff->indir_dma,
+						       16);
+		}
+
 		dma_unmap_single(dev, tx_buff->indir_dma,
 				 sizeof(tx_buff->indir_arr), DMA_TO_DEVICE);
 	} else {
-- 
2.18.1

