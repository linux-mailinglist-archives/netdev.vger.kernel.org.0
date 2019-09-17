Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51800B5420
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 19:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfIQR0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 13:26:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47120 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727838AbfIQR0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 13:26:41 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8HHMrrC142596;
        Tue, 17 Sep 2019 13:26:32 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v327rd12r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 13:26:32 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8HHPLW8009893;
        Tue, 17 Sep 2019 17:26:31 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 2v0svqs4vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 17:26:31 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8HHQU1v48759108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 17:26:30 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68886B2066;
        Tue, 17 Sep 2019 17:26:30 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F916B205F;
        Tue, 17 Sep 2019 17:26:30 +0000 (GMT)
Received: from ltcfleet2-lp9.aus.stglabs.ibm.com (unknown [9.40.195.116])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 17 Sep 2019 17:26:29 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     julietk@linux.vnet.ibm.com, tlfalcon@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 0/2] net/ibmvnic: serialization fixes
Date:   Tue, 17 Sep 2019 13:15:50 -0400
Message-Id: <20190917171552.32498-1-julietk@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.16.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-17_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=873 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909170167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes two fixes. The first improves reset code to allow
linkwatch_event to proceed during reset. The second ensures that no more
than one thread runs in reset at a time.

v2:
- Separate change param reset from do_reset()
- Return IBMVNIC_OPEN_FAILED in open failiure case
- Remove setting wait_for_reset to false from __ibmvnic_reset(), this
  is done in wait_for_reset()
- Move the check for force_reset_recovery from patch 1 to patch 2

v3:
- Restore reset’s successful return in open failure case

Juliet Kim (2):
  net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can run
  net/ibmvnic: prevent more than one thread from running in reset

 drivers/net/ethernet/ibm/ibmvnic.c | 245 +++++++++++++++++++++++++++----------
 drivers/net/ethernet/ibm/ibmvnic.h |   4 +
 2 files changed, 181 insertions(+), 68 deletions(-)

-- 
2.16.4

