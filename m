Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAC86BBC3F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjCOSgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjCOSfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:35:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EF99544E;
        Wed, 15 Mar 2023 11:35:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FIJsgG005415;
        Wed, 15 Mar 2023 18:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=P/7EMFa2t+TXowDlsQuNMGN1b4u0zwVqVV3/L/WgKK4=;
 b=ZQGF/Qw1JWtDX9DCcCX1UeBREoL+8DNnFzlXhNkvaakn5lc18b394eMsz5REM1/HGoMc
 a2gynTLxVZpVFrFD87tE0FJAvS5aEOJFAH3CirD+/jf+xqnKAQY8K5fBp8u6pOZf6L7a
 WIoLfMx3Q3yBeetO8liKR/GvlMJdooMIVqnmwi9YDKMcDl2X9xvrSHpftVLGuJzr8lyS
 +/rD+2NYLR0CuaQY4klz1xMYuZJFjV+mnTdshBDXkonJmW7chhB4bERXgw1g/TOOldqe
 Q60nddcG/LqnelPnm0pJnMMguiiPGQnf+vHpd5tmk1b47tXKxRKeW4bJ6KgI4swk4f9Y Xg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2u324pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 18:34:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FHXpTO025203;
        Wed, 15 Mar 2023 18:34:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2w7rwea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 18:34:17 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FIYHX3019740;
        Wed, 15 Mar 2023 18:34:17 GMT
Received: from pkannoju-vm.us.oracle.com (dhcp-10-191-221-114.vpn.oracle.com [10.191.221.114])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pb2w7rw9j-1;
        Wed, 15 Mar 2023 18:34:17 +0000
From:   Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rajesh.sivaramasubramaniom@oracle.com,
        rama.nichanamatlu@oracle.com, manjunath.b.patil@oracle.com,
        Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Subject: [PATCH RFC] net/sched: use real_num_tx_queues in dev_watchdog()
Date:   Thu, 16 Mar 2023 00:04:08 +0530
Message-Id: <20230315183408.2723-1-praveen.kannoju@oracle.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_10,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=992
 adultscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150154
X-Proofpoint-ORIG-GUID: 56azL7HXCPNjAfmjjgUaV0TP6tNgiKV2
X-Proofpoint-GUID: 56azL7HXCPNjAfmjjgUaV0TP6tNgiKV2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently dev_watchdog() loops through num_tx_queues[Number of TX queues
allocated at alloc_netdev_mq() time] instead of real_num_tx_queues
[Number of TX queues currently active in device] to detect transmit
queue time out. Make this efficient by using real_num_tx_queues.

Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
---
PS: Please let me know if I am missing something obvious here.
 net/sched/sch_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a9aadc4e6858..e7d41a25f0e8 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -506,7 +506,7 @@ static void dev_watchdog(struct timer_list *t)
 			unsigned int i;
 			unsigned long trans_start;
 
-			for (i = 0; i < dev->num_tx_queues; i++) {
+			for (i = 0; i < dev->real_num_tx_queues; i++) {
 				struct netdev_queue *txq;
 
 				txq = netdev_get_tx_queue(dev, i);
-- 
2.31.1

