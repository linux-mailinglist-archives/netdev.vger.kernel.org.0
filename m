Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6A82BB936
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgKTWkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:40:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9368 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728952AbgKTWkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:22 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMZQeG152750
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jiH9pZ+TN7+My1CnU1xGTZUpA6oo/r6v7OTWqT0wyRQ=;
 b=RHSHINwVbsexFZbTcap5jZem0kGjSIpMGTD759Na+Og+PgbCWm5rEB5IM4iW+526YQ3j
 /0h1bPjH41TEOvyhTlfuDIOyQl31aTm+qSASfAHJwJt5yRpkGCuOhpjYHwWz1FZEAesE
 FAsvK3UXsj3QrUWDwcsecJETQljwBHaRzpT5lTUgQ8hbbgw/aYLMWXFlG0K+zhMiYPRf
 f6xFdtKxbaY9CcG+azpqTZcqWpjNH9y/grPREY18QJt82Q238iH1A6Nq4dGdMqDEf2Um
 NfLpCIVkhbsHvMQmAZ+zN1MkLUXwPL0VM92vLITXCCgimgCviF6oj6s5w7QLubeU/AWB lg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xdt082p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:20 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMbdXS019521
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:20 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 34w263h7vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:20 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMeI1l17433174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:18 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39DC96E053;
        Fri, 20 Nov 2020 22:40:18 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7669E6E052;
        Fri, 20 Nov 2020 22:40:17 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:17 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH net v2 3/3] ibmvnic: skip tx timeout reset while in resetting
Date:   Fri, 20 Nov 2020 16:40:13 -0600
Message-Id: <20201120224013.46891-4-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224013.46891-1-ljp@linux.ibm.com>
References: <20201120224013.46891-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0 suspectscore=1
 adultscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes it takes longer than 5 seconds (watchdog timeout) to complete
failover, migration, and other resets. In stead of scheduling another
timeout reset, we wait for the current one to complete.

Suggested-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: no change

 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9665532a9ed2..2aa40b2f225c 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2356,6 +2356,12 @@ static void ibmvnic_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(dev);
 
+	if (test_bit(0, &adapter->resetting)) {
+		netdev_err(adapter->netdev,
+			   "Adapter is resetting, skip timeout reset\n");
+		return;
+	}
+
 	ibmvnic_reset(adapter, VNIC_RESET_TIMEOUT);
 }
 
-- 
2.23.0

