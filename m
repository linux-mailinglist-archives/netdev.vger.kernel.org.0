Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7DC2A41B7
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgKCKZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:25:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728015AbgKCKZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:25:54 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3A2hrh139202;
        Tue, 3 Nov 2020 05:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Gne/t4pG1Qv908m6QG5vxJHjhVX+BkMcJFSdoEjgcGU=;
 b=kgNlKQJm6KgscG9Ej91I8uZI7s1QKzr8rHsaDJPzw7lfzCeyp0dO5yQnqjiJdc5OWrDk
 d/dS6wIqHFseFrjxaWf28YWZKuJ81GevIoXU8AP/QXGv77X1WvW9LfvuweZvHGvk3HQU
 uZQSCnUebspuDBEX32gKI1n12msPDVpo83iwZ+jEqlD5evfaxsf9PKwQWcJT/3sQLSlU
 a+NF+4vWm072Dl9Vw9Wx8iZnx1MX2FQBZ/loT4M2TBItDETl55IcJtt3vqN0sBwjhjCE
 3OhAC6wT8CT9PI/wtNr6Ky9BFWCDRYGZkCjWHpHJWWKHfN+ywkg2OCT7hrN+vZeGGp6I mQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34jyyt1fev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 05:25:53 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A3AN4nI020297;
        Tue, 3 Nov 2020 10:25:51 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 34h01ub1f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 10:25:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A3APmU461604248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Nov 2020 10:25:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 347DEA4054;
        Tue,  3 Nov 2020 10:25:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F179AA405C;
        Tue,  3 Nov 2020 10:25:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Nov 2020 10:25:47 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v2 06/15] net/smc: Add diagnostic information to link structure
Date:   Tue,  3 Nov 2020 11:25:22 +0100
Message-Id: <20201103102531.91710-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201103102531.91710-1-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_07:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 suspectscore=1 priorityscore=1501
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

During link creation add network and ib-device name to
link structure. This is needed for diagnostic purposes.

When diagnostic information is gathered, we need to traverse
device, linkgroup and link structures, to be able to do that
we need to hold a spinlock for the linkgroup list, without this
diagnostic information in link structure, another device list
mutex holding would be necessary to dereference the device
pointer in the link structure which would be impossible when
holding a spinlock already.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 10 ++++++++++
 net/smc/smc_core.h |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index da94725deb09..28fc583d9033 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -303,6 +303,15 @@ static u8 smcr_next_link_id(struct smc_link_group *lgr)
 	return link_id;
 }
 
+static inline void smcr_copy_dev_info_to_link(struct smc_link *link)
+{
+	struct smc_ib_device *smcibdev = link->smcibdev;
+
+	memcpy(link->ibname, smcibdev->ibdev->name, sizeof(link->ibname));
+	memcpy(link->ndevname, smcibdev->netdev[link->ibport - 1],
+	       sizeof(link->ndevname));
+}
+
 int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 		   u8 link_idx, struct smc_init_info *ini)
 {
@@ -317,6 +326,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
 	atomic_inc(&ini->ib_dev->lnk_cnt_by_port[ini->ib_port - 1]);
+	smcr_copy_dev_info_to_link(lnk);
 	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
 	atomic_set(&lnk->conn_cnt, 0);
 	smc_llc_link_set_uid(lnk);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 83a88a4635db..bd16d63c5222 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -124,6 +124,9 @@ struct smc_link {
 	u8			link_is_asym;	/* is link asymmetric? */
 	struct smc_link_group	*lgr;		/* parent link group */
 	struct work_struct	link_down_wrk;	/* wrk to bring link down */
+	/* Diagnostic relevant link information */
+	u8			ibname[IB_DEVICE_NAME_MAX];/* ib device name */
+	u8			ndevname[IFNAMSIZ];/* network device name */
 
 	enum smc_link_state	state;		/* state of link */
 	struct delayed_work	llc_testlink_wrk; /* testlink worker */
-- 
2.17.1

