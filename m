Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C144C3E57
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237799AbiBYGYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236480AbiBYGYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:24:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7B91C025D
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:24:03 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P55HcN029760
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=iV1d7PGto60TwN5qpnSQODcQNNG6ry/EG6QIN1DEgxY=;
 b=GgD39XzPkvTICTyGXilwJ7en7gxWPrplCP2m6iJp9PL5jTV7Y33KrDd2+LB120ukQ+rW
 5y6X7yUqLYBjhgL9hw8ChlrvCYgMzGhQIn1d4FMBIDm20y/zfCBIQ+0PhkWlXPrxzSis
 HMmhsbmfVxj5RwBb19PThwhYGG1TMnRsdAWfhhTxiGtpyuzKe7+YO/dQMcaHw1pjfShz
 lBeiDdU52S3EIhVQ9pN9chKB2vxCogMCyCytWs3g19WOJIlFzXIe1nfCFAK4xHRP5AFY
 F9tsPLvpsUf02QFLXcLOEaM+Np/g2mi+tzW3ZMSH643Suzc/8bFZcS6ayNTUy70SdJm0 Lw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edh6y62vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:02 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P6MamZ010281
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:02 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 3ear6ceq62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:02 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P6O04E15467088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 06:24:00 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A416F136065;
        Fri, 25 Feb 2022 06:24:00 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEB4813605E;
        Fri, 25 Feb 2022 06:23:59 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.204.104])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 06:23:59 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 0/8] ibmvnic: Fix a race in ibmvnic_probe()
Date:   Thu, 24 Feb 2022 22:23:50 -0800
Message-Id: <20220225062358.1435652-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MNxQT18IHpPOxOGdzq5UGR3dq-gFOq9g
X-Proofpoint-ORIG-GUID: MNxQT18IHpPOxOGdzq5UGR3dq-gFOq9g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_05,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=903 phishscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202250030
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

