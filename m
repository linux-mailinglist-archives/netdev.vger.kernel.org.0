Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0C86B19EE
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 04:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjCIDU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 22:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjCIDUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 22:20:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECA55CEF8;
        Wed,  8 Mar 2023 19:20:32 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328N4UDh015850;
        Thu, 9 Mar 2023 03:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=P+XQbZcJj7p0rNMIlml0pnPg6Y2kSG4UNaeF3ISR50s=;
 b=KH+OLAxVh3seqOKxHQ1WFEDK/axBWRAw0r0UIWepHm+l/nWsxPSogGcTC7AP7XKZEIjM
 1HQ7lpow22pL9Y+2CsH7SNtjkJBnSsIftpgc1xICOAup8f/bVkRWJUM1kNT9P/6fPBFO
 VNYAo+wfPhuvPV3LFSUIcb6S56nchmZ8giWW4K3CnnWEMXnV+gNIZAGzd3zSVQK6lNgo
 PESzgUzc+wr4HqAWs6AuLRl7xOb3uulQUP0FzvoqKXwvJMggcI0anJi9Jrk9a9/fiWhQ
 UHuAyptEXKKOsOIJFr07tzPF8fPSgjS0B1BV9S1SctlRCwhjKJ8IWMyQH9Z5CJNsbCOH Ew== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn960w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 03:20:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32932NH3021707;
        Thu, 9 Mar 2023 03:20:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9p4wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 03:20:11 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3293IwmE022200;
        Thu, 9 Mar 2023 03:20:11 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3p6fr9p4pq-5;
        Thu, 09 Mar 2023 03:20:10 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH 4/5] connector/cn_proc: Allow non-root users access
Date:   Wed,  8 Mar 2023 19:19:52 -0800
Message-Id: <20230309031953.2350213-5-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
References: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090025
X-Proofpoint-GUID: 1ySnjuO3dTeEn6RmV9zfqcME4Hs8Rllv
X-Proofpoint-ORIG-GUID: 1ySnjuO3dTeEn6RmV9zfqcME4Hs8Rllv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch allows non-root users to receive cn proc connector
notifications, as anyone can normally get process start/exit status from
/proc. The reason for not allowing non-root users to receive multicast
messages is long gone, as described in this thread:
https://linux-kernel.vger.kernel.narkive.com/CpJFcnra/multicast-netlink-for-non-root-process

Also, many other netlink protocols allow non-root users to receive multicast
messages, and there is no reason to discriminate against CONNECTOR.

Reason we need this change is we need to run our DB application as a 
non-root user.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 drivers/connector/cn_proc.c   | 7 -------
 drivers/connector/connector.c | 1 +
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index ef3820b43b5c..03ba70f07113 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -376,12 +376,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	    !task_is_in_init_pid_ns(current))
 		return;
 
-	/* Can only change if privileged. */
-	if (!__netlink_ns_capable(nsp, &init_user_ns, CAP_NET_ADMIN)) {
-		err = EPERM;
-		goto out;
-	}
-
 	if (msg->len == sizeof(mc_op))
 		mc_op = *((enum proc_cn_mcast_op *)msg->data);
 	else
@@ -414,7 +408,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 		break;
 	}
 
-out:
 	cn_proc_ack(err, msg->seq, msg->ack);
 }
 
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 1b7851b1aa0f..136a9f38a063 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -251,6 +251,7 @@ static int cn_init(void)
 {
 	struct cn_dev *dev = &cdev;
 	struct netlink_kernel_cfg cfg = {
+		.flags = NL_CFG_F_NONROOT_RECV,
 		.groups	= CN_NETLINK_USERS + 0xf,
 		.input	= cn_rx_skb,
 	};
-- 
2.39.2

