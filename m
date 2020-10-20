Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD92294570
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 01:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439286AbgJTX2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 19:28:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439280AbgJTX2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 19:28:17 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09KN1wn7115604;
        Tue, 20 Oct 2020 19:28:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=NntWf61g3hFvgkCTEYMzGCe0Nf3xMeRe0sQ235Osong=;
 b=O6EToVob4ZLP1Juk8YrSP+mHlufKx1XZEH9b4wwtIAzvi2FLQa0ixk82AI65NaZqFWHG
 YBOoCZOKJc0dyDLWScbN3MrP1cphcJmi4npBxhQLKzWYs4bj7GxSrtzJ7KCtstrQteiM
 xqfTCsAPJBO+5JcGTYTTp9aON6oQkudY9Ph0ZQoH9zwHmoGWW03CbMsszumrkO2lhWsX
 G3FUb3N9yH94xxZtdBsKpV7OrTYH4ajYveO3v73ElV9xwICwIQSkRSjk5SNwx6Dtk0Av
 3lsopA6a6qfxFWLR2lSepUsqSFaDXLJBDx0kyvPgTqnNPs5+toWidnWwluIFIpdebo2V aw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34a7eek7xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 19:28:14 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09KNRwc6004147;
        Tue, 20 Oct 2020 23:28:13 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 347r89ankg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 23:28:13 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09KNSDov38011200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 23:28:13 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 184E82805E;
        Tue, 20 Oct 2020 23:28:13 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC2262805C;
        Tue, 20 Oct 2020 23:28:12 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.179.149])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 20 Oct 2020 23:28:12 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] ibmvnic: no need to update adapter->mac_addr before it completes
Date:   Tue, 20 Oct 2020 18:28:12 -0500
Message-Id: <20201020232812.46498-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-20_13:2020-10-20,2020-10-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=923 priorityscore=1501 lowpriorityscore=0 suspectscore=1
 clxscore=1011 malwarescore=0 impostorscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200153
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski brought up a concern in ibmvnic_set_mac().
ibmvnic_set_mac() does this:

	ether_addr_copy(adapter->mac_addr, addr->sa_data);
	if (adapter->state != VNIC_PROBED)
		rc = __ibmvnic_set_mac(netdev, addr->sa_data);

So if state == VNIC_PROBED, the user can assign an invalid address to
adapter->mac_addr, and ibmvnic_set_mac() will still return 0.

The fix is to not update adapter->mac_addr in ibmvnic_set_mac
and the error path of __ibmvnic_set_mac, and to update adpater->mac_addr
in handle_change_mac_rsp after the change mac request is completed in
VIOS.

Fixes: 62740e97881c ("net/ibmvnic: Update MAC address settings after adapter reset")
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4dd3625a4fbc..c4c2b0e453fc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1817,7 +1817,6 @@ static int __ibmvnic_set_mac(struct net_device *netdev, u8 *dev_addr)
 	mutex_unlock(&adapter->fw_lock);
 	return 0;
 err:
-	ether_addr_copy(adapter->mac_addr, netdev->dev_addr);
 	return rc;
 }
 
@@ -1828,7 +1827,6 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 	int rc;
 
 	rc = 0;
-	ether_addr_copy(adapter->mac_addr, addr->sa_data);
 	if (adapter->state != VNIC_PROBED)
 		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
 
-- 
2.23.0

