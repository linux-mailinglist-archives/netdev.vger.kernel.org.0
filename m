Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5116BB437
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjCONPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjCONPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:15:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FFB65C61;
        Wed, 15 Mar 2023 06:14:58 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FDBTCk030107;
        Wed, 15 Mar 2023 13:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LnGAxE/w1geMJYGLju7etwlhU3AppjVPV6TIYvG/Jvw=;
 b=foHiFJpZ7jtLAD4t/gM7pQly5JEH2f9tmdPzfKA7zD9R+J42IxgZK7j8thtutRsAEQ92
 D8dgD/yVfFbPcMgaxwPwtGSpPSP1XI2xSJSoIBp30lDVvbEU/2Tv0WE+qczesO0a5NL8
 FsiIXTSNrMbCZq12oleePVzfjp5ccd2iyLJL+V2H5Te35sb42KRBtnbTWBGGOyPVuyQ3
 4iXYAK4urQrgTD0zR6tcAq13SUhaYjfj+JsR8KNKhqrsC42o+39mBkoKH4jUCWky38cV
 KQJSil3iutLVBABwqZ3b6MW84o72F/rGPYl01M+8C5ps9gk/cPhNRwqouy+rIhMZtpyc Rw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbepe83jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 13:14:52 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32EN6cqr009954;
        Wed, 15 Mar 2023 13:14:50 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pb29sgtak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 13:14:50 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FDEkKC19792392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 13:14:46 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81AAE2004E;
        Wed, 15 Mar 2023 13:14:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70E132004B;
        Wed, 15 Mar 2023 13:14:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 15 Mar 2023 13:14:46 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 322D2E035C; Wed, 15 Mar 2023 14:14:46 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net] net/iucv: Fix size of interrupt data
Date:   Wed, 15 Mar 2023 14:14:35 +0100
Message-Id: <20230315131435.4113889-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SfCACpnZn14uCFdePYoVqlRYRazYHGj2
X-Proofpoint-ORIG-GUID: SfCACpnZn14uCFdePYoVqlRYRazYHGj2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_06,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 adultscore=0 clxscore=1011
 spamscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iucv_irq_data needs to be 4 bytes larger.
These bytes are not used by the iucv module, but written by
the z/VM hypervisor in case a CPU is deconfigured.

Reported as:
BUG dma-kmalloc-64 (Not tainted): kmalloc Redzone overwritten
-----------------------------------------------------------------------------
0x0000000000400564-0x0000000000400567 @offset=1380. First byte 0x80 instead of 0xcc
Allocated in iucv_cpu_prepare+0x44/0xd0 age=167839 cpu=2 pid=1
__kmem_cache_alloc_node+0x166/0x450
kmalloc_node_trace+0x3a/0x70
iucv_cpu_prepare+0x44/0xd0
cpuhp_invoke_callback+0x156/0x2f0
cpuhp_issue_call+0xf0/0x298
__cpuhp_setup_state_cpuslocked+0x136/0x338
__cpuhp_setup_state+0xf4/0x288
iucv_init+0xf4/0x280
do_one_initcall+0x78/0x390
do_initcalls+0x11a/0x140
kernel_init_freeable+0x25e/0x2a0
kernel_init+0x2e/0x170
__ret_from_fork+0x3c/0x58
ret_from_fork+0xa/0x40
Freed in iucv_init+0x92/0x280 age=167839 cpu=2 pid=1
__kmem_cache_free+0x308/0x358
iucv_init+0x92/0x280
do_one_initcall+0x78/0x390
do_initcalls+0x11a/0x140
kernel_init_freeable+0x25e/0x2a0
kernel_init+0x2e/0x170
__ret_from_fork+0x3c/0x58
ret_from_fork+0xa/0x40
Slab 0x0000037200010000 objects=32 used=30 fp=0x0000000000400640 flags=0x1ffff00000010200(slab|head|node=0|zone=0|
Object 0x0000000000400540 @offset=1344 fp=0x0000000000000000
Redzone  0000000000400500: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
Redzone  0000000000400510: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
Redzone  0000000000400520: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
Redzone  0000000000400530: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
Object   0000000000400540: 00 01 00 03 00 00 00 00 00 00 00 00 00 00 00 00  ................
Object   0000000000400550: f3 86 81 f2 f4 82 f8 82 f0 f0 f0 f0 f0 f0 f0 f2  ................
Object   0000000000400560: 00 00 00 00 80 00 00 00 cc cc cc cc cc cc cc cc  ................
Object   0000000000400570: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
Redzone  0000000000400580: cc cc cc cc cc cc cc cc                          ........
Padding  00000000004005d4: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
Padding  00000000004005e4: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
Padding  00000000004005f4: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a              ZZZZZZZZZZZZ
CPU: 6 PID: 121030 Comm: 116-pai-crypto. Not tainted 6.3.0-20230221.rc0.git4.99b8246b2d71.300.fc37.s390x+debug #1
Hardware name: IBM 3931 A01 704 (z/VM 7.3.0)
Call Trace:
[<000000032aa034ec>] dump_stack_lvl+0xac/0x100
[<0000000329f5a6cc>] check_bytes_and_report+0x104/0x140
[<0000000329f5aa78>] check_object+0x370/0x3c0
[<0000000329f5ede6>] free_debug_processing+0x15e/0x348
[<0000000329f5f06a>] free_to_partial_list+0x9a/0x2f0
[<0000000329f5f4a4>] __slab_free+0x1e4/0x3a8
[<0000000329f61768>] __kmem_cache_free+0x308/0x358
[<000000032a91465c>] iucv_cpu_dead+0x6c/0x88
[<0000000329c2fc66>] cpuhp_invoke_callback+0x156/0x2f0
[<000000032aa062da>] _cpu_down.constprop.0+0x22a/0x5e0
[<0000000329c3243e>] cpu_device_down+0x4e/0x78
[<000000032a61dee0>] device_offline+0xc8/0x118
[<000000032a61e048>] online_store+0x60/0xe0
[<000000032a08b6b0>] kernfs_fop_write_iter+0x150/0x1e8
[<0000000329fab65c>] vfs_write+0x174/0x360
[<0000000329fab9fc>] ksys_write+0x74/0x100
[<000000032aa03a5a>] __do_syscall+0x1da/0x208
[<000000032aa177b2>] system_call+0x82/0xb0
INFO: lockdep is turned off.
FIX dma-kmalloc-64: Restoring kmalloc Redzone 0x0000000000400564-0x0000000000400567=0xcc
FIX dma-kmalloc-64: Object at 0x0000000000400540 not freed

Fixes: 2356f4cb1911 ("[S390]: Rewrite of the IUCV base code, part 2")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 net/iucv/iucv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index eb0295d90039..fc3fddeb6f36 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -83,7 +83,7 @@ struct iucv_irq_data {
 	u16 ippathid;
 	u8  ipflags1;
 	u8  iptype;
-	u32 res2[8];
+	u32 res2[9];
 };
 
 struct iucv_irq_list {
-- 
2.37.2

