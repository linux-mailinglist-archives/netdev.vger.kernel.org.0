Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0ACB645845
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiLGKxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiLGKxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:53:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355794B760;
        Wed,  7 Dec 2022 02:53:23 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B79vtea016766;
        Wed, 7 Dec 2022 10:53:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=W/NxrVN+hsZ5+tOtcE6Gfa4nFVgZdIeiP4MldHCmx8s=;
 b=jK2EYJqkLTV1kVVqBc7516clOpu+qXI5Y+fbwgdR00HDq+bzdSApoAjphuYl9161X1TX
 jGCA3Nid1heNKLiqeyziVBbGUBZoNshEcDMDW0DN0lOVzjdtrz1IHYdyyQ3AdrCpsM0x
 m8/cWFo+nVSTfGEjwl8vPDGtsb6M/Q81w0PyqmMI3+49TwlinWdBLElaIDqLGMQ4YIB4
 zAicmyrJ7z6acTKo5Vc0CCl9Txt3dIWS30FARSyCo8jaHzBmQcMtpnFHGvX1QU8fggzi
 cDO6oMlguS400mpvlzXriTYB98SAaq8RrYOlTvHkvia/k4N165j9rtSga0mKRppMAVyf vw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mapx1m7tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 10:53:14 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LhHbX010333;
        Wed, 7 Dec 2022 10:53:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3m9ks42tjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 10:53:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B7Ar8qj39453110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Dec 2022 10:53:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9807B2004B;
        Wed,  7 Dec 2022 10:53:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01BC320049;
        Wed,  7 Dec 2022 10:53:08 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box.com (unknown [9.171.51.222])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Dec 2022 10:53:07 +0000 (GMT)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net v2] s390/qeth: fix use-after-free in hsci
Date:   Wed,  7 Dec 2022 11:53:04 +0100
Message-Id: <20221207105304.20494-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9vhbU2XVaSGQQDVE5W6JPOAsSOu5NgF1
X-Proofpoint-ORIG-GUID: 9vhbU2XVaSGQQDVE5W6JPOAsSOu5NgF1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_04,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 clxscore=1011 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212070089
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEXHASH_WORD,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KASAN found that addr was dereferenced after br2dev_event_work was freed.

==================================================================
BUG: KASAN: use-after-free in qeth_l2_br2dev_worker+0x5ba/0x6b0
Read of size 1 at addr 00000000fdcea440 by task kworker/u760:4/540
CPU: 17 PID: 540 Comm: kworker/u760:4 Tainted: G            E      6.1.0-20221128.rc7.git1.5aa3bed4ce83.300.fc36.s390x+kasan #1
Hardware name: IBM 8561 T01 703 (LPAR)
Workqueue: 0.0.8000_event qeth_l2_br2dev_worker
Call Trace:
 [<000000016944d4ce>] dump_stack_lvl+0xc6/0xf8
 [<000000016942cd9c>] print_address_description.constprop.0+0x34/0x2a0
 [<000000016942d118>] print_report+0x110/0x1f8
 [<0000000167a7bd04>] kasan_report+0xfc/0x128
 [<000000016938d79a>] qeth_l2_br2dev_worker+0x5ba/0x6b0
 [<00000001673edd1e>] process_one_work+0x76e/0x1128
 [<00000001673ee85c>] worker_thread+0x184/0x1098
 [<000000016740718a>] kthread+0x26a/0x310
 [<00000001672c606a>] __ret_from_fork+0x8a/0xe8
 [<00000001694711da>] ret_from_fork+0xa/0x40
Allocated by task 108338:
 kasan_save_stack+0x40/0x68
 kasan_set_track+0x36/0x48
 __kasan_kmalloc+0xa0/0xc0
 qeth_l2_switchdev_event+0x25a/0x738
 atomic_notifier_call_chain+0x9c/0xf8
 br_switchdev_fdb_notify+0xf4/0x110
 fdb_notify+0x122/0x180
 fdb_add_entry.constprop.0.isra.0+0x312/0x558
 br_fdb_add+0x59e/0x858
 rtnl_fdb_add+0x58a/0x928
 rtnetlink_rcv_msg+0x5f8/0x8d8
 netlink_rcv_skb+0x1f2/0x408
 netlink_unicast+0x570/0x790
 netlink_sendmsg+0x752/0xbe0
 sock_sendmsg+0xca/0x110
 ____sys_sendmsg+0x510/0x6a8
 ___sys_sendmsg+0x12a/0x180
 __sys_sendmsg+0xe6/0x168
 __do_sys_socketcall+0x3c8/0x468
 do_syscall+0x22c/0x328
 __do_syscall+0x94/0xf0
 system_call+0x82/0xb0
