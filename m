Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57451678CDF
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 01:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjAXAb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 19:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAXAbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 19:31:25 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F91422796
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 16:31:22 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NMKRXF013750;
        Tue, 24 Jan 2023 00:31:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=cseIGiQX3i+N3xsiDom/qB2YL9173dmziZEm60K7FfQ=;
 b=OiQ+GgLtdgZjQ9L2+rNdF7lkrFBlAW7NrgZuXMaeBoYEY5H8OHOgDjPzVo+r5smTWdjm
 PzmEDuQmX2z/lhZtrTHQJe5rMRcKDb/VM+rqXE8Y55LYMS+vZLLLsXiR1UjRDiLB+eHM
 nYWYpO2TV6a8VF9YK1deCe0mVqYp0DfbbicW7du2gYllrh0KcoA7S2bxFvKlTw9vJrtS
 u7zKdQTHUvDJ5MHzGW/kcFRZwRVU3CggnOu/+ujLPdXsPrVKVZQzGQmDPp5WUkKmC14l
 PoRW/fOBWG4ge/Q5rj1l0puRK727dn4P+HiYhX3gA+syFKvdENjU1zqYooOYBX8LHO+1 eA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3na2xsas9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 00:31:21 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30O02qO2019881;
        Tue, 24 Jan 2023 00:31:20 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3n87p732kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 00:31:20 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30O0VIbv27198180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 00:31:19 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 967265804E;
        Tue, 24 Jan 2023 00:31:18 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42A0B58056;
        Tue, 24 Jan 2023 00:31:18 +0000 (GMT)
Received: from ltc19u30.pok.stglabs.ibm.com (unknown [9.114.224.51])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 24 Jan 2023 00:31:18 +0000 (GMT)
From:   David Christensen <drc@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     David Christensen <drc@linux.vnet.ibm.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Subject: [PATCH] net/tg3: resolve deadlock in tg3_reset_task() during EEH
Date:   Mon, 23 Jan 2023 19:31:07 -0500
Message-Id: <20230124003107.214307-1-drc@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dTM8HURionw3hTucikF2Ofy4zkODL0ka
X-Proofpoint-ORIG-GUID: dTM8HURionw3hTucikF2Ofy4zkODL0ka
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230223
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During EEH error injection testing, a deadlock was encountered in the tg3
driver when tg3_io_error_detected() was attempting to cancel outstanding
reset tasks:

crash> foreach UN bt
...
PID: 159    TASK: c0000000067c6000  CPU: 8   COMMAND: "eehd"
...
 #5 [c00000000681f990] __cancel_work_timer at c00000000019fd18
 #6 [c00000000681fa30] tg3_io_error_detected at c00800000295f098 [tg3]
 #7 [c00000000681faf0] eeh_report_error at c00000000004e25c
...

PID: 290    TASK: c000000036e5f800  CPU: 6   COMMAND: "kworker/6:1"
...
 #4 [c00000003721fbc0] rtnl_lock at c000000000c940d8
 #5 [c00000003721fbe0] tg3_reset_task at c008000002969358 [tg3]
 #6 [c00000003721fc60] process_one_work at c00000000019e5c4
...

PID: 296    TASK: c000000037a65800  CPU: 21  COMMAND: "kworker/21:1"
...
 #4 [c000000037247bc0] rtnl_lock at c000000000c940d8
 #5 [c000000037247be0] tg3_reset_task at c008000002969358 [tg3]
 #6 [c000000037247c60] process_one_work at c00000000019e5c4
...

PID: 655    TASK: c000000036f49000  CPU: 16  COMMAND: "kworker/16:2"
...:1

 #4 [c0000000373ebbc0] rtnl_lock at c000000000c940d8
 #5 [c0000000373ebbe0] tg3_reset_task at c008000002969358 [tg3]
 #6 [c0000000373ebc60] process_one_work at c00000000019e5c4
...

Code inspection shows that both tg3_io_error_detected() and
tg3_reset_task() attempt to acquire the RTNL lock at the beginning of
their code blocks.  If tg3_reset_task() should happen to execute between
the times when tg3_io_error_deteced() acquires the RTNL lock and
tg3_reset_task_cancel() is called, a deadlock will occur.

Moving tg3_reset_task_cancel() call earlier within the code block, prior
to acquiring RTNL, prevents this from happening, but also exposes another
deadlock issue where tg3_reset_task() may execute AFTER
tg3_io_error_detected() has executed:

crash> foreach UN bt
PID: 159    TASK: c0000000067d2000  CPU: 9   COMMAND: "eehd"
...
 #4 [c000000006867a60] rtnl_lock at c000000000c940d8
 #5 [c000000006867a80] tg3_io_slot_reset at c0080000026c2ea8 [tg3]
 #6 [c000000006867b00] eeh_report_reset at c00000000004de88
...
PID: 363    TASK: c000000037564000  CPU: 6   COMMAND: "kworker/6:1"
...
 #3 [c000000036c1bb70] msleep at c000000000259e6c
 #4 [c000000036c1bba0] napi_disable at c000000000c6b848
 #5 [c000000036c1bbe0] tg3_reset_task at c0080000026d942c [tg3]
 #6 [c000000036c1bc60] process_one_work at c00000000019e5c4
...

This issue can be avoided by aborting tg3_reset_task() if EEH error
recovery is already in progress.

Signed-off-by: David Christensen <drc@linux.vnet.ibm.com>
Cc: Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc: Prashant Sreedharan <prashant@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 59debdc344a5..ee4604e6900e 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -11166,7 +11166,8 @@ static void tg3_reset_task(struct work_struct *work)
 	rtnl_lock();
 	tg3_full_lock(tp, 0);
 
-	if (!netif_running(tp->dev)) {
+	// Skip reset task if no netdev or already in PCI recovery
+	if (!tp->dev || tp->pcierr_recovery || !netif_running(tp->dev)) {
 		tg3_flag_clear(tp, RESET_TASK_PENDING);
 		tg3_full_unlock(tp);
 		rtnl_unlock();
@@ -18101,6 +18102,9 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	netdev_info(netdev, "PCI I/O error detected\n");
 
+	/* Want to make sure that the reset task doesn't run */
+	tg3_reset_task_cancel(tp);
+
 	rtnl_lock();
 
 	/* Could be second call or maybe we don't have netdev yet */
@@ -18117,9 +18121,6 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	tg3_timer_stop(tp);
 
-	/* Want to make sure that the reset task doesn't run */
-	tg3_reset_task_cancel(tp);
-
 	netif_device_detach(netdev);
 
 	/* Clean up software state, even if MMIO is blocked */
-- 
2.31.1

