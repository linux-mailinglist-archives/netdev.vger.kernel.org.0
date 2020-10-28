Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF45929D7BE
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733092AbgJ1W0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:26:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732936AbgJ1W0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:26:34 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09S5XCN6052786
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 01:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5X35NlJ0mSSH6qBxTc1xRyKx4uF7Be2xxC04lEVCXp4=;
 b=WVT5Cc32yynXzapYP1092c5KLjL+6EaIv+zSQ/kvOUACXVg1KtMN2yCYx/EXRGlTryMX
 63Jc+YxB5XjpzUDdHNfovVfvC82eVJyLsmLOYpKibgETusbH2KhKpiv+/Az8KjeH2bN1
 bwP23ajTE5H6taawFZDuktD2an0aUfZh7nNgB+0FYGA1u7dRQ2OX8j/v65LJ7y7mdNw0
 XSg6eqsYYv7qskx0TjdZoqoSB7Jg/5Za2AN7Bpl7YCvKIhw2O/b2FP/Emi4TPUfmcvW7
 wyNQ72+kYW5r4cre7ECAHJ1NT5LjeDQixaZkq+T4N/PRFZRH+sp9wICKXlGnf/EhinEn zQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ec5uss63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 01:57:46 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09S5rS9l000387
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 05:57:46 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 34dy045q71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 05:57:46 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09S5vjRX47907324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 05:57:45 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13C1113605D;
        Wed, 28 Oct 2020 05:57:45 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79B0F136055;
        Wed, 28 Oct 2020 05:57:44 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.105])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 28 Oct 2020 05:57:44 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH net 2/2] ibmvnic: skip tx timeout reset while in resetting
Date:   Wed, 28 Oct 2020 00:57:42 -0500
Message-Id: <20201028055742.74941-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201028055742.74941-1-ljp@linux.ibm.com>
References: <20201028055742.74941-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_01:2020-10-26,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010280031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes it takes longer than 5 seconds to complete failover,
migration, and other resets. In stead of scheduling another timeout reset,
we wait for the current one to complete.

Suggested-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 718da39f5ae4..eb0eb1e8ac22 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2336,6 +2336,12 @@ static void ibmvnic_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(dev);
 
+	if (test_bit(0, &adapter->resetting)) {
+		netdev_err(adapter->netdev,
+			   "adapter is resetting, skip timeout reset\n");
+		return;
+	}
+
 	ibmvnic_reset(adapter, VNIC_RESET_TIMEOUT);
 }
 
-- 
2.23.0

