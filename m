Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7D563D7DC
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiK3ONm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiK3ON0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:13:26 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDAE1759A;
        Wed, 30 Nov 2022 06:12:48 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUDTxx8011736;
        Wed, 30 Nov 2022 14:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2022-7-12;
 bh=81Gw5jnCL8waFzPfYwJgsHW4IkKTk/GT8Ct4LdrMODM=;
 b=CQdwj51p6KRg4NWqvuKl1Hv4vPpEIVw0gYMdr3gBmYVR6ycsgP6goucwGAxYOt6A4Mkw
 P6D7cPW1CwdfjS4GTkroRbZfZabn4EMQYJBHQ1/t9i8lqxqYmRDuQqcZ0WMu/KlcjIA8
 Cx6lT7bqIvJkMnZ6GitMdCmi2wGIHQk2YoI1xi9RmD64KPZ/0cr1Ly+INrBXSmYbfqyr
 5Fe7ZYyADG3mX4K1noaVIBUwd5MP0RoHleNZE8aVgyHAthNCUivgGaMYJYX+IU97V4/1
 oqgG1YxdDM8h5jZc1c5tJFijTXsL49OsSDInDqSbRV5FoFoJ/afql/YgpYv7Nu6QrbdO lA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m40y414v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 14:12:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AUE6ojL000587;
        Wed, 30 Nov 2022 14:12:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398ff6gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 14:12:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUECa9P000944;
        Wed, 30 Nov 2022 14:12:36 GMT
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (dhcp-10-152-13-169.usdhcp.oraclecorp.com [10.152.13.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3m398ff6b5-1;
        Wed, 30 Nov 2022 14:12:36 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     george.kennedy@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        harshit.m.mogalapalli@oracle.com
Subject: [PATCH] net: check for dev pointer being NULL in dev_hard_header() to avoid GPF
Date:   Wed, 30 Nov 2022 09:11:52 -0500
Message-Id: <1669817512-4560-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300099
X-Proofpoint-GUID: O52LZs4KDTyVMXOkO-BKiWXxxRYPyoWW
X-Proofpoint-ORIG-GUID: O52LZs4KDTyVMXOkO-BKiWXxxRYPyoWW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev pointer can be NULL in dev_hard_header(). Add check for dev being
NULL in dev_hard_header() to avoid GPF.

general protection fault, probably for non-canonical address
    0xdffffc0000000046: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000230-0x0000000000000237]
CPU: 1 PID: 45 Comm: kworker/1:1 Not tainted 6.1.0-rc7+ #2
Hardware name: Red Hat KVM, BIOS 1.15.0-2.module+el8.6.0+20659+3dcf7c70
Workqueue: mld mld_ifc_work
RIP: 0010:macvlan_hard_header (./include/linux/netdevice.h:3057
    (discriminator 4) drivers/net/macvlan.c:594 (discriminator 4))
RSP: 0018:ffff888103d377d0 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: ffff88801cf1a000 RCX: 0000000000000000
RDX: 0000000000000046 RSI: 0000000000000000 RDI: 0000000000000230
RBP: ffff88801e8ef328 R08: 0000000000000000 R09: 0000000000000060
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88801f0497c0
R13: 0000000000000000 R14: ffff888045187c98 R15: 0000000000000060
FS:  0000000000000000(0000) GS:ffff888106c80000(0000)
    knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbf3f1c1840 CR3: 0000000014e36000 CR4: 00000000000006e0
Call Trace:
 <TASK>
neigh_connected_output (./include/linux/netdevice.h:3060
    net/core/neighbour.c:1595)
ip6_finish_output2 (./include/net/neighbour.h:546
    net/ipv6/ip6_output.c:134)
ip6_finish_output (net/ipv6/ip6_output.c:195 net/ipv6/ip6_output.c:206)
ip6_output (./include/linux/netfilter.h:291 net/ipv6/ip6_output.c:227)
NF_HOOK.constprop.0 (./include/net/dst.h:445
    ./include/linux/netfilter.h:302)
mld_sendpack (net/ipv6/mcast.c:1824)
mld_send_cr (net/ipv6/mcast.c:2122)
mld_ifc_work (net/ipv6/mcast.c:2655)
process_one_work (kernel/workqueue.c:2294)
worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
kthread (kernel/kthread.c:376)
ret_from_fork (arch/x86/entry/entry_64.S:312)
 </TASK>
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
---[ end trace 0000000000000000 ]---

Fixes: 0c4e85813d0a ("[NET]: Wrap netdevice hardware header creation.")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eddf8ee270e7..9b25a6301fa5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3054,7 +3054,7 @@ static inline int dev_hard_header(struct sk_buff *skb, struct net_device *dev,
 				  const void *daddr, const void *saddr,
 				  unsigned int len)
 {
-	if (!dev->header_ops || !dev->header_ops->create)
+	if (!dev || !dev->header_ops || !dev->header_ops->create)
 		return 0;
 
 	return dev->header_ops->create(skb, dev, type, daddr, saddr, len);
-- 
2.31.1

