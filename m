Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA4B2BB950
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgKTWlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35996 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728581AbgKTWlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:41:04 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMVq66026211
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ATO6Y0dtUO+auE+JA01dBDCrBB6+E4LsDQdCGGs16j8=;
 b=Iqe+Bv2aVqfO4q0t7QIGtHcN/04xTn5af3FT8+4q9vleEc8RYZjUMMKd3J5O7bChOFjg
 sxbMrabbQrsXqXiWHjrNhIi+xSpIwskb85VZxRdAZSA5+27GQ844hNmQcXJVRYcTokZ9
 OSCZ4gb/rzuHAHtuzfL/4Zma4ojHrQc0wAYdYJvXsUkuY+HyjrVrjuHX09AWENW8Hco8
 o8QcXEB9twIx8fh0oHrhKVSfGdDPF5mx9ULL0sL6qeLKhy7tap8+0UiorvkYducknVgW
 Cosr3gkk7avdO5y3gyHRK1ktAayI/k7d5Hojbh3agyOrrKbYBpTePHcCax+fVD6leHV+ tA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xp77gsnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:04 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMe9nl017265
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:03 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 34w5w8tneh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:03 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMf2S062325098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:41:02 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E1656E053;
        Fri, 20 Nov 2020 22:41:02 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BFDD6E054;
        Fri, 20 Nov 2020 22:41:01 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:41:01 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 13/15] ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq
Date:   Fri, 20 Nov 2020 16:40:47 -0600
Message-Id: <20201120224049.46933-14-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=1 adultscore=0 clxscore=1015 malwarescore=0 spamscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

crq->msgs could be NULL if the previous reset did not complete after
freeing crq->msgs. Check for NULL before dereferencing them.

Snippet of call trace:
...
ibmvnic 30000003 env3 (unregistering): Releasing sub-CRQ
ibmvnic 30000003 env3 (unregistering): Releasing CRQ
BUG: Kernel NULL pointer dereference on read at 0x00000000
Faulting instruction address: 0xc0000000000c1a30
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: ibmvnic(E-) rpadlpar_io rpaphp xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables xsk_diag tcp_diag udp_diag tun raw_diag inet_diag unix_diag bridge af_packet_diag netlink_diag stp llc rfkill sunrpc pseries_rng xts vmx_crypto uio_pdrv_genirq uio binfmt_misc ip_tables xfs libcrc32c sd_mod t10_pi sg ibmvscsi ibmveth scsi_transport_srp dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ibmvnic]
CPU: 20 PID: 8426 Comm: kworker/20:0 Tainted: G            E     5.10.0-rc1+ #12
Workqueue: events __ibmvnic_reset [ibmvnic]
NIP:  c0000000000c1a30 LR: c008000001b00c18 CTR: 0000000000000400
REGS: c00000000d05b7a0 TRAP: 0380   Tainted: G            E      (5.10.0-rc1+)
MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 44002480  XER: 20040000
CFAR: c0000000000c19ec IRQMASK: 0
GPR00: 0000000000000400 c00000000d05ba30 c008000001b17c00 0000000000000000
GPR04: 0000000000000000 0000000000000000 0000000000000000 00000000000001e2
GPR08: 000000000001f400 ffffffffffffd950 0000000000000000 c008000001b0b280
GPR12: c0000000000c19c8 c00000001ec72e00 c00000000019a778 c00000002647b440
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000006 0000000000000001 0000000000000003 0000000000000002
GPR24: 0000000000001000 c008000001b0d570 0000000000000005 c00000007ab5d550
GPR28: c00000007ab5c000 c000000032fcf848 c00000007ab5cc00 c000000032fcf800
NIP [c0000000000c1a30] memset+0x68/0x104
LR [c008000001b00c18] ibmvnic_reset_crq+0x70/0x110 [ibmvnic]
Call Trace:
[c00000000d05ba30] [0000000000000800] 0x800 (unreliable)
[c00000000d05bab0] [c008000001b0a930] do_reset.isra.40+0x224/0x634 [ibmvnic]
[c00000000d05bb80] [c008000001b08574] __ibmvnic_reset+0x17c/0x3c0 [ibmvnic]
[c00000000d05bc50] [c00000000018d9ac] process_one_work+0x2cc/0x800
[c00000000d05bd20] [c00000000018df58] worker_thread+0x78/0x520
[c00000000d05bdb0] [c00000000019a934] kthread+0x1c4/0x1d0
[c00000000d05be20] [c00000000000d5d0] ret_from_kernel_thread+0x5c/0x6c

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a0dbd963a1ab..dda2d4bb9b40 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5053,6 +5053,10 @@ static int ibmvnic_reset_crq(struct ibmvnic_adapter *adapter)
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 
 	/* Clean out the queue */
+	if (!crq->msgs) {
+		netdev_warn(adapter->netdev, "crq->msgs == NULL\n");
+		return -EINVAL;
+	}
 	memset(crq->msgs, 0, PAGE_SIZE);
 	crq->cur = 0;
 	crq->active = false;
-- 
2.23.0

