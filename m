Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CC46C3517
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCUPH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjCUPH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:07:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC136509AE
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:07:33 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LEhJoK030431
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 15:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=qkKNDP+Er/pK+Hl/KcmMIAOm35Mulo/z+wug/iPcEm4=;
 b=qx7ttqMTBGtG6l4sRO3+zzY8V2Wc2CuFle1OWjBRK/x6/Hss6Y4bZYdOnqWulL38nLHS
 OYC3/FLIQvmphAjL61l9KNWyj43SiqyMuChZL4I1Uk+WfUV9JONgwxFZbypHis3jzoV7
 ZCiRf47+v05UdfaVYK5T4/aqw1s4ee+4ixOJ79IPtC/QqDyqTvcGsKHa37bGdMNovMV5
 kOR2YFDl8C/IX0Ukg1CQlE4qe/klG6kILRP4PJWa2jdS0NAiARiU7/U+mMoApIVMff7x
 ZLxY2LtG4oZPqiT8T7HdfgpSbd43Tdqi002sgG2ykMlohVILDrkVo/cA2HFCfoZLYsIK dA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pfc52n9p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 15:07:32 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32LCSYMm031919
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 15:07:32 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3pd4x6u6e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 15:07:32 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32LF7UdS42140052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 15:07:30 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8549F5805B;
        Tue, 21 Mar 2023 15:07:30 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB6D35804B;
        Tue, 21 Mar 2023 15:07:29 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com.com (unknown [9.77.147.181])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 21 Mar 2023 15:07:29 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net-next v2 2/2] netdev: Enforce index cap in netdev_get_tx_queue
Date:   Tue, 21 Mar 2023 10:07:25 -0500
Message-Id: <20230321150725.127229-2-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230321150725.127229-1-nnac123@linux.ibm.com>
References: <20230321150725.127229-1-nnac123@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a6eFMBTaou-J-9CTfENp54fGbwqtkgSM
X-Proofpoint-ORIG-GUID: a6eFMBTaou-J-9CTfENp54fGbwqtkgSM
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303210118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When requesting a TX queue at a given index, warn on out-of-bounds
referencing if the index is greater than the allocated number of
queues.

Specifically, since this function is used heavily in the networking
stack use DEBUG_NET_WARN_ON_ONCE to avoid executing a new branch on
every packet.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
Changes since v1 (respond to Jakubs review):
 - send to net-next instead of net
 - use DEBUG_NET_WARN_ON_ONCE instead of a conditonal returning 1st queue

v1 - https://lore.kernel.org/netdev/20230320214942.38395e6e@kicinski-fedora-PC1C0HJN/

 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 23b0d7eaaadd..838b7310a80b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2482,6 +2482,7 @@ static inline
 struct netdev_queue *netdev_get_tx_queue(const struct net_device *dev,
 					 unsigned int index)
 {
+	DEBUG_NET_WARN_ON_ONCE(index >= dev->num_tx_queues);
 	return &dev->_tx[index];
 }
 
-- 
2.31.1