Freed by task 540:
 kasan_save_stack+0x40/0x68
 kasan_set_track+0x36/0x48
 kasan_save_free_info+0x4c/0x68
 ____kasan_slab_free+0x14e/0x1a8
 __kasan_slab_free+0x24/0x30
 __kmem_cache_free+0x168/0x338
 qeth_l2_br2dev_worker+0x154/0x6b0
 process_one_work+0x76e/0x1128
 worker_thread+0x184/0x1098
 kthread+0x26a/0x310
 __ret_from_fork+0x8a/0xe8
 ret_from_fork+0xa/0x40
Last potentially related work creation:
 kasan_save_stack+0x40/0x68
 __kasan_record_aux_stack+0xbe/0xd0
 insert_work+0x56/0x2e8
 __queue_work+0x4ce/0xd10
 queue_work_on+0xf4/0x100
 qeth_l2_switchdev_event+0x520/0x738
 atomic_notifier_call_chain+0x9c/0xf8
 br_switchdev_fdb_notify+0xf4/0x110
 fdb_notify+0x122/0x180
 fdb_add_entry.constprop.0.isra.0+0x312/0x558
 br_fdb_add+0x59e/0x858
 rtnl_fdb_add+0x58a/0x928
 rtnetlink_rcv_msg+0x5f8/0x8d8
 netlink_rcv_skb+0x1f2/0x408
 netlink_unicast+0x570/0x790
 netlink_sendmsg+0x752/0xbe0
 sock_sendmsg+0xca/0x110
 ____sys_sendmsg+0x510/0x6a8
 ___sys_sendmsg+0x12a/0x180
 __sys_sendmsg+0xe6/0x168
 __do_sys_socketcall+0x3c8/0x468
 do_syscall+0x22c/0x328
 __do_syscall+0x94/0xf0
 system_call+0x82/0xb0
Second to last potentially related work creation:
 kasan_save_stack+0x40/0x68
 __kasan_record_aux_stack+0xbe/0xd0
 kvfree_call_rcu+0xb2/0x760
 kernfs_unlink_open_file+0x348/0x430
 kernfs_fop_release+0xc2/0x320
 __fput+0x1ae/0x768
 task_work_run+0x1bc/0x298
 exit_to_user_mode_prepare+0x1a0/0x1a8
 __do_syscall+0x94/0xf0
 system_call+0x82/0xb0
The buggy address belongs to the object at 00000000fdcea400
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 64 bytes inside of
 96-byte region [00000000fdcea400, 00000000fdcea460)
The buggy address belongs to the physical page:
page:000000005a9c26e8 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xfdcea
flags: 0x3ffff00000000200(slab|node=0|zone=1|lastcpupid=0x1ffff)
raw: 3ffff00000000200 0000000000000000 0000000100000122 000000008008cc00
raw: 0000000000000000 0020004100000000 ffffffff00000001 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 00000000fdcea300: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 00000000fdcea380: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>00000000fdcea400: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                           ^
 00000000fdcea480: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 00000000fdcea500: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================

Fixes: f7936b7b2663 ("s390/qeth: Update MACs of LEARNING_SYNC device")
Reported-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: Thorsten Winkler <twinkler@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 9dc935886e9f..c6ded3fdd715 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -758,7 +758,6 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	struct list_head *iter;
 	int err = 0;
 
-	kfree(br2dev_event_work);
 	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
 	QETH_CARD_TEXT_(card, 4, "ma%012llx", ether_addr_to_u64(addr));
 
@@ -815,6 +814,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	dev_put(brdev);
 	dev_put(lsyncdev);
 	dev_put(dstdev);
+	kfree(br2dev_event_work);
 }
 
 static int qeth_l2_br2dev_queue_work(struct net_device *brdev,
-- 
2.37.1 (Apple Git-137.1)

