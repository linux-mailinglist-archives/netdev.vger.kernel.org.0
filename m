Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8774A3FD01A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245248AbhIAAKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:10:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243304AbhIAAJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:09:13 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18104OF7160689
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=AHv6sVqRAYmxLti/u194BDmBrG5u+VZ56qtGbA30CIE=;
 b=DwynicHmbCHpz3AudL4oHgv62l3gzXJGnNr5fK4rhUV4f2JnJT3D7d05IKEribU7tW3M
 GQe4axNlP5ExqLyRyyyOabb65lLQgqX7Uka2MB+LuGyd1dn8Ew1Wg3s8Q6P7ahfYai+8
 IhKToD0+uTgfRTq7/+ZTV968wK2HNQ0aSMhIx3E0VIOVbuStY9y3KPsqePyDEywOdch2
 csaM5LRSwZ0Vul5UCf76gyzmgotIt2nthhvG0nLxOxrL+GpRSSRuPxXbURMds5or+v71
 sSh+w66qKS4diKJ2JGJfXSOd+D/IyPLRYQF6H+fyEJA1DxMIXPIgrED4wFZJxHvcO/yJ yw== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asuk9v3cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:17 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17VNue5M022830
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 00:08:16 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 3aqcscj36n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 00:08:16 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18108Fg147513992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 00:08:15 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40ECD7806B;
        Wed,  1 Sep 2021 00:08:15 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E321B78067;
        Wed,  1 Sep 2021 00:08:13 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.237.107])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 00:08:13 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next 0/9] ibmvnic: Reuse ltb, rx, tx pools
Date:   Tue, 31 Aug 2021 17:08:03 -0700
Message-Id: <20210901000812.120968-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h7pbN1VTS7VrOa1b3JgMtttT9to3X5Gh
X-Proofpoint-ORIG-GUID: h7pbN1VTS7VrOa1b3JgMtttT9to3X5Gh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 phishscore=0 lowpriorityscore=5 malwarescore=0
 bulkscore=5 suspectscore=0 clxscore=1011 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310133
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

 drivers/net/ethernet/ibm/ibmvnic.c | 592 ++++++++++++++++++-----------
 drivers/net/ethernet/ibm/ibmvnic.h |  10 +-
 2 files changed, 379 insertions(+), 223 deletions(-)

-- 
2.31.1

