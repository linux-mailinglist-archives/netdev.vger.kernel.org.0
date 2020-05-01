Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF14F1C111E
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgEAKsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3574 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728642AbgEAKse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:34 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AXZFF177405;
        Fri, 1 May 2020 06:48:31 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30r825p2s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:31 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041Ak7sC028261;
        Fri, 1 May 2020 10:48:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 30mcu5bfbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AmQYT58851476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:48:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17AEBA4054;
        Fri,  1 May 2020 10:48:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D047BA4064;
        Fri,  1 May 2020 10:48:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:25 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 12/13] net/smc: allocate index for a new link
Date:   Fri,  1 May 2020 12:48:12 +0200
Message-Id: <20200501104813.76601-13-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_03:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add smc_llc_alloc_alt_link() to find a free link index for a new link,
depending on the new link group type. And update constants for the
maximum number of links to 3 (2 symmetric and 1 dangling asymmetric link).
These maximum numbers are the same as used by other implementations of the
SMC-R protocol.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.h |  2 +-
 net/smc/smc_llc.c  | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index da3cddbd1651..eb27f2eb7c8c 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -128,7 +128,7 @@ struct smc_link {
 /* For now we just allow one parallel link per link group. The SMC protocol
  * allows more (up to 8).
  */
-#define SMC_LINKS_PER_LGR_MAX	1
+#define SMC_LINKS_PER_LGR_MAX	3
 #define SMC_SINGLE_LINK		0
 
 #define SMC_FIRST_CONTACT	1		/* first contact to a peer */
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index e478a4c11877..3a25b6ebe3a8 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -541,6 +541,30 @@ static int smc_llc_send_message(struct smc_link *link, void *llcbuf)
 
 /********************************* receive ***********************************/
 
+static int smc_llc_alloc_alt_link(struct smc_link_group *lgr,
+				  enum smc_lgr_type lgr_new_t)
+{
+	int i;
+
+	if (lgr->type == SMC_LGR_SYMMETRIC ||
+	    (lgr->type != SMC_LGR_SINGLE &&
+	     (lgr_new_t == SMC_LGR_ASYMMETRIC_LOCAL ||
+	      lgr_new_t == SMC_LGR_ASYMMETRIC_PEER)))
+		return -EMLINK;
+
+	if (lgr_new_t == SMC_LGR_ASYMMETRIC_LOCAL ||
+	    lgr_new_t == SMC_LGR_ASYMMETRIC_PEER) {
+		for (i = SMC_LINKS_PER_LGR_MAX - 1; i >= 0; i--)
+			if (lgr->lnk[i].state == SMC_LNK_UNUSED)
+				return i;
+	} else {
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++)
+			if (lgr->lnk[i].state == SMC_LNK_UNUSED)
+				return i;
+	}
+	return -EMLINK;
+}
+
 static void smc_llc_rx_delete_link(struct smc_link *link,
 				   struct smc_llc_msg_del_link *llc)
 {
-- 
2.17.1

