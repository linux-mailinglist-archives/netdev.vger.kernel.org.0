Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133A54C3CF1
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 05:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbiBYEKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 23:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237293AbiBYEKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 23:10:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779B52692CD
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 20:09:50 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P46Pvk025576
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=iV1d7PGto60TwN5qpnSQODcQNNG6ry/EG6QIN1DEgxY=;
 b=iMtJoenMRYFb/a9T62NrlyR3rTVrJNRgfwLMyTWnn7b6wyBDOLUaaEaOCSnxJf19hkHY
 iM/tSXA5tDC2MMkYaqrGIg1J6/POGzfbylnHArHk8yV+QMgP4O2lJ/k5hU1r+7Ij1/sP
 EA8XBQCHu3pdEMKjcrTtiv61nBbPwrtWlavlbDDR1L1JyeaZlNWOrUBvRUGx5lYnvagY
 tYysDXkNZwhbMoKLT9YcYokZoZ4OFEvySzNVsx9LNige1+r81R0XjK8q7zbuKvIL7ks9
 QudBqC1Lgxjdnvcrun/474hZlp9vWiYYcvlLhq4JbpyDHuzOjt1HD/VN1NYI/vU8YgmM RA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edx1xecwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:50 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P42UD7000546
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:49 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 3ed22eygxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:09:49 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P49hQr11075914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 04:09:43 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85FA3BE04F;
        Fri, 25 Feb 2022 04:09:43 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AC73BE051;
        Fri, 25 Feb 2022 04:09:42 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.204.104])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 04:09:42 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-internal v2 0/8] ibmvnic: Fix a race in ibmvnic_probe()
Date:   Thu, 24 Feb 2022 20:09:33 -0800
Message-Id: <20220225040941.1429630-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8c-D1st2zIYiz-TQ6zrvirs2AtDew4oc
X-Proofpoint-GUID: 8c-D1st2zIYiz-TQ6zrvirs2AtDew4oc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_01,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxlogscore=956
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250020
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we get a transport (reset) event right after a successful CRQ_INIT
during ibmvnic_probe() but before we set the adapter state to VNIC_PROBED,
we will throw away the reset assuming that the adapter is still in the
probing state. But since the adapter has completed the CRQ_INIT any
subsequent CRQs the we send will be ignored by the vnicserver until
we release/init the CRQ again. This can leave the adapter unconfigured.

While here fix a couple of other bugs that were observed (Patches 1,2,4).

Sukadev Bhattiprolu (8):
  ibmvnic: free reset-work-item when flushing
  ibmvnic: initialize rc before completing wait
  ibmvnic: define flush_reset_queue helper
  ibmvnic: complete init_done on transport events
  ibmvnic: register netdev after init of adapter
  ibmvnic: init init_done_rc earlier
  ibmvnic: clear fop when retrying probe
  ibmvnic: Allow queueing resets during probe

 drivers/net/ethernet/ibm/ibmvnic.c | 183 ++++++++++++++++++++++++-----
 drivers/net/ethernet/ibm/ibmvnic.h |   1 +
 2 files changed, 156 insertions(+), 28 deletions(-)

-- 
2.27.0

