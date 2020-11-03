Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FED22A41C3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgKCK0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:26:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728057AbgKCKZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:25:54 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3A2rLM144223;
        Tue, 3 Nov 2020 05:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ag+R+vMP/I79qQbBPxbwIUcND10y7U6pOMvU9TEVx9s=;
 b=UdHefZQ+NKwmDaZxr+d9aSAl5GmGWft9SF4fExiUWeTDFC3gbmlauFB7pUVPEwqGgxH5
 TsHmEAPaNJWZ/6bHm36ZP20pHwH9gGobxclBfv49TBnhptgpGEb92v14vGPRhG/eZVYl
 3+C+SEs2UgARKJqBXcEAMdAtiSG3IufzwLs0mSTz53b+OgnRq0qrUTZkkDyw0O4ffrvM
 l/4BVsGaF8EBG0032sW02O1G7qzQvp3PO2FntrXFvC6VrHWXKLTxbw7fDRpTrFcJOOlj
 L6IKj9PjK53Upj47L75lz2jQXZkrsUSBdH/GIWRrV8iYIk8bl6GTgjnfmn6RlZ95SF0o IA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34k2a4nwjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 05:25:52 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A3ANn8S021656;
        Tue, 3 Nov 2020 10:25:50 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 34h01qsks6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 10:25:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A3APlEj2228946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Nov 2020 10:25:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EA4BA4054;
        Tue,  3 Nov 2020 10:25:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66FE8A405F;
        Tue,  3 Nov 2020 10:25:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Nov 2020 10:25:47 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v2 04/15] net/smc: Add link counters for IB device ports
Date:   Tue,  3 Nov 2020 11:25:20 +0100
Message-Id: <20201103102531.91710-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201103102531.91710-1-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_07:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 mlxscore=0 impostorscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Add link counters to the structure of the smc ib device, one counter per
ib port. Increase/decrease the counters as needed in the corresponding
routines.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 3 +++
 net/smc/smc_ib.h   | 1 +
 2 files changed, 4 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 6e2077161267..da94725deb09 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -316,6 +316,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->link_idx = link_idx;
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
+	atomic_inc(&ini->ib_dev->lnk_cnt_by_port[ini->ib_port - 1]);
 	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
 	atomic_set(&lnk->conn_cnt, 0);
 	smc_llc_link_set_uid(lnk);
@@ -360,6 +361,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	smc_llc_link_clear(lnk, false);
 out:
 	put_device(&ini->ib_dev->ibdev->dev);
+	atomic_dec(&ini->ib_dev->lnk_cnt_by_port[ini->ib_port - 1]);
 	memset(lnk, 0, sizeof(struct smc_link));
 	lnk->state = SMC_LNK_UNUSED;
 	if (!atomic_dec_return(&ini->ib_dev->lnk_cnt))
@@ -750,6 +752,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
 	smc_ib_dealloc_protection_domain(lnk);
 	smc_wr_free_link_mem(lnk);
 	put_device(&lnk->smcibdev->ibdev->dev);
+	atomic_dec(&lnk->smcibdev->lnk_cnt_by_port[lnk->ibport - 1]);
 	smcibdev = lnk->smcibdev;
 	memset(lnk, 0, sizeof(struct smc_link));
 	lnk->state = SMC_LNK_UNUSED;
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 2ce481187dd0..3e6bfeddd53b 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -53,6 +53,7 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	atomic_t		lnk_cnt;	/* number of links on ibdev */
 	wait_queue_head_t	lnks_deleted;	/* wait 4 removal of all links*/
 	struct mutex		mutex;		/* protect dev setup+cleanup */
+	atomic_t		lnk_cnt_by_port[SMC_MAX_PORTS];/*#lnk per port*/
 };
 
 struct smc_buf_desc;
-- 
2.17.1

