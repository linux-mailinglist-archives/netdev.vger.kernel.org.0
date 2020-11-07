Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9380F2AA52D
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgKGNAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:00:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64192 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727863AbgKGNAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:00:18 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CWNmP167110;
        Sat, 7 Nov 2020 08:00:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=MSc8z+WqhyinuhVNpHBi7NK/hKxfO/YH9TPNd9lgEIA=;
 b=Xieieob0UsBF7wcTZvJb6W5BnIMCnVHdL05xyFIw5++wkSgpGe1Vxyy/584S4pKameB+
 t0/13yFxD75PY8SVnYo3lhymbV2gWDqsNNCoU/QERBWyX5Ql9JUcBC+UzIPnn/nYG9Y1
 OtHC8Nd06B3akvF1p99OnIRevkJ5rSpOWPUS33tC9FncyivmGpA1LHymKQNFeD/jorhA
 cilOjMxMVsy1U+iAlUnpU7oPxG02olgsBr7TpepIIP/vPbLolI+vGt/IMaGQGIni3D4q
 y7Op6uCl7+1yqA2dVNdkoajrxQrjX3XD+yEY2UYTtJqgMa5sXxQuyg0+jmb7t1OTH1fH YQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34nrb3cjpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 08:00:15 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CwCki024939;
        Sat, 7 Nov 2020 13:00:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 34nk7805c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 13:00:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A7D0AMt46465518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 7 Nov 2020 13:00:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FBC2A4072;
        Sat,  7 Nov 2020 13:00:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 261B1A4040;
        Sat,  7 Nov 2020 13:00:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  7 Nov 2020 13:00:09 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v3 06/15] net/smc: Add diagnostic information to link structure
Date:   Sat,  7 Nov 2020 13:59:49 +0100
Message-Id: <20201107125958.16384-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107125958.16384-1-kgraul@linux.ibm.com>
References: <20201107125958.16384-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-07_07:2020-11-05,2020-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 mlxlogscore=-1000
 malwarescore=0 mlxscore=100 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 phishscore=0
 spamscore=100 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011070081
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
 net/smc/smc_core.c | 11 +++++++++++
 net/smc/smc_core.h |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index e5996cf5dd3d..ef0aae43a209 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -303,6 +303,16 @@ static u8 smcr_next_link_id(struct smc_link_group *lgr)
 	return link_id;
 }
 
+static inline void smcr_copy_dev_info_to_link(struct smc_link *link)
+{
+	struct smc_ib_device *smcibdev = link->smcibdev;
+
+	snprintf(link->ibname, sizeof(link->ibname), "%s",
+		 smcibdev->ibdev->name);
+	snprintf(link->ndevname, sizeof(link->ndevname), "%s",
+		 smcibdev->netdev[link->ibport - 1]);
+}
+
 int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 		   u8 link_idx, struct smc_init_info *ini)
 {
@@ -317,6 +327,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
 	smc_ibdev_cnt_inc(lnk);
+	smcr_copy_dev_info_to_link(lnk);
 	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
 	atomic_set(&lnk->conn_cnt, 0);
 	smc_llc_link_set_uid(lnk);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 4cf8e811940d..a6ba9cc8c60e 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -124,6 +124,9 @@ struct smc_link {
 	u8			link_is_asym;	/* is link asymmetric? */
 	struct smc_link_group	*lgr;		/* parent link group */
 	struct work_struct	link_down_wrk;	/* wrk to bring link down */
+	/* Diagnostic relevant link information */
+	char			ibname[IB_DEVICE_NAME_MAX];/* ib device name */
+	char			ndevname[IFNAMSIZ];/* network device name */
 
 	enum smc_link_state	state;		/* state of link */
 	struct delayed_work	llc_testlink_wrk; /* testlink worker */
-- 
2.17.1

