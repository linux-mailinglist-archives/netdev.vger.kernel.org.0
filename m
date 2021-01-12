Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7E62F35A2
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406832AbhALQYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:24:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406223AbhALQYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:24:19 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CG5x7i108538;
        Tue, 12 Jan 2021 11:21:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=xJq3yq08V7yshNl1XkvYQh750dekA5DkqILLPZa6+Rk=;
 b=EbDjmzA6VypGd37UkZyPUtR8P0gP0i2TcxrK730rzWx9xO6B3WTpbDGPVtPFi2fpubRW
 xnwrAD0zApPbgqIFQnTftqdFGHF2IHyZw/pq7NSd0aJ0S5lJIlY7NJSp2n9RRbTcqd2d
 gQMXTsHwMh5MGbxvY3k5m8qjmjp8IfwxzlcgNe7B+j1gwjnHzCh3ragExdDArHMATb/d
 9ZKlOHqt/2Xvg/G247TlD3OAANrNsh6SKIGGAMuf0qZsrk84yvCXEmi7X+rsWvpGXA9R
 O6Q9R9NOVNCb0Y6WNub2bb21S9IIEhjomTfhPiGltQwtqDckL6dIGaOzI6XEBtJpW/vd Wg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361e7yswcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:21:34 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CGHgAq011880;
        Tue, 12 Jan 2021 16:21:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3604h999ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 16:21:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CGLSl336045282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 16:21:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF13BA4059;
        Tue, 12 Jan 2021 16:21:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B32AA404D;
        Tue, 12 Jan 2021 16:21:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 16:21:28 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net 2/2] net/smc: use memcpy instead of snprintf to avoid out of bounds read
Date:   Tue, 12 Jan 2021 17:21:22 +0100
Message-Id: <20210112162122.26832-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112162122.26832-1-kgraul@linux.ibm.com>
References: <20210112162122.26832-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_10:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Using snprintf() to convert not null-terminated strings to null
terminated strings may cause out of bounds read in the source string.
Therefore use memcpy() and terminate the target string with a null
afterwards.

Fixes: a3db10efcc4c ("net/smc: Add support for obtaining SMCR device list")
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 17 +++++++++++------
 net/smc/smc_ib.c   |  6 +++---
 net/smc/smc_ism.c  |  3 ++-
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 8d866b4ed8f6..0df85a12651e 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -258,7 +258,8 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
 		smc_ism_get_system_eid(smcd_dev, &seid);
 	mutex_unlock(&smcd_dev_list.mutex);
 	if (seid && smc_ism_is_v2_capable()) {
-		snprintf(smc_seid, sizeof(smc_seid), "%s", seid);
+		memcpy(smc_seid, seid, SMC_MAX_EID_LEN);
+		smc_seid[SMC_MAX_EID_LEN] = 0;
 		if (nla_put_string(skb, SMC_NLA_SYS_SEID, smc_seid))
 			goto errattr;
 	}
@@ -296,7 +297,8 @@ static int smc_nl_fill_lgr(struct smc_link_group *lgr,
 		goto errattr;
 	if (nla_put_u8(skb, SMC_NLA_LGR_R_VLAN_ID, lgr->vlan_id))
 		goto errattr;
-	snprintf(smc_target, sizeof(smc_target), "%s", lgr->pnet_id);
+	memcpy(smc_target, lgr->pnet_id, SMC_MAX_PNETID_LEN);
+	smc_target[SMC_MAX_PNETID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_LGR_R_PNETID, smc_target))
 		goto errattr;
 
@@ -313,7 +315,7 @@ static int smc_nl_fill_lgr_link(struct smc_link_group *lgr,
 				struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
-	char smc_ibname[IB_DEVICE_NAME_MAX + 1];
+	char smc_ibname[IB_DEVICE_NAME_MAX];
 	u8 smc_gid_target[41];
 	struct nlattr *attrs;
 	u32 link_uid = 0;
@@ -462,7 +464,8 @@ static int smc_nl_fill_smcd_lgr(struct smc_link_group *lgr,
 		goto errattr;
 	if (nla_put_u32(skb, SMC_NLA_LGR_D_CHID, smc_ism_get_chid(lgr->smcd)))
 		goto errattr;
-	snprintf(smc_pnet, sizeof(smc_pnet), "%s", lgr->smcd->pnetid);
+	memcpy(smc_pnet, lgr->smcd->pnetid, SMC_MAX_PNETID_LEN);
+	smc_pnet[SMC_MAX_PNETID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_LGR_D_PNETID, smc_pnet))
 		goto errattr;
 
@@ -475,10 +478,12 @@ static int smc_nl_fill_smcd_lgr(struct smc_link_group *lgr,
 		goto errv2attr;
 	if (nla_put_u8(skb, SMC_NLA_LGR_V2_OS, lgr->peer_os))
 		goto errv2attr;
-	snprintf(smc_host, sizeof(smc_host), "%s", lgr->peer_hostname);
+	memcpy(smc_host, lgr->peer_hostname, SMC_MAX_HOSTNAME_LEN);
+	smc_host[SMC_MAX_HOSTNAME_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_LGR_V2_PEER_HOST, smc_host))
 		goto errv2attr;
-	snprintf(smc_eid, sizeof(smc_eid), "%s", lgr->negotiated_eid);
+	memcpy(smc_eid, lgr->negotiated_eid, SMC_MAX_EID_LEN);
+	smc_eid[SMC_MAX_EID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_LGR_V2_NEG_EID, smc_eid))
 		goto errv2attr;
 
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index ddd7fac98b1d..7d7ba0320d5a 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -371,8 +371,8 @@ static int smc_nl_handle_dev_port(struct sk_buff *skb,
 	if (nla_put_u8(skb, SMC_NLA_DEV_PORT_PNET_USR,
 		       smcibdev->pnetid_by_user[port]))
 		goto errattr;
-	snprintf(smc_pnet, sizeof(smc_pnet), "%s",
-		 (char *)&smcibdev->pnetid[port]);
+	memcpy(smc_pnet, &smcibdev->pnetid[port], SMC_MAX_PNETID_LEN);
+	smc_pnet[SMC_MAX_PNETID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_DEV_PORT_PNETID, smc_pnet))
 		goto errattr;
 	if (nla_put_u32(skb, SMC_NLA_DEV_PORT_NETDEV,
@@ -414,7 +414,7 @@ static int smc_nl_handle_smcr_dev(struct smc_ib_device *smcibdev,
 				  struct sk_buff *skb,
 				  struct netlink_callback *cb)
 {
-	char smc_ibname[IB_DEVICE_NAME_MAX + 1];
+	char smc_ibname[IB_DEVICE_NAME_MAX];
 	struct smc_pci_dev smc_pci_dev;
 	struct pci_dev *pci_dev;
 	unsigned char is_crit;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 524ef64a191a..9c6e95882553 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -250,7 +250,8 @@ static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
 		goto errattr;
 	if (nla_put_u8(skb, SMC_NLA_DEV_PORT_PNET_USR, smcd->pnetid_by_user))
 		goto errportattr;
-	snprintf(smc_pnet, sizeof(smc_pnet), "%s", smcd->pnetid);
+	memcpy(smc_pnet, smcd->pnetid, SMC_MAX_PNETID_LEN);
+	smc_pnet[SMC_MAX_PNETID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_DEV_PORT_PNETID, smc_pnet))
 		goto errportattr;
 
-- 
2.17.1

