Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAEB1BFAD1
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgD3N4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23878 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728629AbgD3N4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:13 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDabrf140515;
        Thu, 30 Apr 2020 09:56:12 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhc3p0n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:11 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmPLG022997;
        Thu, 30 Apr 2020 13:56:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5tnvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDu6L365339600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:56:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE0C94C046;
        Thu, 30 Apr 2020 13:56:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93AF64C059;
        Thu, 30 Apr 2020 13:56:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:06 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 10/14] net/smc: new smc_rtoken_set functions for multiple link support
Date:   Thu, 30 Apr 2020 15:55:47 +0200
Message-Id: <20200430135551.26267-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004300106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce smc_rtoken_set() to set the rtoken for a new link to an
existing rmb whose rtoken is given, and smc_rtoken_set2() to set an
rtoken for a new link whose link_id is given.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_core.h |  4 ++++
 2 files changed, 51 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index f71a366ed6ac..096dce92ee2b 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1368,6 +1368,53 @@ static inline int smc_rmb_reserve_rtoken_idx(struct smc_link_group *lgr)
 	return -ENOSPC;
 }
 
+static int smc_rtoken_find_by_link(struct smc_link_group *lgr, int lnk_idx,
+				   u32 rkey)
+{
+	int i;
+
+	for (i = 0; i < SMC_RMBS_PER_LGR_MAX; i++) {
+		if (test_bit(i, lgr->rtokens_used_mask) &&
+		    lgr->rtokens[i][lnk_idx].rkey == rkey)
+			return i;
+	}
+	return -ENOENT;
+}
+
+/* set rtoken for a new link to an existing rmb */
+void smc_rtoken_set(struct smc_link_group *lgr, int link_idx, int link_idx_new,
+		    __be32 nw_rkey_known, __be64 nw_vaddr, __be32 nw_rkey)
+{
+	int rtok_idx;
+
+	rtok_idx = smc_rtoken_find_by_link(lgr, link_idx, ntohl(nw_rkey_known));
+	if (rtok_idx == -ENOENT)
+		return;
+	lgr->rtokens[rtok_idx][link_idx_new].rkey = ntohl(nw_rkey);
+	lgr->rtokens[rtok_idx][link_idx_new].dma_addr = be64_to_cpu(nw_vaddr);
+}
+
+/* set rtoken for a new link whose link_id is given */
+void smc_rtoken_set2(struct smc_link_group *lgr, int rtok_idx, int link_id,
+		     __be64 nw_vaddr, __be32 nw_rkey)
+{
+	u64 dma_addr = be64_to_cpu(nw_vaddr);
+	u32 rkey = ntohl(nw_rkey);
+	bool found = false;
+	int link_idx;
+
+	for (link_idx = 0; link_idx < SMC_LINKS_PER_LGR_MAX; link_idx++) {
+		if (lgr->lnk[link_idx].link_id == link_id) {
+			found = true;
+			break;
+		}
+	}
+	if (!found)
+		return;
+	lgr->rtokens[rtok_idx][link_idx].rkey = rkey;
+	lgr->rtokens[rtok_idx][link_idx].dma_addr = dma_addr;
+}
+
 /* add a new rtoken from peer */
 int smc_rtoken_add(struct smc_link *lnk, __be64 nw_vaddr, __be32 nw_rkey)
 {
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 364a54e28d61..0be26386057f 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -352,6 +352,10 @@ int smc_rmb_rtoken_handling(struct smc_connection *conn, struct smc_link *link,
 			    struct smc_clc_msg_accept_confirm *clc);
 int smc_rtoken_add(struct smc_link *lnk, __be64 nw_vaddr, __be32 nw_rkey);
 int smc_rtoken_delete(struct smc_link *lnk, __be32 nw_rkey);
+void smc_rtoken_set(struct smc_link_group *lgr, int link_idx, int link_idx_new,
+		    __be32 nw_rkey_known, __be64 nw_vaddr, __be32 nw_rkey);
+void smc_rtoken_set2(struct smc_link_group *lgr, int rtok_idx, int link_id,
+		     __be64 nw_vaddr, __be32 nw_rkey);
 void smc_sndbuf_sync_sg_for_cpu(struct smc_connection *conn);
 void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn);
 void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn);
-- 
2.17.1

