Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EC2CA787
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 18:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406481AbfJCQyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:54:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26284 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406371AbfJCQyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:54:51 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x93GmpAV109559;
        Thu, 3 Oct 2019 12:54:40 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vdm171dpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Oct 2019 12:54:39 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x93GrPOS020802;
        Thu, 3 Oct 2019 16:54:37 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 2v9y58h8wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Oct 2019 16:54:37 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x93GsZTq56754432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Oct 2019 16:54:35 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF680136051;
        Thu,  3 Oct 2019 16:54:35 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EAB9136055;
        Thu,  3 Oct 2019 16:54:35 +0000 (GMT)
Received: from oc5348122405.ibm.com.austin.ibm.com (unknown [9.53.179.215])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Oct 2019 16:54:34 +0000 (GMT)
From:   David Dai <zdai@linux.vnet.ibm.com>
To:     jeffrey.t.kirsher@intel.com, davem@davemloft.net
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zdai@us.ibm.com,
        zdai@linux.vnet.ibm.com
Subject: [v1] e1000e: EEH on e1000e adapter detects io perm failure can trigger crash
Date:   Thu,  3 Oct 2019 11:54:32 -0500
Message-Id: <1570121672-12172-1-git-send-email-zdai@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-03_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=989 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910030146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We see the behavior when EEH e1000e adapter detects io permanent failure,
it will crash kernel with this stack:
EEH: Beginning: 'error_detected(permanent failure)'
EEH: PE#900000 (PCI 0115:90:00.1): Invoking e1000e->error_detected(permanent failure)
EEH: PE#900000 (PCI 0115:90:00.1): e1000e driver reports: 'disconnect'
EEH: PE#900000 (PCI 0115:90:00.0): Invoking e1000e->error_detected(permanent failure)
EEH: PE#900000 (PCI 0115:90:00.0): e1000e driver reports: 'disconnect'
EEH: Finished:'error_detected(permanent failure)'
Oops: Exception in kernel mode, sig: 5 [#1]
NIP [c0000000007b1be0] free_msi_irqs+0xa0/0x280
 LR [c0000000007b1bd0] free_msi_irqs+0x90/0x280
Call Trace:
[c0000004f491ba10] [c0000000007b1bd0] free_msi_irqs+0x90/0x280 (unreliable)
[c0000004f491ba70] [c0000000007b260c] pci_disable_msi+0x13c/0x180
[c0000004f491bab0] [d0000000046381ac] e1000_remove+0x234/0x2a0 [e1000e]
[c0000004f491baf0] [c000000000783cec] pci_device_remove+0x6c/0x120
[c0000004f491bb30] [c00000000088da6c] device_release_driver_internal+0x2bc/0x3f0
[c0000004f491bb80] [c00000000076f5a8] pci_stop_and_remove_bus_device+0xb8/0x110
[c0000004f491bbc0] [c00000000006e890] pci_hp_remove_devices+0x90/0x130
[c0000004f491bc50] [c00000000004ad34] eeh_handle_normal_event+0x1d4/0x660
[c0000004f491bd10] [c00000000004bf10] eeh_event_handler+0x1c0/0x1e0
[c0000004f491bdc0] [c00000000017c4ac] kthread+0x1ac/0x1c0
[c0000004f491be30] [c00000000000b75c] ret_from_kernel_thread+0x5c/0x80

Basically the e1000e irqs haven't been freed at the time eeh is trying to 
remove the the e1000e device.
Need to make sure when e1000e_close is called to bring down the NIC,
if adapter error_state is pci_channel_io_perm_failure, it should also 
bring down the link and free irqs.

Reported-by: Morumuri Srivalli  <smorumu1@in.ibm.com>
Signed-off-by: David Dai <zdai@linux.vnet.ibm.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index d7d56e4..cf618e1 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4715,7 +4715,8 @@ int e1000e_close(struct net_device *netdev)
 
 	pm_runtime_get_sync(&pdev->dev);
 
-	if (!test_bit(__E1000_DOWN, &adapter->state)) {
+	if (!test_bit(__E1000_DOWN, &adapter->state) ||
+	    (adapter->pdev->error_state == pci_channel_io_perm_failure)) {
 		e1000e_down(adapter, true);
 		e1000_free_irq(adapter);
 
-- 
1.7.1

