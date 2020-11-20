Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF632BB951
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgKTWlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8078 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729077AbgKTWlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:41:04 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMVsMR028539
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zeJVDQB3iJTB39I797TP/oPV/TLR7PqSIhmc5cnJbe0=;
 b=Z0Wtp/ExxV9KcDqS+DW+/GoCaR6jg3eAK/rthkRZ+iJ3nqv0EO7r6lb/tmCEWufFM4TY
 8nJFpOj8aO3Ix+L96UqYpbusOeR8K+UYxRt1tcfMw/JPFqGO1EwdF1nIE4FydTglVsxZ
 uzXng38sTxwPZa84QH1EwbUal97uBxbi4Ok7b1okMc9/aGeNBAuoDDI+p5Oa3OyuZsES
 xJJsAdoEeGY5sTivdA2cVhni0fMN3lmXHwBeuPYMIJpWRvLkKZhHyQuFWdKYX4RaMOkD
 r3+nsHGMqGjt9u9WPiSBYLJZT0T3RTfY+5WZh1HL8JSV2J8PhcfQ0U+k089UtLDCvqKt hA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xghfbydn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:03 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMaw1f008180
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:02 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 34vgjn94vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:02 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMesec7144118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:55 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B56C6E059;
        Fri, 20 Nov 2020 22:41:01 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A1B66E053;
        Fri, 20 Nov 2020 22:41:00 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:41:00 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 12/15] ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
Date:   Fri, 20 Nov 2020 16:40:46 -0600
Message-Id: <20201120224049.46933-13-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1
 mlxlogscore=999 spamscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200144
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

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 47446e5f8ec5..a0dbd963a1ab 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2930,6 +2930,13 @@ static int reset_sub_crq_queues(struct ibmvnic_adapter *adapter)
 {
 	int i, rc;
 
+	if (!adapter->tx_scrq || !adapter->rx_scrq) {
+		netdev_err(adapter->netdev,
+			   "tx_scrq (%p) or rx_scrq (%p) does not exist\n",
+			   adapter->tx_scrq, adapter->rx_scrq);
+		return -EINVAL;
+	}
+
 	for (i = 0; i < adapter->req_tx_queues; i++) {
 		netdev_dbg(adapter->netdev, "Re-setting tx_scrq[%d]\n", i);
 		rc = reset_one_sub_crq_queue(adapter, adapter->tx_scrq[i]);
-- 
2.23.0

