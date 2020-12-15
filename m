Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B232DA9D5
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 10:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgLOJMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 04:12:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29070 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727985AbgLOJMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 04:12:01 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BF90lIL053046;
        Tue, 15 Dec 2020 04:11:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=jiZO/kA77AjrYZKg2UlzH+l8bNrELwdy7Zcqs3bEXzU=;
 b=UV8iQg9PELemCHfLGbdCQp6Pdm16uWO2HdJJP6bLXFLsu+gFSlpNPF3N0eyzZ8rKQQnx
 aG5VXuE5faBf2/5g5vL9sFFMFo6ZHt3FBEmHxNxcnVK87WyZJ4jr17bAuk4LTs9dSwtP
 GkOxUb7HzYLd5nNbtYH9rNTVIcCmg/YDHL5hd+SUreBk8DpCpfTLCvh1f8h1a7ZHuXrE
 ax4LGw759LkZCqK6/PZF2SkGErEZV0tW7W/wgOT3/5UIIc0j5tAj8pulJB6iugaN+2S4
 qSyZIMXCQdtaOPOILqqRylfOifAL3MvVoAucGzfYhc7VauawevHUvDQju3+R7+dl3+qX ZA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ernwk1ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 04:11:14 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BF987A9029760;
        Tue, 15 Dec 2020 09:11:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 35cn4hb34j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 09:11:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BF9B9ls28442988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 09:11:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97EF65204E;
        Tue, 15 Dec 2020 09:11:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5848652059;
        Tue, 15 Dec 2020 09:11:09 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next 1/1] net/smc: fix access to parent of an ib device
Date:   Tue, 15 Dec 2020 10:10:58 +0100
Message-Id: <20201215091058.49354-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215091058.49354-1-kgraul@linux.ibm.com>
References: <20201215091058.49354-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_04:2020-12-11,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parent of an ib device is used to retrieve the PCI device
attributes. It turns out that there are possible cases when an ib device
has no parent set in the device structure, which may lead to page
faults when trying to access this memory.
Fix that by checking the parent pointer and consolidate the pci device
specific processing in a new function.

Fixes: a3db10efcc4c ("net/smc: Add support for obtaining SMCR device list")
Reported-by: syzbot+600fef7c414ee7e2d71b@syzkaller.appspotmail.com
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_ib.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 89ea10675a7d..ddd7fac98b1d 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -394,6 +394,22 @@ static int smc_nl_handle_dev_port(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static bool smc_nl_handle_pci_values(const struct smc_pci_dev *smc_pci_dev,
+				     struct sk_buff *skb)
+{
+	if (nla_put_u32(skb, SMC_NLA_DEV_PCI_FID, smc_pci_dev->pci_fid))
+		return false;
+	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_CHID, smc_pci_dev->pci_pchid))
+		return false;
+	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_VENDOR, smc_pci_dev->pci_vendor))
+		return false;
+	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_DEVICE, smc_pci_dev->pci_device))
+		return false;
+	if (nla_put_string(skb, SMC_NLA_DEV_PCI_ID, smc_pci_dev->pci_id))
+		return false;
+	return true;
+}
+
 static int smc_nl_handle_smcr_dev(struct smc_ib_device *smcibdev,
 				  struct sk_buff *skb,
 				  struct netlink_callback *cb)
@@ -417,19 +433,13 @@ static int smc_nl_handle_smcr_dev(struct smc_ib_device *smcibdev,
 	is_crit = smcr_diag_is_dev_critical(&smc_lgr_list, smcibdev);
 	if (nla_put_u8(skb, SMC_NLA_DEV_IS_CRIT, is_crit))
 		goto errattr;
-	memset(&smc_pci_dev, 0, sizeof(smc_pci_dev));
-	pci_dev = to_pci_dev(smcibdev->ibdev->dev.parent);
-	smc_set_pci_values(pci_dev, &smc_pci_dev);
-	if (nla_put_u32(skb, SMC_NLA_DEV_PCI_FID, smc_pci_dev.pci_fid))
-		goto errattr;
-	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_CHID, smc_pci_dev.pci_pchid))
-		goto errattr;
-	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_VENDOR, smc_pci_dev.pci_vendor))
-		goto errattr;
-	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_DEVICE, smc_pci_dev.pci_device))
-		goto errattr;
-	if (nla_put_string(skb, SMC_NLA_DEV_PCI_ID, smc_pci_dev.pci_id))
-		goto errattr;
+	if (smcibdev->ibdev->dev.parent) {
+		memset(&smc_pci_dev, 0, sizeof(smc_pci_dev));
+		pci_dev = to_pci_dev(smcibdev->ibdev->dev.parent);
+		smc_set_pci_values(pci_dev, &smc_pci_dev);
+		if (!smc_nl_handle_pci_values(&smc_pci_dev, skb))
+			goto errattr;
+	}
 	snprintf(smc_ibname, sizeof(smc_ibname), "%s", smcibdev->ibdev->name);
 	if (nla_put_string(skb, SMC_NLA_DEV_IB_NAME, smc_ibname))
 		goto errattr;
-- 
2.17.1

