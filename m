Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EFC25C9CA
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgICTyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:54:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729172AbgICTxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:53:40 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083JhP8N110098;
        Thu, 3 Sep 2020 15:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=yxdo+R2w8O1GVQMZNBw3Y9VDs1Jq9hgLeHCB23K7dzA=;
 b=CNQ/MVZGM6znItrr0I8jH134by7jSBweKGgyu7HvvblaypN25UWpTaNS9OLHIHvTtFTR
 fw2Wz0vxvIf/CgKb9zpoU90G1mwTq81+SbhBrdrNziliD0EeeizakZcYtXi+lFCgUGqJ
 SZApwc4A45QcMPzn0Nz0PFNXGEDrsxqY9P0MfVE8+Z3obbQxmoXdCOkOGgyKvlpSUmYj
 uDsanoYfSUHR9bTPM7XydBdD3nO7VO4GPbv78Es6nodU5liLepldRrRmDCEPnfotAznQ
 0DwuekqAHukgGH8YkdG/vSVdN2mBvfdQvpnh4p9pGJr7eD9NNmQCj0nd8tuPWAD6DehF 8w== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33b6vx87ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 15:53:37 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 083JrZgX016234;
        Thu, 3 Sep 2020 19:53:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 339ap7t3tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 19:53:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 083JrW2P23134500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 19:53:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91EF411C04A;
        Thu,  3 Sep 2020 19:53:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5987211C050;
        Thu,  3 Sep 2020 19:53:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 19:53:32 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 3/4] net/smc: reset sndbuf_desc if freed
Date:   Thu,  3 Sep 2020 21:53:17 +0200
Message-Id: <20200903195318.39288-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903195318.39288-1-kgraul@linux.ibm.com>
References: <20200903195318.39288-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_13:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=3 mlxlogscore=999
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

When an SMC connection is created, and there is a problem to
create an RMB or DMB, the previously created send buffer is
thrown away as well including buffer descriptor freeing.
Make sure the connection no longer references the freed
buffer descriptor, otherwise bugs like this are possible:

[71556.835148] =============================================================================
[71556.835168] BUG kmalloc-128 (Tainted: G    B      OE    ): Poison overwritten
[71556.835172] -----------------------------------------------------------------------------

[71556.835179] INFO: 0x00000000d20894be-0x00000000aaef63e9 @offset=2724. First byte 0x0 instead of 0x6b
[71556.835215] INFO: Allocated in __smc_buf_create+0x184/0x578 [smc] age=0 cpu=5 pid=46726
[71556.835234]     ___slab_alloc+0x5a4/0x690
[71556.835239]     __slab_alloc.constprop.0+0x70/0xb0
[71556.835243]     kmem_cache_alloc_trace+0x38e/0x3f8
[71556.835250]     __smc_buf_create+0x184/0x578 [smc]
[71556.835257]     smc_buf_create+0x2e/0xe8 [smc]
[71556.835264]     smc_listen_work+0x516/0x6a0 [smc]
[71556.835275]     process_one_work+0x280/0x478
[71556.835280]     worker_thread+0x66/0x368
[71556.835287]     kthread+0x17a/0x1a0
[71556.835294]     ret_from_fork+0x28/0x2c
[71556.835301] INFO: Freed in smc_buf_create+0xd8/0xe8 [smc] age=0 cpu=5 pid=46726
[71556.835307]     __slab_free+0x246/0x560
[71556.835311]     kfree+0x398/0x3f8
[71556.835318]     smc_buf_create+0xd8/0xe8 [smc]
[71556.835324]     smc_listen_work+0x516/0x6a0 [smc]
[71556.835328]     process_one_work+0x280/0x478
[71556.835332]     worker_thread+0x66/0x368
[71556.835337]     kthread+0x17a/0x1a0
[71556.835344]     ret_from_fork+0x28/0x2c
[71556.835348] INFO: Slab 0x00000000a0744551 objects=51 used=51 fp=0x0000000000000000 flags=0x1ffff00000010200
[71556.835352] INFO: Object 0x00000000563480a1 @offset=2688 fp=0x00000000289567b2

