Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA2142DFA0
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhJNQvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:51:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58066 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233202AbhJNQuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:50:52 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EGKTG2023148;
        Thu, 14 Oct 2021 12:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ajtnnQPYsZIaOVWtFcDlVc5hApbamOHVoABLoj+q3Eo=;
 b=Iejkr3WYenq9L+eVGfLKphpluOo2mmMSiD57cTgEtdWffaIXZ9+Lo20SsF9KoIqhbjF8
 vSZH+gia/hQkfL6uW2mxcKW2OQi8GSxM3vw5chRdNhtuKYk9f7Q6vZM7Wj9r/hQc1kOg
 fBu4IXLkCmdvlY6X/LM3mDl3E5334LnTKyUChtglI+r3OtO7yeBqHLnaAGTAccwarBI2
 zfFoKu0v7Pdp8i58Q6M9tl/pirCewlpvOn6yt6TkWnvPQ5tQFWQ3aNgzdjY9LSfZl1BK
 hOmqYl0IJpKAWKUbAoUgbQQAW4KmemjMdJK6X0WAhs2ztTPv6z/k2lWcP1lFMMfLE91C NQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnmnaq3b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 12:48:45 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EGbpBK017340;
        Thu, 14 Oct 2021 16:48:42 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3bk2qamht8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 16:48:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19EGgxdc36831612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 16:42:59 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 314DDA4060;
        Thu, 14 Oct 2021 16:48:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEBF8A4068;
        Thu, 14 Oct 2021 16:48:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 16:48:39 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v2 11/11] net/smc: stop links when their GID is removed
Date:   Thu, 14 Oct 2021 18:47:52 +0200
Message-Id: <20211014164752.3647027-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211014164752.3647027-1-kgraul@linux.ibm.com>
References: <20211014164752.3647027-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P-HgIAu99XjESI6XjdoFkTc-8wReuf1U
X-Proofpoint-ORIG-GUID: P-HgIAu99XjESI6XjdoFkTc-8wReuf1U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_09,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With SMC-Rv2 the GID is an IP address that can be deleted from the
device. When an IB_EVENT_GID_CHANGE event is provided then iterate over
all active links and check if their GID is still defined. Otherwise
stop the affected link.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_ib.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 32f9d2fdc474..d93055ec17ae 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -295,6 +295,58 @@ int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
 	return -ENODEV;
 }
 
+/* check if gid is still defined on smcibdev */
+static bool smc_ib_check_link_gid(u8 gid[SMC_GID_SIZE], bool smcrv2,
+				  struct smc_ib_device *smcibdev, u8 ibport)
+{
+	const struct ib_gid_attr *attr;
+	bool rc = false;
+	int i;
+
+	for (i = 0; !rc && i < smcibdev->pattr[ibport - 1].gid_tbl_len; i++) {
+		attr = rdma_get_gid_attr(smcibdev->ibdev, ibport, i);
+		if (IS_ERR(attr))
+			continue;
+
+		rcu_read_lock();
+		if ((!smcrv2 && attr->gid_type == IB_GID_TYPE_ROCE) ||
+		    (smcrv2 && attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP &&
+		     !(ipv6_addr_type((const struct in6_addr *)&attr->gid)
+				     & IPV6_ADDR_LINKLOCAL)))
+			if (!memcmp(gid, &attr->gid, SMC_GID_SIZE))
+				rc = true;
+		rcu_read_unlock();
+		rdma_put_gid_attr(attr);
+	}
+	return rc;
+}
+
+/* check all links if the gid is still defined on smcibdev */
+static void smc_ib_gid_check(struct smc_ib_device *smcibdev, u8 ibport)
+{
+	struct smc_link_group *lgr;
+	int i;
+
+	spin_lock_bh(&smc_lgr_list.lock);
+	list_for_each_entry(lgr, &smc_lgr_list.list, list) {
+		if (strncmp(smcibdev->pnetid[ibport - 1], lgr->pnet_id,
+			    SMC_MAX_PNETID_LEN))
+			continue; /* lgr is not affected */
+		if (list_empty(&lgr->list))
+			continue;
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			if (lgr->lnk[i].state == SMC_LNK_UNUSED ||
+			    lgr->lnk[i].smcibdev != smcibdev)
+				continue;
+			if (!smc_ib_check_link_gid(lgr->lnk[i].gid,
+						   lgr->smc_version == SMC_V2,
+						   smcibdev, ibport))
+				smcr_port_err(smcibdev, ibport);
+		}
+	}
+	spin_unlock_bh(&smc_lgr_list.lock);
+}
+
 static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport)
 {
 	int rc;
@@ -333,6 +385,7 @@ static void smc_ib_port_event_work(struct work_struct *work)
 		} else {
 			clear_bit(port_idx, smcibdev->ports_going_away);
 			smcr_port_add(smcibdev, port_idx + 1);
+			smc_ib_gid_check(smcibdev, port_idx + 1);
 		}
 	}
 }
-- 
2.25.1

