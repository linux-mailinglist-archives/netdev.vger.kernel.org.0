Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931222C2F42
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404110AbgKXRvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:51:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24616 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404089AbgKXRvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:51:14 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHWcdi019485;
        Tue, 24 Nov 2020 12:51:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=cUk5H2qIc04kVUWwCZGHsg5RNXN2nEW9VVGwx3aPDic=;
 b=MsqmeN0bGyDppb58vzNNEZGKRYl2MGSipuDqs78y+BrlT/2T6jOqUplXiS1XeXn83mOG
 uaoAKa3pPROh5+wv3+5n5k6nVfJzI4I2Qz/OYhZjXPHG8J1juF5MqKjB+UyPMO7y3aIQ
 b9FyOcClhy8t582fUCnkip6OMF38/oKOUUw0os2z0e4/tseIBp3EUXMWXOUivgB9UnWc
 VQiZBvXwiu2jIE3fNlFMcofLfvCZZYc77VIwtf42SpQPNbTU24FTNS9Y8M867cUPUgPc
 5yUWdM78giMTeVl4Ib0/+37UpOhetrfm2fDG20+EGnVcdjbBJLsoBSQYifOuCyt1QjfC hQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 350rnb51up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 12:51:10 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHhIZj017735;
        Tue, 24 Nov 2020 17:51:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 34yy8r13uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 17:51:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOHp5YX6619710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:51:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0590FA4057;
        Tue, 24 Nov 2020 17:51:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD02BA406D;
        Tue, 24 Nov 2020 17:51:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 17:51:04 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v5 06/14] net/smc: Add diagnostic information to link structure
Date:   Tue, 24 Nov 2020 18:50:39 +0100
Message-Id: <20201124175047.56949-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201124175047.56949-1-kgraul@linux.ibm.com>
References: <20201124175047.56949-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_05:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

During link creation add net-device ifindex and ib-device
name to link structure. This is needed for diagnostic purposes.

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
 net/smc/smc_core.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 46087cec3bcd..0088511e30bf 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -313,6 +313,15 @@ static u8 smcr_next_link_id(struct smc_link_group *lgr)
 	return link_id;
 }
 
+static void smcr_copy_dev_info_to_link(struct smc_link *link)
+{
+	struct smc_ib_device *smcibdev = link->smcibdev;
+
+	snprintf(link->ibname, sizeof(link->ibname), "%s",
+		 smcibdev->ibdev->name);
+	link->ndev_ifidx = smcibdev->ndev_ifidx[link->ibport - 1];
+}
+
 int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 		   u8 link_idx, struct smc_init_info *ini)
 {
@@ -327,6 +336,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
 	smc_ibdev_cnt_inc(lnk);
+	smcr_copy_dev_info_to_link(lnk);
 	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
 	atomic_set(&lnk->conn_cnt, 0);
 	smc_llc_link_set_uid(lnk);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index eefb6770b268..3a1bb8e4b81f 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -124,6 +124,8 @@ struct smc_link {
 	u8			link_is_asym;	/* is link asymmetric? */
 	struct smc_link_group	*lgr;		/* parent link group */
 	struct work_struct	link_down_wrk;	/* wrk to bring link down */
+	char			ibname[IB_DEVICE_NAME_MAX]; /* ib device name */
+	int			ndev_ifidx; /* network device ifindex */
 
 	enum smc_link_state	state;		/* state of link */
 	struct delayed_work	llc_testlink_wrk; /* testlink worker */
-- 
2.17.1