[71556.835359] Redzone 000000006783cde2: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[71556.835363] Redzone 00000000e35b876e: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[71556.835367] Redzone 0000000023074562: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[71556.835372] Redzone 00000000b9564b8c: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[71556.835376] Redzone 00000000810c6362: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[71556.835380] Redzone 0000000065ef52c3: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[71556.835384] Redzone 00000000c5dd6984: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[71556.835388] Redzone 000000004c480f8f: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[71556.835392] Object 00000000563480a1: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[71556.835397] Object 000000009c479d06: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[71556.835401] Object 000000006e1dce92: 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b  kkkk....kkkkkkkk
[71556.835405] Object 00000000227f7cf8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[71556.835410] Object 000000009a701215: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[71556.835414] Object 000000003731ce76: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[71556.835418] Object 00000000f7085967: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[71556.835422] Object 0000000007f99927: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[71556.835427] Redzone 00000000579c4913: bb bb bb bb bb bb bb bb                          ........
[71556.835431] Padding 00000000305aef82: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[71556.835435] Padding 00000000b1cdd722: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[71556.835438] Padding 00000000c7568199: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[71556.835442] Padding 00000000fad4c4d4: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[71556.835451] CPU: 0 PID: 47939 Comm: kworker/0:15 Tainted: G    B      OE     5.9.0-rc1uschi+ #54
[71556.835456] Hardware name: IBM 3906 M03 703 (LPAR)
[71556.835464] Workqueue: events smc_listen_work [smc]
[71556.835470] Call Trace:
[71556.835478]  [<00000000d5eaeb10>] show_stack+0x90/0xf8
[71556.835493]  [<00000000d66fc0f8>] dump_stack+0xa8/0xe8
[71556.835499]  [<00000000d61a511c>] check_bytes_and_report+0x104/0x130
[71556.835504]  [<00000000d61a57b2>] check_object+0x26a/0x2e0
[71556.835509]  [<00000000d61a59bc>] alloc_debug_processing+0x194/0x238
[71556.835514]  [<00000000d61a8c14>] ___slab_alloc+0x5a4/0x690
[71556.835519]  [<00000000d61a9170>] __slab_alloc.constprop.0+0x70/0xb0
[71556.835524]  [<00000000d61aaf66>] kmem_cache_alloc_trace+0x38e/0x3f8
[71556.835530]  [<000003ff80549bbc>] __smc_buf_create+0x184/0x578 [smc]
[71556.835538]  [<000003ff8054a396>] smc_buf_create+0x2e/0xe8 [smc]
[71556.835545]  [<000003ff80540c16>] smc_listen_work+0x516/0x6a0 [smc]
[71556.835549]  [<00000000d5f0f448>] process_one_work+0x280/0x478
[71556.835554]  [<00000000d5f0f6a6>] worker_thread+0x66/0x368
[71556.835559]  [<00000000d5f18692>] kthread+0x17a/0x1a0
[71556.835563]  [<00000000d6abf3b8>] ret_from_fork+0x28/0x2c
[71556.835569] INFO: lockdep is turned off.
[71556.835573] FIX kmalloc-128: Restoring 0x00000000d20894be-0x00000000aaef63e9=0x6b

[71556.835577] FIX kmalloc-128: Marking all objects used

Fixes: fd7f3a746582 ("net/smc: remove freed buffer from list")
Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a6ac0eb20c99..a406627b1d55 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1779,6 +1779,7 @@ int smc_buf_create(struct smc_sock *smc, bool is_smcd)
 		list_del(&smc->conn.sndbuf_desc->list);
 		mutex_unlock(&smc->conn.lgr->sndbufs_lock);
 		smc_buf_free(smc->conn.lgr, false, smc->conn.sndbuf_desc);
+		smc->conn.sndbuf_desc = NULL;
 	}
 	return rc;
 }
-- 
2.17.1

