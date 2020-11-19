Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459322B8953
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgKSBMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:12:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725947AbgKSBMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:12:48 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ12cOc002860;
        Wed, 18 Nov 2020 20:12:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=63zCUGTQUiWuEkB2z2PB5wi1DRmFoQ3R7hVO7Y4u5T8=;
 b=QMEE6fdo6KtbwEeQuPzT8q/65Zv7/M3B3/BCtM/P19HSw10fdix1kAMdAi1/O18K3XgP
 B+kybb3ftw+LRvqGU8G4dKnCDImdBbn/r8HrwPkOfazsl7Wfy14wZQxV+RWB4G6ottwM
 /AkOoYNCmctouedclXhoebvauA9KgApNVEEz49y1fcWd4A5f4AZELCeZjL+UMGRZal4b
 qz3m00Pvi36R1ZNWibPxnoWkImQ13o9b35kd+mCoU5S9R4bQFZhdNCs9uF2YeYSCFZn1
 iXEPHPeGkZOc0U8ISOZarTLrH6hsxTntiVFRxYspa5/q2gSRiuRmoiawa54/DGZqvzdn nA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34w8p8taqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 20:12:40 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ0ufTt029126;
        Thu, 19 Nov 2020 01:12:39 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02wdc.us.ibm.com with ESMTP id 34w5w8be43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 01:12:39 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ1CVUv9306804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 01:12:31 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18FD86A05D;
        Thu, 19 Nov 2020 01:12:37 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD6136A04F;
        Thu, 19 Nov 2020 01:12:34 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.199.179])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 01:12:34 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cforno12@linux.ibm.com, ljp@linux.vnet.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, tlfalcon@linux.ibm.com
Subject: [PATCH net-next v2 0/9] ibmvnic: Performance improvements and other updates
Date:   Wed, 18 Nov 2020 19:12:16 -0600
Message-Id: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_10:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=938
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first three patches utilize a hypervisor call allowing multiple 
TX and RX buffer replenishment descriptors to be sent in one operation,
which significantly reduces hypervisor call overhead. The xmit_more
and Byte Queue Limit API's are leveraged to provide this support
for TX descriptors.

The subsequent two patches remove superfluous code and members in
TX completion handling function and TX buffer structure, respectively,
and remove unused routines.

Finally, four patches which ensure that device queue memory is
cache-line aligned, resolving slowdowns observed in PCI traces,
as well as optimize the driver's NAPI polling function and 
to RX buffer replenishment are provided by Dwip Banerjee.

This series provides significant performance improvements, allowing
the driver to fully utilize 100Gb NIC's.

v2 updates:

1) Removed three patches from the original series which
   were bug fixes and thus better suited for the net tree,
   suggested by Jakub Kicinski.
2) Fixed error handling when initializing device queues,
   suggested by Jakub Kicinski.
3) Fixed bug where queued entries were not flushed after a
   dropped frame, also suggested by Jakub. Two functions,
   ibmvnic_tx_scrq_flush and its helper ibmvnic_tx_scrq_clean_buffer,
   were introduced to ensure that queued frames are either submitted
   to firmware or, if that is not successful, freed as dropped and
   associated data structures are updated with the new device queue state.

Dwip N. Banerjee (4):
  ibmvnic: Ensure that device queue memory is cache-line aligned
  ibmvnic: Correctly re-enable interrupts in NAPI polling routine
  ibmvnic: Use netdev_alloc_skb instead of alloc_skb to replenish RX
    buffers
  ibmvnic: Do not replenish RX buffers after every polling loop

Thomas Falcon (5):
  ibmvnic: Introduce indirect subordinate Command Response Queue buffer
  ibmvnic: Introduce batched RX buffer descriptor transmission
  ibmvnic: Introduce xmit_more support using batched subCRQ hcalls
  ibmvnic: Clean up TX code and TX buffer data structure
  ibmvnic: Remove send_subcrq function

 drivers/net/ethernet/ibm/ibmvnic.c | 398 ++++++++++++++++++-----------
 drivers/net/ethernet/ibm/ibmvnic.h |  27 +-
 2 files changed, 256 insertions(+), 169 deletions(-)

-- 
2.26.2

