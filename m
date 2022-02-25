Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062014C3E59
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237807AbiBYGZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbiBYGY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:24:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267F3268373
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:24:26 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P6GLlt027182
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VBjydXoLjnr4ETBn2pX0Ir7mOIe15GU+sxsSxoQLweI=;
 b=br2ldqQEFkLEoiWWKiSnB6Y8dQ+oVOPpAOgJnbNJ4L9Tjk/4eYxxSRtrFHlG5rs6lUWu
 NQCQYmwr/2az3tbq7mFc8Kwf6lKxaK6q/SejqeqK7shGvlSbQT/9pc+6OWNwTJhItrSi
 /9HrqQrCT+gAqu6Y8q1l8N0cJ5VosOxUytlyf1e8jp7XRldqC/fbyJWxpZTYpanZE6u8
 wR/mBJvfRCZxDrXeJciwIueB0D9Mr8BkFILbVtQYAat1kSwchGe64b0mQZh2grTgGU1q
 zX/0xpcjEuQ0hRba4C1aR71GNtmzHEZHNhB+NXYmxr5JtKQUWIYMK1XHqKQ662WIKgVQ 5g== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edx1xgm7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:25 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P6Ma7L010225
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:24 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 3ear6ceqah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:24 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P6OMwQ37486978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 06:24:22 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EDC313604F;
        Fri, 25 Feb 2022 06:24:22 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 027A213605E;
        Fri, 25 Feb 2022 06:24:21 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.204.104])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 06:24:20 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 7/8] ibmvnic: clear fop when retrying probe
Date:   Thu, 24 Feb 2022 22:23:57 -0800
Message-Id: <20220225062358.1435652-8-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225062358.1435652-1-sukadev@linux.ibm.com>
References: <20220225062358.1435652-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jyjZqdYAZ7_N-x0xHF-GcZgQQuViztzr
X-Proofpoint-GUID: jyjZqdYAZ7_N-x0xHF-GcZgQQuViztzr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_05,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250030
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear ->failover_pending flag that may have been set in the previous
pass of registering CRQ. If we don't clear, a subsequent ibmvnic_open()
call would be misled into thinking a failover is pending and assuming
that the reset worker thread would open the adapter. If this pass of
registering the CRQ succeeds (i.e there is no transport event), there
wouldn't be a reset worker thread.

This would leave the adapter unconfigured and require manual intervention
to bring it up during boot.

Fixes: 5a18e1e0c193 ("ibmvnic: Fix failover case for non-redundant configuration")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 936a94eaed5e..85ccef7cd292 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5807,6 +5807,11 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	do {
 		reinit_init_done(adapter);
 
+		/* clear any failovers we got in the previous pass
+		 * since we are reinitializing the CRQ
+		 */
+		adapter->failover_pending = false;
+
 		rc = init_crq_queue(adapter);
 		if (rc) {
 			dev_err(&dev->dev, "Couldn't initialize crq. rc=%d\n",
-- 
2.27.0

