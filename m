Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8CCB50F0
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 17:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbfIQPDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 11:03:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726183AbfIQPDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 11:03:54 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8HEsocq012881;
        Tue, 17 Sep 2019 11:03:45 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v31k7gv89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 11:03:44 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8HF2fuj008734;
        Tue, 17 Sep 2019 15:03:43 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 2v0tcyhdst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 15:03:43 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8HF3hft53543204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 15:03:43 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01B03124052;
        Tue, 17 Sep 2019 15:03:43 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A194C124055;
        Tue, 17 Sep 2019 15:03:42 +0000 (GMT)
Received: from ltcfleet2-lp9.aus.stglabs.ibm.com (unknown [9.40.195.116])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 17 Sep 2019 15:03:42 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     julietk@linux.vnet.ibm.com, tlfalcon@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 0/2] net/ibmvnic: serialization fixes
Date:   Tue, 17 Sep 2019 10:52:47 -0400
Message-Id: <20190917145249.15334-1-julietk@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.16.4
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=921 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909170144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes two fixes. The first improves reset code to allow 
linkwatch_event to proceed during reset. The second ensures that no more
than one thread runs in reset at a time. 

v2: 
- Separate change param reset from do_reset()
- Return IBMVNIC_OPEN_FAILED if __ibmvnic_open fails 
- Remove setting wait_for_reset to false from __ibmvnic_reset(), this 
  is done in wait_for_reset()
- Move the check for force_reset_recovery from patch 1 to patch 2

Juliet Kim (2):
  net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can run
  net/ibmvnic: prevent more than one thread from running in reset

 drivers/net/ethernet/ibm/ibmvnic.c | 244 ++++++++++++++++++++++++++-----------
 drivers/net/ethernet/ibm/ibmvnic.h |   4 +
 2 files changed, 180 insertions(+), 68 deletions(-)

-- 
2.16.4

