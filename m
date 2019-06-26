Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A399356E01
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfFZPsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:48:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726239AbfFZPsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:48:06 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QFlxpe141317
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 11:48:05 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tcb189u3j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 11:48:04 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Wed, 26 Jun 2019 16:48:03 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Jun 2019 16:48:00 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5QFluwL61014172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 15:47:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A983AE045;
        Wed, 26 Jun 2019 15:47:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23C2BAE056;
        Wed, 26 Jun 2019 15:47:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jun 2019 15:47:56 +0000 (GMT)
From:   Ursula Braun <ubraun@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com, zhp@smail.nju.edu.cn,
        yuehaibing@huawei.com
Subject: [PATCH net 1/2] net/smc: hold conns_lock before calling smc_lgr_register_conn()
Date:   Wed, 26 Jun 2019 17:47:49 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626154750.46127-1-ubraun@linux.ibm.com>
References: <20190626154750.46127-1-ubraun@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062615-0016-0000-0000-0000028C9574
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062615-0017-0000-0000-000032EA0EF3
Message-Id: <20190626154750.46127-2-ubraun@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=29 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260185
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huaping Zhou <zhp@smail.nju.edu.cn>

After smc_lgr_create(), the newly created link group is added
to smc_lgr_list, thus is accessible from other context.
Although link group creation is serialized by
smc_create_lgr_pending, the new link group may still be accessed
concurrently. For example, if ib_device is no longer active,
smc_ib_port_event_work() will call smc_port_terminate(), which
in turn will call __smc_lgr_terminate() on every link group of
this device. So conns_lock is required here.

Signed-off-by: Huaping Zhou <zhp@smail.nju.edu.cn>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 2d2850adc2a3..4ca50ddf8d16 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -652,7 +652,10 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		rc = smc_lgr_create(smc, ini);
 		if (rc)
 			goto out;
+		lgr = conn->lgr;
+		write_lock_bh(&lgr->conns_lock);
 		smc_lgr_register_conn(conn); /* add smc conn to lgr */
+		write_unlock_bh(&lgr->conns_lock);
 	}
 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
-- 
2.17.1

