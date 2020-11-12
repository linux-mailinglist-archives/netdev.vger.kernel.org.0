Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496C52B0D7D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgKLTKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:10:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbgKLTKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:10:35 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ24DF081339;
        Thu, 12 Nov 2020 14:10:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=XjZz9MHmCGnQHCVQZncLeRlhYjkNmmDXysLrZ/DwJtc=;
 b=nkuYajLcVTretmKIO9DBLtH6WmBXsUKArAMwsd9ml48bK908bWmw3pmyuM0AibXZiQoR
 lVKllzFbDbQCCYw1VdyoW8vXFfYM0stge7EVhcIufFfaeiSCPnEeTTD0mpy5mOVWZUSw
 mIFUxm0uiJfLaSmfJGk9swQmi5/JJAeVOhPtbblY3S2r0ez7aiOBXPYul/tyFvNtehok
 ZKyJHJ8jQY+rzxBcUh2t/31VCZajpsnp9+WwCVmt+sy6NLLfK7z4O6Qo5ClOZdBAlyBc
 Nita707mniDdPPtpB8g6G5q0mYNVTPbOSDTeY4HwIqsLf4vy6vRf1p9X0qhCze8E9Rkq Pw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34sarugbxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 14:10:23 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ACJ7UI4030898;
        Thu, 12 Nov 2020 19:10:23 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 34nk7a8306-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Nov 2020 19:10:23 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ACJAMeR12190364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 19:10:22 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0735AE062;
        Thu, 12 Nov 2020 19:10:21 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6BA8AE071;
        Thu, 12 Nov 2020 19:10:20 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.10.22])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 12 Nov 2020 19:10:20 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, dnbanerg@us.ibm.com,
        brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        tlfalcon@linux.ibm.com, ricklind@linux.ibm.com
Subject: [PATCH net-next 01/12] ibmvnic: Ensure that subCRQ entry reads are ordered
Date:   Thu, 12 Nov 2020 13:09:56 -0600
Message-Id: <1605208207-1896-2-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_09:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 suspectscore=1 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011120109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that received Subordinate Command-Response Queue
entries are properly read in order by the driver.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index da15913879f8..5647f54bf387 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2391,6 +2391,8 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 
 		if (!pending_scrq(adapter, adapter->rx_scrq[scrq_num]))
 			break;
+		/* ensure that we do not prematurely exit the polling loop */
+		dma_rmb();
 		next = ibmvnic_next_scrq(adapter, adapter->rx_scrq[scrq_num]);
 		rx_buff =
 		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
@@ -3087,6 +3089,8 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 		int num_entries = 0;
 
 		next = ibmvnic_next_scrq(adapter, scrq);
+		/* ensure that we are reading the correct queue entry */
+		dma_rmb();
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
 			if (next->tx_comp.rcs[i]) {
 				dev_err(dev, "tx error %x\n",
-- 
2.26.2

