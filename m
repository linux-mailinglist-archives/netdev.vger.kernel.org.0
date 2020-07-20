Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A052261F1
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgGTOZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:25:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726381AbgGTOZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 10:25:01 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KE34fi154157;
        Mon, 20 Jul 2020 10:25:01 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d5x3wrf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 10:25:00 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KEOsNH005837;
        Mon, 20 Jul 2020 14:24:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 32dbmn01hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 14:24:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KEOt0i30212488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 14:24:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79368AE04D;
        Mon, 20 Jul 2020 14:24:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B6A7AE056;
        Mon, 20 Jul 2020 14:24:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jul 2020 14:24:55 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 2/2] net/smc: fix dmb buffer shortage
Date:   Mon, 20 Jul 2020 16:24:29 +0200
Message-Id: <20200720142429.17916-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200720142429.17916-1-kgraul@linux.ibm.com>
References: <20200720142429.17916-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a current limit of 1920 registered dmb buffers per ISM device
for smc-d. One link group can contain 255 connections, each connection
is using one dmb buffer. When the connection is closed then the
registered buffer is held in a queue and is reused by the next
connection. When a link group is 'full' then another link group is
created and uses an own buffer pool. The link groups are added to a
list using list_add() which puts a new link group to the first position
in the list.
In the situation that many connections are opened (>1920) and a few of
them stay open while others are closed quickly we end up with at least 8
link groups. For a new connection a matching link group is looked up,
iterating over the list of link groups. The trailing 7 link groups
all have registered dmb buffers which could be reused, while the first
link group has only a few dmb buffers and then hit the 1920 limit.
Because the first link group is not full (255 connection limit not
reached) it is chosen and finally the connection falls back to TCP
because there is no dmb buffer available in this link group.
There are multiple ways to fix that: using list_add_tail() allows
to scan older link groups first for free buffers which ensures that
buffers are reused first. This fixes the problem for smc-r link groups
as well. For smc-d there is an even better way to address this problem
because smc-d does not have the 255 connections per link group limit.
So fix the problem for smc-d by allowing large link groups.

Fixes: c6ba7c9ba43d ("net/smc: add base infrastructure for SMC-D and ISM")
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index ca3dc6af73af..f82a2e599917 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -444,7 +444,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	}
 	smc->conn.lgr = lgr;
 	spin_lock_bh(lgr_lock);
-	list_add(&lgr->list, lgr_list);
+	list_add_tail(&lgr->list, lgr_list);
 	spin_unlock_bh(lgr_lock);
 	return 0;
 
@@ -1311,7 +1311,7 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		     smcr_lgr_match(lgr, ini->ib_lcl, role, ini->ib_clcqpn)) &&
 		    !lgr->sync_err &&
 		    lgr->vlan_id == ini->vlan_id &&
-		    (role == SMC_CLNT ||
+		    (role == SMC_CLNT || ini->is_smcd ||
 		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
 			/* link group found */
 			ini->cln_first_contact = SMC_REUSE_CONTACT;
-- 
2.17.1

