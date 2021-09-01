Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AC03FE1B2
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344779AbhIASGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:06:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235904AbhIASGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:06:52 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181I2oNj047422
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 14:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Y/CnkgrbyyYikP1BMrKSWzFfqwWzX6/OlGItVHHEohg=;
 b=tsLKsoL1TfzgGzXMzeGKsn/xrfHqdcTgsdg2dXoIjBsTBUHqMqQbVTxQW/M7rNyPiLEw
 GyNe707YeNbekRx8dZsflv9U/5VtzFXgxDxsEG0za3o3iUPowrsw2msJUQs3FrGt/xqm
 8A6orU4D7JOzdbj8+jPp9Vkwoj8mClLuKf2ecTU3kff3me3/cY2bYuMMB/eFRpxeA7zr
 hjn/BsC6XxeaY5g8n61IyZgMj9BqvVpxYhbq6ZggOWbomjQNntt0GkSN04+iLlV0PPQt
 fC1s+xAji06/FqvlvhyRpt1au5ocKQ5YnFeESdg/p4ngfUiis0ejFxm9JIvM2BEWSH2s 5w== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ate1brtch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:05:55 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181I49og000429
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 18:05:54 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 3atdxtrqvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 18:05:54 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181I5rqQ44696000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 18:05:53 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B4B212405C;
        Wed,  1 Sep 2021 18:05:53 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C642124069;
        Wed,  1 Sep 2021 18:05:52 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.160.152.143])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 18:05:51 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next v2 0/9] ibmvnic: Reuse ltb, rx, tx pools
Date:   Wed,  1 Sep 2021 11:05:42 -0700
Message-Id: <20210901180551.150126-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -t0uufTWQR_PxhXn7Rqaq73jIYz2XVpG
X-Proofpoint-ORIG-GUID: -t0uufTWQR_PxhXn7Rqaq73jIYz2XVpG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=10 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 bulkscore=10 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109010104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It can take a long time to free and reallocate rx and tx pools and long
term buffer (LTB) during each reset of the VNIC. This is specially true
when the partition (LPAR) is heavily loaded and going through a Logical
Partition Migration (LPM). The long drawn reset causes the LPAR to lose
connectivity for extended periods of time and results in "RMC connection"
errors and the LPM failing.

What is worse is that during the LPM we could get a failover because
of the lost connectivity. At that point, the vnic driver releases
even the resources it has already allocated and starts over.

As long as the resources we have already allocated are valid/applicable,
we might as well hold on to them while trying to allocate the remaining
resources. This patch set attempts to reuse the resources previously
allocated as long as they are valid. It seems to vastly improve the
time taken for the vnic reset. We have also not seen any RMC connection
issues during our testing with this patch set.

If the backing devices for a vnic adapter are not "matched" (see "pool
parameters" in patches 8 and 9) it is possible that we will still free
all the resources and allocate them. If that becomes a common problem,
we have to address it separately.

Thanks to input and extensive testing from Brian King, Cris Forno,
Dany Madden, Rick Lindsley.

Changelog[v2]
	[Jakub Kicinski] Fix kdoc issues

Sukadev Bhattiprolu (9):
  ibmvnic: consolidate related code in replenish_rx_pool()
  ibmvnic: Fix up some comments and messages
  ibmvnic: Use/rename local vars in init_rx_pools
  ibmvnic: Use/rename local vars in init_tx_pools
  ibmvnic: init_tx_pools move loop-invariant code out
  ibmvnic: use bitmap for LTB map_ids
  ibmvnic: Reuse LTB when possible
  ibmvnic: Reuse rx pools when possible
  ibmvnic: Reuse tx pools when possible

 drivers/net/ethernet/ibm/ibmvnic.c | 640 +++++++++++++++++++----------
 drivers/net/ethernet/ibm/ibmvnic.h |  10 +-
 2 files changed, 427 insertions(+), 223 deletions(-)

-- 
2.26.2

