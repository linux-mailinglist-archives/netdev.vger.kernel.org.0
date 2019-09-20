Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF07B9861
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 22:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbfITUWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 16:22:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8820 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727273AbfITUWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 16:22:23 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8KKMGLR063981;
        Fri, 20 Sep 2019 16:22:19 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v55kwgdb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 16:22:19 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8KKJdn0007926;
        Fri, 20 Sep 2019 20:22:17 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 2v3vbuw2vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 20:22:17 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8KKMG5S38994278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 20:22:16 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EAF26A047;
        Fri, 20 Sep 2019 20:22:16 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 252E66A04D;
        Fri, 20 Sep 2019 20:22:16 +0000 (GMT)
Received: from ltcfleet2-lp9.aus.stglabs.ibm.com (unknown [9.40.195.116])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 20:22:15 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     julietk@linux.vnet.ibm.com, tlfalcon@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 0/2] net/ibmvnic: serialization fixes
Date:   Fri, 20 Sep 2019 16:11:21 -0400
Message-Id: <20190920201123.18913-1-julietk@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.16.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=889 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200167
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

v3:
- Restore reset’s successful return in open failure case

v4:
- Change resetting flag access to atomic

Juliet Kim (2):
  net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can run
  net/ibmvnic: prevent more than one thread from running in reset

 drivers/net/ethernet/ibm/ibmvnic.c | 262 ++++++++++++++++++++++++++-----------
 drivers/net/ethernet/ibm/ibmvnic.h |   6 +-
 2 files changed, 190 insertions(+), 78 deletions(-)

-- 
2.16.4

