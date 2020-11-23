Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CAB2C148C
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgKWTfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:35:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728930AbgKWTfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:35:51 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJV0XX036558
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 14:35:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5VzxQEggM60hC5aUMu+TRSFu1+z7t4ScxOAbmZwwx8Y=;
 b=OOWXak9gViYzhjuZlzJIhx4VWILcnkvEKbGkBwjOVQQQ9Y95t0LwsH+tl3KjFAzVXFrw
 bwtqyZN6Q7a3h3dy6eZv9TV2eLWr7Xaj9RJ/hbSQ7Ze9uVfgyTOwUT3kwSwDNrOyhNo7
 /LAkIdLjkUOB3En0RBB1taqIqKGqVvDPIaLA65gZQps9CTc/HjH0U/bvHAcFFdcT0zhm
 /uzjj3XVRvUA5VYHiDgBr1DeSc/53CAcGvE00Yr+vFdz/LieGh9QCMnsQV27KMBFjC6Q
 l5r6dC7geSQnAL3fyUhhsypeo5bEgdbcOEDu+dPYGtbjYCVoNkBDPugtwXxyHR3XZdwE TQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34yucmvv7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 14:35:50 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJXOWB031752
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 19:35:49 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 34xth8x3np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 19:35:49 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANJZmtH8913572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 19:35:48 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B00DB2064;
        Mon, 23 Nov 2020 19:35:48 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FFC5B2065;
        Mon, 23 Nov 2020 19:35:48 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.185.230])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 19:35:47 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net v2 1/3] ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
Date:   Mon, 23 Nov 2020 13:35:45 -0600
Message-Id: <20201123193547.57225-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201123193547.57225-1-ljp@linux.ibm.com>
References: <20201123193547.57225-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

adapter->tx_scrq and adapter->rx_scrq could be NULL if the previous reset
did not complete after freeing sub crqs. Check for NULL before
dereferencing them.

Snippet of call trace:
ibmvnic 30000006 env6: Releasing sub-CRQ
ibmvnic 30000006 env6: Releasing CRQ
...
ibmvnic 30000006 env6: Got Control IP offload Response
ibmvnic 30000006 env6: Re-setting tx_scrq[0]
BUG: Kernel NULL pointer dereference on read at 0x00000000
Faulting instruction address: 0xc008000003dea7cc
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: rpadlpar_io rpaphp xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables xsk_diag tcp_diag udp_diag raw_diag inet_diag unix_diag af_packet_diag netlink_diag tun bridge stp llc rfkill sunrpc pseries_rng xts vmx_crypto uio_pdrv_genirq uio binfmt_misc ip_tables xfs libcrc32c sd_mod t10_pi sg ibmvscsi ibmvnic ibmveth scsi_transport_srp dm_mirror dm_region_hash dm_log dm_mod
CPU: 80 PID: 1856 Comm: kworker/80:2 Tainted: G        W         5.8.0+ #4
Workqueue: events __ibmvnic_reset [ibmvnic]
NIP:  c008000003dea7cc LR: c008000003dea7bc CTR: 0000000000000000
REGS: c0000007ef7db860 TRAP: 0380   Tainted: G        W          (5.8.0+)
MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 28002422  XER: 0000000d
CFAR: c000000000bd9520 IRQMASK: 0
GPR00: c008000003dea7bc c0000007ef7dbaf0 c008000003df7400 c0000007fa26ec00
GPR04: c0000007fcd0d008 c0000007fcd96350 0000000000000027 c0000007fcd0d010
GPR08: 0000000000000023 0000000000000000 0000000000000000 0000000000000000
GPR12: 0000000000002000 c00000001ec18e00 c0000000001982f8 c0000007bad6e840
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 fffffffffffffef7
GPR24: 0000000000000402 c0000007fa26f3a8 0000000000000003 c00000016f8ec048
GPR28: 0000000000000000 0000000000000000 0000000000000000 c0000007fa26ec00
NIP [c008000003dea7cc] ibmvnic_reset_init+0x15c/0x258 [ibmvnic]
LR [c008000003dea7bc] ibmvnic_reset_init+0x14c/0x258 [ibmvnic]
Call Trace:
[c0000007ef7dbaf0] [c008000003dea7bc] ibmvnic_reset_init+0x14c/0x258 [ibmvnic] (unreliable)
[c0000007ef7dbb80] [c008000003de8860] __ibmvnic_reset+0x408/0x970 [ibmvnic]
[c0000007ef7dbc50] [c00000000018b7cc] process_one_work+0x2cc/0x800
[c0000007ef7dbd20] [c00000000018bd78] worker_thread+0x78/0x520
[c0000007ef7dbdb0] [c0000000001984c4] kthread+0x1d4/0x1e0
[c0000007ef7dbe20] [c00000000000cea8] ret_from_kernel_thread+0x5c/0x74

Fixes: 57a49436f4e8 ("ibmvnic: Reset sub-crqs during driver reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: add fix tag
    remove verbose printout, return silently.
    reset function itself will handle the error return    
    
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 47446e5f8ec5..5f4fdd13184a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2930,6 +2930,9 @@ static int reset_sub_crq_queues(struct ibmvnic_adapter *adapter)
 {
 	int i, rc;
 
+	if (!adapter->tx_scrq || !adapter->rx_scrq)
+		return -EINVAL;
+
 	for (i = 0; i < adapter->req_tx_queues; i++) {
 		netdev_dbg(adapter->netdev, "Re-setting tx_scrq[%d]\n", i);
 		rc = reset_one_sub_crq_queue(adapter, adapter->tx_scrq[i]);
-- 
2.23.0

