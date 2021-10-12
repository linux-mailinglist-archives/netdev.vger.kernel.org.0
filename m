Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BBC42A1DC
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbhJLKUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:20:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235909AbhJLKUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 06:20:34 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C9C6o1007781;
        Tue, 12 Oct 2021 06:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ajtnnQPYsZIaOVWtFcDlVc5hApbamOHVoABLoj+q3Eo=;
 b=oLpCzYXgSyeq01RoGl9oIvi1UjIKNE2SKwCpjdvIIkcGgBqgJYAgHz7kBnX3hQGlt3En
 S2E6/DWWiF8up3HVJP5gyfJIGxhPXmpA6sDtQ1JcvbuMVKJqRHeOCdBPNiN6xNzfFTem
 pnnygDyp6zYJyS9e4c8DxWzSUpQRL0qZyjWKTwrP/v8FdgmMdSLR48Fow+7nLj9sBb1v
 GhXUlBnX0ir09ahbIRP8106rtVHj18CWmzFNel12hEcnmKr2MGtvuf0mlQ2I75NXijCW
 dktwO7JGY8fILwOhW3gVw83hET+QbgORfA89pI6zO3kLuzEsO0TBQBhPknQgT8bT38K4 YQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn7h09a7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 06:18:32 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CABPGf011129;
        Tue, 12 Oct 2021 10:18:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3bk2q9nbv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 10:18:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CAIOGU5243450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 10:18:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6EE9AE05F;
        Tue, 12 Oct 2021 10:18:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB0ACAE06F;
        Tue, 12 Oct 2021 10:18:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 10:18:22 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH net-next 11/11] net/smc: stop links when their GID is removed
Date:   Tue, 12 Oct 2021 12:17:43 +0200
Message-Id: <20211012101743.2282031-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012101743.2282031-1-kgraul@linux.ibm.com>
References: <20211012101743.2282031-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4w2ehPxNdhnOh-8_e5B_GUhv4cXqJF39
X-Proofpoint-GUID: 4w2ehPxNdhnOh-8_e5B_GUhv4cXqJF39
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_02,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 spamscore=0
 mlxscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110120058
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

