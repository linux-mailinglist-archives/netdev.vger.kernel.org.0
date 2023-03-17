Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44296BF093
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjCQSTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCQSTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:19:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2A149BB
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 11:19:48 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HHglek025514
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 18:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MlrMBQb6ukN17nr3p+qt3m6kxT5ob1CF8Z7V5yhyXr4=;
 b=Zg3eGCKLCgy1vyCy/yFvtaNl0gaxT2VARmLB46QDWdPU0fHAJRUy6bC3EJ5dGtE7tMY3
 MUdt35Dgyhx28Sf/MUzpO4Q3yThfGu5zRJTGrtHNtNvIbXrYA8DLtXHiLFcQktHqlr8A
 pH3QAQiN9hc6/aDaeVvwwv+Uu6phLZt5wbRzayqt8TaMr078OclLwnRSBYEHNpptI/vd
 EmGkWTi1W+W8if8W2290eM7fIpra8qeMjpOEdhqkl7j+dCCKyqag1I9oa9FOtL3tNjDx
 TZE5mn/9Wg66PJ6cIMYIKFK97vBWbrG4yT+Z4PotAk3EkWm6fUQRl3n9Q8x4qTzAmt3U UQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcvukrtg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 18:19:48 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32HH9REb031014
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 18:19:47 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3pbs919wch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 18:19:47 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HIJj9O30474880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 18:19:45 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10C4858057;
        Fri, 17 Mar 2023 18:19:45 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FDFA58059;
        Fri, 17 Mar 2023 18:19:44 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com.com (unknown [9.65.227.169])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Mar 2023 18:19:44 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net 2/2] netdev: Enforce index cap in netdev_get_tx_queue
Date:   Fri, 17 Mar 2023 13:19:41 -0500
Message-Id: <20230317181941.86151-2-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230317181941.86151-1-nnac123@linux.ibm.com>
References: <20230317181941.86151-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EnqfYJILqcwZVLFNtWSf3WSnKMWsfGXR
X-Proofpoint-ORIG-GUID: EnqfYJILqcwZVLFNtWSf3WSnKMWsfGXR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 spamscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303170122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When requesting a TX queue at a given index, prevent out-of-bounds
referencing by ensuring that the index is within the allocated number
of queues.

If there is an out-of-bounds reference then inform the user and return
a reference to the first tx queue instead.

Fixes: e8a0464cc950 ("netdev: Allocate multiple queues for TX.")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
 include/linux/netdevice.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 23b0d7eaaadd..fe88b1a7393d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2482,6 +2482,13 @@ static inline
 struct netdev_queue *netdev_get_tx_queue(const struct net_device *dev,
 					 unsigned int index)
 {
+	if (unlikely(index >= dev->num_tx_queues)) {
+		net_warn_ratelimited("%s selects TX queue %d, but number of TX queues is %d\n",
+				     dev->name, index,
+				     dev->num_tx_queues);
+		return &dev->_tx[0];
+	}
+
 	return &dev->_tx[index];
 }
 
-- 
2.31.1

