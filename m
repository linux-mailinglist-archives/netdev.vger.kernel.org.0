Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9CF2CABBA
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404311AbgLATVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:21:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731264AbgLATVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:21:46 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1J21Gd176638;
        Tue, 1 Dec 2020 14:21:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=cUk5H2qIc04kVUWwCZGHsg5RNXN2nEW9VVGwx3aPDic=;
 b=XAmvHmruoX/8wNlGUawYmWb/yvR1luJDvNuW5GaI/yzdEN5wvIzOVI+CLHilQifvPRbA
 BnKhFUSiGBiBEaODPXKdnpSKsnrBPYHUyb+WRF1uC00d5hPiNefnXHkCni6BGBjqHRNn
 yeW4ktiEyGCBlFZ5w5JbBxrBnr0eJDnbsuMztTs6Swee7cUgf3LhoZ8tARPTcbWnq2b7
 8qoCjyqnFdEWeZ1ml8XNMyj5ZCsbLLvQupKCpwlghfkx8oUIPkP0nPFlbrOfUPrr2ios
 9qN8cUzshxJYY8TiHVLR2NjtXyJ8BPlSA00ooTTo2Lt3BWEs3CPPq07PrL6drOq9OVZ9 gg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 355k52jwhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 14:21:02 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JHp4S017909;
        Tue, 1 Dec 2020 19:21:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 353e683etv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:21:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1JKvOu60424536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 19:20:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46928AE055;
        Tue,  1 Dec 2020 19:20:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C336AE053;
        Tue,  1 Dec 2020 19:20:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v7 06/14] net/smc: Add diagnostic information to link structure
Date:   Tue,  1 Dec 2020 20:20:41 +0100
Message-Id: <20201201192049.53517-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201192049.53517-1-kgraul@linux.ibm.com>
References: <20201201192049.53517-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012010112
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

