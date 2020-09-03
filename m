Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D883325C9BD
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgICTxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:53:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729159AbgICTxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:53:39 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083JWR8F003091;
        Thu, 3 Sep 2020 15:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=aEPraWf6PSv9FYGUMmqWPrpVrMFynOfx3y12znjs/kM=;
 b=cAqnfvsAI4uTTlHrMwmJn6MaMm1E6srinYlIl61UKfniYTWT7B0v5Zt3k9bGSWAcnuH3
 yIqwNgCklewQARt3+5UuuZKhUnaSCN5Jfp27RZ800Bz2rPtRbsMHg0b2QA4BpGSWvtQy
 21ENWLlYqgMwPewNhobyqC3Bdq7BsjFXkeNcu4gBhWR1goRR+A1ZvjJRyyrRVNy6tBqi
 cAslnygeBfTMNVPrCjqbZVsS1RCwvICvdYqlXdwNt0OCrUtVD4IyGCFHZfq1oGTQfrv6
 TxIk/d2QTqZYR8aZ0DBR0cQyNLmuzv7/owNEFM9Q3ZBlaIIZaS5W0Yvn171yQVzPuo7B kw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33b68n14un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 15:53:37 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 083JqdrZ001306;
        Thu, 3 Sep 2020 19:53:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 337en7ksj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 19:53:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 083JrWw928639632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 19:53:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 005B611C050;
        Thu,  3 Sep 2020 19:53:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC19711C052;
        Thu,  3 Sep 2020 19:53:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 19:53:31 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 1/4] net/smc: fix toleration of fake add_link messages
Date:   Thu,  3 Sep 2020 21:53:15 +0200
Message-Id: <20200903195318.39288-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903195318.39288-1-kgraul@linux.ibm.com>
References: <20200903195318.39288-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_13:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 mlxscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Older SMCR implementations had no link failover support and used one
link only. Because the handshake protocol requires to try the
establishment of a second link the old code sent a fake add_link message
and declined any server response afterwards.
The current code supports multiple links and inspects the received fake
add_link message more closely. To tolerate the fake add_link messages
smc_llc_is_local_add_link() needs an improved check of the message to
be able to separate between locally enqueued and fake add_link messages.
And smc_llc_cli_add_link() needs to check if the provided qp_mtu size is
invalid and reject the add_link request in that case.

Fixes: c48254fa48e5 ("net/smc: move add link processing for new device into llc layer")
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_llc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index df5b0a6ea848..3ea33466ebe9 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -841,6 +841,9 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	struct smc_init_info ini;
 	int lnk_idx, rc = 0;
 
+	if (!llc->qp_mtu)
+		goto out_reject;
+
 	ini.vlan_id = lgr->vlan_id;
 	smc_pnet_find_alt_roce(lgr, &ini, link->smcibdev);
 	if (!memcmp(llc->sender_gid, link->peer_gid, SMC_GID_SIZE) &&
@@ -917,10 +920,20 @@ static void smc_llc_cli_add_link_invite(struct smc_link *link,
 	kfree(qentry);
 }
 
+static bool smc_llc_is_empty_llc_message(union smc_llc_msg *llc)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(llc->raw.data); i++)
+		if (llc->raw.data[i])
+			return false;
+	return true;
+}
+
 static bool smc_llc_is_local_add_link(union smc_llc_msg *llc)
 {
 	if (llc->raw.hdr.common.type == SMC_LLC_ADD_LINK &&
-	    !llc->add_link.qp_mtu && !llc->add_link.link_num)
+	    smc_llc_is_empty_llc_message(llc))
 		return true;
 	return false;
 }
-- 
2.17.1

