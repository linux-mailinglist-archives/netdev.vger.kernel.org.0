Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CD417BF73
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCFNpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:45:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49364 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726704AbgCFNpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:45:31 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 026Dis6t017407
        for <netdev@vger.kernel.org>; Fri, 6 Mar 2020 08:45:30 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ykp8mbceb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 08:45:29 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Fri, 6 Mar 2020 13:45:28 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 13:45:26 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 026DjOiP39911454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 13:45:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68051A4057;
        Fri,  6 Mar 2020 13:45:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28D54A405B;
        Fri,  6 Mar 2020 13:45:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 13:45:24 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net] net/smc: cancel event worker during device removal
Date:   Fri,  6 Mar 2020 14:45:18 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20030613-0012-0000-0000-0000038DC974
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030613-0013-0000-0000-000021CA8BD9
Message-Id: <20200306134518.84416-1-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_04:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=1 impostorscore=0 clxscore=1015
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During IB device removal, cancel the event worker before the device
structure is freed. In the worker, check if the device is being
terminated and do not proceed with the event work in that case.

Fixes: a4cf0443c414 ("smc: introduce SMC as an IB-client")
Reported-by: syzbot+b297c6825752e7a07272@syzkaller.appspotmail.com
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_ib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index d6ba186f67e2..5e4e64a9aa4b 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -240,6 +240,9 @@ static void smc_ib_port_event_work(struct work_struct *work)
 		work, struct smc_ib_device, port_event_work);
 	u8 port_idx;
 
+	if (list_empty(&smcibdev->list))
+		return;
+
 	for_each_set_bit(port_idx, &smcibdev->port_event_mask, SMC_MAX_PORTS) {
 		smc_ib_remember_port_attr(smcibdev, port_idx + 1);
 		clear_bit(port_idx, &smcibdev->port_event_mask);
@@ -582,6 +585,7 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
 	smc_smcr_terminate_all(smcibdev);
 	smc_ib_cleanup_per_ibdev(smcibdev);
 	ib_unregister_event_handler(&smcibdev->event_handler);
+	cancel_work_sync(&smcibdev->port_event_work);
 	kfree(smcibdev);
 }
 
-- 
2.17.1

