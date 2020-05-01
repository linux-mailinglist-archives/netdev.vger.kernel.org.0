Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE7E1C112A
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgEAKsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728268AbgEAKsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:30 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AXWtR177203;
        Fri, 1 May 2020 06:48:28 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30r825p2qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:27 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041Ak31b014464;
        Fri, 1 May 2020 10:48:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 30mcu7ydks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AmNXG64094710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:48:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B8CEA4054;
        Fri,  1 May 2020 10:48:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FA63A405F;
        Fri,  1 May 2020 10:48:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:22 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 03/13] net/smc: map and register buffers for a new link
Date:   Fri,  1 May 2020 12:48:03 +0200
Message-Id: <20200501104813.76601-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_03:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce support to map and register all current buffers for a new
link. smcr_buf_map_lgr() will map used buffers for a new link and
smcr_buf_reg_lgr() can be called to register used buffers on the
IB device of the new link.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_core.h |  2 ++
 2 files changed, 62 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index d5ecea490b4e..0e87f652caea 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1185,6 +1185,66 @@ int smcr_link_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc)
 	return 0;
 }
 
+static int _smcr_buf_map_lgr(struct smc_link *lnk, struct mutex *lock,
+			     struct list_head *lst, bool is_rmb)
+{
+	struct smc_buf_desc *buf_desc, *bf;
+	int rc = 0;
+
+	mutex_lock(lock);
+	list_for_each_entry_safe(buf_desc, bf, lst, list) {
+		if (!buf_desc->used)
+			continue;
+		rc = smcr_buf_map_link(buf_desc, is_rmb, lnk);
+		if (rc)
+			goto out;
+	}
+out:
+	mutex_unlock(lock);
+	return rc;
+}
+
+/* map all used buffers of lgr for a new link */
+int smcr_buf_map_lgr(struct smc_link *lnk)
+{
+	struct smc_link_group *lgr = lnk->lgr;
+	int i, rc = 0;
+
+	for (i = 0; i < SMC_RMBE_SIZES; i++) {
+		rc = _smcr_buf_map_lgr(lnk, &lgr->rmbs_lock,
+				       &lgr->rmbs[i], true);
+		if (rc)
+			return rc;
+		rc = _smcr_buf_map_lgr(lnk, &lgr->sndbufs_lock,
+				       &lgr->sndbufs[i], false);
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
+/* register all used buffers of lgr for a new link */
+int smcr_buf_reg_lgr(struct smc_link *lnk)
+{
+	struct smc_link_group *lgr = lnk->lgr;
+	struct smc_buf_desc *buf_desc, *bf;
+	int i, rc = 0;
+
+	mutex_lock(&lgr->rmbs_lock);
+	for (i = 0; i < SMC_RMBE_SIZES; i++) {
+		list_for_each_entry_safe(buf_desc, bf, &lgr->rmbs[i], list) {
+			if (!buf_desc->used)
+				continue;
+			rc = smcr_link_reg_rmb(lnk, buf_desc);
+			if (rc)
+				goto out;
+		}
+	}
+out:
+	mutex_unlock(&lgr->rmbs_lock);
+	return rc;
+}
+
 static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 						bool is_rmb, int bufsize)
 {
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index fa532a423fd7..61ddb5264936 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -368,6 +368,8 @@ int smc_core_init(void);
 void smc_core_exit(void);
 
 void smcr_link_clear(struct smc_link *lnk);
+int smcr_buf_map_lgr(struct smc_link *lnk);
+int smcr_buf_reg_lgr(struct smc_link *lnk);
 int smcr_link_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc);
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
 {
-- 
2.17.1

